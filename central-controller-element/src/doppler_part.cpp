#include "doppler_part.h"

#include "ap_axi_sdata.h"
#include "complex-math.h"
#include "hamming.h"
#include "main.h"
#include <cstdint>
#include <hls_math.h>
#include <strings.h>

// Per-sequence accumulators, defined once here (declared extern in the header).
ap_uint<128> mask_seqs[TOTAL_SEQUENCES];
ap_uint<16> chirp_ind[TOTAL_SEQUENCES];

// 10^(8.393/10): the AIE threshold kernel's 8.393 dB margin, expressed as a
// power (magnitude-squared) ratio.
constexpr float kThrMagMult = 6.9072f;

// seq_generator runs once per chirp inside the DATAFLOW region, so it reads
// exactly one MaskPacket per call and keeps its accumulation state in
// mask_seqs / chirp_ind across calls.
void seq_generator(hls::stream<MaskPacket> &mask_in,
                   hls::stream<Addr> &idx_out) {
  // One bit per sequence, set when that sequence reaches chirp 255.  The end
  // marker is only sent once every sequence (0..127) is done.
  static ap_uint<128> seqs_done = 0;

  for (;;) {
    MaskPacket mask = mask_in.read();

    if (mask.seq < TOTAL_SEQUENCES) {
      if (mask.chirp == 0) {
        // first chirp of a sequence: seed, because AND-ing into a zeroed
        // accumulator would never set a bit
        mask_seqs[mask.seq] = mask.mask;
      } else {
        mask_seqs[mask.seq] = mask_seqs[mask.seq] & mask.mask;
      }
      chirp_ind[mask.seq] = mask.chirp;

      if (mask.chirp == 255) {
        seqs_done[mask.seq] = 1;

        // sequence complete: emit every range block that survived all chirps.
        // bit i covers range bins [i*16, i*16+15], so the block starts at i*16.
        ap_uint<128> current_mask = mask_seqs[mask.seq];
        ap_uint<16> current_seq = mask.seq;

        for (int i = 0; i < 128; i++) {
          if (current_mask[i]) {
            Addr a;
            a.index = (ap_uint<16>)(i * 16);
            a.seq = current_seq;
            idx_out.write(a);
          }
        }
      }
    }

    // All 128 sequences have reached chirp 255: send the single end marker
    // and stop.
    // if (seqs_done == ~ap_uint<128>(0)) {
    //   Addr end;
    //   end.index = ADDR_END;
    //   end.seq = 0;
    //   idx_out.write(end);
    //   break;
    // }

    // ---- temporary: single-sequence test, break once seq 0 is done ----
    if (seqs_done[0]) {
      Addr end;
      end.index = ADDR_END;
      end.seq = 0;
      idx_out.write(end);
      break;
    }
  }
}

void doppler(ap_uint<32> *mm, hls::stream<Addr> &idx_in,
             hls::stream<pkt> &out_d_02, hls::stream<pkt> &out_d_03,
             hls::stream<pkt> &in_d_02, hls::stream<pkt> &in_d_03,
             hls::stream<ap_uint<64>> &mask_stream) {
  // One long window: 16 range bins x every chirp of the frame.  It is kept
  // whole so a single Doppler pass sees the complete chirp axis; the window is
  // not split per chirp or per call.
  // window[range bin][chirp]; 16 * 256 * 32 bit = 128 Kbit of BRAM.
  ap_uint<32> window[16][TOTAL_CHIRPS];

  for (;;) {
    Addr a = idx_in.read();
    if (a.index == ADDR_END)
      break; // this chirp contributed no blocks

    // One 16-word range block per chirp: same address aie_consume_one() wrote.
    for (int c = 0; c < TOTAL_CHIRPS; c++) {
#pragma HLS LOOP_TRIPCOUNT min = 256 max =                                     \
    256 // tell the tool the bound is constant
      ap_uint<32> *src = range_bin_ptr(mm, a.seq, (ap_uint<16>)c, a.index);

      // one dram brust here
      for (int j = 0; j < 16; j++) {
#pragma HLS pipeline
#pragma HLS LOOP_TRIPCOUNT min = 16 max = 16
        // 16 contiguous words per chirp = one DDR burst
        window[j][c] = src[j];
      }
    }

    // Doppler FFT along the chirp axis (c) for each of the 16 bins: send the
    // bin to the AIE 256-point FFT, then consume its result.
    for (int b = 0; b < 16; b++) {
      doppler_forward_one(window[b], out_d_02, out_d_03);
      aie_consume_doppler(in_d_02, in_d_03, mask_stream, mm, a.seq,
                          (ap_uint<16>)(a.index + b));
    }
  }

  // End-of-frame marker, written once after the last range block.  dummy()
  // drains the mask stream until it sees this; without it the sink blocks and
  // csim reports an empty stream read.  One beat is enough: the header word
  // carries rank = 0xFFFF and no payload follows.
  mask_stream.write((ap_uint<64>)0xFFFF);
}

void doppler_forward_one(ap_uint<32> *in_adc0, hls::stream<pkt> &out_d_02,
                         hls::stream<pkt> &out_d_03) {
  for (int i = 0; i < TOTAL_CHIRPS; i += 2) {
#pragma HLS PIPELINE II = 1

    // Split the 64-bit beat into two cint16 samples
    cint16 s_low = bits_to_cint16(in_adc0[i]);
    cint16 s_high = bits_to_cint16(in_adc0[i + 1]);

    // Window coefficients
    cint16 w_low = hamming_window_256[i];
    cint16 w_high = hamming_window_256[i + 1];

    // Complex multiply
    cint16 y_low = cmul(s_low, w_low);
    cint16 y_high = cmul(s_high, w_high);

    // Pack back and send
    pkt q0, q1;
    q0.data = cint16_to_bits(y_low);
    q1.data = cint16_to_bits(y_high);
    // no last here

    out_d_02.write(q0);
    out_d_03.write(q1);
  }
}

// inline unsigned int histogram_index(int32_t mag, int32_t mean) {
//   // Magnitude already computed by the caller (in_data_mag); mean is the mean
//   // magnitude over the frame. Map [0, 4*mean] onto the 64 bins [0, 63]:
//   //
//   //   bin = (mag - lower) * (upper_bin - lower_bin) / (upper - lower)
//   //
//   // with lower = 0, upper = 4*mean, lower_bin = 0, upper_bin = 64.
//   // Anything above 4*mean is clamped into the last bin.
//   //
//   // No usable scale reference: put every sample in the first bin.
//   if (!(mean > 0))
//     return 0;

//   int bin = (int)(mag * 64 / (4 * mean));
//   if (bin < 0)
//     bin = 0;
//   if (bin > 63)
//     bin = 63;
//   return (unsigned int)bin;
// }



void aie_consume_doppler(hls::stream<pkt> &in_d_02, hls::stream<pkt> &in_d_03,
                         hls::stream<ap_uint<64>> &mask_stream,
                         ap_uint<32> *mm, ap_uint<16> seq, ap_uint<16> ind) {

  unsigned int histogram[64] = {0};

  cint16 in_data[256];
  int32_t in_data_mag[256];

  // Store the raw samples only; this loop touches the streams and in_data.
  for (int i = 0; i < 256; i += 2) {
#pragma HLS PIPELINE II = 1
    auto even_element = bits_to_cint16(in_d_02.read().get_data());
    auto odd_element = bits_to_cint16(in_d_03.read().get_data());

    in_data[i] = even_element;
    in_data[i + 1] = odd_element;
  }

  int64_t mean_acc = 0;

  for (int i = 0; i < 256; i++) {
#pragma HLS PIPELINE II = 1
    int32_t re = (int32_t)in_data[i].real;
    int32_t im = (int32_t)in_data[i].imag;

    // widen BEFORE multiply to avoid (-32768)^2 + (-32768)^2 = 2^31 overflow
    int64_t power64 = (int64_t)re * re + (int64_t)im * im;
    int32_t power = (power64 > INT32_MAX) ? INT32_MAX : (int32_t)power64;

    in_data_mag[i] = power;
    mean_acc += power;
  }

  // ÷256 via shift; result is Q2.30 average power (same scale as in_data_mag[])
  int32_t mean = (int32_t)(mean_acc >> 8);

  /// this shit was slow, AI made a better one IDK how it fucking works

  ///
  //   // ---- histogram of the magnitudes squared
  //   ------------------------------ for (int i = 0; i < 256; i++) {
  // #pragma HLS PIPELINE
  //     auto index = histogram_index(in_data_mag[i], mean);
  //     histogram[index] += 1;
  //   }

  // ---- histogram (Q24 reciprocal, 32-bit scale, DSP multiply) -----------
  uint32_t mean_u = (mean > 0) ? (uint32_t)mean : 1u;

  // scale_q24 = (16 << 24) / mean_u.  The HLS divider macro is a 34-stage
  // sequential unit whose internal path is 7.0 ns; do the same restoring
  // division here over short pipelined steps instead.  (16 << 24) is 2^28,
  // so only the first dividend bit is set and 29 iterations cover the
  // 29-bit quotient.
  uint32_t scale_q24 = 0;
  uint32_t div_rem = 0;
  for (int i = 0; i < 29; i++) {
#pragma HLS PIPELINE II = 2
    div_rem = (div_rem << 1) | ((i == 0) ? 1u : 0u);
    scale_q24 <<= 1;
    if (div_rem >= mean_u) {
      div_rem -= mean_u;
      scale_q24 |= 1u;
    }
  }

  for (int i = 0; i < 256; i++) {
#pragma HLS PIPELINE II = 2
    uint64_t bin64 = ((uint64_t)(uint32_t)in_data_mag[i] * scale_q24) >> 24;
    uint32_t bin = (bin64 > 63u) ? 63u : (uint32_t)bin64;
    histogram[bin] += 1;
  }

  // ---- median -----------------------------------------------------------
  // Walk bins from 0 until the cumulative count passes half the samples.
  int sum = 0;
  int median_bin = 0;
  for (int i = 0; i < 64; i++) {
    sum += histogram[i];
    if (sum > 256 / 2) {
      median_bin = i;
      break;
    }
  }

  // ---- threshold (integer fixed point) ----------------------------------
  // Same value as the old float expression, with no float or double at all:
  //   threshold = 6.9072 * (median_bin + 0.5) * (mean / 16)
  //             = (2*median_bin + 1) * mean * 6.9072 / 32
  // 884 / 4096 is 6.9072 / 32 in Q12.  Both multiplies are bound to pipelined
  // DSPs: the extra latency costs a few cycles but keeps every combinational
  // path short (the old double->int cast was a 137-bit variable shifter).
  const uint32_t thr_q12 = 884u; // round(6.9072 / 32 * 4096)

  uint32_t a = (uint32_t)(median_bin * 2 + 1); // 1 .. 127

  uint64_t a_mean;
#pragma HLS BIND_OP variable = a_mean op = mul impl = dsp latency = 4
  a_mean = (uint64_t)a * mean_u;

  uint64_t thr_prod;
#pragma HLS BIND_OP variable = thr_prod op = mul impl = dsp latency = 4
  thr_prod = a_mean * thr_q12;

  uint64_t thr64 = thr_prod >> 12;
  uint32_t threshold =
      (thr64 > 0xFFFFFFFFull) ? 0xFFFFFFFFu : (uint32_t)thr64;


  
  ap_uint<16> mask = 0;

  
  // ---- keep / write back ------------------------------------------------
  // A bin is 16 samples: if any sample in the bin is above the threshold, the
  // whole bin is written back.  mm is the base of the three-cube allocation;
  // doppler_bin_ptr() resolves the 16-word burst for each kept bin.
  for (int b = 0; b < 256 / 16; b++) {
#pragma HLS PIPELINE II = 1
    bool keep = false;

    for (int j = 0; j < 16; j++) {
#pragma HLS UNROLL
      if ((uint32_t)in_data_mag[b * 16 + j] > threshold)
        keep = true;
    }

    if (keep) {
      mask[b] = 1;
      ap_uint<32> *dst = doppler_bin_ptr(mm, seq, (ap_uint<16>)(b * 16), ind);
      for (int j = 0; j < 16; j++) {
#pragma HLS UNROLL
        dst[j] = cint16_to_bits(in_data[b * 16 + j]);
      }
    } else {
      mask[b] = 0;
    }
  }

  // One packet per bin: all 256 powers plus the header.  Ship it as 64-bit
  // beats so the stream is a narrow, easily routed 64-bit line instead of a
  // 2816-bit bus.  Header beat first, then two powers per beat.
  DopplerMaskPacket dmask;
  dmask.rank = 0;
  dmask.mask = mask;
  dmask.seq = seq;
  dmask.index = ind;

  for (int i = 0; i < TOTAL_CHIRPS; i++) {
#pragma HLS PIPELINE II = 1
#pragma HLS LOOP_TRIPCOUNT min = 256 max = 256
    dmask.data[i] = in_data_mag[i];
  }

  // Reinterpret the whole packet as 129 uint64 beats and push them in order.
  const ap_uint<64> *words = reinterpret_cast<const ap_uint<64> *>(&dmask);
  for (int i = 0; i < kDopplerPacketWords; i++) {
#pragma HLS PIPELINE II = 1
#pragma HLS LOOP_TRIPCOUNT min = 129 max = 129
    mask_stream.write(words[i]);
  }
}

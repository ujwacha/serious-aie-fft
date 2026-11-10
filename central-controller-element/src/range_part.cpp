#include "range_part.h"

#include "complex-math.h"

void build_mask_indices(const ap_uint<32> *mask_words, unsigned int *idxs,
                        unsigned int &count) {

  unsigned int n = 0, accum = 0;

  for (int i = 0; i < 64; i++) {
#pragma HLS pipeline 
    auto high_mask = mask_words[i].range(31, 16);
    auto low_mask = mask_words[i].range(15, 0);

    if (low_mask == 0xFFFF)
      idxs[n++] = accum;
    accum += 16;
    if (high_mask == 0xFFFF)
      idxs[n++] = accum;
    accum += 16;
  }

  count = n;
}


// void build_mask_indices(const ap_uint<32> *mask_words, unsigned int *idxs,
//                         unsigned int &count) {

//   // Step 1: flatten the 64×32-bit words into a 128-bit "keep" mask
//   ap_uint<128> keep = 0;
//   for (int i = 0; i < 64; i++) {
// #pragma HLS UNROLL
//     keep[i * 2]     = (mask_words[i].range(15, 0)  == 0xFFFF) ? 1 : 0;
//     keep[i * 2 + 1] = (mask_words[i].range(31, 16) == 0xFFFF) ? 1 : 0;
//   }

//   // Step 2: emit indices — n is now a chain of 1-bit adds, no loop recurrence
//   unsigned int n = 0;
//   for (int i = 0; i < 128; i++) {
// #pragma HLS UNROLL
//     if (keep[i]) {
//       idxs[n] = i * 16;
//       n++;
//     }
//   }
//   count = n;
// }

void adc_forward(hls::stream<pkt_adc> &in_adc0, hls::stream<pkt> &out_r_00,
                 hls::stream<pkt> &out_r_01, unsigned int num_chirps) {
  for (unsigned int c = 0; c < num_chirps; c++) {
#pragma HLS loop_flatten off
    for (int i = 0; i < 1024; i++) {
#pragma HLS PIPELINE II = 1
#pragma HLS LOOP_TRIPCOUNT min=1024 max=1024     // ← ADD THIS      
      pkt_adc in_packet = in_adc0.read();
      ap_uint<64> in_data = in_packet.data; // field, no parens

      // Split the 64-bit beat into two cint16 samples
      cint16 s_low = bits_to_cint16(in_data.range(31, 0));   // sample[2i]
      cint16 s_high = bits_to_cint16(in_data.range(63, 32)); // sample[2i+1]

      // Window coefficients
      cint16 w_low = hamming_window_2048[2 * i];
      cint16 w_high = hamming_window_2048[2 * i + 1];

      // Complex multiply
      cint16 y_low = cmul(s_low, w_low);
      cint16 y_high = cmul(s_high, w_high);

      // Pack back and send
      pkt q0, q1;
      q0.data = cint16_to_bits(y_low);
      q1.data = cint16_to_bits(y_high);
      q0.last = in_packet.last;
      q1.last = in_packet.last;
      out_r_00.write(q0);
      out_r_01.write(q1);
    }
  }
}

void aie_range_consume(hls::stream<pkt> &in_r_00,
                       hls::stream<pkt> &in_r_01,
                       hls::stream<MaskPacket> &mask_stream, ap_uint<32> *mm,
                       unsigned int sequence, unsigned int num_chirps) {
  for (unsigned int c = 0; c < num_chirps; c++) {
    ap_uint<16> chirp = (ap_uint<16>)c;

    // phase 1: read 64 mask beats, discard 64 zeros
    ap_uint<32> mask_head[64];
    unsigned int adr_buf[128];
    unsigned int count;

    for (int i = 0; i < 64; i++) {
#pragma HLS PIPELINE
      mask_head[i] = in_r_00.read().data;
      in_r_01.read(); // we'll be getting zeros here
    }

    // phase 2: build indices, consume kept blocks alternating streams, write DRAM
    build_mask_indices(mask_head, adr_buf, count);

    for (int i = 0; i < count; i++) {
#pragma HLS PIPELINE
      // even i, data comes from in_r_00

      ap_uint<32> buf[16];

      if (i % 2 == 0) {
        for (int j = 0; j < 16; j++) {
#pragma HLS PIPELINE
          buf[j] = in_r_00.read().data;
        }
      } else {
        // odd i, data comes from in_r_01
        for (int j = 0; j < 16; j++) {
#pragma HLS PIPELINE
          buf[j] = in_r_01.read().data;
        }
      }

      // read 16 numbers, then burst them to memory
      ap_uint<32> *dst = range_bin_ptr(mm, (ap_uint<16>)sequence,
                                       chirp, (ap_uint<16>)adr_buf[i]);

      for (int j = 0; j < 16; j++) {
#pragma HLS PIPELINE
        dst[j] = buf[j];
      }
    }

    // ---- phase 3: condense mask, ship to Doppler module ----
    ap_uint<128> condensed = 0;
    for (int i = 0; i < 64; i++) {
#pragma HLS UNROLL
      condensed[i * 2] = (mask_head[i].range(15, 0) == 0xFFFF) ? 1 : 0;
      condensed[i * 2 + 1] = (mask_head[i].range(31, 16) == 0xFFFF) ? 1 : 0;
    }

    MaskPacket mp;
    mp.mask = condensed;
    mp.seq = (ap_uint<8>)sequence;
    mp.chirp = (ap_uint<8>)chirp;
    mask_stream.write(mp);
  }
}

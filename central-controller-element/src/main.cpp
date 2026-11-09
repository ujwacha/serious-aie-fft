#include "main.h"

#include "angle_part.h"
#include "doppler_part.h"
#include "range_part.h"

// The three-cube DRAM layout and the bin mappers live in main.h.
//   range   writes -> [kRangeBase,   kDopplerBase)
//   doppler writes -> [kDopplerBase, kAngleBase)
//   angle   writes -> [kAngleBase,   3 * kCubeWords)

void kernel(ap_uint<32> *mm, hls::stream<pkt_adc> &in_adc0,
            hls::stream<pkt> &out_r_00, hls::stream<pkt> &out_r_01,
            hls::stream<pkt> &in_r_00, hls::stream<pkt> &in_r_01,
            hls::stream<pkt> &out_d_02, hls::stream<pkt> &out_d_03,
            hls::stream<pkt> &in_d_02, hls::stream<pkt> &in_d_03,
            unsigned int num_chirps) {

// 3 cubes reserved: 3 * 67,108,864 = 201,326,592 words (768 MiB, 0.75 GiB).
#pragma HLS INTERFACE m_axi port = mm offset = slave bundle = gmem depth =     \
    201326592
#pragma HLS INTERFACE s_axilite port=mm bundle=control
#pragma HLS INTERFACE axis port = in_adc0
#pragma HLS INTERFACE axis port = out_r_00
#pragma HLS INTERFACE axis port = out_r_01
#pragma HLS INTERFACE axis port = in_r_00
#pragma HLS INTERFACE axis port = in_r_01
#pragma HLS INTERFACE axis port = out_d_02
#pragma HLS INTERFACE axis port = out_d_03
#pragma HLS INTERFACE axis port = in_d_02
#pragma HLS INTERFACE axis port = in_d_03
#pragma HLS INTERFACE s_axilite port = num_chirps bundle = control
#pragma HLS INTERFACE s_axilite port = return bundle = control

#pragma HLS STREAM variable = in_adc0 depth = 1024
#pragma HLS STREAM variable = out_r_00 depth = 1024
#pragma HLS STREAM variable = out_r_01 depth = 1024
#pragma HLS STREAM variable = in_r_00 depth = 1024
#pragma HLS STREAM variable = in_r_01 depth = 1024
#pragma HLS STREAM variable = out_d_02 depth = 1024
#pragma HLS STREAM variable = out_d_03 depth = 1024
#pragma HLS STREAM variable = in_d_02 depth = 1024
#pragma HLS STREAM variable = in_d_03 depth = 1024

  // The whole frame is one DATAFLOW region: each stage loops over the chirps
  // internally, and only the streams connect them.
  hls::stream<MaskPacket> mask_stream;
  hls::stream<Addr> idx_stream;
  hls::stream<DopplerMaskPacket> doppler_mask_stream;
#pragma HLS STREAM variable = mask_stream depth = 128
#pragma HLS STREAM variable = idx_stream depth = 128
#pragma HLS STREAM variable = doppler_mask_stream depth = 128
#pragma HLS DATAFLOW
  adc_forward(in_adc0, out_r_00, out_r_01, num_chirps);
  aie_range_consume(in_r_00, in_r_01, mask_stream, mm, 0, num_chirps);
  seq_generator(mask_stream, idx_stream);
  doppler(mm, idx_stream, out_d_02, out_d_03, in_d_02, in_d_03,
          doppler_mask_stream);
  dummy(doppler_mask_stream);
}

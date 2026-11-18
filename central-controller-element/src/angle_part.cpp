#include "angle_part.h"

void dummy(hls::stream<ap_uint<64>> &mask_stream) {
  // Drain every packet the Doppler stage produces.  The first beat of each
  // packet is the header word (rank/mask/seq/index); rank == 0xFFFF is the
  // end-of-frame marker and carries no payload.  A data packet is followed by
  // kDopplerPacketWords - 1 payload beats.  Leaving beats in the FIFO would
  // make an RTL simulation hang once the FIFO fills.
  for (;;) {
    ap_uint<64> header = mask_stream.read();
    ap_uint<16> rank = header.range(15, 0);
    if (rank == 0xFFFF)
      break;

    for (int i = 1; i < kDopplerPacketWords; i++) {
#pragma HLS PIPELINE II = 1
      mask_stream.read();
    }
  }
}

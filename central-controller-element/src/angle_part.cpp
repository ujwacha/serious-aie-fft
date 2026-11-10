#include "angle_part.h"

void dummy(hls::stream<DopplerMaskPacket> &mask_stream) {
  // Drain every packet the Doppler stage produces.  rank == 0xFFFF is the
  // end-of-frame marker written by doppler().  Leaving packets in the FIFO
  // would make an RTL simulation hang once the 128-deep FIFO fills.
  for (;;) {
    DopplerMaskPacket p = mask_stream.read();
    if (p.rank == 0xFFFF)
      break;
  }
}

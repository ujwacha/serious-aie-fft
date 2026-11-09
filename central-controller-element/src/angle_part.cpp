#include "angle_part.h"

void dummy(hls::stream<DopplerMaskPacket> &mask_stream) {
  DopplerMaskPacket p = mask_stream.read();
  (void)p;
}

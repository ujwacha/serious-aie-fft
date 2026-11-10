#ifndef ANGLE_PART_H
#define ANGLE_PART_H

#include "main.h"
#include <hls_stream.h>

/* Temporary sink for the Doppler output: gives doppler_mask_stream a reader so
 * the FIFO is legal.  Drains packets until doppler() writes its rank=0xFFFF
 * end-of-frame marker; the real angle stage replaces it. */
void dummy(hls::stream<DopplerMaskPacket> &mask_stream);

#endif

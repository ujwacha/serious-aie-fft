#ifndef ANGLE_PART_H
#define ANGLE_PART_H

#include "main.h"
#include <hls_stream.h>

/* Temporary sink for the Doppler output: gives doppler_mask_stream a reader so
 * the FIFO is legal.  Drains 64-bit beats until doppler() writes its
 * rank=0xFFFF end-of-frame header; the real angle stage replaces it. */
void dummy(hls::stream<ap_uint<64>> &mask_stream);

#endif

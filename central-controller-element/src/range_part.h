#ifndef RANGE_PART_H
#define RANGE_PART_H

#include "main.h"

/* Hamming-window every chirp of the frame and split each 64-bit ADC beat into
 * the even/odd sample streams for the range FFT. */
void adc_forward(hls::stream<pkt_adc> &in_adc0, hls::stream<pkt> &out_r_00,
                 hls::stream<pkt> &out_r_01, unsigned int num_chirps,
                 SequenceList sequences);

/* Consume the range-FFT output of every chirp: walk the mask, burst the kept
 * blocks into DRAM, and emit the condensed mask packet. */
void aie_range_consume(hls::stream<pkt> &in_r_00, hls::stream<pkt> &in_r_01,
                       hls::stream<MaskPacket> &mask_stream, ap_uint<32> *mm,
                       unsigned int num_chirps, SequenceList sequences);

#endif /* RANGE_PART_H */

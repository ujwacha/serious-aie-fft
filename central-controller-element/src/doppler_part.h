#ifndef DOPPLER_PART_H
#define DOPPLER_PART_H

#include "main.h"
#include <ap_axi_sdata.h>

#define TOTAL_SEQUENCES 128
#define TOTAL_CHIRPS    256

/* End-of-batch marker on the idx stream.  A real Addr always has
 * index <= 2032, so 0xFFFF is unambiguous. */
#define ADDR_END        0xFFFF

extern ap_uint<128> mask_seqs[TOTAL_SEQUENCES];
extern ap_uint<16>   chirp_ind[TOTAL_SEQUENCES];


/* Turn the per-chirp mask packets into the range indices that need a Doppler
 * pass.  mask_in is the internal stream produced by aie_consume_one(). */
void seq_generator(hls::stream<MaskPacket> &mask_in,
                   hls::stream<Addr> &idx_out);

/* Window one range bin's 256 chirps and send them to the AIE 256-point FFT. */
void doppler_forward_one(ap_uint<32> *in_adc0, hls::stream<pkt> &out_d_02,
                         hls::stream<pkt> &out_d_03);

/* Run the Doppler stage for each range index arriving on idx_in, reading the
 * range-FFT frame from mm. */
void doppler(ap_uint<32> *mm, hls::stream<Addr> &idx_in,
             hls::stream<pkt> &out_d_02, hls::stream<pkt> &out_d_03,
             hls::stream<pkt> &in_d_02, hls::stream<pkt> &in_d_03,
             hls::stream<DopplerMaskPacket> &mask_stream);

/* Consume one Doppler-FFT frame: histogram/median/threshold on the magnitudes,
 * write the kept bins to mm, and emit the keep mask, sequence and range index
 * on mask_stream for the CFAR stage. */
void aie_consume_doppler(hls::stream<pkt> &in_d_02,
                         hls::stream<pkt> &in_d_03,
                         hls::stream<DopplerMaskPacket> &mask_stream,
                         ap_uint<32> *mm, ap_uint<16> seq, ap_uint<16> ind);

#endif /* DOPPLER_PART_H */

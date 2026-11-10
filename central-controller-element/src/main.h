#ifndef MAIN_H
#define MAIN_H

#include <ap_axi_sdata.h>
#include <hls_stream.h>
#include "hamming.h"

typedef ap_axiu<32, 0, 0, 0> pkt;
typedef ap_axiu<64, 0, 0, 0> pkt_adc;

struct MaskPacket {
    ap_uint<128> mask;
    ap_uint<16>   seq;
    ap_uint<16>   chirp;
};

/* One range/sequence coordinate handed from seq_generator to doppler. */
struct Addr {
    ap_uint<16> index;
    ap_uint<16> seq;
};


struct DopplerMaskPacket {
    ap_uint<16> rank;     /* 0..2: magnitude payload is split in 3        */
    ap_uint<16> mask;     /* 256 / 16 bits: one keep bit per 16-sample bin */
    ap_uint<16> seq;      /* sequence number (rank 0 only)                */
    ap_uint<16> index;    /* range index     (rank 0 only)                */
    int32_t       data[86]; /* 1/3 of the 256 powers (|x|^2), per rank      */
};

// helper — exposed for testbench unit test
void build_mask_indices(const ap_uint<32> *mask_words,
                        unsigned int      *idxs,
                        unsigned int      &count);

/* ---- DRAM cube layout -------------------------------------------------
 * One cube = 2048 range bins x 256 chirps x 128 sequences cint16
 *          = 67,108,864 words (256 MiB, 0.25 GiB).
 * The three cubes live back-to-back inside the single mm allocation. */
constexpr unsigned int kRangeBins  = 2048u;
constexpr unsigned int kChirps     = 256u;
constexpr unsigned int kSeqs       = 128u;
constexpr unsigned int kCubeWords  = kRangeBins * kChirps * kSeqs;
constexpr unsigned int kRangeBase   = 0u;
constexpr unsigned int kDopplerBase = kCubeWords;
constexpr unsigned int kAngleBase   = 2u * kCubeWords;

/* DRAM mappers into the three-cube mm allocation.  Both take the same
 * (seq, chirp, index) triple and return the word address of that bin:
 *   range_bin_ptr   -> [seq][chirp][index]     (fast time contiguous)
 *   doppler_bin_ptr -> [seq][index][chirp]     (slow time contiguous,
 *                                               chirp is the Doppler bin)
 * Defined here because they are inline and called from several TUs. */
inline ap_uint<32> *range_bin_ptr(ap_uint<32> *mm, ap_uint<16> seq,
                                  ap_uint<16> chirp, ap_uint<16> index) {
  return mm + (unsigned int)seq * (kRangeBins * kChirps) +
         (unsigned int)chirp * kRangeBins + (unsigned int)index;
}

inline ap_uint<32> *doppler_bin_ptr(ap_uint<32> *mm, ap_uint<16> seq,
                                    ap_uint<16> chirp, ap_uint<16> index) {
  return mm + kDopplerBase + (unsigned int)seq * (kRangeBins * kChirps) +
         (unsigned int)index * kChirps + (unsigned int)chirp;
}

extern "C" {
void kernel(ap_uint<32>         *mm,
            hls::stream<pkt_adc> &in_adc0,
            hls::stream<pkt>     &out_r_00,
            hls::stream<pkt>     &out_r_01,
            hls::stream<pkt>     &in_r_00,
            hls::stream<pkt>     &in_r_01,
            hls::stream<pkt>     &out_d_02,
            hls::stream<pkt>     &out_d_03,
            hls::stream<pkt>     &in_d_02,
            hls::stream<pkt>     &in_d_03,
            unsigned int          num_chirps);
}

#endif

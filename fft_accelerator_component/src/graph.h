#include "adf/new_frontend/adf.h"
#include "adf/window/complexint.h"
#include "fft_ifft_dit_1ch_graph.hpp"
#include "threshold_kernel_better.h"
#include <adf.h>

using namespace adf;
namespace dsp = xf::dsp::aie::fft::dit_1ch;

class my_graph : public graph {
public:
  output_plio tempout0;
  output_plio tempout1;
  
  input_plio tempin0;
  input_plio tempin1;

  output_plio tempout2;
  output_plio tempout3;

  input_plio tempin2;
  input_plio tempin3;

  output_plio tempout4;
  output_plio tempout5;

  input_plio tempin4;
  input_plio tempin5;

  kernel k1;

  my_graph() {
    // 1. Create PLIOs
    tempout0 = output_plio::create(plio_32_bits, "data/temp_output0.txt");
    tempout1 = output_plio::create(plio_32_bits, "data/temp_output1.txt");

    tempin0 = input_plio::create(plio_32_bits, "data/temp_input0.txt");
    tempin1 = input_plio::create(plio_32_bits, "data/temp_input1.txt");

    // 256-point FFT (Doppler) streams
    tempout2 = output_plio::create(plio_32_bits, "data/temp_output2.txt");
    tempout3 = output_plio::create(plio_32_bits, "data/temp_output3.txt");

    tempin2 = input_plio::create(plio_32_bits, "data/temp_input2.txt");
    tempin3 = input_plio::create(plio_32_bits, "data/temp_input3.txt");

    // 128-point FFT streams
    tempout4 = output_plio::create(plio_32_bits, "data/temp_output4.txt");
    tempout5 = output_plio::create(plio_32_bits, "data/temp_output5.txt");

    tempin4 = input_plio::create(plio_32_bits, "data/temp_input4.txt");
    tempin5 = input_plio::create(plio_32_bits, "data/temp_input5.txt");

    // 2. FFT Graph (Requires 2 streams in, 2 streams out)
    dsp::fft_ifft_dit_1ch_graph<cint16, // TT_DATA
                                cint16, // TT_TWIDDLE
                                2048,   // TP_POINT_SIZE
                                1,      // TP_FFT_NIFFT
                                11,     // TP_SHIFT
                                1,      // TP_CASC_LEN
                                0,      // TP_DYN_PT_SIZE
                                2048,   // TP_WINDOW_VSIZE
                                1,      // TP_API: 1 = streaming
                                0       // TP_PARALLEL_POWER: 0 = single FFT
                                >
        fft_inst_range;

    // 256-point FFT (Doppler), same layout: 2 streams in, 2 streams out
    dsp::fft_ifft_dit_1ch_graph<cint16, // TT_DATA
                                cint16, // TT_TWIDDLE
                                256,    // TP_POINT_SIZE
                                1,      // TP_FFT_NIFFT
                                8,      // TP_SHIFT
                                1,      // TP_CASC_LEN
                                0,      // TP_DYN_PT_SIZE
                                256,    // TP_WINDOW_VSIZE
                                1,      // TP_API: 1 = streaming
                                0       // TP_PARALLEL_POWER: 0 = single FFT
                                >
        fft_inst_doppler;

    // 128-point FFT, same layout: 2 streams in, 2 streams out
    dsp::fft_ifft_dit_1ch_graph<cint16, // TT_DATA
                                cint16, // TT_TWIDDLE
                                128,    // TP_POINT_SIZE
                                1,      // TP_FFT_NIFFT
                                7,      // TP_SHIFT
                                1,      // TP_CASC_LEN
                                0,      // TP_DYN_PT_SIZE
                                128,    // TP_WINDOW_VSIZE
                                1,      // TP_API: 1 = streaming
                                0       // TP_PARALLEL_POWER: 0 = single FFT
                                >
        fft_inst_128;

    // 3. Log Kernel
    k1 = kernel::create_object<threshold_kernel_better>(2048);
    runtime<ratio>(k1) = 0.9;
    source(k1) = "src/threshold_kernel_better.cpp";

    // 4. Connections
    
    // Inputs to FFT
    connect<>(tempin0.out[0], fft_inst_range.in[0]);
    connect<>(tempin1.out[0], fft_inst_range.in[1]);

    // FFT Outputs to Log Kernel Inputs
    connect<>(fft_inst_range.out[0], k1.in[0]);
    connect<>(fft_inst_range.out[1], k1.in[1]);

    // Log Kernel Outputs to PLIOs
    connect<>(k1.out[0], tempout0.in[0]);
    connect<>(k1.out[1], tempout1.in[0]);

    // 256-point FFT: PLIOs in, PLIOs out
    connect<>(tempin2.out[0], fft_inst_doppler.in[0]);
    connect<>(tempin3.out[0], fft_inst_doppler.in[1]);
    connect<>(fft_inst_doppler.out[0], tempout2.in[0]);
    connect<>(fft_inst_doppler.out[1], tempout3.in[0]);

    // 128-point FFT: PLIOs in, PLIOs out
    connect<>(tempin4.out[0], fft_inst_128.in[0]);
    connect<>(tempin5.out[0], fft_inst_128.in[1]);
    connect<>(fft_inst_128.out[0], tempout4.in[0]);
    connect<>(fft_inst_128.out[1], tempout5.in[0]);
  }
};

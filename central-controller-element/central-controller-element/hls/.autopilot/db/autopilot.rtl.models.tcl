set SynModuleInfo {
  {SRCNAME adc_forward MODELNAME adc_forward RTLNAME kernel_adc_forward
    SUBMODULES {
      {MODELNAME kernel_mul_16s_15ns_31_2_1 RTLNAME kernel_mul_16s_15ns_31_2_1 BINDTYPE op TYPE mul IMPL auto LATENCY 1 ALLOW_PRAGMA 1}
      {MODELNAME kernel_adc_forward_hamming_window_2048_real_ROM_AUTO_1R RTLNAME kernel_adc_forward_hamming_window_2048_real_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME kernel_regslice_both RTLNAME kernel_regslice_both BINDTYPE interface TYPE adapter IMPL reg_slice}
      {MODELNAME kernel_flow_control_loop_pipe RTLNAME kernel_flow_control_loop_pipe BINDTYPE interface TYPE internal_upc_flow_control INSTNAME kernel_flow_control_loop_pipe_U}
    }
  }
  {SRCNAME aie_range_consume_Pipeline_VITIS_LOOP_69_2 MODELNAME aie_range_consume_Pipeline_VITIS_LOOP_69_2 RTLNAME kernel_aie_range_consume_Pipeline_VITIS_LOOP_69_2
    SUBMODULES {
      {MODELNAME kernel_flow_control_loop_pipe_sequential_init RTLNAME kernel_flow_control_loop_pipe_sequential_init BINDTYPE interface TYPE internal_upc_flow_control INSTNAME kernel_flow_control_loop_pipe_sequential_init_U}
    }
  }
  {SRCNAME aie_range_consume_Pipeline_VITIS_LOOP_10_1 MODELNAME aie_range_consume_Pipeline_VITIS_LOOP_10_1 RTLNAME kernel_aie_range_consume_Pipeline_VITIS_LOOP_10_1}
  {SRCNAME aie_range_consume_Pipeline_VITIS_LOOP_78_3 MODELNAME aie_range_consume_Pipeline_VITIS_LOOP_78_3 RTLNAME kernel_aie_range_consume_Pipeline_VITIS_LOOP_78_3}
  {SRCNAME aie_range_consume MODELNAME aie_range_consume RTLNAME kernel_aie_range_consume
    SUBMODULES {
      {MODELNAME kernel_aie_range_consume_mask_head_RAM_AUTO_1R1W RTLNAME kernel_aie_range_consume_mask_head_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME kernel_aie_range_consume_adr_buf_RAM_AUTO_1R1W RTLNAME kernel_aie_range_consume_adr_buf_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME seq_generator_Pipeline_VITIS_LOOP_49_2 MODELNAME seq_generator_Pipeline_VITIS_LOOP_49_2 RTLNAME kernel_seq_generator_Pipeline_VITIS_LOOP_49_2
    SUBMODULES {
      {MODELNAME kernel_bitselect_1ns_128ns_7ns_1_1_1 RTLNAME kernel_bitselect_1ns_128ns_7ns_1_1_1 BINDTYPE op TYPE bitselect IMPL auto}
    }
  }
  {SRCNAME seq_generator MODELNAME seq_generator RTLNAME kernel_seq_generator
    SUBMODULES {
      {MODELNAME kernel_bitset_128ns_128ns_7ns_1s_128_1_1 RTLNAME kernel_bitset_128ns_128ns_7ns_1s_128_1_1 BINDTYPE op TYPE bitset IMPL auto}
      {MODELNAME kernel_seq_generator_mask_seqs_RAM_AUTO_1R1W RTLNAME kernel_seq_generator_mask_seqs_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME doppler_Pipeline_VITIS_LOOP_97_2_VITIS_LOOP_101_3 MODELNAME doppler_Pipeline_VITIS_LOOP_97_2_VITIS_LOOP_101_3 RTLNAME kernel_doppler_Pipeline_VITIS_LOOP_97_2_VITIS_LOOP_101_3}
  {SRCNAME doppler_forward_one MODELNAME doppler_forward_one RTLNAME kernel_doppler_forward_one
    SUBMODULES {
      {MODELNAME kernel_doppler_forward_one_hamming_window_256_real_ROM_AUTO_1R RTLNAME kernel_doppler_forward_one_hamming_window_256_real_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME aie_consume_doppler_Pipeline_1 MODELNAME aie_consume_doppler_Pipeline_1 RTLNAME kernel_aie_consume_doppler_Pipeline_1}
  {SRCNAME aie_consume_doppler_Pipeline_VITIS_LOOP_185_1 MODELNAME aie_consume_doppler_Pipeline_VITIS_LOOP_185_1 RTLNAME kernel_aie_consume_doppler_Pipeline_VITIS_LOOP_185_1}
  {SRCNAME aie_consume_doppler_Pipeline_VITIS_LOOP_195_2 MODELNAME aie_consume_doppler_Pipeline_VITIS_LOOP_195_2 RTLNAME kernel_aie_consume_doppler_Pipeline_VITIS_LOOP_195_2
    SUBMODULES {
      {MODELNAME kernel_sitofp_32s_32_7_no_dsp_1 RTLNAME kernel_sitofp_32s_32_7_no_dsp_1 BINDTYPE op TYPE sitofp IMPL auto LATENCY 6 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME aie_consume_doppler_Pipeline_VITIS_LOOP_210_3 MODELNAME aie_consume_doppler_Pipeline_VITIS_LOOP_210_3 RTLNAME kernel_aie_consume_doppler_Pipeline_VITIS_LOOP_210_3
    SUBMODULES {
      {MODELNAME kernel_fdiv_32ns_32ns_32_30_no_dsp_1 RTLNAME kernel_fdiv_32ns_32ns_32_30_no_dsp_1 BINDTYPE op TYPE fdiv IMPL fabric LATENCY 29 ALLOW_PRAGMA 1}
      {MODELNAME kernel_lshr_79ns_32ns_79_2_1 RTLNAME kernel_lshr_79ns_32ns_79_2_1 BINDTYPE op TYPE lshr IMPL auto_pipe LATENCY 1}
      {MODELNAME kernel_shl_79ns_32ns_79_2_1 RTLNAME kernel_shl_79ns_32ns_79_2_1 BINDTYPE op TYPE shl IMPL auto_pipe LATENCY 1}
    }
  }
  {SRCNAME aie_consume_doppler_Pipeline_VITIS_LOOP_221_4 MODELNAME aie_consume_doppler_Pipeline_VITIS_LOOP_221_4 RTLNAME kernel_aie_consume_doppler_Pipeline_VITIS_LOOP_221_4}
  {SRCNAME aie_consume_doppler_Pipeline_VITIS_LOOP_244_5 MODELNAME aie_consume_doppler_Pipeline_VITIS_LOOP_244_5 RTLNAME kernel_aie_consume_doppler_Pipeline_VITIS_LOOP_244_5
    SUBMODULES {
      {MODELNAME kernel_bitset_16ns_16ns_4ns_1ns_16_1_1 RTLNAME kernel_bitset_16ns_16ns_4ns_1ns_16_1_1 BINDTYPE op TYPE bitset IMPL auto}
    }
  }
  {SRCNAME aie_consume_doppler_Pipeline_VITIS_LOOP_282_9 MODELNAME aie_consume_doppler_Pipeline_VITIS_LOOP_282_9 RTLNAME kernel_aie_consume_doppler_Pipeline_VITIS_LOOP_282_9}
  {SRCNAME aie_consume_doppler MODELNAME aie_consume_doppler RTLNAME kernel_aie_consume_doppler
    SUBMODULES {
      {MODELNAME kernel_fadd_32ns_32ns_32_10_full_dsp_1 RTLNAME kernel_fadd_32ns_32ns_32_10_full_dsp_1 BINDTYPE op TYPE fadd IMPL fulldsp LATENCY 9 ALLOW_PRAGMA 1}
      {MODELNAME kernel_fmul_32ns_32ns_32_8_max_dsp_1 RTLNAME kernel_fmul_32ns_32ns_32_8_max_dsp_1 BINDTYPE op TYPE fmul IMPL maxdsp LATENCY 7 ALLOW_PRAGMA 1}
      {MODELNAME kernel_sitofp_32ns_32_7_no_dsp_1 RTLNAME kernel_sitofp_32ns_32_7_no_dsp_1 BINDTYPE op TYPE sitofp IMPL auto LATENCY 6 ALLOW_PRAGMA 1}
      {MODELNAME kernel_fcmp_32ns_32ns_1_4_no_dsp_1 RTLNAME kernel_fcmp_32ns_32ns_1_4_no_dsp_1 BINDTYPE op TYPE fcmp IMPL auto LATENCY 3 ALLOW_PRAGMA 1}
      {MODELNAME kernel_aie_consume_doppler_histogram_RAM_AUTO_1R1W RTLNAME kernel_aie_consume_doppler_histogram_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME kernel_aie_consume_doppler_in_data_real_RAM_AUTO_1R1W RTLNAME kernel_aie_consume_doppler_in_data_real_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME kernel_aie_consume_doppler_in_data_mag_RAM_1WNR_AUTO_1R1W RTLNAME kernel_aie_consume_doppler_in_data_mag_RAM_1WNR_AUTO_1R1W BINDTYPE storage TYPE ram_1wnr IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME kernel_aie_consume_doppler_dmask_data_RAM_AUTO_1R1W RTLNAME kernel_aie_consume_doppler_dmask_data_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME doppler MODELNAME doppler RTLNAME kernel_doppler
    SUBMODULES {
      {MODELNAME kernel_doppler_window_RAM_AUTO_1R1W RTLNAME kernel_doppler_window_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME Block_entry_gmem_wr_proc MODELNAME Block_entry_gmem_wr_proc RTLNAME kernel_Block_entry_gmem_wr_proc
    SUBMODULES {
      {MODELNAME kernel_fifo_w32_d128_A RTLNAME kernel_fifo_w32_d128_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME idx_stream_U}
      {MODELNAME kernel_fifo_w160_d128_A RTLNAME kernel_fifo_w160_d128_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME mask_stream_U}
    }
  }
  {SRCNAME dummy MODELNAME dummy RTLNAME kernel_dummy}
  {SRCNAME kernel MODELNAME kernel RTLNAME kernel IS_TOP 1
    SUBMODULES {
      {MODELNAME kernel_fifo_w2816_d128_A RTLNAME kernel_fifo_w2816_d128_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME doppler_mask_stream_U}
      {MODELNAME kernel_start_for_dummy_U0 RTLNAME kernel_start_for_dummy_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_dummy_U0_U}
      {MODELNAME kernel_gmem_m_axi RTLNAME kernel_gmem_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME kernel_control_s_axi RTLNAME kernel_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
    }
  }
}

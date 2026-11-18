set SynModuleInfo {
  {SRCNAME adc_forward_Pipeline_VITIS_LOOP_58_3 MODELNAME adc_forward_Pipeline_VITIS_LOOP_58_3 RTLNAME kernel_adc_forward_Pipeline_VITIS_LOOP_58_3
    SUBMODULES {
      {MODELNAME kernel_mul_16s_15ns_31_1_1 RTLNAME kernel_mul_16s_15ns_31_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
      {MODELNAME kernel_adc_forward_Pipeline_VITIS_LOOP_58_3_hamming_window_2048_real_ROM_AUTO_1R RTLNAME kernel_adc_forward_Pipeline_VITIS_LOOP_58_3_hamming_window_2048_real_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME kernel_flow_control_loop_pipe_sequential_init RTLNAME kernel_flow_control_loop_pipe_sequential_init BINDTYPE interface TYPE internal_upc_flow_control INSTNAME kernel_flow_control_loop_pipe_sequential_init_U}
    }
  }
  {SRCNAME adc_forward MODELNAME adc_forward RTLNAME kernel_adc_forward
    SUBMODULES {
      {MODELNAME kernel_regslice_both RTLNAME kernel_regslice_both BINDTYPE interface TYPE adapter IMPL reg_slice}
    }
  }
  {SRCNAME aie_range_consume_Pipeline_VITIS_LOOP_102_3 MODELNAME aie_range_consume_Pipeline_VITIS_LOOP_102_3 RTLNAME kernel_aie_range_consume_Pipeline_VITIS_LOOP_102_3}
  {SRCNAME aie_range_consume_Pipeline_VITIS_LOOP_10_1 MODELNAME aie_range_consume_Pipeline_VITIS_LOOP_10_1 RTLNAME kernel_aie_range_consume_Pipeline_VITIS_LOOP_10_1}
  {SRCNAME aie_range_consume_Pipeline_VITIS_LOOP_112_4 MODELNAME aie_range_consume_Pipeline_VITIS_LOOP_112_4 RTLNAME kernel_aie_range_consume_Pipeline_VITIS_LOOP_112_4}
  {SRCNAME aie_range_consume MODELNAME aie_range_consume RTLNAME kernel_aie_range_consume
    SUBMODULES {
      {MODELNAME kernel_aie_range_consume_agg_tmp1_ids_ROM_AUTO_1R RTLNAME kernel_aie_range_consume_agg_tmp1_ids_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
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
  {SRCNAME doppler_Pipeline_VITIS_LOOP_97_2_VITIS_LOOP_103_3 MODELNAME doppler_Pipeline_VITIS_LOOP_97_2_VITIS_LOOP_103_3 RTLNAME kernel_doppler_Pipeline_VITIS_LOOP_97_2_VITIS_LOOP_103_3}
  {SRCNAME doppler_forward_one MODELNAME doppler_forward_one RTLNAME kernel_doppler_forward_one
    SUBMODULES {
      {MODELNAME kernel_doppler_forward_one_hamming_window_256_real_ROM_AUTO_1R RTLNAME kernel_doppler_forward_one_hamming_window_256_real_ROM_AUTO_1R BINDTYPE storage TYPE rom IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME aie_consume_doppler_Pipeline_1 MODELNAME aie_consume_doppler_Pipeline_1 RTLNAME kernel_aie_consume_doppler_Pipeline_1}
  {SRCNAME aie_consume_doppler_Pipeline_VITIS_LOOP_188_1 MODELNAME aie_consume_doppler_Pipeline_VITIS_LOOP_188_1 RTLNAME kernel_aie_consume_doppler_Pipeline_VITIS_LOOP_188_1}
  {SRCNAME aie_consume_doppler_Pipeline_VITIS_LOOP_199_2 MODELNAME aie_consume_doppler_Pipeline_VITIS_LOOP_199_2 RTLNAME kernel_aie_consume_doppler_Pipeline_VITIS_LOOP_199_2
    SUBMODULES {
      {MODELNAME kernel_mul_16s_16s_32_1_1 RTLNAME kernel_mul_16s_16s_32_1_1 BINDTYPE op TYPE mul IMPL auto LATENCY 0 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME aie_consume_doppler_Pipeline_VITIS_LOOP_235_3 MODELNAME aie_consume_doppler_Pipeline_VITIS_LOOP_235_3 RTLNAME kernel_aie_consume_doppler_Pipeline_VITIS_LOOP_235_3}
  {SRCNAME aie_consume_doppler_Pipeline_VITIS_LOOP_245_4 MODELNAME aie_consume_doppler_Pipeline_VITIS_LOOP_245_4 RTLNAME kernel_aie_consume_doppler_Pipeline_VITIS_LOOP_245_4
    SUBMODULES {
      {MODELNAME kernel_mul_32ns_32ns_64_3_1 RTLNAME kernel_mul_32ns_32ns_64_3_1 BINDTYPE op TYPE mul IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
    }
  }
  {SRCNAME aie_consume_doppler_Pipeline_VITIS_LOOP_256_5 MODELNAME aie_consume_doppler_Pipeline_VITIS_LOOP_256_5 RTLNAME kernel_aie_consume_doppler_Pipeline_VITIS_LOOP_256_5}
  {SRCNAME aie_consume_doppler_Pipeline_VITIS_LOOP_296_6 MODELNAME aie_consume_doppler_Pipeline_VITIS_LOOP_296_6 RTLNAME kernel_aie_consume_doppler_Pipeline_VITIS_LOOP_296_6
    SUBMODULES {
      {MODELNAME kernel_bitset_16ns_16ns_4ns_1ns_16_1_1 RTLNAME kernel_bitset_16ns_16ns_4ns_1ns_16_1_1 BINDTYPE op TYPE bitset IMPL auto}
    }
  }
  {SRCNAME aie_consume_doppler_Pipeline_VITIS_LOOP_327_9 MODELNAME aie_consume_doppler_Pipeline_VITIS_LOOP_327_9 RTLNAME kernel_aie_consume_doppler_Pipeline_VITIS_LOOP_327_9}
  {SRCNAME aie_consume_doppler_Pipeline_VITIS_LOOP_335_10 MODELNAME aie_consume_doppler_Pipeline_VITIS_LOOP_335_10 RTLNAME kernel_aie_consume_doppler_Pipeline_VITIS_LOOP_335_10}
  {SRCNAME aie_consume_doppler MODELNAME aie_consume_doppler RTLNAME kernel_aie_consume_doppler
    SUBMODULES {
      {MODELNAME kernel_mul_31ns_7ns_38_5_1 RTLNAME kernel_mul_31ns_7ns_38_5_1 BINDTYPE op TYPE mul IMPL dsp LATENCY 4 ALLOW_PRAGMA 1}
      {MODELNAME kernel_mul_38ns_11ns_48_5_1 RTLNAME kernel_mul_38ns_11ns_48_5_1 BINDTYPE op TYPE mul IMPL dsp LATENCY 4 ALLOW_PRAGMA 1}
      {MODELNAME kernel_aie_consume_doppler_dmask_RAM_AUTO_1R1W RTLNAME kernel_aie_consume_doppler_dmask_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME kernel_aie_consume_doppler_in_data_real_RAM_AUTO_1R1W RTLNAME kernel_aie_consume_doppler_in_data_real_RAM_AUTO_1R1W BINDTYPE storage TYPE ram IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
      {MODELNAME kernel_aie_consume_doppler_in_data_mag_RAM_1WNR_AUTO_1R1W RTLNAME kernel_aie_consume_doppler_in_data_mag_RAM_1WNR_AUTO_1R1W BINDTYPE storage TYPE ram_1wnr IMPL auto LATENCY 2 ALLOW_PRAGMA 1}
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
  {SRCNAME dummy_Pipeline_VITIS_LOOP_15_2 MODELNAME dummy_Pipeline_VITIS_LOOP_15_2 RTLNAME kernel_dummy_Pipeline_VITIS_LOOP_15_2}
  {SRCNAME dummy MODELNAME dummy RTLNAME kernel_dummy}
  {SRCNAME kernel MODELNAME kernel RTLNAME kernel IS_TOP 1
    SUBMODULES {
      {MODELNAME kernel_fifo_w64_d128_A RTLNAME kernel_fifo_w64_d128_A BINDTYPE storage TYPE fifo IMPL memory ALLOW_PRAGMA 1 INSTNAME doppler_mask_stream_U}
      {MODELNAME kernel_start_for_dummy_U0 RTLNAME kernel_start_for_dummy_U0 BINDTYPE storage TYPE fifo IMPL srl ALLOW_PRAGMA 1 INSTNAME start_for_dummy_U0_U}
      {MODELNAME kernel_gmem_m_axi RTLNAME kernel_gmem_m_axi BINDTYPE interface TYPE adapter IMPL m_axi}
      {MODELNAME kernel_control_s_axi RTLNAME kernel_control_s_axi BINDTYPE interface TYPE interface_s_axilite}
    }
  }
}

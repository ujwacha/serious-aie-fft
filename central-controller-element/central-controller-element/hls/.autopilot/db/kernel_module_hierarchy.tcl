set ModuleHierarchy {[{
"Name" : "kernel", "RefName" : "kernel","ID" : "0","Type" : "dataflow",
"SubInsts" : [
	{"Name" : "adc_forward_U0", "RefName" : "adc_forward","ID" : "1","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_53_1","RefName" : "VITIS_LOOP_53_1","ID" : "2","Type" : "no",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_55_2","RefName" : "VITIS_LOOP_55_2","ID" : "3","Type" : "no",
			"SubInsts" : [
			{"Name" : "grp_adc_forward_Pipeline_VITIS_LOOP_58_3_fu_93", "RefName" : "adc_forward_Pipeline_VITIS_LOOP_58_3","ID" : "4","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "VITIS_LOOP_58_3","RefName" : "VITIS_LOOP_58_3","ID" : "5","Type" : "pipeline"},]},]},]},]},
	{"Name" : "Block_entry_gmem_wr_proc_U0", "RefName" : "Block_entry_gmem_wr_proc","ID" : "6","Type" : "sequential",
		"SubInsts" : [
		{"Name" : "grp_aie_range_consume_fu_150", "RefName" : "aie_range_consume","ID" : "7","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_92_1","RefName" : "VITIS_LOOP_92_1","ID" : "8","Type" : "no",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_93_2","RefName" : "VITIS_LOOP_93_2","ID" : "9","Type" : "no",
				"SubInsts" : [
				{"Name" : "grp_aie_range_consume_Pipeline_VITIS_LOOP_102_3_fu_810", "RefName" : "aie_range_consume_Pipeline_VITIS_LOOP_102_3","ID" : "10","Type" : "sequential",
						"SubLoops" : [
						{"Name" : "VITIS_LOOP_102_3","RefName" : "VITIS_LOOP_102_3","ID" : "11","Type" : "pipeline"},]},
				{"Name" : "grp_aie_range_consume_Pipeline_VITIS_LOOP_10_1_fu_831", "RefName" : "aie_range_consume_Pipeline_VITIS_LOOP_10_1","ID" : "12","Type" : "sequential",
						"SubLoops" : [
						{"Name" : "VITIS_LOOP_10_1","RefName" : "VITIS_LOOP_10_1","ID" : "13","Type" : "pipeline"},]},
				{"Name" : "grp_aie_range_consume_Pipeline_VITIS_LOOP_112_4_fu_838", "RefName" : "aie_range_consume_Pipeline_VITIS_LOOP_112_4","ID" : "14","Type" : "sequential",
						"SubLoops" : [
						{"Name" : "VITIS_LOOP_112_4","RefName" : "VITIS_LOOP_112_4","ID" : "15","Type" : "pipeline"},]},]},]},]},
		{"Name" : "grp_seq_generator_fu_179", "RefName" : "seq_generator","ID" : "16","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_28_1","RefName" : "VITIS_LOOP_28_1","ID" : "17","Type" : "no",
			"SubInsts" : [
			{"Name" : "grp_seq_generator_Pipeline_VITIS_LOOP_49_2_fu_91", "RefName" : "seq_generator_Pipeline_VITIS_LOOP_49_2","ID" : "18","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "VITIS_LOOP_49_2","RefName" : "VITIS_LOOP_49_2","ID" : "19","Type" : "pipeline"},]},]},]},
		{"Name" : "grp_doppler_fu_189", "RefName" : "doppler","ID" : "20","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_91_1","RefName" : "VITIS_LOOP_91_1","ID" : "21","Type" : "no",
			"SubInsts" : [
			{"Name" : "grp_doppler_Pipeline_VITIS_LOOP_97_2_VITIS_LOOP_103_3_fu_163", "RefName" : "doppler_Pipeline_VITIS_LOOP_97_2_VITIS_LOOP_103_3","ID" : "22","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "VITIS_LOOP_97_2_VITIS_LOOP_103_3","RefName" : "VITIS_LOOP_97_2_VITIS_LOOP_103_3","ID" : "23","Type" : "pipeline"},]},],
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_113_4","RefName" : "VITIS_LOOP_113_4","ID" : "24","Type" : "no",
				"SubInsts" : [
				{"Name" : "grp_doppler_forward_one_fu_172", "RefName" : "doppler_forward_one","ID" : "25","Type" : "sequential",
						"SubLoops" : [
						{"Name" : "VITIS_LOOP_129_1","RefName" : "VITIS_LOOP_129_1","ID" : "26","Type" : "pipeline"},]},
				{"Name" : "grp_aie_consume_doppler_fu_196", "RefName" : "aie_consume_doppler","ID" : "27","Type" : "sequential",
						"SubInsts" : [
						{"Name" : "grp_aie_consume_doppler_Pipeline_1_fu_239", "RefName" : "aie_consume_doppler_Pipeline_1","ID" : "28","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "Loop 1","RefName" : "Loop 1","ID" : "29","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_188_1_fu_245", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_188_1","ID" : "30","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_188_1","RefName" : "VITIS_LOOP_188_1","ID" : "31","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_199_2_fu_269", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_199_2","ID" : "32","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_199_2","RefName" : "VITIS_LOOP_199_2","ID" : "33","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_235_3_fu_277", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_235_3","ID" : "34","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_235_3","RefName" : "VITIS_LOOP_235_3","ID" : "35","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_245_4_fu_283", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_245_4","ID" : "36","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_245_4","RefName" : "VITIS_LOOP_245_4","ID" : "37","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_256_5_fu_290", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_256_5","ID" : "38","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_256_5","RefName" : "VITIS_LOOP_256_5","ID" : "39","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_296_6_fu_296", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_296_6","ID" : "40","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_296_6","RefName" : "VITIS_LOOP_296_6","ID" : "41","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_327_9_fu_310", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_327_9","ID" : "42","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_327_9","RefName" : "VITIS_LOOP_327_9","ID" : "43","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_335_10_fu_316", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_335_10","ID" : "44","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_335_10","RefName" : "VITIS_LOOP_335_10","ID" : "45","Type" : "pipeline"},]},]},]},]},]},]},
	{"Name" : "dummy_U0", "RefName" : "dummy","ID" : "46","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_9_1","RefName" : "VITIS_LOOP_9_1","ID" : "47","Type" : "no",
		"SubInsts" : [
		{"Name" : "grp_dummy_Pipeline_VITIS_LOOP_15_2_fu_28", "RefName" : "dummy_Pipeline_VITIS_LOOP_15_2","ID" : "48","Type" : "sequential",
				"SubLoops" : [
				{"Name" : "VITIS_LOOP_15_2","RefName" : "VITIS_LOOP_15_2","ID" : "49","Type" : "pipeline"},]},]},]},]
}]}
set ModuleHierarchy {[{
"Name" : "kernel", "RefName" : "kernel","ID" : "0","Type" : "dataflow",
"SubInsts" : [
	{"Name" : "adc_forward_U0", "RefName" : "adc_forward","ID" : "1","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_52_1","RefName" : "VITIS_LOOP_52_1","ID" : "2","Type" : "no",
		"SubInsts" : [
		{"Name" : "grp_adc_forward_Pipeline_VITIS_LOOP_54_2_fu_70", "RefName" : "adc_forward_Pipeline_VITIS_LOOP_54_2","ID" : "3","Type" : "sequential",
				"SubLoops" : [
				{"Name" : "VITIS_LOOP_54_2","RefName" : "VITIS_LOOP_54_2","ID" : "4","Type" : "pipeline"},]},]},]},
	{"Name" : "Block_entry_gmem_wr_proc_U0", "RefName" : "Block_entry_gmem_wr_proc","ID" : "5","Type" : "sequential",
		"SubInsts" : [
		{"Name" : "grp_aie_range_consume_fu_148", "RefName" : "aie_range_consume","ID" : "6","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_88_1","RefName" : "VITIS_LOOP_88_1","ID" : "7","Type" : "no",
			"SubInsts" : [
			{"Name" : "grp_aie_range_consume_Pipeline_VITIS_LOOP_96_2_fu_774", "RefName" : "aie_range_consume_Pipeline_VITIS_LOOP_96_2","ID" : "8","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "VITIS_LOOP_96_2","RefName" : "VITIS_LOOP_96_2","ID" : "9","Type" : "pipeline"},]},
			{"Name" : "grp_aie_range_consume_Pipeline_VITIS_LOOP_10_1_fu_795", "RefName" : "aie_range_consume_Pipeline_VITIS_LOOP_10_1","ID" : "10","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "VITIS_LOOP_10_1","RefName" : "VITIS_LOOP_10_1","ID" : "11","Type" : "pipeline"},]},
			{"Name" : "grp_aie_range_consume_Pipeline_VITIS_LOOP_105_3_fu_802", "RefName" : "aie_range_consume_Pipeline_VITIS_LOOP_105_3","ID" : "12","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "VITIS_LOOP_105_3","RefName" : "VITIS_LOOP_105_3","ID" : "13","Type" : "pipeline"},]},]},]},
		{"Name" : "grp_seq_generator_fu_175", "RefName" : "seq_generator","ID" : "14","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_28_1","RefName" : "VITIS_LOOP_28_1","ID" : "15","Type" : "no",
			"SubInsts" : [
			{"Name" : "grp_seq_generator_Pipeline_VITIS_LOOP_49_2_fu_91", "RefName" : "seq_generator_Pipeline_VITIS_LOOP_49_2","ID" : "16","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "VITIS_LOOP_49_2","RefName" : "VITIS_LOOP_49_2","ID" : "17","Type" : "pipeline"},]},]},]},
		{"Name" : "grp_doppler_fu_185", "RefName" : "doppler","ID" : "18","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_91_1","RefName" : "VITIS_LOOP_91_1","ID" : "19","Type" : "no",
			"SubInsts" : [
			{"Name" : "grp_doppler_Pipeline_VITIS_LOOP_97_2_VITIS_LOOP_103_3_fu_163", "RefName" : "doppler_Pipeline_VITIS_LOOP_97_2_VITIS_LOOP_103_3","ID" : "20","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "VITIS_LOOP_97_2_VITIS_LOOP_103_3","RefName" : "VITIS_LOOP_97_2_VITIS_LOOP_103_3","ID" : "21","Type" : "pipeline"},]},],
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_113_4","RefName" : "VITIS_LOOP_113_4","ID" : "22","Type" : "no",
				"SubInsts" : [
				{"Name" : "grp_doppler_forward_one_fu_172", "RefName" : "doppler_forward_one","ID" : "23","Type" : "sequential",
						"SubLoops" : [
						{"Name" : "VITIS_LOOP_137_1","RefName" : "VITIS_LOOP_137_1","ID" : "24","Type" : "pipeline"},]},
				{"Name" : "grp_aie_consume_doppler_fu_196", "RefName" : "aie_consume_doppler","ID" : "25","Type" : "sequential",
						"SubInsts" : [
						{"Name" : "grp_aie_consume_doppler_Pipeline_1_fu_1048", "RefName" : "aie_consume_doppler_Pipeline_1","ID" : "26","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "Loop 1","RefName" : "Loop 1","ID" : "27","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_196_1_fu_1054", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_196_1","ID" : "28","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_196_1","RefName" : "VITIS_LOOP_196_1","ID" : "29","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_207_2_fu_1078", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_207_2","ID" : "30","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_207_2","RefName" : "VITIS_LOOP_207_2","ID" : "31","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_237_3_fu_1086", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_237_3","ID" : "32","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_237_3","RefName" : "VITIS_LOOP_237_3","ID" : "33","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_248_4_fu_1094", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_248_4","ID" : "34","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_248_4","RefName" : "VITIS_LOOP_248_4","ID" : "35","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_287_5_fu_1100", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_287_5","ID" : "36","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_287_5","RefName" : "VITIS_LOOP_287_5","ID" : "37","Type" : "pipeline"},]},],
						"SubLoops" : [
						{"Name" : "VITIS_LOOP_312_8","RefName" : "VITIS_LOOP_312_8","ID" : "38","Type" : "no",
						"SubInsts" : [
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_326_9_fu_1114", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_326_9","ID" : "39","Type" : "sequential",
								"SubLoops" : [
								{"Name" : "VITIS_LOOP_326_9","RefName" : "VITIS_LOOP_326_9","ID" : "40","Type" : "pipeline"},]},]},]},]},]},]},]},
	{"Name" : "dummy_U0", "RefName" : "dummy","ID" : "41","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_7_1","RefName" : "VITIS_LOOP_7_1","ID" : "42","Type" : "pipeline"},]},]
}]}
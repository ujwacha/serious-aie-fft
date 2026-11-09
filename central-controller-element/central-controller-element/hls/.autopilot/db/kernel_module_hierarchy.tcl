set ModuleHierarchy {[{
"Name" : "kernel", "RefName" : "kernel","ID" : "0","Type" : "dataflow",
"SubInsts" : [
	{"Name" : "adc_forward_U0", "RefName" : "adc_forward","ID" : "1","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_27_1_VITIS_LOOP_28_2","RefName" : "VITIS_LOOP_27_1_VITIS_LOOP_28_2","ID" : "2","Type" : "pipeline"},]},
	{"Name" : "Block_entry_gmem_wr_proc_U0", "RefName" : "Block_entry_gmem_wr_proc","ID" : "3","Type" : "sequential",
		"SubInsts" : [
		{"Name" : "grp_aie_range_consume_fu_148", "RefName" : "aie_range_consume","ID" : "4","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_61_1","RefName" : "VITIS_LOOP_61_1","ID" : "5","Type" : "no",
			"SubInsts" : [
			{"Name" : "grp_aie_range_consume_Pipeline_VITIS_LOOP_69_2_fu_774", "RefName" : "aie_range_consume_Pipeline_VITIS_LOOP_69_2","ID" : "6","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "VITIS_LOOP_69_2","RefName" : "VITIS_LOOP_69_2","ID" : "7","Type" : "pipeline"},]},
			{"Name" : "grp_aie_range_consume_Pipeline_VITIS_LOOP_10_1_fu_795", "RefName" : "aie_range_consume_Pipeline_VITIS_LOOP_10_1","ID" : "8","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "VITIS_LOOP_10_1","RefName" : "VITIS_LOOP_10_1","ID" : "9","Type" : "pipeline"},]},
			{"Name" : "grp_aie_range_consume_Pipeline_VITIS_LOOP_78_3_fu_802", "RefName" : "aie_range_consume_Pipeline_VITIS_LOOP_78_3","ID" : "10","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "VITIS_LOOP_78_3","RefName" : "VITIS_LOOP_78_3","ID" : "11","Type" : "pipeline"},]},]},]},
		{"Name" : "grp_seq_generator_fu_175", "RefName" : "seq_generator","ID" : "12","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_28_1","RefName" : "VITIS_LOOP_28_1","ID" : "13","Type" : "no",
			"SubInsts" : [
			{"Name" : "grp_seq_generator_Pipeline_VITIS_LOOP_49_2_fu_91", "RefName" : "seq_generator_Pipeline_VITIS_LOOP_49_2","ID" : "14","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "VITIS_LOOP_49_2","RefName" : "VITIS_LOOP_49_2","ID" : "15","Type" : "pipeline"},]},]},]},
		{"Name" : "grp_doppler_fu_185", "RefName" : "doppler","ID" : "16","Type" : "sequential",
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_91_1","RefName" : "VITIS_LOOP_91_1","ID" : "17","Type" : "no",
			"SubInsts" : [
			{"Name" : "grp_doppler_Pipeline_VITIS_LOOP_97_2_VITIS_LOOP_101_3_fu_151", "RefName" : "doppler_Pipeline_VITIS_LOOP_97_2_VITIS_LOOP_101_3","ID" : "18","Type" : "sequential",
					"SubLoops" : [
					{"Name" : "VITIS_LOOP_97_2_VITIS_LOOP_101_3","RefName" : "VITIS_LOOP_97_2_VITIS_LOOP_101_3","ID" : "19","Type" : "pipeline"},]},],
			"SubLoops" : [
			{"Name" : "VITIS_LOOP_112_4","RefName" : "VITIS_LOOP_112_4","ID" : "20","Type" : "no",
				"SubInsts" : [
				{"Name" : "grp_doppler_forward_one_fu_160", "RefName" : "doppler_forward_one","ID" : "21","Type" : "sequential",
						"SubLoops" : [
						{"Name" : "VITIS_LOOP_125_1","RefName" : "VITIS_LOOP_125_1","ID" : "22","Type" : "pipeline"},]},
				{"Name" : "grp_aie_consume_doppler_fu_184", "RefName" : "aie_consume_doppler","ID" : "23","Type" : "sequential",
						"SubInsts" : [
						{"Name" : "grp_aie_consume_doppler_Pipeline_1_fu_984", "RefName" : "aie_consume_doppler_Pipeline_1","ID" : "24","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "Loop 1","RefName" : "Loop 1","ID" : "25","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_185_1_fu_990", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_185_1","ID" : "26","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_185_1","RefName" : "VITIS_LOOP_185_1","ID" : "27","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_195_2_fu_1014", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_195_2","ID" : "28","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_195_2","RefName" : "VITIS_LOOP_195_2","ID" : "29","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_210_3_fu_1022", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_210_3","ID" : "30","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_210_3","RefName" : "VITIS_LOOP_210_3","ID" : "31","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_221_4_fu_1030", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_221_4","ID" : "32","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_221_4","RefName" : "VITIS_LOOP_221_4","ID" : "33","Type" : "pipeline"},]},
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_244_5_fu_1036", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_244_5","ID" : "34","Type" : "sequential",
							"SubLoops" : [
							{"Name" : "VITIS_LOOP_244_5","RefName" : "VITIS_LOOP_244_5","ID" : "35","Type" : "pipeline"},]},],
						"SubLoops" : [
						{"Name" : "VITIS_LOOP_269_8","RefName" : "VITIS_LOOP_269_8","ID" : "36","Type" : "no",
						"SubInsts" : [
						{"Name" : "grp_aie_consume_doppler_Pipeline_VITIS_LOOP_282_9_fu_1053", "RefName" : "aie_consume_doppler_Pipeline_VITIS_LOOP_282_9","ID" : "37","Type" : "sequential",
								"SubLoops" : [
								{"Name" : "VITIS_LOOP_282_9","RefName" : "VITIS_LOOP_282_9","ID" : "38","Type" : "pipeline"},]},]},]},]},]},]},]},
	{"Name" : "dummy_U0", "RefName" : "dummy","ID" : "39","Type" : "sequential"},]
}]}
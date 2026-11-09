set moduleName aie_consume_doppler_Pipeline_VITIS_LOOP_195_2
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set isPipelined_legacy 1
set pipeline_type loop_auto_rewind
set FunctionProtocol ap_ctrl_hs
set restart_counter_num 0
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set svuvm_can_support 1
set cdfgNum 23
set C_modelName {aie_consume_doppler_Pipeline_VITIS_LOOP_195_2}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
dict set ap_memory_interface_dict in_data_real { MEM_WIDTH 16 MEM_SIZE 512 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE WORD_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict in_data_imag { MEM_WIDTH 16 MEM_SIZE 512 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE WORD_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict in_data_mag { MEM_WIDTH 32 MEM_SIZE 1024 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE WORD_ADDRESS PACKAGE_IO port READ_LATENCY 0 }
set C_modelArgList {
	{ in_data_real int 16 regular {array 256 { 1 3 } 1 1 }  }
	{ in_data_imag int 16 regular {array 256 { 1 3 } 1 1 }  }
	{ in_data_mag float 32 regular {array 256 { 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 } 0 1 }  }
	{ mean_1_out float 32 regular {pointer 1}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "in_data_real", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "in_data_imag", "interface" : "memory", "bitwidth" : 16, "direction" : "READONLY"} , 
 	{ "Name" : "in_data_mag", "interface" : "memory", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "mean_1_out", "interface" : "wire", "bitwidth" : 32, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 27
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ in_data_real_address0 sc_out sc_lv 8 signal 0 } 
	{ in_data_real_ce0 sc_out sc_logic 1 signal 0 } 
	{ in_data_real_q0 sc_in sc_lv 16 signal 0 } 
	{ in_data_imag_address0 sc_out sc_lv 8 signal 1 } 
	{ in_data_imag_ce0 sc_out sc_logic 1 signal 1 } 
	{ in_data_imag_q0 sc_in sc_lv 16 signal 1 } 
	{ in_data_mag_address0 sc_out sc_lv 8 signal 2 } 
	{ in_data_mag_ce0 sc_out sc_logic 1 signal 2 } 
	{ in_data_mag_we0 sc_out sc_logic 1 signal 2 } 
	{ in_data_mag_d0 sc_out sc_lv 32 signal 2 } 
	{ mean_1_out sc_out sc_lv 32 signal 3 } 
	{ mean_1_out_ap_vld sc_out sc_logic 1 outvld 3 } 
	{ grp_fu_1060_p_din0 sc_out sc_lv 32 signal -1 } 
	{ grp_fu_1060_p_din1 sc_out sc_lv 32 signal -1 } 
	{ grp_fu_1060_p_opcode sc_out sc_lv 2 signal -1 } 
	{ grp_fu_1060_p_dout0 sc_in sc_lv 32 signal -1 } 
	{ grp_fu_1060_p_ce sc_out sc_logic 1 signal -1 } 
	{ grp_fu_1065_p_din0 sc_out sc_lv 32 signal -1 } 
	{ grp_fu_1065_p_din1 sc_out sc_lv 32 signal -1 } 
	{ grp_fu_1065_p_dout0 sc_in sc_lv 32 signal -1 } 
	{ grp_fu_1065_p_ce sc_out sc_logic 1 signal -1 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "in_data_real_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "in_data_real", "role": "address0" }} , 
 	{ "name": "in_data_real_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_real", "role": "ce0" }} , 
 	{ "name": "in_data_real_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "in_data_real", "role": "q0" }} , 
 	{ "name": "in_data_imag_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "in_data_imag", "role": "address0" }} , 
 	{ "name": "in_data_imag_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_imag", "role": "ce0" }} , 
 	{ "name": "in_data_imag_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "in_data_imag", "role": "q0" }} , 
 	{ "name": "in_data_mag_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "in_data_mag", "role": "address0" }} , 
 	{ "name": "in_data_mag_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_mag", "role": "ce0" }} , 
 	{ "name": "in_data_mag_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_mag", "role": "we0" }} , 
 	{ "name": "in_data_mag_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_data_mag", "role": "d0" }} , 
 	{ "name": "mean_1_out", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mean_1_out", "role": "default" }} , 
 	{ "name": "mean_1_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "mean_1_out", "role": "ap_vld" }} , 
 	{ "name": "grp_fu_1060_p_din0", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "grp_fu_1060_p_din0", "role": "default" }} , 
 	{ "name": "grp_fu_1060_p_din1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "grp_fu_1060_p_din1", "role": "default" }} , 
 	{ "name": "grp_fu_1060_p_opcode", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "grp_fu_1060_p_opcode", "role": "default" }} , 
 	{ "name": "grp_fu_1060_p_dout0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "grp_fu_1060_p_dout0", "role": "default" }} , 
 	{ "name": "grp_fu_1060_p_ce", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "grp_fu_1060_p_ce", "role": "default" }} , 
 	{ "name": "grp_fu_1065_p_din0", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "grp_fu_1065_p_din0", "role": "default" }} , 
 	{ "name": "grp_fu_1065_p_din1", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "grp_fu_1065_p_din1", "role": "default" }} , 
 	{ "name": "grp_fu_1065_p_dout0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "grp_fu_1065_p_dout0", "role": "default" }} , 
 	{ "name": "grp_fu_1065_p_ce", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "grp_fu_1065_p_ce", "role": "default" }}  ]}

set ArgLastReadFirstWriteLatency {
	aie_consume_doppler_Pipeline_VITIS_LOOP_195_2 {
		in_data_real {Type I LastRead 1 FirstWrite -1}
		in_data_imag {Type I LastRead 1 FirstWrite -1}
		in_data_mag {Type O LastRead -1 FirstWrite 29}
		mean_1_out {Type O LastRead -1 FirstWrite 28}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2846", "Max" : "2846"}
	, {"Name" : "Interval", "Min" : "2827", "Max" : "2827"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	in_data_real { ap_memory {  { in_data_real_address0 mem_address 1 8 }  { in_data_real_ce0 mem_ce 1 1 }  { in_data_real_q0 mem_dout 0 16 } } }
	in_data_imag { ap_memory {  { in_data_imag_address0 mem_address 1 8 }  { in_data_imag_ce0 mem_ce 1 1 }  { in_data_imag_q0 mem_dout 0 16 } } }
	in_data_mag { ap_memory {  { in_data_mag_address0 mem_address 1 8 }  { in_data_mag_ce0 mem_ce 1 1 }  { in_data_mag_we0 mem_we 1 1 }  { in_data_mag_d0 mem_din 1 32 } } }
	mean_1_out { ap_vld {  { mean_1_out out_data 1 32 }  { mean_1_out_ap_vld out_vld 1 1 } } }
}

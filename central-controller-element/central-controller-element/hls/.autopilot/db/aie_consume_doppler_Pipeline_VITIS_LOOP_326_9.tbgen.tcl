set moduleName aie_consume_doppler_Pipeline_VITIS_LOOP_326_9
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
set cdfgNum 24
set C_modelName {aie_consume_doppler_Pipeline_VITIS_LOOP_326_9}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
dict set ap_memory_interface_dict in_data_mag { MEM_WIDTH 32 MEM_SIZE 1024 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE WORD_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict dmask_data { MEM_WIDTH 32 MEM_SIZE 344 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE WORD_ADDRESS PACKAGE_IO port READ_LATENCY 0 }
set C_modelArgList {
	{ phi_mul int 9 regular  }
	{ in_data_mag int 32 regular {array 256 { 1 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 } 1 1 }  }
	{ dmask_data int 32 regular {array 86 { 0 3 } 0 1 }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "phi_mul", "interface" : "wire", "bitwidth" : 9, "direction" : "READONLY"} , 
 	{ "Name" : "in_data_mag", "interface" : "memory", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "dmask_data", "interface" : "memory", "bitwidth" : 32, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 14
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ phi_mul sc_in sc_lv 9 signal 0 } 
	{ in_data_mag_address0 sc_out sc_lv 8 signal 1 } 
	{ in_data_mag_ce0 sc_out sc_logic 1 signal 1 } 
	{ in_data_mag_q0 sc_in sc_lv 32 signal 1 } 
	{ dmask_data_address0 sc_out sc_lv 7 signal 2 } 
	{ dmask_data_ce0 sc_out sc_logic 1 signal 2 } 
	{ dmask_data_we0 sc_out sc_logic 1 signal 2 } 
	{ dmask_data_d0 sc_out sc_lv 32 signal 2 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "phi_mul", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "phi_mul", "role": "default" }} , 
 	{ "name": "in_data_mag_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "in_data_mag", "role": "address0" }} , 
 	{ "name": "in_data_mag_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_mag", "role": "ce0" }} , 
 	{ "name": "in_data_mag_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_data_mag", "role": "q0" }} , 
 	{ "name": "dmask_data_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "dmask_data", "role": "address0" }} , 
 	{ "name": "dmask_data_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "dmask_data", "role": "ce0" }} , 
 	{ "name": "dmask_data_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "dmask_data", "role": "we0" }} , 
 	{ "name": "dmask_data_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "dmask_data", "role": "d0" }}  ]}

set ArgLastReadFirstWriteLatency {
	aie_consume_doppler_Pipeline_VITIS_LOOP_326_9 {
		phi_mul {Type I LastRead 0 FirstWrite -1}
		in_data_mag {Type I LastRead 1 FirstWrite -1}
		dmask_data {Type O LastRead -1 FirstWrite 3}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "90", "Max" : "90"}
	, {"Name" : "Interval", "Min" : "87", "Max" : "87"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	phi_mul { ap_none {  { phi_mul in_data 0 9 } } }
	in_data_mag { ap_memory {  { in_data_mag_address0 mem_address 1 8 }  { in_data_mag_ce0 mem_ce 1 1 }  { in_data_mag_q0 mem_dout 0 32 } } }
	dmask_data { ap_memory {  { dmask_data_address0 mem_address 1 7 }  { dmask_data_ce0 mem_ce 1 1 }  { dmask_data_we0 mem_we 1 1 }  { dmask_data_d0 mem_din 1 32 } } }
}

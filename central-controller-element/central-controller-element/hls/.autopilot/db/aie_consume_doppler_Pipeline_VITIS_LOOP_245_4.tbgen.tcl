set moduleName aie_consume_doppler_Pipeline_VITIS_LOOP_245_4
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
set cdfgNum 27
set C_modelName {aie_consume_doppler_Pipeline_VITIS_LOOP_245_4}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
dict set ap_memory_interface_dict in_data_mag { MEM_WIDTH 32 MEM_SIZE 1024 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE WORD_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict histogram { MEM_WIDTH 32 MEM_SIZE 256 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE WORD_ADDRESS PACKAGE_IO port READ_LATENCY 0 }
set C_modelArgList {
	{ in_data_mag int 32 regular {array 256 { 1 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 } 1 1 }  }
	{ zext_ln247 int 32 regular  }
	{ histogram int 32 regular {array 64 { 0 1 } 1 1 }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "in_data_mag", "interface" : "memory", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "zext_ln247", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "histogram", "interface" : "memory", "bitwidth" : 32, "direction" : "READWRITE"} ]}
# RTL Port declarations: 
set portNum 17
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ in_data_mag_address0 sc_out sc_lv 8 signal 0 } 
	{ in_data_mag_ce0 sc_out sc_logic 1 signal 0 } 
	{ in_data_mag_q0 sc_in sc_lv 32 signal 0 } 
	{ zext_ln247 sc_in sc_lv 32 signal 1 } 
	{ histogram_address0 sc_out sc_lv 6 signal 2 } 
	{ histogram_ce0 sc_out sc_logic 1 signal 2 } 
	{ histogram_we0 sc_out sc_logic 1 signal 2 } 
	{ histogram_d0 sc_out sc_lv 32 signal 2 } 
	{ histogram_address1 sc_out sc_lv 6 signal 2 } 
	{ histogram_ce1 sc_out sc_logic 1 signal 2 } 
	{ histogram_q1 sc_in sc_lv 32 signal 2 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "in_data_mag_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "in_data_mag", "role": "address0" }} , 
 	{ "name": "in_data_mag_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_mag", "role": "ce0" }} , 
 	{ "name": "in_data_mag_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_data_mag", "role": "q0" }} , 
 	{ "name": "zext_ln247", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "zext_ln247", "role": "default" }} , 
 	{ "name": "histogram_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "histogram", "role": "address0" }} , 
 	{ "name": "histogram_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "histogram", "role": "ce0" }} , 
 	{ "name": "histogram_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "histogram", "role": "we0" }} , 
 	{ "name": "histogram_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "histogram", "role": "d0" }} , 
 	{ "name": "histogram_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "histogram", "role": "address1" }} , 
 	{ "name": "histogram_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "histogram", "role": "ce1" }} , 
 	{ "name": "histogram_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "histogram", "role": "q1" }}  ]}

set ArgLastReadFirstWriteLatency {
	aie_consume_doppler_Pipeline_VITIS_LOOP_245_4 {
		in_data_mag {Type I LastRead 0 FirstWrite -1}
		zext_ln247 {Type I LastRead 0 FirstWrite -1}
		histogram {Type IO LastRead 6 FirstWrite 8}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "520", "Max" : "520"}
	, {"Name" : "Interval", "Min" : "514", "Max" : "514"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	in_data_mag { ap_memory {  { in_data_mag_address0 mem_address 1 8 }  { in_data_mag_ce0 mem_ce 1 1 }  { in_data_mag_q0 mem_dout 0 32 } } }
	zext_ln247 { ap_none {  { zext_ln247 in_data 0 32 } } }
	histogram { ap_memory {  { histogram_address0 mem_address 1 6 }  { histogram_ce0 mem_ce 1 1 }  { histogram_we0 mem_we 1 1 }  { histogram_d0 mem_din 1 32 }  { histogram_address1 MemPortADDR2 1 6 }  { histogram_ce1 MemPortCE2 1 1 }  { histogram_q1 MemPortDOUT2 0 32 } } }
}

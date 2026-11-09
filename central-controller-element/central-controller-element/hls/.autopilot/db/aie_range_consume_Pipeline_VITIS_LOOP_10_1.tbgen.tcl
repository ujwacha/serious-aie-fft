set moduleName aie_range_consume_Pipeline_VITIS_LOOP_10_1
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
set C_modelName {aie_range_consume_Pipeline_VITIS_LOOP_10_1}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
dict set ap_memory_interface_dict mask_head { MEM_WIDTH 32 MEM_SIZE 256 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE WORD_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
dict set ap_memory_interface_dict adr_buf { MEM_WIDTH 12 MEM_SIZE 256 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE WORD_ADDRESS PACKAGE_IO port READ_LATENCY 0 }
set C_modelArgList {
	{ mask_head int 32 regular {array 64 { 1 3 } 1 1 }  }
	{ adr_buf int 12 regular {array 128 { 0 3 } 0 1 }  }
	{ n_out int 32 regular {pointer 1}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "mask_head", "interface" : "memory", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "adr_buf", "interface" : "memory", "bitwidth" : 12, "direction" : "WRITEONLY"} , 
 	{ "Name" : "n_out", "interface" : "wire", "bitwidth" : 32, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 15
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ mask_head_address0 sc_out sc_lv 6 signal 0 } 
	{ mask_head_ce0 sc_out sc_logic 1 signal 0 } 
	{ mask_head_q0 sc_in sc_lv 32 signal 0 } 
	{ adr_buf_address0 sc_out sc_lv 7 signal 1 } 
	{ adr_buf_ce0 sc_out sc_logic 1 signal 1 } 
	{ adr_buf_we0 sc_out sc_logic 1 signal 1 } 
	{ adr_buf_d0 sc_out sc_lv 12 signal 1 } 
	{ n_out sc_out sc_lv 32 signal 2 } 
	{ n_out_ap_vld sc_out sc_logic 1 outvld 2 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "mask_head_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "mask_head", "role": "address0" }} , 
 	{ "name": "mask_head_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mask_head", "role": "ce0" }} , 
 	{ "name": "mask_head_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "mask_head", "role": "q0" }} , 
 	{ "name": "adr_buf_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":7, "type": "signal", "bundle":{"name": "adr_buf", "role": "address0" }} , 
 	{ "name": "adr_buf_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "adr_buf", "role": "ce0" }} , 
 	{ "name": "adr_buf_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "adr_buf", "role": "we0" }} , 
 	{ "name": "adr_buf_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "adr_buf", "role": "d0" }} , 
 	{ "name": "n_out", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "n_out", "role": "default" }} , 
 	{ "name": "n_out_ap_vld", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "n_out", "role": "ap_vld" }}  ]}

set ArgLastReadFirstWriteLatency {
	aie_range_consume_Pipeline_VITIS_LOOP_10_1 {
		mask_head {Type I LastRead 1 FirstWrite -1}
		adr_buf {Type O LastRead -1 FirstWrite 4}
		n_out {Type O LastRead -1 FirstWrite 3}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "261", "Max" : "261"}
	, {"Name" : "Interval", "Min" : "260", "Max" : "260"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	mask_head { ap_memory {  { mask_head_address0 mem_address 1 6 }  { mask_head_ce0 mem_ce 1 1 }  { mask_head_q0 mem_dout 0 32 } } }
	adr_buf { ap_memory {  { adr_buf_address0 mem_address 1 7 }  { adr_buf_ce0 mem_ce 1 1 }  { adr_buf_we0 mem_we 1 1 }  { adr_buf_d0 mem_din 1 12 } } }
	n_out { ap_vld {  { n_out out_data 1 32 }  { n_out_ap_vld out_vld 1 1 } } }
}

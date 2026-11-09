set moduleName dummy
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set isPipelined_legacy 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set restart_counter_num 0
set isOneStateSeq 1
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set svuvm_can_support 1
set cdfgNum 23
set C_modelName {dummy}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ doppler_mask_stream int 2816 regular {fifo 0 volatile }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "doppler_mask_stream", "interface" : "fifo", "bitwidth" : 2816, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 12
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ doppler_mask_stream_dout sc_in sc_lv 2816 signal 0 } 
	{ doppler_mask_stream_empty_n sc_in sc_logic 1 signal 0 } 
	{ doppler_mask_stream_read sc_out sc_logic 1 signal 0 } 
	{ doppler_mask_stream_num_data_valid sc_in sc_lv 8 signal 0 } 
	{ doppler_mask_stream_fifo_cap sc_in sc_lv 8 signal 0 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "doppler_mask_stream_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":2816, "type": "signal", "bundle":{"name": "doppler_mask_stream", "role": "dout" }} , 
 	{ "name": "doppler_mask_stream_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "doppler_mask_stream", "role": "empty_n" }} , 
 	{ "name": "doppler_mask_stream_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "doppler_mask_stream", "role": "read" }} , 
 	{ "name": "doppler_mask_stream_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "doppler_mask_stream", "role": "num_data_valid" }} , 
 	{ "name": "doppler_mask_stream_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "doppler_mask_stream", "role": "fifo_cap" }}  ]}

set ArgLastReadFirstWriteLatency {
	dummy {
		doppler_mask_stream {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "0", "Max" : "0"}
	, {"Name" : "Interval", "Min" : "0", "Max" : "0"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	doppler_mask_stream { ap_fifo {  { doppler_mask_stream_dout fifo_data_out 0 2816 }  { doppler_mask_stream_empty_n fifo_status_empty 0 1 }  { doppler_mask_stream_read fifo_data_in 1 1 }  { doppler_mask_stream_num_data_valid fifo_update 0 8 }  { doppler_mask_stream_fifo_cap fifo_data 0 8 } } }
}

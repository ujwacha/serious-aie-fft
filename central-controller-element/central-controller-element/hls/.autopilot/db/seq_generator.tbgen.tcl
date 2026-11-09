set moduleName seq_generator
set isTopModule 0
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set isPipelined_legacy 0
set pipeline_type none
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
set C_modelName {seq_generator}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ mask_stream int 160 regular {fifo 0 volatile }  }
	{ idx_stream int 32 regular {fifo 1 volatile }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "mask_stream", "interface" : "fifo", "bitwidth" : 160, "direction" : "READONLY"} , 
 	{ "Name" : "idx_stream", "interface" : "fifo", "bitwidth" : 32, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 12
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ mask_stream_dout sc_in sc_lv 160 signal 0 } 
	{ mask_stream_empty_n sc_in sc_logic 1 signal 0 } 
	{ mask_stream_read sc_out sc_logic 1 signal 0 } 
	{ idx_stream_din sc_out sc_lv 32 signal 1 } 
	{ idx_stream_full_n sc_in sc_logic 1 signal 1 } 
	{ idx_stream_write sc_out sc_logic 1 signal 1 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "mask_stream_dout", "direction": "in", "datatype": "sc_lv", "bitwidth":160, "type": "signal", "bundle":{"name": "mask_stream", "role": "dout" }} , 
 	{ "name": "mask_stream_empty_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mask_stream", "role": "empty_n" }} , 
 	{ "name": "mask_stream_read", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "mask_stream", "role": "read" }} , 
 	{ "name": "idx_stream_din", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "idx_stream", "role": "din" }} , 
 	{ "name": "idx_stream_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "idx_stream", "role": "full_n" }} , 
 	{ "name": "idx_stream_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "idx_stream", "role": "write" }}  ]}

set ArgLastReadFirstWriteLatency {
	seq_generator {
		mask_stream {Type I LastRead 1 FirstWrite -1}
		idx_stream {Type O LastRead -1 FirstWrite 2}
		mask_seqs {Type IO LastRead -1 FirstWrite -1}
		seqs_done {Type IO LastRead -1 FirstWrite -1}}
	seq_generator_Pipeline_VITIS_LOOP_49_2 {
		current_mask {Type I LastRead 0 FirstWrite -1}
		mask_seq {Type I LastRead 0 FirstWrite -1}
		idx_stream {Type O LastRead -1 FirstWrite 2}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "-1", "Max" : "-1"}
	, {"Name" : "Interval", "Min" : "-1", "Max" : "-1"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	mask_stream { ap_fifo {  { mask_stream_dout fifo_data_out 0 160 }  { mask_stream_empty_n fifo_status_empty 0 1 }  { mask_stream_read fifo_data_in 1 1 } } }
	idx_stream { ap_fifo {  { idx_stream_din fifo_data_out 1 32 }  { idx_stream_full_n fifo_status_empty 0 1 }  { idx_stream_write fifo_data_in 1 1 } } }
}

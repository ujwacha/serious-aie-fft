set moduleName adc_forward
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
set C_modelName {adc_forward}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ in_adc0_V_data_V int 64 regular {axi_s 0 volatile  { in_adc0 Data } }  }
	{ in_adc0_V_keep_V int 8 regular {axi_s 0 volatile  { in_adc0 Keep } }  }
	{ in_adc0_V_strb_V int 8 regular {axi_s 0 volatile  { in_adc0 Strb } }  }
	{ in_adc0_V_last_V int 1 regular {axi_s 0 volatile  { in_adc0 Last } }  }
	{ out_r_00_V_data_V int 32 regular {axi_s 1 volatile  { out_r_00 Data } }  }
	{ out_r_00_V_keep_V int 4 regular {axi_s 1 volatile  { out_r_00 Keep } }  }
	{ out_r_00_V_strb_V int 4 regular {axi_s 1 volatile  { out_r_00 Strb } }  }
	{ out_r_00_V_last_V int 1 regular {axi_s 1 volatile  { out_r_00 Last } }  }
	{ out_r_01_V_data_V int 32 regular {axi_s 1 volatile  { out_r_01 Data } }  }
	{ out_r_01_V_keep_V int 4 regular {axi_s 1 volatile  { out_r_01 Keep } }  }
	{ out_r_01_V_strb_V int 4 regular {axi_s 1 volatile  { out_r_01 Strb } }  }
	{ out_r_01_V_last_V int 1 regular {axi_s 1 volatile  { out_r_01 Last } }  }
	{ num_chirps int 32 regular  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "in_adc0_V_data_V", "interface" : "axis", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "in_adc0_V_keep_V", "interface" : "axis", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "in_adc0_V_strb_V", "interface" : "axis", "bitwidth" : 8, "direction" : "READONLY"} , 
 	{ "Name" : "in_adc0_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "out_r_00_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_r_00_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_r_00_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_r_00_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_r_01_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_r_01_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_r_01_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_r_01_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "num_chirps", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 26
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ in_adc0_TVALID sc_in sc_logic 1 invld 3 } 
	{ out_r_00_TREADY sc_in sc_logic 1 outacc 7 } 
	{ out_r_01_TREADY sc_in sc_logic 1 outacc 11 } 
	{ in_adc0_TDATA sc_in sc_lv 64 signal 0 } 
	{ in_adc0_TREADY sc_out sc_logic 1 inacc 3 } 
	{ in_adc0_TKEEP sc_in sc_lv 8 signal 1 } 
	{ in_adc0_TSTRB sc_in sc_lv 8 signal 2 } 
	{ in_adc0_TLAST sc_in sc_lv 1 signal 3 } 
	{ out_r_00_TDATA sc_out sc_lv 32 signal 4 } 
	{ out_r_00_TVALID sc_out sc_logic 1 outvld 7 } 
	{ out_r_00_TKEEP sc_out sc_lv 4 signal 5 } 
	{ out_r_00_TSTRB sc_out sc_lv 4 signal 6 } 
	{ out_r_00_TLAST sc_out sc_lv 1 signal 7 } 
	{ out_r_01_TDATA sc_out sc_lv 32 signal 8 } 
	{ out_r_01_TVALID sc_out sc_logic 1 outvld 11 } 
	{ out_r_01_TKEEP sc_out sc_lv 4 signal 9 } 
	{ out_r_01_TSTRB sc_out sc_lv 4 signal 10 } 
	{ out_r_01_TLAST sc_out sc_lv 1 signal 11 } 
	{ num_chirps sc_in sc_lv 32 signal 12 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "in_adc0_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_adc0_V_last_V", "role": "default" }} , 
 	{ "name": "out_r_00_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "out_r_00_V_last_V", "role": "default" }} , 
 	{ "name": "out_r_01_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "out_r_01_V_last_V", "role": "default" }} , 
 	{ "name": "in_adc0_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "in_adc0_V_data_V", "role": "default" }} , 
 	{ "name": "in_adc0_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_adc0_V_last_V", "role": "default" }} , 
 	{ "name": "in_adc0_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "in_adc0_V_keep_V", "role": "default" }} , 
 	{ "name": "in_adc0_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "in_adc0_V_strb_V", "role": "default" }} , 
 	{ "name": "in_adc0_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_adc0_V_last_V", "role": "default" }} , 
 	{ "name": "out_r_00_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "out_r_00_V_data_V", "role": "default" }} , 
 	{ "name": "out_r_00_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "out_r_00_V_last_V", "role": "default" }} , 
 	{ "name": "out_r_00_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_r_00_V_keep_V", "role": "default" }} , 
 	{ "name": "out_r_00_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_r_00_V_strb_V", "role": "default" }} , 
 	{ "name": "out_r_00_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_r_00_V_last_V", "role": "default" }} , 
 	{ "name": "out_r_01_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "out_r_01_V_data_V", "role": "default" }} , 
 	{ "name": "out_r_01_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "out_r_01_V_last_V", "role": "default" }} , 
 	{ "name": "out_r_01_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_r_01_V_keep_V", "role": "default" }} , 
 	{ "name": "out_r_01_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_r_01_V_strb_V", "role": "default" }} , 
 	{ "name": "out_r_01_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_r_01_V_last_V", "role": "default" }} , 
 	{ "name": "num_chirps", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "num_chirps", "role": "default" }}  ]}

set ArgLastReadFirstWriteLatency {
	adc_forward {
		in_adc0_V_data_V {Type I LastRead 2 FirstWrite -1}
		in_adc0_V_keep_V {Type I LastRead 2 FirstWrite -1}
		in_adc0_V_strb_V {Type I LastRead 2 FirstWrite -1}
		in_adc0_V_last_V {Type I LastRead 2 FirstWrite -1}
		out_r_00_V_data_V {Type O LastRead -1 FirstWrite 4}
		out_r_00_V_keep_V {Type O LastRead -1 FirstWrite 4}
		out_r_00_V_strb_V {Type O LastRead -1 FirstWrite 4}
		out_r_00_V_last_V {Type O LastRead -1 FirstWrite 4}
		out_r_01_V_data_V {Type O LastRead -1 FirstWrite 4}
		out_r_01_V_keep_V {Type O LastRead -1 FirstWrite 4}
		out_r_01_V_strb_V {Type O LastRead -1 FirstWrite 4}
		out_r_01_V_last_V {Type O LastRead -1 FirstWrite 4}
		num_chirps {Type I LastRead 0 FirstWrite -1}
		hamming_window_2048_real {Type I LastRead -1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "2", "Max" : "4398046510086"}
	, {"Name" : "Interval", "Min" : "1", "Max" : "4398046510081"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	in_adc0_V_data_V { axis {  { in_adc0_TDATA in_data 0 64 } } }
	in_adc0_V_keep_V { axis {  { in_adc0_TKEEP in_data 0 8 } } }
	in_adc0_V_strb_V { axis {  { in_adc0_TSTRB in_data 0 8 } } }
	in_adc0_V_last_V { axis {  { in_adc0_TVALID in_vld 0 1 }  { in_adc0_TREADY in_acc 1 1 }  { in_adc0_TLAST in_data 0 1 } } }
	out_r_00_V_data_V { axis {  { out_r_00_TDATA out_data 1 32 } } }
	out_r_00_V_keep_V { axis {  { out_r_00_TKEEP out_data 1 4 } } }
	out_r_00_V_strb_V { axis {  { out_r_00_TSTRB out_data 1 4 } } }
	out_r_00_V_last_V { axis {  { out_r_00_TREADY out_acc 0 1 }  { out_r_00_TVALID out_vld 1 1 }  { out_r_00_TLAST out_data 1 1 } } }
	out_r_01_V_data_V { axis {  { out_r_01_TDATA out_data 1 32 } } }
	out_r_01_V_keep_V { axis {  { out_r_01_TKEEP out_data 1 4 } } }
	out_r_01_V_strb_V { axis {  { out_r_01_TSTRB out_data 1 4 } } }
	out_r_01_V_last_V { axis {  { out_r_01_TREADY out_acc 0 1 }  { out_r_01_TVALID out_vld 1 1 }  { out_r_01_TLAST out_data 1 1 } } }
	num_chirps { ap_none {  { num_chirps in_data 0 32 } } }
}

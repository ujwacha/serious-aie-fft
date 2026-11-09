set moduleName doppler_forward_one
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
set C_modelName {doppler_forward_one}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
dict set ap_memory_interface_dict in_adc0 { MEM_WIDTH 32 MEM_SIZE 16384 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE WORD_ADDRESS PACKAGE_IO port READ_LATENCY 1 }
set C_modelArgList {
	{ in_adc0 int 32 regular {array 4096 { 1 1 } 1 1 }  }
	{ in_adc0_offset int 4 regular  }
	{ out_d_02_V_data_V int 32 regular {axi_s 1 volatile  { out_d_02 Data } }  }
	{ out_d_02_V_keep_V int 4 regular {axi_s 1 volatile  { out_d_02 Keep } }  }
	{ out_d_02_V_strb_V int 4 regular {axi_s 1 volatile  { out_d_02 Strb } }  }
	{ out_d_02_V_last_V int 1 regular {axi_s 1 volatile  { out_d_02 Last } }  }
	{ out_d_03_V_data_V int 32 regular {axi_s 1 volatile  { out_d_03 Data } }  }
	{ out_d_03_V_keep_V int 4 regular {axi_s 1 volatile  { out_d_03 Keep } }  }
	{ out_d_03_V_strb_V int 4 regular {axi_s 1 volatile  { out_d_03 Strb } }  }
	{ out_d_03_V_last_V int 1 regular {axi_s 1 volatile  { out_d_03 Last } }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "in_adc0", "interface" : "memory", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "in_adc0_offset", "interface" : "wire", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "out_d_02_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_d_02_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_d_02_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_d_02_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_d_03_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_d_03_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_d_03_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_d_03_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 25
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ out_d_02_TREADY sc_in sc_logic 1 outacc 2 } 
	{ out_d_03_TREADY sc_in sc_logic 1 outacc 6 } 
	{ in_adc0_address0 sc_out sc_lv 12 signal 0 } 
	{ in_adc0_ce0 sc_out sc_logic 1 signal 0 } 
	{ in_adc0_q0 sc_in sc_lv 32 signal 0 } 
	{ in_adc0_address1 sc_out sc_lv 12 signal 0 } 
	{ in_adc0_ce1 sc_out sc_logic 1 signal 0 } 
	{ in_adc0_q1 sc_in sc_lv 32 signal 0 } 
	{ in_adc0_offset sc_in sc_lv 4 signal 1 } 
	{ out_d_02_TDATA sc_out sc_lv 32 signal 2 } 
	{ out_d_02_TVALID sc_out sc_logic 1 outvld 5 } 
	{ out_d_02_TKEEP sc_out sc_lv 4 signal 3 } 
	{ out_d_02_TSTRB sc_out sc_lv 4 signal 4 } 
	{ out_d_02_TLAST sc_out sc_lv 1 signal 5 } 
	{ out_d_03_TDATA sc_out sc_lv 32 signal 6 } 
	{ out_d_03_TVALID sc_out sc_logic 1 outvld 9 } 
	{ out_d_03_TKEEP sc_out sc_lv 4 signal 7 } 
	{ out_d_03_TSTRB sc_out sc_lv 4 signal 8 } 
	{ out_d_03_TLAST sc_out sc_lv 1 signal 9 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "out_d_02_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "out_d_02_V_data_V", "role": "default" }} , 
 	{ "name": "out_d_03_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "out_d_03_V_data_V", "role": "default" }} , 
 	{ "name": "in_adc0_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "in_adc0", "role": "address0" }} , 
 	{ "name": "in_adc0_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_adc0", "role": "ce0" }} , 
 	{ "name": "in_adc0_q0", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_adc0", "role": "q0" }} , 
 	{ "name": "in_adc0_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":12, "type": "signal", "bundle":{"name": "in_adc0", "role": "address1" }} , 
 	{ "name": "in_adc0_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_adc0", "role": "ce1" }} , 
 	{ "name": "in_adc0_q1", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_adc0", "role": "q1" }} , 
 	{ "name": "in_adc0_offset", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_adc0_offset", "role": "default" }} , 
 	{ "name": "out_d_02_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "out_d_02_V_data_V", "role": "default" }} , 
 	{ "name": "out_d_02_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "out_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "out_d_02_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_d_02_V_keep_V", "role": "default" }} , 
 	{ "name": "out_d_02_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_d_02_V_strb_V", "role": "default" }} , 
 	{ "name": "out_d_02_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "out_d_03_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "out_d_03_V_data_V", "role": "default" }} , 
 	{ "name": "out_d_03_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "out_d_03_V_last_V", "role": "default" }} , 
 	{ "name": "out_d_03_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_d_03_V_keep_V", "role": "default" }} , 
 	{ "name": "out_d_03_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_d_03_V_strb_V", "role": "default" }} , 
 	{ "name": "out_d_03_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_d_03_V_last_V", "role": "default" }}  ]}

set ArgLastReadFirstWriteLatency {
	doppler_forward_one {
		in_adc0 {Type I LastRead 2 FirstWrite -1}
		in_adc0_offset {Type I LastRead 0 FirstWrite -1}
		out_d_02_V_data_V {Type O LastRead -1 FirstWrite 4}
		out_d_02_V_keep_V {Type O LastRead -1 FirstWrite 4}
		out_d_02_V_strb_V {Type O LastRead -1 FirstWrite 4}
		out_d_02_V_last_V {Type O LastRead -1 FirstWrite 4}
		out_d_03_V_data_V {Type O LastRead -1 FirstWrite 4}
		out_d_03_V_keep_V {Type O LastRead -1 FirstWrite 4}
		out_d_03_V_strb_V {Type O LastRead -1 FirstWrite 4}
		out_d_03_V_last_V {Type O LastRead -1 FirstWrite 4}
		hamming_window_256_real {Type I LastRead -1 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "133", "Max" : "133"}
	, {"Name" : "Interval", "Min" : "129", "Max" : "129"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	in_adc0 { ap_memory {  { in_adc0_address0 mem_address 1 12 }  { in_adc0_ce0 mem_ce 1 1 }  { in_adc0_q0 mem_dout 0 32 }  { in_adc0_address1 MemPortADDR2 1 12 }  { in_adc0_ce1 MemPortCE2 1 1 }  { in_adc0_q1 MemPortDOUT2 0 32 } } }
	in_adc0_offset { ap_none {  { in_adc0_offset in_data 0 4 } } }
	out_d_02_V_data_V { axis {  { out_d_02_TREADY out_acc 0 1 }  { out_d_02_TDATA out_data 1 32 } } }
	out_d_02_V_keep_V { axis {  { out_d_02_TKEEP out_data 1 4 } } }
	out_d_02_V_strb_V { axis {  { out_d_02_TSTRB out_data 1 4 } } }
	out_d_02_V_last_V { axis {  { out_d_02_TVALID out_vld 1 1 }  { out_d_02_TLAST out_data 1 1 } } }
	out_d_03_V_data_V { axis {  { out_d_03_TREADY out_acc 0 1 }  { out_d_03_TDATA out_data 1 32 } } }
	out_d_03_V_keep_V { axis {  { out_d_03_TKEEP out_data 1 4 } } }
	out_d_03_V_strb_V { axis {  { out_d_03_TSTRB out_data 1 4 } } }
	out_d_03_V_last_V { axis {  { out_d_03_TVALID out_vld 1 1 }  { out_d_03_TLAST out_data 1 1 } } }
}

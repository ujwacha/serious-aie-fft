set moduleName aie_consume_doppler_Pipeline_VITIS_LOOP_185_1
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
set C_modelName {aie_consume_doppler_Pipeline_VITIS_LOOP_185_1}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
dict set ap_memory_interface_dict in_data_real { MEM_WIDTH 16 MEM_SIZE 512 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE WORD_ADDRESS PACKAGE_IO port READ_LATENCY 0 }
dict set ap_memory_interface_dict in_data_imag { MEM_WIDTH 16 MEM_SIZE 512 MASTER_TYPE BRAM_CTRL MEM_ADDRESS_MODE WORD_ADDRESS PACKAGE_IO port READ_LATENCY 0 }
set C_modelArgList {
	{ in_d_02_V_data_V int 32 regular {axi_s 0 volatile  { in_d_02 Data } }  }
	{ in_d_02_V_keep_V int 4 regular {axi_s 0 volatile  { in_d_02 Keep } }  }
	{ in_d_02_V_strb_V int 4 regular {axi_s 0 volatile  { in_d_02 Strb } }  }
	{ in_d_02_V_last_V int 1 regular {axi_s 0 volatile  { in_d_02 Last } }  }
	{ in_d_03_V_data_V int 32 regular {axi_s 0 volatile  { in_d_03 Data } }  }
	{ in_d_03_V_keep_V int 4 regular {axi_s 0 volatile  { in_d_03 Keep } }  }
	{ in_d_03_V_strb_V int 4 regular {axi_s 0 volatile  { in_d_03 Strb } }  }
	{ in_d_03_V_last_V int 1 regular {axi_s 0 volatile  { in_d_03 Last } }  }
	{ in_data_real int 16 regular {array 256 { 0 0 } 0 1 }  }
	{ in_data_imag int 16 regular {array 256 { 0 0 } 0 1 }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "in_d_02_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "in_d_02_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_d_02_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_d_02_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "in_d_03_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "in_d_03_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_d_03_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_d_03_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "in_data_real", "interface" : "memory", "bitwidth" : 16, "direction" : "WRITEONLY"} , 
 	{ "Name" : "in_data_imag", "interface" : "memory", "bitwidth" : 16, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 34
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ in_d_02_TVALID sc_in sc_logic 1 invld 0 } 
	{ in_d_03_TVALID sc_in sc_logic 1 invld 4 } 
	{ in_d_02_TDATA sc_in sc_lv 32 signal 0 } 
	{ in_d_02_TREADY sc_out sc_logic 1 inacc 3 } 
	{ in_d_02_TKEEP sc_in sc_lv 4 signal 1 } 
	{ in_d_02_TSTRB sc_in sc_lv 4 signal 2 } 
	{ in_d_02_TLAST sc_in sc_lv 1 signal 3 } 
	{ in_d_03_TDATA sc_in sc_lv 32 signal 4 } 
	{ in_d_03_TREADY sc_out sc_logic 1 inacc 7 } 
	{ in_d_03_TKEEP sc_in sc_lv 4 signal 5 } 
	{ in_d_03_TSTRB sc_in sc_lv 4 signal 6 } 
	{ in_d_03_TLAST sc_in sc_lv 1 signal 7 } 
	{ in_data_real_address0 sc_out sc_lv 8 signal 8 } 
	{ in_data_real_ce0 sc_out sc_logic 1 signal 8 } 
	{ in_data_real_we0 sc_out sc_logic 1 signal 8 } 
	{ in_data_real_d0 sc_out sc_lv 16 signal 8 } 
	{ in_data_real_address1 sc_out sc_lv 8 signal 8 } 
	{ in_data_real_ce1 sc_out sc_logic 1 signal 8 } 
	{ in_data_real_we1 sc_out sc_logic 1 signal 8 } 
	{ in_data_real_d1 sc_out sc_lv 16 signal 8 } 
	{ in_data_imag_address0 sc_out sc_lv 8 signal 9 } 
	{ in_data_imag_ce0 sc_out sc_logic 1 signal 9 } 
	{ in_data_imag_we0 sc_out sc_logic 1 signal 9 } 
	{ in_data_imag_d0 sc_out sc_lv 16 signal 9 } 
	{ in_data_imag_address1 sc_out sc_lv 8 signal 9 } 
	{ in_data_imag_ce1 sc_out sc_logic 1 signal 9 } 
	{ in_data_imag_we1 sc_out sc_logic 1 signal 9 } 
	{ in_data_imag_d1 sc_out sc_lv 16 signal 9 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "in_d_02_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_d_02_V_data_V", "role": "default" }} , 
 	{ "name": "in_d_03_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_d_03_V_data_V", "role": "default" }} , 
 	{ "name": "in_d_02_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_d_02_V_data_V", "role": "default" }} , 
 	{ "name": "in_d_02_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_02_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_d_02_V_keep_V", "role": "default" }} , 
 	{ "name": "in_d_02_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_d_02_V_strb_V", "role": "default" }} , 
 	{ "name": "in_d_02_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_03_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_d_03_V_data_V", "role": "default" }} , 
 	{ "name": "in_d_03_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_d_03_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_03_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_d_03_V_keep_V", "role": "default" }} , 
 	{ "name": "in_d_03_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_d_03_V_strb_V", "role": "default" }} , 
 	{ "name": "in_d_03_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_d_03_V_last_V", "role": "default" }} , 
 	{ "name": "in_data_real_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "in_data_real", "role": "address0" }} , 
 	{ "name": "in_data_real_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_real", "role": "ce0" }} , 
 	{ "name": "in_data_real_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_real", "role": "we0" }} , 
 	{ "name": "in_data_real_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "in_data_real", "role": "d0" }} , 
 	{ "name": "in_data_real_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "in_data_real", "role": "address1" }} , 
 	{ "name": "in_data_real_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_real", "role": "ce1" }} , 
 	{ "name": "in_data_real_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_real", "role": "we1" }} , 
 	{ "name": "in_data_real_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "in_data_real", "role": "d1" }} , 
 	{ "name": "in_data_imag_address0", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "in_data_imag", "role": "address0" }} , 
 	{ "name": "in_data_imag_ce0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_imag", "role": "ce0" }} , 
 	{ "name": "in_data_imag_we0", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_imag", "role": "we0" }} , 
 	{ "name": "in_data_imag_d0", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "in_data_imag", "role": "d0" }} , 
 	{ "name": "in_data_imag_address1", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "in_data_imag", "role": "address1" }} , 
 	{ "name": "in_data_imag_ce1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_imag", "role": "ce1" }} , 
 	{ "name": "in_data_imag_we1", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "in_data_imag", "role": "we1" }} , 
 	{ "name": "in_data_imag_d1", "direction": "out", "datatype": "sc_lv", "bitwidth":16, "type": "signal", "bundle":{"name": "in_data_imag", "role": "d1" }}  ]}

set ArgLastReadFirstWriteLatency {
	aie_consume_doppler_Pipeline_VITIS_LOOP_185_1 {
		in_d_02_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_last_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_last_V {Type I LastRead 1 FirstWrite -1}
		in_data_real {Type O LastRead -1 FirstWrite 1}
		in_data_imag {Type O LastRead -1 FirstWrite 1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "130", "Max" : "130"}
	, {"Name" : "Interval", "Min" : "129", "Max" : "129"}
]}

set PipelineEnableSignalInfo {[
	{"Pipeline" : "0", "EnableSignal" : "ap_enable_pp0"}
]}

set Spec2ImplPortList { 
	in_d_02_V_data_V { axis {  { in_d_02_TVALID in_vld 0 1 }  { in_d_02_TDATA in_data 0 32 } } }
	in_d_02_V_keep_V { axis {  { in_d_02_TKEEP in_data 0 4 } } }
	in_d_02_V_strb_V { axis {  { in_d_02_TSTRB in_data 0 4 } } }
	in_d_02_V_last_V { axis {  { in_d_02_TREADY in_acc 1 1 }  { in_d_02_TLAST in_data 0 1 } } }
	in_d_03_V_data_V { axis {  { in_d_03_TVALID in_vld 0 1 }  { in_d_03_TDATA in_data 0 32 } } }
	in_d_03_V_keep_V { axis {  { in_d_03_TKEEP in_data 0 4 } } }
	in_d_03_V_strb_V { axis {  { in_d_03_TSTRB in_data 0 4 } } }
	in_d_03_V_last_V { axis {  { in_d_03_TREADY in_acc 1 1 }  { in_d_03_TLAST in_data 0 1 } } }
	in_data_real { ap_memory {  { in_data_real_address0 mem_address 1 8 }  { in_data_real_ce0 mem_ce 1 1 }  { in_data_real_we0 mem_we 1 1 }  { in_data_real_d0 mem_din 1 16 }  { in_data_real_address1 MemPortADDR2 1 8 }  { in_data_real_ce1 MemPortCE2 1 1 }  { in_data_real_we1 MemPortWE2 1 1 }  { in_data_real_d1 MemPortDIN2 1 16 } } }
	in_data_imag { ap_memory {  { in_data_imag_address0 mem_address 1 8 }  { in_data_imag_ce0 mem_ce 1 1 }  { in_data_imag_we0 mem_we 1 1 }  { in_data_imag_d0 mem_din 1 16 }  { in_data_imag_address1 MemPortADDR2 1 8 }  { in_data_imag_ce1 MemPortCE2 1 1 }  { in_data_imag_we1 MemPortWE2 1 1 }  { in_data_imag_d1 MemPortDIN2 1 16 } } }
}

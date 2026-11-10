set moduleName Block_entry_gmem_wr_proc
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
set cdfgNum 24
set C_modelName {Block_entry_gmem_wr_proc}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ in_r_00_V_data_V int 32 regular {axi_s 0 volatile  { in_r_00 Data } }  }
	{ in_r_00_V_keep_V int 4 regular {axi_s 0 volatile  { in_r_00 Keep } }  }
	{ in_r_00_V_strb_V int 4 regular {axi_s 0 volatile  { in_r_00 Strb } }  }
	{ in_r_00_V_last_V int 1 regular {axi_s 0 volatile  { in_r_00 Last } }  }
	{ in_r_01_V_data_V int 32 regular {axi_s 0 volatile  { in_r_01 Data } }  }
	{ in_r_01_V_keep_V int 4 regular {axi_s 0 volatile  { in_r_01 Keep } }  }
	{ in_r_01_V_strb_V int 4 regular {axi_s 0 volatile  { in_r_01 Strb } }  }
	{ in_r_01_V_last_V int 1 regular {axi_s 0 volatile  { in_r_01 Last } }  }
	{ gmem int 32 regular {axi_master 2}  }
	{ mm int 64 regular  }
	{ num_chirps int 32 regular  }
	{ out_d_02_V_data_V int 32 regular {axi_s 1 volatile  { out_d_02 Data } }  }
	{ out_d_02_V_keep_V int 4 regular {axi_s 1 volatile  { out_d_02 Keep } }  }
	{ out_d_02_V_strb_V int 4 regular {axi_s 1 volatile  { out_d_02 Strb } }  }
	{ out_d_02_V_last_V int 1 regular {axi_s 1 volatile  { out_d_02 Last } }  }
	{ out_d_03_V_data_V int 32 regular {axi_s 1 volatile  { out_d_03 Data } }  }
	{ out_d_03_V_keep_V int 4 regular {axi_s 1 volatile  { out_d_03 Keep } }  }
	{ out_d_03_V_strb_V int 4 regular {axi_s 1 volatile  { out_d_03 Strb } }  }
	{ out_d_03_V_last_V int 1 regular {axi_s 1 volatile  { out_d_03 Last } }  }
	{ in_d_02_V_data_V int 32 regular {axi_s 0 volatile  { in_d_02 Data } }  }
	{ in_d_02_V_keep_V int 4 regular {axi_s 0 volatile  { in_d_02 Keep } }  }
	{ in_d_02_V_strb_V int 4 regular {axi_s 0 volatile  { in_d_02 Strb } }  }
	{ in_d_02_V_last_V int 1 regular {axi_s 0 volatile  { in_d_02 Last } }  }
	{ in_d_03_V_data_V int 32 regular {axi_s 0 volatile  { in_d_03 Data } }  }
	{ in_d_03_V_keep_V int 4 regular {axi_s 0 volatile  { in_d_03 Keep } }  }
	{ in_d_03_V_strb_V int 4 regular {axi_s 0 volatile  { in_d_03 Strb } }  }
	{ in_d_03_V_last_V int 1 regular {axi_s 0 volatile  { in_d_03 Last } }  }
	{ doppler_mask_stream int 2816 regular {fifo 1 volatile }  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "in_r_00_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "in_r_00_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_r_00_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_r_00_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "in_r_01_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "in_r_01_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_r_01_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_r_01_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "gmem", "interface" : "axi_master", "bitwidth" : 32, "direction" : "READWRITE", "id_num" : 0, "bitSlice":[ {"cElement": [{"cName": "mm","offset": { "type": "dynamic","port_name": "mm","bundle": "control"},"direction": "READWRITE"}]}]} , 
 	{ "Name" : "mm", "interface" : "wire", "bitwidth" : 64, "direction" : "READONLY"} , 
 	{ "Name" : "num_chirps", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "out_d_02_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_d_02_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_d_02_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_d_02_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_d_03_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_d_03_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_d_03_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "WRITEONLY"} , 
 	{ "Name" : "out_d_03_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "WRITEONLY"} , 
 	{ "Name" : "in_d_02_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "in_d_02_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_d_02_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_d_02_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "in_d_03_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "in_d_03_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_d_03_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_d_03_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "doppler_mask_stream", "interface" : "fifo", "bitwidth" : 2816, "direction" : "WRITEONLY"} ]}
# RTL Port declarations: 
set portNum 99
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ start_full_n sc_in sc_logic 1 signal -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_continue sc_in sc_logic 1 continue -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ start_out sc_out sc_logic 1 signal -1 } 
	{ start_write sc_out sc_logic 1 signal -1 } 
	{ in_r_00_TDATA sc_in sc_lv 32 signal 0 } 
	{ in_r_00_TVALID sc_in sc_logic 1 invld 3 } 
	{ in_r_00_TREADY sc_out sc_logic 1 inacc 3 } 
	{ in_r_00_TKEEP sc_in sc_lv 4 signal 1 } 
	{ in_r_00_TSTRB sc_in sc_lv 4 signal 2 } 
	{ in_r_00_TLAST sc_in sc_lv 1 signal 3 } 
	{ in_r_01_TDATA sc_in sc_lv 32 signal 4 } 
	{ in_r_01_TVALID sc_in sc_logic 1 invld 7 } 
	{ in_r_01_TREADY sc_out sc_logic 1 inacc 7 } 
	{ in_r_01_TKEEP sc_in sc_lv 4 signal 5 } 
	{ in_r_01_TSTRB sc_in sc_lv 4 signal 6 } 
	{ in_r_01_TLAST sc_in sc_lv 1 signal 7 } 
	{ m_axi_gmem_0_AWVALID sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem_0_AWREADY sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem_0_AWADDR sc_out sc_lv 64 signal 8 } 
	{ m_axi_gmem_0_AWID sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem_0_AWLEN sc_out sc_lv 32 signal 8 } 
	{ m_axi_gmem_0_AWSIZE sc_out sc_lv 3 signal 8 } 
	{ m_axi_gmem_0_AWBURST sc_out sc_lv 2 signal 8 } 
	{ m_axi_gmem_0_AWLOCK sc_out sc_lv 2 signal 8 } 
	{ m_axi_gmem_0_AWCACHE sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem_0_AWPROT sc_out sc_lv 3 signal 8 } 
	{ m_axi_gmem_0_AWQOS sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem_0_AWREGION sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem_0_AWUSER sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem_0_WVALID sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem_0_WREADY sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem_0_WDATA sc_out sc_lv 32 signal 8 } 
	{ m_axi_gmem_0_WSTRB sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem_0_WLAST sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem_0_WID sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem_0_WUSER sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem_0_ARVALID sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem_0_ARREADY sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem_0_ARADDR sc_out sc_lv 64 signal 8 } 
	{ m_axi_gmem_0_ARID sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem_0_ARLEN sc_out sc_lv 32 signal 8 } 
	{ m_axi_gmem_0_ARSIZE sc_out sc_lv 3 signal 8 } 
	{ m_axi_gmem_0_ARBURST sc_out sc_lv 2 signal 8 } 
	{ m_axi_gmem_0_ARLOCK sc_out sc_lv 2 signal 8 } 
	{ m_axi_gmem_0_ARCACHE sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem_0_ARPROT sc_out sc_lv 3 signal 8 } 
	{ m_axi_gmem_0_ARQOS sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem_0_ARREGION sc_out sc_lv 4 signal 8 } 
	{ m_axi_gmem_0_ARUSER sc_out sc_lv 1 signal 8 } 
	{ m_axi_gmem_0_RVALID sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem_0_RREADY sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem_0_RDATA sc_in sc_lv 32 signal 8 } 
	{ m_axi_gmem_0_RLAST sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem_0_RID sc_in sc_lv 1 signal 8 } 
	{ m_axi_gmem_0_RFIFONUM sc_in sc_lv 9 signal 8 } 
	{ m_axi_gmem_0_RUSER sc_in sc_lv 1 signal 8 } 
	{ m_axi_gmem_0_RRESP sc_in sc_lv 2 signal 8 } 
	{ m_axi_gmem_0_BVALID sc_in sc_logic 1 signal 8 } 
	{ m_axi_gmem_0_BREADY sc_out sc_logic 1 signal 8 } 
	{ m_axi_gmem_0_BRESP sc_in sc_lv 2 signal 8 } 
	{ m_axi_gmem_0_BID sc_in sc_lv 1 signal 8 } 
	{ m_axi_gmem_0_BUSER sc_in sc_lv 1 signal 8 } 
	{ mm sc_in sc_lv 64 signal 9 } 
	{ num_chirps sc_in sc_lv 32 signal 10 } 
	{ out_d_02_TDATA sc_out sc_lv 32 signal 11 } 
	{ out_d_02_TVALID sc_out sc_logic 1 outvld 14 } 
	{ out_d_02_TREADY sc_in sc_logic 1 outacc 14 } 
	{ out_d_02_TKEEP sc_out sc_lv 4 signal 12 } 
	{ out_d_02_TSTRB sc_out sc_lv 4 signal 13 } 
	{ out_d_02_TLAST sc_out sc_lv 1 signal 14 } 
	{ out_d_03_TDATA sc_out sc_lv 32 signal 15 } 
	{ out_d_03_TVALID sc_out sc_logic 1 outvld 18 } 
	{ out_d_03_TREADY sc_in sc_logic 1 outacc 18 } 
	{ out_d_03_TKEEP sc_out sc_lv 4 signal 16 } 
	{ out_d_03_TSTRB sc_out sc_lv 4 signal 17 } 
	{ out_d_03_TLAST sc_out sc_lv 1 signal 18 } 
	{ in_d_02_TDATA sc_in sc_lv 32 signal 19 } 
	{ in_d_02_TVALID sc_in sc_logic 1 invld 22 } 
	{ in_d_02_TREADY sc_out sc_logic 1 inacc 22 } 
	{ in_d_02_TKEEP sc_in sc_lv 4 signal 20 } 
	{ in_d_02_TSTRB sc_in sc_lv 4 signal 21 } 
	{ in_d_02_TLAST sc_in sc_lv 1 signal 22 } 
	{ in_d_03_TDATA sc_in sc_lv 32 signal 23 } 
	{ in_d_03_TVALID sc_in sc_logic 1 invld 26 } 
	{ in_d_03_TREADY sc_out sc_logic 1 inacc 26 } 
	{ in_d_03_TKEEP sc_in sc_lv 4 signal 24 } 
	{ in_d_03_TSTRB sc_in sc_lv 4 signal 25 } 
	{ in_d_03_TLAST sc_in sc_lv 1 signal 26 } 
	{ doppler_mask_stream_din sc_out sc_lv 2816 signal 27 } 
	{ doppler_mask_stream_full_n sc_in sc_logic 1 signal 27 } 
	{ doppler_mask_stream_write sc_out sc_logic 1 signal 27 } 
	{ doppler_mask_stream_num_data_valid sc_in sc_lv 8 signal 27 } 
	{ doppler_mask_stream_fifo_cap sc_in sc_lv 8 signal 27 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "start_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_full_n", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_continue", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "continue", "bundle":{"name": "ap_continue", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "start_out", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_out", "role": "default" }} , 
 	{ "name": "start_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "start_write", "role": "default" }} , 
 	{ "name": "in_r_00_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_r_00_V_data_V", "role": "default" }} , 
 	{ "name": "in_r_00_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_r_00_V_last_V", "role": "default" }} , 
 	{ "name": "in_r_00_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_r_00_V_last_V", "role": "default" }} , 
 	{ "name": "in_r_00_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_r_00_V_keep_V", "role": "default" }} , 
 	{ "name": "in_r_00_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_r_00_V_strb_V", "role": "default" }} , 
 	{ "name": "in_r_00_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_r_00_V_last_V", "role": "default" }} , 
 	{ "name": "in_r_01_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_r_01_V_data_V", "role": "default" }} , 
 	{ "name": "in_r_01_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_r_01_V_last_V", "role": "default" }} , 
 	{ "name": "in_r_01_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_r_01_V_last_V", "role": "default" }} , 
 	{ "name": "in_r_01_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_r_01_V_keep_V", "role": "default" }} , 
 	{ "name": "in_r_01_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_r_01_V_strb_V", "role": "default" }} , 
 	{ "name": "in_r_01_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_r_01_V_last_V", "role": "default" }} , 
 	{ "name": "m_axi_gmem_0_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_AWVALID" }} , 
 	{ "name": "m_axi_gmem_0_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_AWREADY" }} , 
 	{ "name": "m_axi_gmem_0_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem", "role": "0_AWADDR" }} , 
 	{ "name": "m_axi_gmem_0_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_AWID" }} , 
 	{ "name": "m_axi_gmem_0_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem", "role": "0_AWLEN" }} , 
 	{ "name": "m_axi_gmem_0_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem", "role": "0_AWSIZE" }} , 
 	{ "name": "m_axi_gmem_0_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "0_AWBURST" }} , 
 	{ "name": "m_axi_gmem_0_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "0_AWLOCK" }} , 
 	{ "name": "m_axi_gmem_0_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "0_AWCACHE" }} , 
 	{ "name": "m_axi_gmem_0_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem", "role": "0_AWPROT" }} , 
 	{ "name": "m_axi_gmem_0_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "0_AWQOS" }} , 
 	{ "name": "m_axi_gmem_0_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "0_AWREGION" }} , 
 	{ "name": "m_axi_gmem_0_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_AWUSER" }} , 
 	{ "name": "m_axi_gmem_0_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_WVALID" }} , 
 	{ "name": "m_axi_gmem_0_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_WREADY" }} , 
 	{ "name": "m_axi_gmem_0_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem", "role": "0_WDATA" }} , 
 	{ "name": "m_axi_gmem_0_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "0_WSTRB" }} , 
 	{ "name": "m_axi_gmem_0_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_WLAST" }} , 
 	{ "name": "m_axi_gmem_0_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_WID" }} , 
 	{ "name": "m_axi_gmem_0_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_WUSER" }} , 
 	{ "name": "m_axi_gmem_0_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_ARVALID" }} , 
 	{ "name": "m_axi_gmem_0_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_ARREADY" }} , 
 	{ "name": "m_axi_gmem_0_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem", "role": "0_ARADDR" }} , 
 	{ "name": "m_axi_gmem_0_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_ARID" }} , 
 	{ "name": "m_axi_gmem_0_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem", "role": "0_ARLEN" }} , 
 	{ "name": "m_axi_gmem_0_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem", "role": "0_ARSIZE" }} , 
 	{ "name": "m_axi_gmem_0_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "0_ARBURST" }} , 
 	{ "name": "m_axi_gmem_0_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "0_ARLOCK" }} , 
 	{ "name": "m_axi_gmem_0_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "0_ARCACHE" }} , 
 	{ "name": "m_axi_gmem_0_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem", "role": "0_ARPROT" }} , 
 	{ "name": "m_axi_gmem_0_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "0_ARQOS" }} , 
 	{ "name": "m_axi_gmem_0_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "0_ARREGION" }} , 
 	{ "name": "m_axi_gmem_0_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_ARUSER" }} , 
 	{ "name": "m_axi_gmem_0_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_RVALID" }} , 
 	{ "name": "m_axi_gmem_0_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_RREADY" }} , 
 	{ "name": "m_axi_gmem_0_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem", "role": "0_RDATA" }} , 
 	{ "name": "m_axi_gmem_0_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_RLAST" }} , 
 	{ "name": "m_axi_gmem_0_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_RID" }} , 
 	{ "name": "m_axi_gmem_0_RFIFONUM", "direction": "in", "datatype": "sc_lv", "bitwidth":9, "type": "signal", "bundle":{"name": "gmem", "role": "0_RFIFONUM" }} , 
 	{ "name": "m_axi_gmem_0_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_RUSER" }} , 
 	{ "name": "m_axi_gmem_0_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "0_RRESP" }} , 
 	{ "name": "m_axi_gmem_0_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_BVALID" }} , 
 	{ "name": "m_axi_gmem_0_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_BREADY" }} , 
 	{ "name": "m_axi_gmem_0_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "0_BRESP" }} , 
 	{ "name": "m_axi_gmem_0_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_BID" }} , 
 	{ "name": "m_axi_gmem_0_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "0_BUSER" }} , 
 	{ "name": "mm", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "mm", "role": "default" }} , 
 	{ "name": "num_chirps", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "num_chirps", "role": "default" }} , 
 	{ "name": "out_d_02_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "out_d_02_V_data_V", "role": "default" }} , 
 	{ "name": "out_d_02_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "out_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "out_d_02_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "out_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "out_d_02_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_d_02_V_keep_V", "role": "default" }} , 
 	{ "name": "out_d_02_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_d_02_V_strb_V", "role": "default" }} , 
 	{ "name": "out_d_02_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "out_d_03_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "out_d_03_V_data_V", "role": "default" }} , 
 	{ "name": "out_d_03_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "out_d_03_V_last_V", "role": "default" }} , 
 	{ "name": "out_d_03_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "out_d_03_V_last_V", "role": "default" }} , 
 	{ "name": "out_d_03_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_d_03_V_keep_V", "role": "default" }} , 
 	{ "name": "out_d_03_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_d_03_V_strb_V", "role": "default" }} , 
 	{ "name": "out_d_03_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_d_03_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_02_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_d_02_V_data_V", "role": "default" }} , 
 	{ "name": "in_d_02_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_02_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_02_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_d_02_V_keep_V", "role": "default" }} , 
 	{ "name": "in_d_02_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_d_02_V_strb_V", "role": "default" }} , 
 	{ "name": "in_d_02_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_03_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_d_03_V_data_V", "role": "default" }} , 
 	{ "name": "in_d_03_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_d_03_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_03_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_d_03_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_03_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_d_03_V_keep_V", "role": "default" }} , 
 	{ "name": "in_d_03_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_d_03_V_strb_V", "role": "default" }} , 
 	{ "name": "in_d_03_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_d_03_V_last_V", "role": "default" }} , 
 	{ "name": "doppler_mask_stream_din", "direction": "out", "datatype": "sc_lv", "bitwidth":2816, "type": "signal", "bundle":{"name": "doppler_mask_stream", "role": "din" }} , 
 	{ "name": "doppler_mask_stream_full_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "doppler_mask_stream", "role": "full_n" }} , 
 	{ "name": "doppler_mask_stream_write", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "doppler_mask_stream", "role": "write" }} , 
 	{ "name": "doppler_mask_stream_num_data_valid", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "doppler_mask_stream", "role": "num_data_valid" }} , 
 	{ "name": "doppler_mask_stream_fifo_cap", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "doppler_mask_stream", "role": "fifo_cap" }}  ]}

set ArgLastReadFirstWriteLatency {
	Block_entry_gmem_wr_proc {
		in_r_00_V_data_V {Type I LastRead 18 FirstWrite -1}
		in_r_00_V_keep_V {Type I LastRead 18 FirstWrite -1}
		in_r_00_V_strb_V {Type I LastRead 18 FirstWrite -1}
		in_r_00_V_last_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_data_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_keep_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_strb_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_last_V {Type I LastRead 18 FirstWrite -1}
		gmem {Type IO LastRead 27 FirstWrite -1}
		mm {Type I LastRead 1 FirstWrite -1}
		num_chirps {Type I LastRead 1 FirstWrite -1}
		out_d_02_V_data_V {Type O LastRead -1 FirstWrite 4}
		out_d_02_V_keep_V {Type O LastRead -1 FirstWrite 4}
		out_d_02_V_strb_V {Type O LastRead -1 FirstWrite 4}
		out_d_02_V_last_V {Type O LastRead -1 FirstWrite 4}
		out_d_03_V_data_V {Type O LastRead -1 FirstWrite 4}
		out_d_03_V_keep_V {Type O LastRead -1 FirstWrite 4}
		out_d_03_V_strb_V {Type O LastRead -1 FirstWrite 4}
		out_d_03_V_last_V {Type O LastRead -1 FirstWrite 4}
		in_d_02_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_last_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_last_V {Type I LastRead 1 FirstWrite -1}
		doppler_mask_stream {Type O LastRead -1 FirstWrite 2}
		mask_seqs {Type IO LastRead -1 FirstWrite -1}
		seqs_done {Type IO LastRead -1 FirstWrite -1}
		hamming_window_256_real {Type I LastRead -1 FirstWrite -1}}
	aie_range_consume {
		in_r_00_V_data_V {Type I LastRead 18 FirstWrite -1}
		in_r_00_V_keep_V {Type I LastRead 18 FirstWrite -1}
		in_r_00_V_strb_V {Type I LastRead 18 FirstWrite -1}
		in_r_00_V_last_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_data_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_keep_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_strb_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_last_V {Type I LastRead 18 FirstWrite -1}
		mask_stream {Type O LastRead -1 FirstWrite 39}
		gmem {Type O LastRead 20 FirstWrite 4}
		mm {Type I LastRead 0 FirstWrite -1}
		num_chirps {Type I LastRead 0 FirstWrite -1}}
	aie_range_consume_Pipeline_VITIS_LOOP_96_2 {
		in_r_00_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_r_00_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_r_00_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_r_00_V_last_V {Type I LastRead 1 FirstWrite -1}
		mask_head {Type O LastRead -1 FirstWrite 1}
		in_r_01_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_r_01_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_r_01_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_r_01_V_last_V {Type I LastRead 1 FirstWrite -1}}
	aie_range_consume_Pipeline_VITIS_LOOP_10_1 {
		mask_head {Type I LastRead 0 FirstWrite -1}
		adr_buf {Type O LastRead -1 FirstWrite 2}
		n_out {Type O LastRead -1 FirstWrite 2}}
	aie_range_consume_Pipeline_VITIS_LOOP_105_3 {
		n_reload {Type I LastRead 0 FirstWrite -1}
		adr_buf {Type I LastRead 0 FirstWrite -1}
		shl_ln {Type I LastRead 0 FirstWrite -1}
		mm {Type I LastRead 0 FirstWrite -1}
		gmem {Type O LastRead 20 FirstWrite 4}
		in_r_00_V_data_V {Type I LastRead 18 FirstWrite -1}
		in_r_00_V_keep_V {Type I LastRead 18 FirstWrite -1}
		in_r_00_V_strb_V {Type I LastRead 18 FirstWrite -1}
		in_r_00_V_last_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_data_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_keep_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_strb_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_last_V {Type I LastRead 18 FirstWrite -1}}
	seq_generator {
		mask_stream {Type I LastRead 1 FirstWrite -1}
		idx_stream {Type O LastRead -1 FirstWrite 1}
		mask_seqs {Type IO LastRead -1 FirstWrite -1}
		seqs_done {Type IO LastRead -1 FirstWrite -1}}
	seq_generator_Pipeline_VITIS_LOOP_49_2 {
		current_mask {Type I LastRead 0 FirstWrite -1}
		mask_seq {Type I LastRead 0 FirstWrite -1}
		idx_stream {Type O LastRead -1 FirstWrite 1}}
	doppler {
		gmem {Type IO LastRead 27 FirstWrite -1}
		mm {Type I LastRead 0 FirstWrite -1}
		idx_stream {Type I LastRead 1 FirstWrite -1}
		out_d_02_V_data_V {Type O LastRead -1 FirstWrite 4}
		out_d_02_V_keep_V {Type O LastRead -1 FirstWrite 4}
		out_d_02_V_strb_V {Type O LastRead -1 FirstWrite 4}
		out_d_02_V_last_V {Type O LastRead -1 FirstWrite 4}
		out_d_03_V_data_V {Type O LastRead -1 FirstWrite 4}
		out_d_03_V_keep_V {Type O LastRead -1 FirstWrite 4}
		out_d_03_V_strb_V {Type O LastRead -1 FirstWrite 4}
		out_d_03_V_last_V {Type O LastRead -1 FirstWrite 4}
		in_d_02_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_last_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_last_V {Type I LastRead 1 FirstWrite -1}
		doppler_mask_stream {Type O LastRead -1 FirstWrite 2}
		hamming_window_256_real {Type I LastRead -1 FirstWrite -1}}
	doppler_Pipeline_VITIS_LOOP_97_2_VITIS_LOOP_103_3 {
		window {Type O LastRead -1 FirstWrite 12}
		zext_ln100 {Type I LastRead 0 FirstWrite -1}
		mm {Type I LastRead 0 FirstWrite -1}
		gmem {Type I LastRead 11 FirstWrite -1}}
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
		hamming_window_256_real {Type I LastRead -1 FirstWrite -1}}
	aie_consume_doppler {
		in_d_02_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_last_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_last_V {Type I LastRead 1 FirstWrite -1}
		doppler_mask_stream {Type O LastRead -1 FirstWrite 142}
		gmem {Type O LastRead 27 FirstWrite 11}
		mm {Type I LastRead 5 FirstWrite -1}
		seq {Type I LastRead 5 FirstWrite -1}
		ind {Type I LastRead 5 FirstWrite -1}}
	aie_consume_doppler_Pipeline_1 {
		histogram {Type O LastRead -1 FirstWrite 1}}
	aie_consume_doppler_Pipeline_VITIS_LOOP_196_1 {
		in_d_02_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_d_02_V_last_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_d_03_V_last_V {Type I LastRead 1 FirstWrite -1}
		in_data_real {Type O LastRead -1 FirstWrite 1}
		in_data_imag {Type O LastRead -1 FirstWrite 1}}
	aie_consume_doppler_Pipeline_VITIS_LOOP_207_2 {
		in_data_real {Type I LastRead 0 FirstWrite -1}
		in_data_imag {Type I LastRead 0 FirstWrite -1}
		in_data_mag {Type O LastRead -1 FirstWrite 4}
		mean_acc_out {Type O LastRead -1 FirstWrite 3}}
	aie_consume_doppler_Pipeline_VITIS_LOOP_237_3 {
		in_data_mag {Type I LastRead 0 FirstWrite -1}
		zext_ln237 {Type I LastRead 0 FirstWrite -1}
		histogram {Type IO LastRead 6 FirstWrite 8}}
	aie_consume_doppler_Pipeline_VITIS_LOOP_248_4 {
		histogram {Type I LastRead 1 FirstWrite -1}
		i_6_out {Type O LastRead -1 FirstWrite 2}}
	aie_consume_doppler_Pipeline_VITIS_LOOP_287_5 {
		shl_ln2 {Type I LastRead 0 FirstWrite -1}
		zext_ln287 {Type I LastRead 0 FirstWrite -1}
		mm {Type I LastRead 0 FirstWrite -1}
		in_data_mag {Type I LastRead 8 FirstWrite -1}
		result_11 {Type I LastRead 0 FirstWrite -1}
		in_data_real {Type I LastRead 17 FirstWrite -1}
		in_data_imag {Type I LastRead 17 FirstWrite -1}
		gmem {Type O LastRead 27 FirstWrite 11}
		mask_out {Type O LastRead -1 FirstWrite 15}}
	aie_consume_doppler_Pipeline_VITIS_LOOP_326_9 {
		phi_mul {Type I LastRead 0 FirstWrite -1}
		in_data_mag {Type I LastRead 1 FirstWrite -1}
		dmask_data {Type O LastRead -1 FirstWrite 3}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "-1", "Max" : "-1"}
	, {"Name" : "Interval", "Min" : "-1", "Max" : "-1"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	in_r_00_V_data_V { axis {  { in_r_00_TDATA in_data 0 32 } } }
	in_r_00_V_keep_V { axis {  { in_r_00_TKEEP in_data 0 4 } } }
	in_r_00_V_strb_V { axis {  { in_r_00_TSTRB in_data 0 4 } } }
	in_r_00_V_last_V { axis {  { in_r_00_TVALID in_vld 0 1 }  { in_r_00_TREADY in_acc 1 1 }  { in_r_00_TLAST in_data 0 1 } } }
	in_r_01_V_data_V { axis {  { in_r_01_TDATA in_data 0 32 } } }
	in_r_01_V_keep_V { axis {  { in_r_01_TKEEP in_data 0 4 } } }
	in_r_01_V_strb_V { axis {  { in_r_01_TSTRB in_data 0 4 } } }
	in_r_01_V_last_V { axis {  { in_r_01_TVALID in_vld 0 1 }  { in_r_01_TREADY in_acc 1 1 }  { in_r_01_TLAST in_data 0 1 } } }
	 { m_axi {  { m_axi_gmem_0_AWVALID VALID 1 1 }  { m_axi_gmem_0_AWREADY READY 0 1 }  { m_axi_gmem_0_AWADDR ADDR 1 64 }  { m_axi_gmem_0_AWID ID 1 1 }  { m_axi_gmem_0_AWLEN SIZE 1 32 }  { m_axi_gmem_0_AWSIZE BURST 1 3 }  { m_axi_gmem_0_AWBURST LOCK 1 2 }  { m_axi_gmem_0_AWLOCK CACHE 1 2 }  { m_axi_gmem_0_AWCACHE PROT 1 4 }  { m_axi_gmem_0_AWPROT QOS 1 3 }  { m_axi_gmem_0_AWQOS REGION 1 4 }  { m_axi_gmem_0_AWREGION USER 1 4 }  { m_axi_gmem_0_AWUSER DATA 1 1 }  { m_axi_gmem_0_WVALID VALID 1 1 }  { m_axi_gmem_0_WREADY READY 0 1 }  { m_axi_gmem_0_WDATA FIFONUM 1 32 }  { m_axi_gmem_0_WSTRB STRB 1 4 }  { m_axi_gmem_0_WLAST LAST 1 1 }  { m_axi_gmem_0_WID ID 1 1 }  { m_axi_gmem_0_WUSER DATA 1 1 }  { m_axi_gmem_0_ARVALID VALID 1 1 }  { m_axi_gmem_0_ARREADY READY 0 1 }  { m_axi_gmem_0_ARADDR ADDR 1 64 }  { m_axi_gmem_0_ARID ID 1 1 }  { m_axi_gmem_0_ARLEN SIZE 1 32 }  { m_axi_gmem_0_ARSIZE BURST 1 3 }  { m_axi_gmem_0_ARBURST LOCK 1 2 }  { m_axi_gmem_0_ARLOCK CACHE 1 2 }  { m_axi_gmem_0_ARCACHE PROT 1 4 }  { m_axi_gmem_0_ARPROT QOS 1 3 }  { m_axi_gmem_0_ARQOS REGION 1 4 }  { m_axi_gmem_0_ARREGION USER 1 4 }  { m_axi_gmem_0_ARUSER DATA 1 1 }  { m_axi_gmem_0_RVALID VALID 0 1 }  { m_axi_gmem_0_RREADY READY 1 1 }  { m_axi_gmem_0_RDATA FIFONUM 0 32 }  { m_axi_gmem_0_RLAST LAST 0 1 }  { m_axi_gmem_0_RID ID 0 1 }  { m_axi_gmem_0_RFIFONUM LEN 0 9 }  { m_axi_gmem_0_RUSER DATA 0 1 }  { m_axi_gmem_0_RRESP RESP 0 2 }  { m_axi_gmem_0_BVALID VALID 0 1 }  { m_axi_gmem_0_BREADY READY 1 1 }  { m_axi_gmem_0_BRESP RESP 0 2 }  { m_axi_gmem_0_BID ID 0 1 }  { m_axi_gmem_0_BUSER DATA 0 1 } } }
	mm { ap_none {  { mm in_data 0 64 } } }
	num_chirps { ap_none {  { num_chirps in_data 0 32 } } }
	out_d_02_V_data_V { axis {  { out_d_02_TDATA out_data 1 32 } } }
	out_d_02_V_keep_V { axis {  { out_d_02_TKEEP out_data 1 4 } } }
	out_d_02_V_strb_V { axis {  { out_d_02_TSTRB out_data 1 4 } } }
	out_d_02_V_last_V { axis {  { out_d_02_TVALID out_vld 1 1 }  { out_d_02_TREADY out_acc 0 1 }  { out_d_02_TLAST out_data 1 1 } } }
	out_d_03_V_data_V { axis {  { out_d_03_TDATA out_data 1 32 } } }
	out_d_03_V_keep_V { axis {  { out_d_03_TKEEP out_data 1 4 } } }
	out_d_03_V_strb_V { axis {  { out_d_03_TSTRB out_data 1 4 } } }
	out_d_03_V_last_V { axis {  { out_d_03_TVALID out_vld 1 1 }  { out_d_03_TREADY out_acc 0 1 }  { out_d_03_TLAST out_data 1 1 } } }
	in_d_02_V_data_V { axis {  { in_d_02_TDATA in_data 0 32 } } }
	in_d_02_V_keep_V { axis {  { in_d_02_TKEEP in_data 0 4 } } }
	in_d_02_V_strb_V { axis {  { in_d_02_TSTRB in_data 0 4 } } }
	in_d_02_V_last_V { axis {  { in_d_02_TVALID in_vld 0 1 }  { in_d_02_TREADY in_acc 1 1 }  { in_d_02_TLAST in_data 0 1 } } }
	in_d_03_V_data_V { axis {  { in_d_03_TDATA in_data 0 32 } } }
	in_d_03_V_keep_V { axis {  { in_d_03_TKEEP in_data 0 4 } } }
	in_d_03_V_strb_V { axis {  { in_d_03_TSTRB in_data 0 4 } } }
	in_d_03_V_last_V { axis {  { in_d_03_TVALID in_vld 0 1 }  { in_d_03_TREADY in_acc 1 1 }  { in_d_03_TLAST in_data 0 1 } } }
	doppler_mask_stream { ap_fifo {  { doppler_mask_stream_din fifo_data_out 1 2816 }  { doppler_mask_stream_full_n fifo_status_empty 0 1 }  { doppler_mask_stream_write fifo_data_in 1 1 }  { doppler_mask_stream_num_data_valid fifo_update 0 8 }  { doppler_mask_stream_fifo_cap fifo_data 0 8 } } }
}

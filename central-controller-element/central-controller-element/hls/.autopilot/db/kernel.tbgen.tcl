set moduleName kernel
set isTopModule 1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set isPipelined_legacy 0
set pipeline_type dataflow
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
set C_modelName {kernel}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ gmem int 32 regular {axi_master 2}  }
	{ mm int 64 regular {axi_slave 0}  }
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
	{ in_r_00_V_data_V int 32 regular {axi_s 0 volatile  { in_r_00 Data } }  }
	{ in_r_00_V_keep_V int 4 regular {axi_s 0 volatile  { in_r_00 Keep } }  }
	{ in_r_00_V_strb_V int 4 regular {axi_s 0 volatile  { in_r_00 Strb } }  }
	{ in_r_00_V_last_V int 1 regular {axi_s 0 volatile  { in_r_00 Last } }  }
	{ in_r_01_V_data_V int 32 regular {axi_s 0 volatile  { in_r_01 Data } }  }
	{ in_r_01_V_keep_V int 4 regular {axi_s 0 volatile  { in_r_01 Keep } }  }
	{ in_r_01_V_strb_V int 4 regular {axi_s 0 volatile  { in_r_01 Strb } }  }
	{ in_r_01_V_last_V int 1 regular {axi_s 0 volatile  { in_r_01 Last } }  }
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
	{ num_chirps int 32 regular {axi_slave 0}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "gmem", "interface" : "axi_master", "bitwidth" : 32, "direction" : "READWRITE", "id_num" : 1, "bitSlice":[ {"cElement": [{"cName": "mm","offset": { "type": "dynamic","port_name": "mm","bundle": "control"},"direction": "READWRITE"}]}]} , 
 	{ "Name" : "mm", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":16}, "offset_end" : {"in":27}} , 
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
 	{ "Name" : "in_r_00_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "in_r_00_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_r_00_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_r_00_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
 	{ "Name" : "in_r_01_V_data_V", "interface" : "axis", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "in_r_01_V_keep_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_r_01_V_strb_V", "interface" : "axis", "bitwidth" : 4, "direction" : "READONLY"} , 
 	{ "Name" : "in_r_01_V_last_V", "interface" : "axis", "bitwidth" : 1, "direction" : "READONLY"} , 
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
 	{ "Name" : "num_chirps", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 32, "direction" : "READONLY", "offset" : {"in":28}, "offset_end" : {"in":35}} ]}
# RTL Port declarations: 
set portNum 119
set portList { 
	{ s_axi_control_AWVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_AWREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_AWADDR sc_in sc_lv 6 signal -1 } 
	{ s_axi_control_WVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_WREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_WDATA sc_in sc_lv 32 signal -1 } 
	{ s_axi_control_WSTRB sc_in sc_lv 4 signal -1 } 
	{ s_axi_control_ARVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_ARREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_ARADDR sc_in sc_lv 6 signal -1 } 
	{ s_axi_control_RVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_RREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_RDATA sc_out sc_lv 32 signal -1 } 
	{ s_axi_control_RRESP sc_out sc_lv 2 signal -1 } 
	{ s_axi_control_BVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_BREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_BRESP sc_out sc_lv 2 signal -1 } 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ interrupt sc_out sc_logic 1 signal -1 } 
	{ m_axi_gmem_AWVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_AWREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_AWADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_gmem_AWID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_AWLEN sc_out sc_lv 8 signal 0 } 
	{ m_axi_gmem_AWSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_AWBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_AWLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_AWCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_AWPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_AWQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_AWREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_AWUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_WVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_WREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_WDATA sc_out sc_lv 32 signal 0 } 
	{ m_axi_gmem_WSTRB sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_WLAST sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_WID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_WUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_ARVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_ARREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_ARADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_gmem_ARID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_ARLEN sc_out sc_lv 8 signal 0 } 
	{ m_axi_gmem_ARSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_ARBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_ARLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_ARCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_ARPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_ARQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_ARREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_ARUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_RVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_RREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_RDATA sc_in sc_lv 32 signal 0 } 
	{ m_axi_gmem_RLAST sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_RID sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_RUSER sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_RRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_gmem_BVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_BREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_BRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_gmem_BID sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_BUSER sc_in sc_lv 1 signal 0 } 
	{ in_adc0_TDATA sc_in sc_lv 64 signal 2 } 
	{ in_adc0_TKEEP sc_in sc_lv 8 signal 3 } 
	{ in_adc0_TSTRB sc_in sc_lv 8 signal 4 } 
	{ in_adc0_TLAST sc_in sc_lv 1 signal 5 } 
	{ out_r_00_TDATA sc_out sc_lv 32 signal 6 } 
	{ out_r_00_TKEEP sc_out sc_lv 4 signal 7 } 
	{ out_r_00_TSTRB sc_out sc_lv 4 signal 8 } 
	{ out_r_00_TLAST sc_out sc_lv 1 signal 9 } 
	{ out_r_01_TDATA sc_out sc_lv 32 signal 10 } 
	{ out_r_01_TKEEP sc_out sc_lv 4 signal 11 } 
	{ out_r_01_TSTRB sc_out sc_lv 4 signal 12 } 
	{ out_r_01_TLAST sc_out sc_lv 1 signal 13 } 
	{ in_r_00_TDATA sc_in sc_lv 32 signal 14 } 
	{ in_r_00_TKEEP sc_in sc_lv 4 signal 15 } 
	{ in_r_00_TSTRB sc_in sc_lv 4 signal 16 } 
	{ in_r_00_TLAST sc_in sc_lv 1 signal 17 } 
	{ in_r_01_TDATA sc_in sc_lv 32 signal 18 } 
	{ in_r_01_TKEEP sc_in sc_lv 4 signal 19 } 
	{ in_r_01_TSTRB sc_in sc_lv 4 signal 20 } 
	{ in_r_01_TLAST sc_in sc_lv 1 signal 21 } 
	{ out_d_02_TDATA sc_out sc_lv 32 signal 22 } 
	{ out_d_02_TKEEP sc_out sc_lv 4 signal 23 } 
	{ out_d_02_TSTRB sc_out sc_lv 4 signal 24 } 
	{ out_d_02_TLAST sc_out sc_lv 1 signal 25 } 
	{ out_d_03_TDATA sc_out sc_lv 32 signal 26 } 
	{ out_d_03_TKEEP sc_out sc_lv 4 signal 27 } 
	{ out_d_03_TSTRB sc_out sc_lv 4 signal 28 } 
	{ out_d_03_TLAST sc_out sc_lv 1 signal 29 } 
	{ in_d_02_TDATA sc_in sc_lv 32 signal 30 } 
	{ in_d_02_TKEEP sc_in sc_lv 4 signal 31 } 
	{ in_d_02_TSTRB sc_in sc_lv 4 signal 32 } 
	{ in_d_02_TLAST sc_in sc_lv 1 signal 33 } 
	{ in_d_03_TDATA sc_in sc_lv 32 signal 34 } 
	{ in_d_03_TKEEP sc_in sc_lv 4 signal 35 } 
	{ in_d_03_TSTRB sc_in sc_lv 4 signal 36 } 
	{ in_d_03_TLAST sc_in sc_lv 1 signal 37 } 
	{ in_adc0_TVALID sc_in sc_logic 1 invld 5 } 
	{ in_adc0_TREADY sc_out sc_logic 1 inacc 5 } 
	{ out_r_00_TVALID sc_out sc_logic 1 outvld 9 } 
	{ out_r_00_TREADY sc_in sc_logic 1 outacc 9 } 
	{ out_r_01_TVALID sc_out sc_logic 1 outvld 13 } 
	{ out_r_01_TREADY sc_in sc_logic 1 outacc 13 } 
	{ in_r_00_TVALID sc_in sc_logic 1 invld 17 } 
	{ in_r_00_TREADY sc_out sc_logic 1 inacc 17 } 
	{ in_r_01_TVALID sc_in sc_logic 1 invld 21 } 
	{ in_r_01_TREADY sc_out sc_logic 1 inacc 21 } 
	{ out_d_02_TVALID sc_out sc_logic 1 outvld 25 } 
	{ out_d_02_TREADY sc_in sc_logic 1 outacc 25 } 
	{ out_d_03_TVALID sc_out sc_logic 1 outvld 29 } 
	{ out_d_03_TREADY sc_in sc_logic 1 outacc 29 } 
	{ in_d_02_TVALID sc_in sc_logic 1 invld 33 } 
	{ in_d_02_TREADY sc_out sc_logic 1 inacc 33 } 
	{ in_d_03_TVALID sc_in sc_logic 1 invld 37 } 
	{ in_d_03_TREADY sc_out sc_logic 1 inacc 37 } 
}
set NewPortList {[ 
	{ "name": "s_axi_control_AWADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "control", "role": "AWADDR" },"address":[{"name":"kernel","role":"start","value":"0","valid_bit":"0"},{"name":"kernel","role":"continue","value":"0","valid_bit":"4"},{"name":"kernel","role":"auto_start","value":"0","valid_bit":"7"},{"name":"mm","role":"data","value":"16"},{"name":"num_chirps","role":"data","value":"28"}] },
	{ "name": "s_axi_control_AWVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWVALID" } },
	{ "name": "s_axi_control_AWREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWREADY" } },
	{ "name": "s_axi_control_WVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WVALID" } },
	{ "name": "s_axi_control_WREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WREADY" } },
	{ "name": "s_axi_control_WDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "WDATA" } },
	{ "name": "s_axi_control_WSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "control", "role": "WSTRB" } },
	{ "name": "s_axi_control_ARADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "control", "role": "ARADDR" },"address":[{"name":"kernel","role":"start","value":"0","valid_bit":"0"},{"name":"kernel","role":"done","value":"0","valid_bit":"1"},{"name":"kernel","role":"idle","value":"0","valid_bit":"2"},{"name":"kernel","role":"ready","value":"0","valid_bit":"3"},{"name":"kernel","role":"auto_start","value":"0","valid_bit":"7"}] },
	{ "name": "s_axi_control_ARVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARVALID" } },
	{ "name": "s_axi_control_ARREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARREADY" } },
	{ "name": "s_axi_control_RVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RVALID" } },
	{ "name": "s_axi_control_RREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RREADY" } },
	{ "name": "s_axi_control_RDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "RDATA" } },
	{ "name": "s_axi_control_RRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "RRESP" } },
	{ "name": "s_axi_control_BVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BVALID" } },
	{ "name": "s_axi_control_BREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BREADY" } },
	{ "name": "s_axi_control_BRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "BRESP" } },
	{ "name": "interrupt", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "interrupt" } }, 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "m_axi_gmem_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "WID" }} , 
 	{ "name": "m_axi_gmem_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "RID" }} , 
 	{ "name": "m_axi_gmem_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "BID" }} , 
 	{ "name": "m_axi_gmem_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "BUSER" }} , 
 	{ "name": "in_adc0_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "in_adc0_V_data_V", "role": "default" }} , 
 	{ "name": "in_adc0_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "in_adc0_V_keep_V", "role": "default" }} , 
 	{ "name": "in_adc0_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "in_adc0_V_strb_V", "role": "default" }} , 
 	{ "name": "in_adc0_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_adc0_V_last_V", "role": "default" }} , 
 	{ "name": "out_r_00_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "out_r_00_V_data_V", "role": "default" }} , 
 	{ "name": "out_r_00_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_r_00_V_keep_V", "role": "default" }} , 
 	{ "name": "out_r_00_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_r_00_V_strb_V", "role": "default" }} , 
 	{ "name": "out_r_00_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_r_00_V_last_V", "role": "default" }} , 
 	{ "name": "out_r_01_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "out_r_01_V_data_V", "role": "default" }} , 
 	{ "name": "out_r_01_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_r_01_V_keep_V", "role": "default" }} , 
 	{ "name": "out_r_01_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_r_01_V_strb_V", "role": "default" }} , 
 	{ "name": "out_r_01_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_r_01_V_last_V", "role": "default" }} , 
 	{ "name": "in_r_00_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_r_00_V_data_V", "role": "default" }} , 
 	{ "name": "in_r_00_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_r_00_V_keep_V", "role": "default" }} , 
 	{ "name": "in_r_00_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_r_00_V_strb_V", "role": "default" }} , 
 	{ "name": "in_r_00_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_r_00_V_last_V", "role": "default" }} , 
 	{ "name": "in_r_01_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_r_01_V_data_V", "role": "default" }} , 
 	{ "name": "in_r_01_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_r_01_V_keep_V", "role": "default" }} , 
 	{ "name": "in_r_01_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_r_01_V_strb_V", "role": "default" }} , 
 	{ "name": "in_r_01_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_r_01_V_last_V", "role": "default" }} , 
 	{ "name": "out_d_02_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "out_d_02_V_data_V", "role": "default" }} , 
 	{ "name": "out_d_02_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_d_02_V_keep_V", "role": "default" }} , 
 	{ "name": "out_d_02_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_d_02_V_strb_V", "role": "default" }} , 
 	{ "name": "out_d_02_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "out_d_03_TDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "out_d_03_V_data_V", "role": "default" }} , 
 	{ "name": "out_d_03_TKEEP", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_d_03_V_keep_V", "role": "default" }} , 
 	{ "name": "out_d_03_TSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "out_d_03_V_strb_V", "role": "default" }} , 
 	{ "name": "out_d_03_TLAST", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "out_d_03_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_02_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_d_02_V_data_V", "role": "default" }} , 
 	{ "name": "in_d_02_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_d_02_V_keep_V", "role": "default" }} , 
 	{ "name": "in_d_02_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_d_02_V_strb_V", "role": "default" }} , 
 	{ "name": "in_d_02_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_03_TDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "in_d_03_V_data_V", "role": "default" }} , 
 	{ "name": "in_d_03_TKEEP", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_d_03_V_keep_V", "role": "default" }} , 
 	{ "name": "in_d_03_TSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "in_d_03_V_strb_V", "role": "default" }} , 
 	{ "name": "in_d_03_TLAST", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "in_d_03_V_last_V", "role": "default" }} , 
 	{ "name": "in_adc0_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_adc0_V_last_V", "role": "default" }} , 
 	{ "name": "in_adc0_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_adc0_V_last_V", "role": "default" }} , 
 	{ "name": "out_r_00_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "out_r_00_V_last_V", "role": "default" }} , 
 	{ "name": "out_r_00_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "out_r_00_V_last_V", "role": "default" }} , 
 	{ "name": "out_r_01_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "out_r_01_V_last_V", "role": "default" }} , 
 	{ "name": "out_r_01_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "out_r_01_V_last_V", "role": "default" }} , 
 	{ "name": "in_r_00_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_r_00_V_last_V", "role": "default" }} , 
 	{ "name": "in_r_00_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_r_00_V_last_V", "role": "default" }} , 
 	{ "name": "in_r_01_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_r_01_V_last_V", "role": "default" }} , 
 	{ "name": "in_r_01_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_r_01_V_last_V", "role": "default" }} , 
 	{ "name": "out_d_02_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "out_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "out_d_02_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "out_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "out_d_03_TVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "outvld", "bundle":{"name": "out_d_03_V_last_V", "role": "default" }} , 
 	{ "name": "out_d_03_TREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "outacc", "bundle":{"name": "out_d_03_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_02_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_02_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_d_02_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_03_TVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "invld", "bundle":{"name": "in_d_03_V_last_V", "role": "default" }} , 
 	{ "name": "in_d_03_TREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "inacc", "bundle":{"name": "in_d_03_V_last_V", "role": "default" }}  ]}

set ArgLastReadFirstWriteLatency {
	kernel {
		gmem {Type IO LastRead 27 FirstWrite -1}
		mm {Type I LastRead 1 FirstWrite -1}
		in_adc0_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_adc0_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_adc0_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_adc0_V_last_V {Type I LastRead 1 FirstWrite -1}
		out_r_00_V_data_V {Type O LastRead -1 FirstWrite 3}
		out_r_00_V_keep_V {Type O LastRead -1 FirstWrite 3}
		out_r_00_V_strb_V {Type O LastRead -1 FirstWrite 3}
		out_r_00_V_last_V {Type O LastRead -1 FirstWrite 3}
		out_r_01_V_data_V {Type O LastRead -1 FirstWrite 3}
		out_r_01_V_keep_V {Type O LastRead -1 FirstWrite 3}
		out_r_01_V_strb_V {Type O LastRead -1 FirstWrite 3}
		out_r_01_V_last_V {Type O LastRead -1 FirstWrite 3}
		in_r_00_V_data_V {Type I LastRead 18 FirstWrite -1}
		in_r_00_V_keep_V {Type I LastRead 18 FirstWrite -1}
		in_r_00_V_strb_V {Type I LastRead 18 FirstWrite -1}
		in_r_00_V_last_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_data_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_keep_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_strb_V {Type I LastRead 18 FirstWrite -1}
		in_r_01_V_last_V {Type I LastRead 18 FirstWrite -1}
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
		num_chirps {Type I LastRead 1 FirstWrite -1}
		hamming_window_2048_real {Type I LastRead -1 FirstWrite -1}
		mask_seqs {Type IO LastRead -1 FirstWrite -1}
		seqs_done {Type IO LastRead -1 FirstWrite -1}
		hamming_window_256_real {Type I LastRead -1 FirstWrite -1}}
	adc_forward {
		in_adc0_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_adc0_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_adc0_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_adc0_V_last_V {Type I LastRead 1 FirstWrite -1}
		out_r_00_V_data_V {Type O LastRead -1 FirstWrite 3}
		out_r_00_V_keep_V {Type O LastRead -1 FirstWrite 3}
		out_r_00_V_strb_V {Type O LastRead -1 FirstWrite 3}
		out_r_00_V_last_V {Type O LastRead -1 FirstWrite 3}
		out_r_01_V_data_V {Type O LastRead -1 FirstWrite 3}
		out_r_01_V_keep_V {Type O LastRead -1 FirstWrite 3}
		out_r_01_V_strb_V {Type O LastRead -1 FirstWrite 3}
		out_r_01_V_last_V {Type O LastRead -1 FirstWrite 3}
		num_chirps {Type I LastRead 0 FirstWrite -1}
		hamming_window_2048_real {Type I LastRead -1 FirstWrite -1}}
	adc_forward_Pipeline_VITIS_LOOP_54_2 {
		in_adc0_V_data_V {Type I LastRead 1 FirstWrite -1}
		in_adc0_V_keep_V {Type I LastRead 1 FirstWrite -1}
		in_adc0_V_strb_V {Type I LastRead 1 FirstWrite -1}
		in_adc0_V_last_V {Type I LastRead 1 FirstWrite -1}
		out_r_00_V_data_V {Type O LastRead -1 FirstWrite 3}
		out_r_00_V_keep_V {Type O LastRead -1 FirstWrite 3}
		out_r_00_V_strb_V {Type O LastRead -1 FirstWrite 3}
		out_r_00_V_last_V {Type O LastRead -1 FirstWrite 3}
		out_r_01_V_data_V {Type O LastRead -1 FirstWrite 3}
		out_r_01_V_keep_V {Type O LastRead -1 FirstWrite 3}
		out_r_01_V_strb_V {Type O LastRead -1 FirstWrite 3}
		out_r_01_V_last_V {Type O LastRead -1 FirstWrite 3}
		hamming_window_2048_real {Type I LastRead -1 FirstWrite -1}}
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
		dmask_data {Type O LastRead -1 FirstWrite 3}}
	dummy {
		doppler_mask_stream {Type I LastRead 0 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "-1", "Max" : "-1"}
	, {"Name" : "Interval", "Min" : "-1", "Max" : "-1"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	gmem { m_axi {  { m_axi_gmem_AWVALID VALID 1 1 }  { m_axi_gmem_AWREADY READY 0 1 }  { m_axi_gmem_AWADDR ADDR 1 64 }  { m_axi_gmem_AWID ID 1 1 }  { m_axi_gmem_AWLEN SIZE 1 8 }  { m_axi_gmem_AWSIZE BURST 1 3 }  { m_axi_gmem_AWBURST LOCK 1 2 }  { m_axi_gmem_AWLOCK CACHE 1 2 }  { m_axi_gmem_AWCACHE PROT 1 4 }  { m_axi_gmem_AWPROT QOS 1 3 }  { m_axi_gmem_AWQOS REGION 1 4 }  { m_axi_gmem_AWREGION USER 1 4 }  { m_axi_gmem_AWUSER DATA 1 1 }  { m_axi_gmem_WVALID VALID 1 1 }  { m_axi_gmem_WREADY READY 0 1 }  { m_axi_gmem_WDATA FIFONUM 1 32 }  { m_axi_gmem_WSTRB STRB 1 4 }  { m_axi_gmem_WLAST LAST 1 1 }  { m_axi_gmem_WID ID 1 1 }  { m_axi_gmem_WUSER DATA 1 1 }  { m_axi_gmem_ARVALID VALID 1 1 }  { m_axi_gmem_ARREADY READY 0 1 }  { m_axi_gmem_ARADDR ADDR 1 64 }  { m_axi_gmem_ARID ID 1 1 }  { m_axi_gmem_ARLEN SIZE 1 8 }  { m_axi_gmem_ARSIZE BURST 1 3 }  { m_axi_gmem_ARBURST LOCK 1 2 }  { m_axi_gmem_ARLOCK CACHE 1 2 }  { m_axi_gmem_ARCACHE PROT 1 4 }  { m_axi_gmem_ARPROT QOS 1 3 }  { m_axi_gmem_ARQOS REGION 1 4 }  { m_axi_gmem_ARREGION USER 1 4 }  { m_axi_gmem_ARUSER DATA 1 1 }  { m_axi_gmem_RVALID VALID 0 1 }  { m_axi_gmem_RREADY READY 1 1 }  { m_axi_gmem_RDATA FIFONUM 0 32 }  { m_axi_gmem_RLAST LAST 0 1 }  { m_axi_gmem_RID ID 0 1 }  { m_axi_gmem_RUSER DATA 0 1 }  { m_axi_gmem_RRESP RESP 0 2 }  { m_axi_gmem_BVALID VALID 0 1 }  { m_axi_gmem_BREADY READY 1 1 }  { m_axi_gmem_BRESP RESP 0 2 }  { m_axi_gmem_BID ID 0 1 }  { m_axi_gmem_BUSER DATA 0 1 } } }
	in_adc0_V_data_V { axis {  { in_adc0_TDATA in_data 0 64 } } }
	in_adc0_V_keep_V { axis {  { in_adc0_TKEEP in_data 0 8 } } }
	in_adc0_V_strb_V { axis {  { in_adc0_TSTRB in_data 0 8 } } }
	in_adc0_V_last_V { axis {  { in_adc0_TLAST in_data 0 1 }  { in_adc0_TVALID in_vld 0 1 }  { in_adc0_TREADY in_acc 1 1 } } }
	out_r_00_V_data_V { axis {  { out_r_00_TDATA out_data 1 32 } } }
	out_r_00_V_keep_V { axis {  { out_r_00_TKEEP out_data 1 4 } } }
	out_r_00_V_strb_V { axis {  { out_r_00_TSTRB out_data 1 4 } } }
	out_r_00_V_last_V { axis {  { out_r_00_TLAST out_data 1 1 }  { out_r_00_TVALID out_vld 1 1 }  { out_r_00_TREADY out_acc 0 1 } } }
	out_r_01_V_data_V { axis {  { out_r_01_TDATA out_data 1 32 } } }
	out_r_01_V_keep_V { axis {  { out_r_01_TKEEP out_data 1 4 } } }
	out_r_01_V_strb_V { axis {  { out_r_01_TSTRB out_data 1 4 } } }
	out_r_01_V_last_V { axis {  { out_r_01_TLAST out_data 1 1 }  { out_r_01_TVALID out_vld 1 1 }  { out_r_01_TREADY out_acc 0 1 } } }
	in_r_00_V_data_V { axis {  { in_r_00_TDATA in_data 0 32 } } }
	in_r_00_V_keep_V { axis {  { in_r_00_TKEEP in_data 0 4 } } }
	in_r_00_V_strb_V { axis {  { in_r_00_TSTRB in_data 0 4 } } }
	in_r_00_V_last_V { axis {  { in_r_00_TLAST in_data 0 1 }  { in_r_00_TVALID in_vld 0 1 }  { in_r_00_TREADY in_acc 1 1 } } }
	in_r_01_V_data_V { axis {  { in_r_01_TDATA in_data 0 32 } } }
	in_r_01_V_keep_V { axis {  { in_r_01_TKEEP in_data 0 4 } } }
	in_r_01_V_strb_V { axis {  { in_r_01_TSTRB in_data 0 4 } } }
	in_r_01_V_last_V { axis {  { in_r_01_TLAST in_data 0 1 }  { in_r_01_TVALID in_vld 0 1 }  { in_r_01_TREADY in_acc 1 1 } } }
	out_d_02_V_data_V { axis {  { out_d_02_TDATA out_data 1 32 } } }
	out_d_02_V_keep_V { axis {  { out_d_02_TKEEP out_data 1 4 } } }
	out_d_02_V_strb_V { axis {  { out_d_02_TSTRB out_data 1 4 } } }
	out_d_02_V_last_V { axis {  { out_d_02_TLAST out_data 1 1 }  { out_d_02_TVALID out_vld 1 1 }  { out_d_02_TREADY out_acc 0 1 } } }
	out_d_03_V_data_V { axis {  { out_d_03_TDATA out_data 1 32 } } }
	out_d_03_V_keep_V { axis {  { out_d_03_TKEEP out_data 1 4 } } }
	out_d_03_V_strb_V { axis {  { out_d_03_TSTRB out_data 1 4 } } }
	out_d_03_V_last_V { axis {  { out_d_03_TLAST out_data 1 1 }  { out_d_03_TVALID out_vld 1 1 }  { out_d_03_TREADY out_acc 0 1 } } }
	in_d_02_V_data_V { axis {  { in_d_02_TDATA in_data 0 32 } } }
	in_d_02_V_keep_V { axis {  { in_d_02_TKEEP in_data 0 4 } } }
	in_d_02_V_strb_V { axis {  { in_d_02_TSTRB in_data 0 4 } } }
	in_d_02_V_last_V { axis {  { in_d_02_TLAST in_data 0 1 }  { in_d_02_TVALID in_vld 0 1 }  { in_d_02_TREADY in_acc 1 1 } } }
	in_d_03_V_data_V { axis {  { in_d_03_TDATA in_data 0 32 } } }
	in_d_03_V_keep_V { axis {  { in_d_03_TKEEP in_data 0 4 } } }
	in_d_03_V_strb_V { axis {  { in_d_03_TSTRB in_data 0 4 } } }
	in_d_03_V_last_V { axis {  { in_d_03_TLAST in_data 0 1 }  { in_d_03_TVALID in_vld 0 1 }  { in_d_03_TREADY in_acc 1 1 } } }
}

set maxi_interface_dict [dict create]
dict set maxi_interface_dict gmem { CHANNEL_NUM 0 BUNDLE gmem NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 16 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_WRITE}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
	{ gmem 1 }
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
	{ gmem 1 }
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}

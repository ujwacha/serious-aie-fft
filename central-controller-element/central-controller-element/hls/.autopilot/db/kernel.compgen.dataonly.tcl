# This script segment is generated automatically by AutoPilot

set axilite_register_dict [dict create]
set port_control {
mm { 
	dir I
	width 64
	depth 1
	mode ap_none
	offset 16
	offset_end 27
	direct_io 0
}
num_chirps { 
	dir I
	width 32
	depth 1
	mode ap_none
	offset 28
	offset_end 35
	direct_io 0
}
ap_start { }
ap_done { }
ap_ready { }
ap_idle { }
interrupt {
}
}
dict set axilite_register_dict control $port_control



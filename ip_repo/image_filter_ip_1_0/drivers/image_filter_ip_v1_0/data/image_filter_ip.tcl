

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "image_filter_ip" "NUM_INSTANCES" "DEVICE_ID"  "C_S_AXI_CTRL_BASEADDR" "C_S_AXI_CTRL_HIGHADDR"
}

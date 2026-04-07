
`timescale 1 ns / 1 ps

	module image_filter_ip #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S_AXI_CTRL
		parameter integer C_S_AXI_CTRL_DATA_WIDTH	= 32,
		parameter integer C_S_AXI_CTRL_ADDR_WIDTH	= 4,

		// Parameters of Axi Slave Bus Interface PIXEL_IN
		parameter integer C_PIXEL_IN_TDATA_WIDTH	= 32,

		// Parameters of Axi Master Bus Interface PIXEL_OUT
		parameter integer C_PIXEL_OUT_TDATA_WIDTH	= 32,
		parameter integer C_PIXEL_OUT_START_COUNT	= 32
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S_AXI_CTRL
		input wire  s_axi_ctrl_aclk,
		input wire  s_axi_ctrl_aresetn,
		input wire [C_S_AXI_CTRL_ADDR_WIDTH-1 : 0] s_axi_ctrl_awaddr,
		input wire [2 : 0] s_axi_ctrl_awprot,
		input wire  s_axi_ctrl_awvalid,
		output wire  s_axi_ctrl_awready,
		input wire [C_S_AXI_CTRL_DATA_WIDTH-1 : 0] s_axi_ctrl_wdata,
		input wire [(C_S_AXI_CTRL_DATA_WIDTH/8)-1 : 0] s_axi_ctrl_wstrb,
		input wire  s_axi_ctrl_wvalid,
		output wire  s_axi_ctrl_wready,
		output wire [1 : 0] s_axi_ctrl_bresp,
		output wire  s_axi_ctrl_bvalid,
		input wire  s_axi_ctrl_bready,
		input wire [C_S_AXI_CTRL_ADDR_WIDTH-1 : 0] s_axi_ctrl_araddr,
		input wire [2 : 0] s_axi_ctrl_arprot,
		input wire  s_axi_ctrl_arvalid,
		output wire  s_axi_ctrl_arready,
		output wire [C_S_AXI_CTRL_DATA_WIDTH-1 : 0] s_axi_ctrl_rdata,
		output wire [1 : 0] s_axi_ctrl_rresp,
		output wire  s_axi_ctrl_rvalid,
		input wire  s_axi_ctrl_rready,

		// Ports of Axi Slave Bus Interface PIXEL_IN
		input wire  pixel_in_aclk,
		input wire  pixel_in_aresetn,
		output wire  pixel_in_tready,
		input wire [C_PIXEL_IN_TDATA_WIDTH-1 : 0] pixel_in_tdata,
		input wire [(C_PIXEL_IN_TDATA_WIDTH/8)-1 : 0] pixel_in_tstrb,
		input wire  pixel_in_tlast,
		input wire  pixel_in_tvalid,

		// Ports of Axi Master Bus Interface PIXEL_OUT
		input wire  pixel_out_aclk,
		input wire  pixel_out_aresetn,
		output wire  pixel_out_tvalid,
		output wire [C_PIXEL_OUT_TDATA_WIDTH-1 : 0] pixel_out_tdata,
		output wire [(C_PIXEL_OUT_TDATA_WIDTH/8)-1 : 0] pixel_out_tstrb,
		output wire  pixel_out_tlast,
		input wire  pixel_out_tready
	);
// Instantiation of Axi Bus Interface S_AXI_CTRL
	image_filter_ip_slave_lite_v1_0_S_AXI_CTRL # ( 
		.C_S_AXI_DATA_WIDTH(C_S_AXI_CTRL_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S_AXI_CTRL_ADDR_WIDTH)
	) image_filter_ip_slave_lite_v1_0_S_AXI_CTRL_inst (
		.S_AXI_ACLK(s_axi_ctrl_aclk),
		.S_AXI_ARESETN(s_axi_ctrl_aresetn),
		.S_AXI_AWADDR(s_axi_ctrl_awaddr),
		.S_AXI_AWPROT(s_axi_ctrl_awprot),
		.S_AXI_AWVALID(s_axi_ctrl_awvalid),
		.S_AXI_AWREADY(s_axi_ctrl_awready),
		.S_AXI_WDATA(s_axi_ctrl_wdata),
		.S_AXI_WSTRB(s_axi_ctrl_wstrb),
		.S_AXI_WVALID(s_axi_ctrl_wvalid),
		.S_AXI_WREADY(s_axi_ctrl_wready),
		.S_AXI_BRESP(s_axi_ctrl_bresp),
		.S_AXI_BVALID(s_axi_ctrl_bvalid),
		.S_AXI_BREADY(s_axi_ctrl_bready),
		.S_AXI_ARADDR(s_axi_ctrl_araddr),
		.S_AXI_ARPROT(s_axi_ctrl_arprot),
		.S_AXI_ARVALID(s_axi_ctrl_arvalid),
		.S_AXI_ARREADY(s_axi_ctrl_arready),
		.S_AXI_RDATA(s_axi_ctrl_rdata),
		.S_AXI_RRESP(s_axi_ctrl_rresp),
		.S_AXI_RVALID(s_axi_ctrl_rvalid),
		.S_AXI_RREADY(s_axi_ctrl_rready)
	);

// Instantiation of Axi Bus Interface PIXEL_IN
/*
	image_filter_ip_slave_stream_v1_0_PIXEL_IN # ( 
		.C_S_AXIS_TDATA_WIDTH(C_PIXEL_IN_TDATA_WIDTH)
	) image_filter_ip_slave_stream_v1_0_PIXEL_IN_inst (
		.S_AXIS_ACLK(pixel_in_aclk),
		.S_AXIS_ARESETN(pixel_in_aresetn),
		.S_AXIS_TREADY(pixel_in_tready),
		.S_AXIS_TDATA(pixel_in_tdata),
		.S_AXIS_TSTRB(pixel_in_tstrb),
		.S_AXIS_TLAST(pixel_in_tlast),
		.S_AXIS_TVALID(pixel_in_tvalid)
	);

// Instantiation of Axi Bus Interface PIXEL_OUT
	image_filter_ip_master_stream_v1_0_PIXEL_OUT # ( 
		.C_M_AXIS_TDATA_WIDTH(C_PIXEL_OUT_TDATA_WIDTH),
		.C_M_START_COUNT(C_PIXEL_OUT_START_COUNT)
	) image_filter_ip_master_stream_v1_0_PIXEL_OUT_inst (
		.M_AXIS_ACLK(pixel_out_aclk),
		.M_AXIS_ARESETN(pixel_out_aresetn),
		.M_AXIS_TVALID(pixel_out_tvalid),
		.M_AXIS_TDATA(pixel_out_tdata),
		.M_AXIS_TSTRB(pixel_out_tstrb),
		.M_AXIS_TLAST(pixel_out_tlast),
		.M_AXIS_TREADY(pixel_out_tready)
	);
*/
    // Add user logic here
    
    // Pass the handshaking signals straight through (using LOWERCASE port names)
    assign pixel_out_tvalid = pixel_in_tvalid;
    assign pixel_in_tready  = pixel_out_tready;
    assign pixel_out_tlast  = pixel_in_tlast;
    
    // Pass the byte strobe through instead of tkeep
    assign pixel_out_tstrb  = pixel_in_tstrb;

    // Invert the pixel data (Assumes 00000000_RRRRRRRR_GGGGGGGG_BBBBBBBB packing)
    // We only invert the lower 24 bits (the RGB values)
    assign pixel_out_tdata  = {pixel_in_tdata[31:24], ~pixel_in_tdata[23:0]};
    
	// User logic ends

endmodule

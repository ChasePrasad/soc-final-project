`timescale 1 ns / 1 ps

    module image_filter_ip #
    (
        // Users to add parameters here

        // User parameters ends
        // Do not modify the parameters beyond this line


        // Parameters of Axi Slave Bus Interface S_AXI_CTRL
        parameter integer C_S_AXI_CTRL_DATA_WIDTH   = 32,
        parameter integer C_S_AXI_CTRL_ADDR_WIDTH   = 4,

        // Parameters of Axi Slave Bus Interface PIXEL_IN
        parameter integer C_PIXEL_IN_TDATA_WIDTH    = 32,

        // Parameters of Axi Master Bus Interface PIXEL_OUT
        parameter integer C_PIXEL_OUT_TDATA_WIDTH   = 32,
        parameter integer C_PIXEL_OUT_START_COUNT   = 32
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

    // -----------------------------------------------------------------------
    // Wire to carry slv_reg0 (filter mode) out of the AXI-Lite slave
    // -----------------------------------------------------------------------
    wire [C_S_AXI_CTRL_DATA_WIDTH-1 : 0] filter_mode;

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
        .S_AXI_RREADY(s_axi_ctrl_rready),
        // --- New port: exposes slv_reg0 so we can read the filter mode ---
        .filter_mode(filter_mode)
    );

    // -----------------------------------------------------------------------
    // AXI-Stream handshaking passthrough (combinational, zero latency)
    // -----------------------------------------------------------------------
    assign pixel_out_tvalid = pixel_in_tvalid;
    assign pixel_in_tready  = pixel_out_tready;
    assign pixel_out_tlast  = pixel_in_tlast;
    assign pixel_out_tstrb  = pixel_in_tstrb;

    // -----------------------------------------------------------------------
    // Pixel channel extraction
    // Packing: [31:24] = unused/alpha, [23:16] = R, [15:8] = G, [7:0] = B
    // -----------------------------------------------------------------------
    wire [7:0] r_in = pixel_in_tdata[23:16];
    wire [7:0] g_in = pixel_in_tdata[15:8];
    wire [7:0] b_in = pixel_in_tdata[7:0];

    // -----------------------------------------------------------------------
    // Grayscale: Y = (77*R + 150*G + 29*B) >> 8
    //
    // Coefficients sum to 256, so the result is already in [0,255] after
    // the right-shift — no clamping needed.
    //   Max value: (77+150+29)*255 = 256*255 = 65280  -> fits in 16 bits
    //   After >>8: max = 255                           -> fits in 8 bits
    // -----------------------------------------------------------------------
    wire [15:0] y_wide = (8'd77  * r_in)
                       + (8'd150 * g_in)
                       + (8'd29  * b_in);
    wire [7:0]  y_out  = y_wide[15:8];   // equivalent to >> 8

    // -----------------------------------------------------------------------
    // Filter mux — selected by filter_mode[1:0] written via AXI-Lite
    //   0 : Passthrough  (no change)
    //   1 : Invert       (bitwise NOT on RGB channels)
    //   2 : Grayscale    (luminance rec. 601 approximation, R=G=B=Y)
    // -----------------------------------------------------------------------
    reg [31:0] filtered_tdata;

    always @(*) begin
        case (filter_mode[1:0])
            2'd0:    filtered_tdata = pixel_in_tdata;                              // passthrough
            2'd1:    filtered_tdata = {pixel_in_tdata[31:24], ~r_in, ~g_in, ~b_in}; // invert
            2'd2:    filtered_tdata = {pixel_in_tdata[31:24],  y_out,  y_out,  y_out}; // grayscale
            default: filtered_tdata = pixel_in_tdata;
        endcase
    end

    assign pixel_out_tdata = filtered_tdata;

    // User logic ends

endmodule
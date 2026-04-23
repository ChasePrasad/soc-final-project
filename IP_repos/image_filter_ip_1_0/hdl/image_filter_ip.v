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
    // Grayscale (Mode 2): Y = (77*R + 150*G + 29*B) >> 8
    //
    // Coefficients sum to 256, so the result is already in [0,255] after
    // the right-shift — no clamping needed.
    //   Max value: (77+150+29)*255 = 256*255 = 65280  -> fits in 16 bits
    //   After >>8: max = 255                           -> fits in 8 bits
    // -----------------------------------------------------------------------
    wire [15:0] y_wide = ({8'b0, 8'd77}  * {8'b0, r_in})
                       + ({8'b0, 8'd150} * {8'b0, g_in})
                       + ({8'b0, 8'd29}  * {8'b0, b_in});
    wire [7:0]  y_out  = y_wide[15:8];   // equivalent to >> 8

    // -----------------------------------------------------------------------
    // Neon Duotone (Mode 3)
    //
    // Hardware-friendly version of the software effect:
    //   t = clamp( grayscale + |R-B|/4 )
    //   output = shadow + (highlight-shadow) * t / 256
    //
    // Shadow    = (20, 35, 120)
    // Highlight = (255, 70, 220)
    // -----------------------------------------------------------------------
    wire [8:0] rb_diff = (r_in >= b_in) ? ({1'b0, r_in} - {1'b0, b_in})
                                        : ({1'b0, b_in} - {1'b0, r_in});

    wire [8:0] glow_tmp = rb_diff >> 2;
    wire [8:0] t_tmp    = {1'b0, y_out} + glow_tmp;
    wire [7:0] t_out    = (t_tmp > 9'd255) ? 8'd255 : t_tmp[7:0];

    localparam [7:0] SHADOW_R    = 8'd20;
    localparam [7:0] SHADOW_G    = 8'd35;
    localparam [7:0] SHADOW_B    = 8'd120;
    localparam [7:0] HIGHLIGHT_R = 8'd255;
    localparam [7:0] HIGHLIGHT_G = 8'd70;
    localparam [7:0] HIGHLIGHT_B = 8'd220;

    localparam [8:0] DELTA_R = 9'd235;   // HIGHLIGHT_R - SHADOW_R
    localparam [8:0] DELTA_G = 9'd35;    // HIGHLIGHT_G - SHADOW_G
    localparam [8:0] DELTA_B = 9'd100;   // HIGHLIGHT_B - SHADOW_B

    wire [16:0] neon_r_mul = DELTA_R * t_out;
    wire [16:0] neon_g_mul = DELTA_G * t_out;
    wire [16:0] neon_b_mul = DELTA_B * t_out;

    wire [7:0] neon_r = SHADOW_R + neon_r_mul[15:8];
    wire [7:0] neon_g = SHADOW_G + neon_g_mul[15:8];
    wire [7:0] neon_b = SHADOW_B + neon_b_mul[15:8];

    // -----------------------------------------------------------------------
    // Sunset (Mode 4)
    //   R += 50 (clamped to 255)
    //   G  = unchanged
    //   B  = B >> 1 (halved)
    // -----------------------------------------------------------------------
    wire [8:0] sunset_r_tmp = {1'b0, r_in} + 9'd50;
    wire [7:0] sunset_r     = (sunset_r_tmp > 9'd255) ? 8'd255 : sunset_r_tmp[7:0];
    wire [7:0] sunset_g     = g_in;
    wire [7:0] sunset_b     = b_in >> 1;

    // -----------------------------------------------------------------------
    // Red Filter (Mode 5)
    //   Keeps only the Red channel; G and B are zeroed out
    // -----------------------------------------------------------------------
    wire [7:0] red_r = r_in;
    wire [7:0] red_g = 8'd0;
    wire [7:0] red_b = 8'd0;

    // -----------------------------------------------------------------------
    // Filter mux — selected by filter_mode[2:0] written via AXI-Lite
    //   0 : Passthrough
    //   1 : Invert
    //   2 : Grayscale
    //   3 : Neon Duotone
    //   4 : Sunset
    //   5 : Red Filter
    // -----------------------------------------------------------------------
    reg [31:0] filtered_tdata;

    always @(*) begin
        case (filter_mode[2:0])
            3'd0:    filtered_tdata = {pixel_in_tdata[31:24], r_in,     g_in,     b_in};        // passthrough
            3'd1:    filtered_tdata = {pixel_in_tdata[31:24], ~r_in,    ~g_in,    ~b_in};       // invert
            3'd2:    filtered_tdata = {pixel_in_tdata[31:24], y_out,    y_out,    y_out};       // grayscale
            3'd3:    filtered_tdata = {pixel_in_tdata[31:24], neon_r,   neon_g,   neon_b};     // neon duotone
            3'd4:    filtered_tdata = {pixel_in_tdata[31:24], sunset_r, sunset_g, sunset_b};   // sunset
            3'd5:    filtered_tdata = {pixel_in_tdata[31:24], red_r,    red_g,    red_b};       // red filter
            default: filtered_tdata = {pixel_in_tdata[31:24], r_in,     g_in,     b_in};        // default passthrough
        endcase
    end

    assign pixel_out_tdata = filtered_tdata;

endmodule
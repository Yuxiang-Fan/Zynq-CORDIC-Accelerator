



module   System_wrapper_top
(
    input             i_clk,
    input             i_rst_n,

    // DDR 接口 - inout 类型
    inout wire [14:0] DDR_addr,
    inout wire [2:0]  DDR_ba,
    inout wire        DDR_cas_n,
    inout wire        DDR_ck_n,
    inout wire        DDR_ck_p,
    inout wire        DDR_cke,
    inout wire        DDR_cs_n,
    inout wire [3:0]  DDR_dm,
    inout wire [31:0] DDR_dq,
    inout wire [3:0]  DDR_dqs_n,
    inout wire [3:0]  DDR_dqs_p,
    inout wire        DDR_odt,
    inout wire        DDR_ras_n,
    inout wire        DDR_reset_n,
    inout wire        DDR_we_n,
    
    // FIXED_IO 接口 - inout 类型
    inout wire        FIXED_IO_ddr_vrn,
    inout wire        FIXED_IO_ddr_vrp,
    inout wire [53:0] FIXED_IO_mio,
    inout wire        FIXED_IO_ps_clk,
    inout wire        FIXED_IO_ps_porb,
    inout wire        FIXED_IO_ps_srstb,
    
    // UART 接口
    input  wire       uart_rtl_0_rxd,
    output wire       uart_rtl_0_txd

);

wire   ps_gen_50m;
wire   ps_tx_uart;
wire   ps_rx_uart;

// 实例化 System_wrapper 模块
System_wrapper    system_wrapper_inst (
    // DDR 接口
    .DDR_addr          (DDR_addr),          // [14:0]
    .DDR_ba            (DDR_ba),            // [2:0]
    .DDR_cas_n         (DDR_cas_n),
    .DDR_ck_n          (DDR_ck_n),
    .DDR_ck_p          (DDR_ck_p),
    .DDR_cke           (DDR_cke),
    .DDR_cs_n          (DDR_cs_n),
    .DDR_dm            (DDR_dm),            // [3:0]
    .DDR_dq            (DDR_dq),            // [31:0]
    .DDR_dqs_n         (DDR_dqs_n),         // [3:0]
    .DDR_dqs_p         (DDR_dqs_p),         // [3:0]
    .DDR_odt           (DDR_odt),
    .DDR_ras_n         (DDR_ras_n),
    .DDR_reset_n       (DDR_reset_n),
    .DDR_we_n          (DDR_we_n),
    
    // FIXED_IO 接口
    .FIXED_IO_ddr_vrn  (FIXED_IO_ddr_vrn),
    .FIXED_IO_ddr_vrp  (FIXED_IO_ddr_vrp),
    .FIXED_IO_mio      (FIXED_IO_mio),      // [53:0]
    .FIXED_IO_ps_clk   (FIXED_IO_ps_clk),
    .FIXED_IO_ps_porb  (FIXED_IO_ps_porb),
    .FIXED_IO_ps_srstb (FIXED_IO_ps_srstb),
    
    
    .ps_gen_50m        (ps_gen_50m),
    // UART 接口
    .uart_rtl_0_rxd    (ps_rx_uart),
    .uart_rtl_0_txd    (ps_tx_uart)
);


uart_loopback    uart_loopback_inst
(
    .Clk     (ps_gen_50m    ),
    .Rst_n   (1'b1          ),
    .uart_rx (ps_tx_uart    ),

    .uart_tx (ps_rx_uart    )
); 



endmodule




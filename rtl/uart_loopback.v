


module uart_loopback 
#(
    parameter DATA_WIDTH = 32,
    parameter MSB_FIRST  = 0
)
(
    input  Clk     ,
    input  Rst_n   ,
    input  uart_rx ,
    
    output uart_tx
); 

wire [2:0]            led      ;
wire [DATA_WIDTH-1:0] rx_data  ;
wire                  Rx_Done  ;
wire [7:0]            data_byte;

reg                  s_input_valid;
reg                  s_output_valid;
reg signed [31:0]    s_input_data ;
reg signed [31:0]    s_output_data;


wire signed  [31:0]    o_data_sin   ;
wire signed  [31:0]    o_data_cos   ;
wire signed  [31:0]    o_data_arcsin;   
wire signed  [31:0]    o_data_arctg ;

wire            o_vaild_1;
wire            o_vaild_2;
wire            o_vaild_3;

reg  [3:0]      s_state;


uart_data_rx #(
    .DATA_WIDTH(DATA_WIDTH), 
    .MSB_FIRST (MSB_FIRST)    
) uart_data_rx_inst(
    .Clk         (Clk)        ,
    .Rst_n       (Rst_n)      ,
    .uart_rx     (uart_rx)    ,
    .Baud_Set    (3'd4)       ,
    
    .data        (rx_data)    , 
    .Rx_Done     (Rx_Done)    , 
    .timeout_flag(led[0])       
);


always@(posedge Clk or negedge Rst_n) begin
    if(!Rst_n)
        s_state <= 0;
    else case(s_state)
        
        0    :     if(Rx_Done && rx_data==32'haaaa_aaaa)
                       s_state <= 1;
                   else if(Rx_Done && rx_data==32'hbbbb_bbbb)
                       s_state <= 2;
                   else if(Rx_Done && rx_data==32'hcccc_cccc)
                       s_state <= 3;
                   else if(Rx_Done && rx_data==32'hdddd_dddd)
                       s_state <= 4;
                   else
                       s_state <= 0;
        
        1    :     if(o_vaild_1)
                       s_state <= 0;
                   else
                       s_state <= 1;
        
        2    :     if(o_vaild_1)
                       s_state <= 0;
                   else
                       s_state <= 2;
        
        3    :     if(o_vaild_2)
                       s_state <= 0;
                   else
                       s_state <= 3;
        
        4    :     if(o_vaild_3)
                       s_state <= 0;
                   else
                       s_state <= 4;

      default :    s_state <= 0;
    
    endcase

end


always@(posedge Clk or negedge Rst_n) begin
    if(!Rst_n)
        s_input_valid <= 0;
    else if(s_state!=0 && Rx_Done)
        s_input_valid <= 1;
    else
        s_input_valid <= 0;   
end

always@(posedge Clk or negedge Rst_n) begin
    if(!Rst_n)
        s_input_data <= 0;
    else
        s_input_data <= rx_data;
end

always@(posedge Clk or negedge Rst_n) begin
    if(!Rst_n)
        s_output_data <= 0;
    else if(s_state==1 && o_vaild_1) begin
        s_output_data  <= o_data_sin;
        s_output_valid <= o_vaild_1;
    end else if(s_state==2 && o_vaild_1) begin
        s_output_data  <= o_data_cos;
        s_output_valid <= o_vaild_1;
    end else if(s_state==3 && o_vaild_2) begin
        s_output_data  <= o_data_arcsin;
        s_output_valid <= o_vaild_2;
    end else if(s_state==4 && o_vaild_3) begin
        s_output_data  <= o_data_arctg;
        s_output_valid <= o_vaild_3;
    end else begin
        s_output_data  <= s_output_data;
        s_output_valid <= 0; 
    end        
end


math_top    math_top_inst
(
    .i_clk        (Clk          ),
    .i_rst_n      (Rst_n        ),

    .i_valid      (s_input_valid),    
    .i_d0         (s_input_data ),  

    .o_vaild_1    (o_vaild_1),
    .o_data_sin   (o_data_sin),
    .o_data_cos   (o_data_cos),

    .o_vaild_2    (o_vaild_2),
    .o_data_arcsin(o_data_arcsin), 

    .o_vaild_3    (o_vaild_3),    
    .o_data_arctg (o_data_arctg) 
);


uart_data_tx #(
    .DATA_WIDTH(DATA_WIDTH),
    .MSB_FIRST (MSB_FIRST)
) uart_data_tx_inst(
    .Clk       (Clk)        ,
    .Rst_n     (Rst_n)      ,
    .Baud_Set  (3'd4)       ,  
    .data      (s_output_data ),
    .send_en   (s_output_valid),   
    
    .uart_tx   (uart_tx)    ,  
    .Tx_Done   (led[1])     , 
    .uart_state(led[2])       
);


endmodule
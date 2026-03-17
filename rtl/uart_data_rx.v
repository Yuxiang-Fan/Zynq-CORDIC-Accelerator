
module uart_data_rx
#(
    parameter DATA_WIDTH = 16, 
    parameter MSB_FIRST  = 1   
)
(
    input                       Clk       ,
    input                       Rst_n     ,
    input                       uart_rx   , 
    input        [2:0]          Baud_Set  ,
 
    output reg [DATA_WIDTH-1:0] data      , 
    output reg                  Rx_Done   , 
    output reg                  timeout_flag 
);

reg  [DATA_WIDTH-1:0] data_r          ; 
wire [7:0]            data_byte       ; 
wire                  byte_rx_done    ; 
wire [19:0]           TIMEOUT         ;
reg  [8:0]            cnt             ; 
reg  [1:0]            state           ;

localparam S0 = 0;  
localparam S1 = 1;  
localparam S2 = 2;  

reg  [31:0]           timeout_cnt     ; 
reg                   to_state        ;


assign TIMEOUT = (Baud_Set == 3'd0) ? 20'd182291 :
                 (Baud_Set == 3'd1) ? 20'd91145  :
                 (Baud_Set == 3'd2) ? 20'd45572  :
                 (Baud_Set == 3'd3) ? 20'd30381  :
                                      20'd15190  ;

uart_byte_rx uart_byte_rx_inst(
    .Clk       (Clk)        , 
    .Rst_n     (Rst_n)      , 
    .baud_set  (Baud_Set)   , 
    .uart_rx   (uart_rx)    , 
    .data_byte (data_byte)  , 
    .Rx_Done   (byte_rx_done) 
);


always@(posedge Clk or negedge Rst_n) begin
    if(!Rst_n) 
        timeout_flag <= 1'd0;
    else if(timeout_cnt >= TIMEOUT) 
        timeout_flag <= 1'd1;
    else if(state == S0) 
        timeout_flag <= 1'd0;
end


always@(posedge Clk or negedge Rst_n) begin
    if(!Rst_n)
        to_state <= 0;
    else if(!uart_rx) 
        to_state <= 1;
    else if(byte_rx_done) 
        to_state <= 0; 
end


always@(posedge Clk or negedge Rst_n) begin
    if(!Rst_n)
        timeout_cnt <= 32'd0;
    else if(to_state) begin 
        if(byte_rx_done) 
            timeout_cnt <= 32'd0;
        else if(timeout_cnt >= TIMEOUT) 
            timeout_cnt <= TIMEOUT;
        else
            timeout_cnt <= timeout_cnt + 1'd1;
    end
end


always@(posedge Clk or negedge Rst_n) begin
    if(!Rst_n) begin
        data_r   <= 0;
        state    <= S0;
        cnt      <= 0;         
        data     <= 0;  
        Rx_Done  <= 0;
    end
    else begin
        case(state)
            S0: begin 
                Rx_Done <= 0;
                data_r  <= 0;
                
                if(DATA_WIDTH == 8) begin 
                    data    <= data_byte; 
                    Rx_Done <= byte_rx_done; 
                end
                else if(byte_rx_done) begin 
                    state <= S1; 
                    cnt   <= cnt + 9'd8;
                    
                    if(MSB_FIRST == 1) 
                        data_r <= {data_r[DATA_WIDTH-1-8:0], data_byte};
                    else 
                        data_r <= {data_byte, data_r[DATA_WIDTH-1:8]};
                end
            end
            
            S1: begin 
                if(timeout_flag) begin 
                    state   <= S0; 
                    Rx_Done <= 1;  
                end
                else if(byte_rx_done) begin 
                    state <= S2;
                    cnt   <= cnt + 9'd8; 
                    
                    if(MSB_FIRST == 1) 
                        data_r <= {data_r[DATA_WIDTH-1-8:0], data_byte};
                    else 
                        data_r <= {data_byte, data_r[DATA_WIDTH-1:8]};
                end
            end
            
            S2: begin 
                if(cnt >= DATA_WIDTH) begin 
                    state   <= S0; 
                    cnt     <= 0;  
                    data    <= data_r; 
                    Rx_Done <= 1;  
                end
                else begin 
                    state   <= S1; 
                    Rx_Done <= 0;  
                end
            end
            
            default: state <= S0;
        endcase 
    end
end

endmodule
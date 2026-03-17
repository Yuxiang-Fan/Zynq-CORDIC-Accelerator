
module    math_top
(
    input                       i_clk        ,
    input                       i_rst_n      ,
                                             
    input                       i_valid      ,    
    input   signed    [31:0]    i_d0         ,  

    output                      o_vaild_1    ,
    output  signed    [31:0]    o_data_sin   ,
    output  signed    [31:0]    o_data_cos   ,
                      
    output                      o_vaild_2    ,
    output  signed    [31:0]    o_data_arcsin, 
                      
    output                      o_vaild_3    ,    
    output  signed    [31:0]    o_data_arctg  
);


cordic_sin_cos    cordic_sin_cos_inst
(
    .clk       (i_clk     ),
    .rst_n     (i_rst_n   ),
                          
    .angle     (i_d0      ),      
    .pre_vaild (i_valid   ),

    .sin       (o_data_sin), 
    .cos       (o_data_cos),
    .post_vaild(o_vaild_1 )

);


cordic_arcsin_arccos    cordic_arcsin_arccos_inst
(
    .clk       (i_clk        ),
    .rst_n     (i_rst_n      ),
                             
    .iData     (i_d0         ),
    .pre_vaild (i_valid      ),

    .arcsin    (o_data_arcsin),
    .post_vaild(o_vaild_2    )

);


Cordic_arctan    Cordic_arctan_inst
(
    .clk       (i_clk       ),
    .rst_n     (i_rst_n     ),
                            
    .cordic_req(i_valid     ),                        
    .X         (i_d0[15:0]  ),
    .Y         (i_d0[31:16] ),
                            
    .cordic_ack(o_vaild_3   ),
    .theta     (o_data_arctg) 
);


endmodule
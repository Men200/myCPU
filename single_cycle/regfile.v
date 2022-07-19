`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/28 16:24:55
// Design Name: 
// Module Name: regfile
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module regfile(
    input               clk,
    input               rst,
    input       [4:0]   rR1,
    input       [4:0]   rR2,
    input       [4:0]   wR,
    input               wE,
    input       [31:0]  wD,
    output  reg [31:0]  rD1,
    output  reg [31:0]  rD2
    );
    
    integer index = 0;
    reg[31:0] reg_array[31:0];
    
    always @(posedge clk) begin     // …œ…˝—ÿ–¥
        reg_array[0]    <=  0;
        if(rst)
            for(index = 0; index < 32; index = index + 1)
                reg_array[index]    <=  0;
        else if(wE && wR != 0) reg_array[wR] <= wD;
    end
    
    always @(negedge clk) begin     // œ¬Ωµ—ÿ∂¡
//    always @(*) begin     // ◊È∫œ¬ﬂº≠∂¡
        rD1 = (rR1 == 5'b0) ? 31'b0 : reg_array[rR1];
        rD2 = (rR2 == 5'b0) ? 31'b0 : reg_array[rR2];
    end 
    
endmodule

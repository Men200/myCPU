`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/03 19:04:55
// Design Name: 
// Module Name: PC
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


module PC(
    input                   clk,
    input                   rst,
    input                   stop,
    input       [31:0]      from_alu,    // 跳转地址
    input       [31:0]      pc4,         // pc+4
    input                   pcSel,
    output reg  [31:0]      current_pc
    );
    
    reg[31:0]   next_pc;
    
    always @(*)begin
        case(pcSel)
            0:  next_pc = from_alu;
            1:  next_pc = pc4;
        endcase
    end
    
    reg rst_p;
    always @ (posedge clk) begin
        rst_p <= rst;
    end
    
    always @(posedge clk) begin
        if(rst_p) begin
            current_pc      <=  0;          // 延迟一个时间周期，复位信号有效的时候保持为0
        end else if(stop) begin
            current_pc     <=  current_pc;
        end else begin
            current_pc      <= next_pc;
        end      
    end
endmodule

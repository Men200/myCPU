`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/11 11:30:14
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    input   wire            clk,
    input   wire            rst,
    input   wire            EX_useful,
    input   wire    [31:0]  EX_pc,
    input   wire    [31:0]  EX_from_alu,
    input   wire    [ 4:0]  EX_wR,
    input   wire    [31:0]  EX_data2,
    input   wire    [ 6:0]  EX_opcode,
    input   wire            EX_regWEn,
    input   wire            EX_memRW,
    input   wire    [ 1:0]  EX_wbSel,
    
    output  reg             MEM_useful,
    output  reg     [31:0]  MEM_pc,
    output  reg     [31:0]  MEM_from_alu,
    output  reg     [ 4:0]  MEM_wR,
    output  reg     [31:0]  MEM_data2,
    output  reg     [ 6:0]  MEM_opcode,
    output  reg             MEM_regWEn,
    output  reg             MEM_memRW,
    output  reg     [ 1:0]  MEM_wbSel
    );
    
    always @(posedge clk) begin
        if(rst) begin
            MEM_useful      <=  'b0;
            MEM_pc          <=  32'b0;
            MEM_data2       <=  32'b0;
            MEM_opcode      <=  7'b0;
            MEM_from_alu    <=  'd4;
            MEM_wR          <=  5'b0;
            MEM_regWEn      <=  0;
            MEM_memRW       <=  0;
            MEM_wbSel       <=  `FROM_ALU; 
        end else begin
            MEM_useful      <=  EX_useful;
            MEM_pc          <=  EX_pc;
            MEM_data2       <=  EX_data2;
            MEM_opcode      <=  EX_opcode;
            MEM_from_alu    <=  EX_from_alu;
            MEM_wR          <=  EX_wR;
            MEM_regWEn      <=  EX_regWEn;
            MEM_memRW       <=  EX_memRW;  // 无效指令不准写内存 ???S
            MEM_wbSel       <=  EX_wbSel;
        end
    end
    
endmodule
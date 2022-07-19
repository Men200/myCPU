`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/11 11:55:54
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    input   wire            clk,
    input   wire            rst,
    input   wire            MEM_useful,
    input   wire    [31:0]  MEM_pc,
    input   wire    [31:0]  MEM_from_alu,
    input   wire    [31:0]  MEM_from_dm,
    input   wire    [ 4:0]  MEM_wR,
    input   wire            MEM_regWEn,
    input   wire    [ 1:0]  MEM_wbSel,
    
    output  reg             WB_useful,
    output  reg     [31:0]  WB_pc,
    output  reg     [31:0]  WB_from_alu,
    output  reg     [31:0]  WB_from_dm,
    output  reg     [ 4:0]  WB_wR,
    output  reg             WB_regWEn,
    output  reg     [ 1:0]  WB_wbSel
    );
    
    always @(posedge clk) begin
        if(rst) begin
            WB_useful       <=   'b0;
            WB_pc           <=  32'b0;
            WB_from_alu     <=  32'b0;
            WB_from_dm      <=  32'b0;
            WB_wR           <=  5'b0;
            WB_regWEn       <=  0;       // ²»Ð´¼Ä´æÆ÷¶Ñ
            WB_wbSel        <=  `FROM_ALU; 
        end else begin
            WB_useful       <=  MEM_useful;
            WB_pc           <=  MEM_pc;
            WB_from_alu     <=  MEM_from_alu;
            WB_from_dm      <=  MEM_from_dm;
            WB_wR           <=  MEM_wR;
            WB_regWEn       <=  MEM_regWEn;    // ÎÞÐ§Ö¸Áî²»×¼Ð´¼Ä´æÆ÷¶Ñ
            WB_wbSel        <=  MEM_wbSel;
        end
    end
    
endmodule

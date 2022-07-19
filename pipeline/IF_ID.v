`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/10 23:05:26
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input   wire            clk,
    input   wire            rst,
    input   wire            stop,
    input   wire            flush,
    input   wire    [31:0]  IF_pc,
    input   wire    [ 4:0]  IF_rR1,
    input   wire    [ 4:0]  IF_rR2,
    input   wire    [ 4:0]  IF_wR,
    input   wire    [24:0]  IF_imm,
    input   wire    [ 6:0]  IF_opcode,
    input   wire            IF_regWEn,
    input   wire    [ 2:0]  IF_immSel,
    input   wire    [ 2:0]  IF_brOp,
    input   wire            IF_aSel,
    input   wire            IF_bSel,
    input   wire    [ 3:0]  IF_aluSel,
    input   wire            IF_memRW,
    input   wire    [ 1:0]  IF_wbSel,
    input   wire            IF_rr1,
    input   wire            IF_rr2,    
    // 输出所需数据
    output  reg             ID_useful,
    output  reg     [31:0]  ID_pc,
    output  reg     [ 4:0]  ID_rR1,
    output  reg     [ 4:0]  ID_rR2,
    output  reg     [ 4:0]  ID_wR,
    output  reg     [24:0]  ID_imm,
    // 输出所得控制信号
    output  reg     [ 6:0]  ID_opcode,
    output  reg             ID_regWEn,
    output  reg [2:0]       ID_immSel,
    output  reg [2:0]       ID_brOp,
    output  reg             ID_aSel,
    output  reg             ID_bSel,
    output  reg [3:0]       ID_aluSel,
    output  reg             ID_memRW,
    output  reg [1:0]       ID_wbSel,
    output  reg             ID_rr1,         
    output  reg             ID_rr2         
    );
    
//    always @(negedge clk) begin
    always @(posedge clk) begin
        if(rst) begin
        // 复位和清空流水级（flush为0)一个效果
            ID_useful   <=  'b0;
            ID_pc       <=  32'b0;
            ID_rR1      <=  5'b0;
            ID_rR2      <=  5'b0;
            ID_wR       <=  5'b0;
            ID_imm      <=  25'b0;
            ID_opcode   <=  7'b0;
            ID_regWEn   <=  1;
            ID_immSel   <=  'b111;
            ID_brOp     <=  'b111;
            ID_aSel     <=  1;
            ID_bSel     <=  1;
            ID_aluSel   <=  `NOOP;
            ID_memRW    <=  0;
            ID_wbSel    <=  `FROM_ALU;
            ID_rr1      <=  0;      // 寄存器1默认的不是读
            ID_rr2      <=  0;
        end else if(!flush) begin
        // 复位和清空流水级（flush为0)一个效果
            ID_useful   <=  'b0;
            ID_pc       <=  32'b0;
            ID_rR1      <=  5'b0;
            ID_rR2      <=  5'b0;
            ID_wR       <=  5'b0;
            ID_imm      <=  25'b0;
            ID_opcode   <=  7'b0;
            ID_regWEn   <=  1;
            ID_immSel   <=  'b111;
            ID_brOp     <=  'b111;
            ID_aSel     <=  1;
            ID_bSel     <=  1;
            ID_aluSel   <=  `NOOP;
            ID_memRW    <=  0;
            ID_wbSel    <=  `FROM_ALU;
            ID_rr1      <=  0;      // 寄存器1默认的不是读
            ID_rr2      <=  0;
        end else if(stop) begin    // 载入使用，停顿后续指令
            ID_useful   <=  ID_useful;
            ID_pc       <=  ID_pc;
            ID_rR1      <=  ID_rR1;
            ID_rR2      <=  ID_rR2;
            ID_wR       <=  ID_wR;
            ID_imm      <=  ID_imm;
            ID_opcode   <=  ID_opcode;
            ID_regWEn   <=  ID_regWEn;
            ID_immSel   <=  ID_immSel;
            ID_brOp     <=  ID_brOp;
            ID_aSel     <=  ID_aSel;
            ID_bSel     <=  ID_bSel;
            ID_aluSel   <=  ID_aluSel;
            ID_memRW    <=  ID_memRW; 
            ID_wbSel    <=  ID_wbSel;
            ID_rr1      <=  ID_rr1;
            ID_rr2      <=  ID_rr2;  
        end else begin
            ID_useful   <=  'b1;
            ID_pc       <=  IF_pc;
            ID_rR1      <=  IF_rR1;
            ID_rR2      <=  IF_rR2;
            ID_wR       <=  IF_wR;
            ID_imm      <=  IF_imm;
            ID_opcode   <=  IF_opcode;
            ID_regWEn   <=  IF_regWEn;
            ID_immSel   <=  IF_immSel;
            ID_brOp     <=  IF_brOp;
            ID_aSel     <=  IF_aSel;
            ID_bSel     <=  IF_bSel;
            ID_aluSel   <=  IF_aluSel;
            ID_memRW    <=  IF_memRW; 
            ID_wbSel    <=  IF_wbSel;
            ID_rr1      <=  IF_rr1;
            ID_rr2      <=  IF_rr2;
        end
    end
    
endmodule
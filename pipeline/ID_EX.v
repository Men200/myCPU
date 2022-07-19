`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/11 09:49:34
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    input   wire            clk,
    input   wire            rst,
    input   wire            stop,
    input   wire            flush,
    input   wire            ID_useful,
    input   wire    [31:0]  ID_pc,
    input   wire    [ 4:0]  ID_wR,
    input   wire    [31:0]  ID_imm_sex,
    input   wire    [31:0]  ID_data1,
    input   wire    [31:0]  ID_data2,
    input   wire    [ 6:0]  ID_opcode,
    input   wire            ID_regWEn,
    input   wire    [ 2:0]  ID_brOp,
    input   wire            ID_aSel,
    input   wire            ID_bSel,
    input   wire    [ 3:0]  ID_aluSel,
    input   wire            ID_memRW,
    input   wire    [ 1:0]  ID_wbSel,
    
    output  reg             EX_useful,
    output  reg     [31:0]  EX_pc,
    output  reg     [ 4:0]  EX_wR,
    output  reg     [31:0]  EX_imm_sex,
    output  reg     [31:0]  EX_data1,
    output  reg     [31:0]  EX_data2,
    output  reg     [ 6:0]  EX_opcode,
    output  reg             EX_regWEn,
    output  reg     [ 2:0]  EX_brOp,
    output  reg             EX_aSel,
    output  reg             EX_bSel,
    output  reg     [ 3:0]  EX_aluSel,
    output  reg             EX_memRW,
    output  reg     [ 1:0]  EX_wbSel
    );
    
    always @(posedge clk) begin
//    always @(negedge clk) begin
        if(rst) begin
        // 复位和清空流水级（flush为0)一个效果
            EX_useful   <=  'b0;
            EX_pc       <=  32'b0;
            EX_data1    <=  32'b0;
            EX_data2    <=  32'b0;
            EX_imm_sex  <=  32'b0;
            EX_wR       <=  5'b0;
            EX_opcode   <=  7'b0;
            EX_regWEn   <=  0;
            EX_brOp     <=  'b111;
            EX_aSel     <=  1;
            EX_bSel     <=  1;
            EX_aluSel   <=  `NOOP;
            EX_memRW    <=  0;
            EX_wbSel    <=  `FROM_ALU; 
        end else if(!flush) begin
        // 复位和清空流水级（flush为0)一个效果
            EX_useful   <=  'b0;
            EX_pc       <=  32'b0;
            EX_data1    <=  32'b0;
            EX_data2    <=  32'b0;
            EX_imm_sex  <=  32'b0;
            EX_wR       <=  5'b0;
            EX_opcode   <=  7'b0;
            EX_regWEn   <=  0;
            EX_brOp     <=  'b111;
            EX_aSel     <=  1;
            EX_bSel     <=  1;
            EX_aluSel   <=  `NOOP;
            EX_memRW    <=  0;
            EX_wbSel    <=  `FROM_ALU; 
        end else if(stop) begin
            // 载入-使用型数据冒险停顿1个时钟周期
            EX_useful   <=  'b0;
            EX_pc       <=  ID_pc;
            EX_data1    <=  ID_data1;
            EX_data2    <=  ID_data2;
            EX_imm_sex  <=  ID_imm_sex;
            EX_wR       <=  ID_wR;
            EX_opcode   <=  ID_opcode;
            EX_regWEn   <=  0;          // 不写寄存器堆
            EX_brOp     <=  ID_brOp;
            EX_aSel     <=  ID_aSel;
            EX_bSel     <=  ID_bSel;
            EX_aluSel   <=  ID_aluSel;
            EX_memRW    <=  0;          // 不写内存 
            EX_wbSel    <=  ID_wbSel;
        end else begin
            EX_useful   <=  ID_useful;
            EX_pc       <=  ID_pc;
            EX_data1    <=  ID_data1;
            EX_data2    <=  ID_data2;
            EX_imm_sex  <=  ID_imm_sex;
            EX_wR       <=  ID_wR;
            EX_opcode   <=  ID_opcode;
            EX_regWEn   <=  ID_regWEn;
            EX_brOp     <=  ID_brOp;
            EX_aSel     <=  ID_aSel;
            EX_bSel     <=  ID_bSel;
            EX_aluSel   <=  ID_aluSel;
            EX_memRW    <=  ID_memRW; 
            EX_wbSel    <=  ID_wbSel;
        end
    end
    
endmodule

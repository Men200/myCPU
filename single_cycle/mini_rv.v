`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/04 15:23:58
// Design Name: 
// Module Name: mini_rv
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


module mini_rv(
    input clk,
    input rst_n,
    input   [31:0]  instruction,    // 来自IM的指令
    input   [31:0]  from_dm,        // 来自DM的数据
    output          memRW,          // 传给DM的使能 
    output  [31:0]  from_alu,       // 传给DM的地址
    output  [31:0]  data2,          // 传给DM的数据          
    output  [31:0]  pc,             // 传给IM的地址  
    output  [31:0]  dataW,          // 用作测试的寄存器堆写数据
    output          regWEn          // 用作测试的寄存器堆写使能信号
    );
    
    // 调整为1为复位信号有效
    wire        rst;
    assign rst = !rst_n;
    
    wire [31:0] pc4;
    assign pc4 = pc + 4;
    
    // 控制信号
    wire        pcSel;
    wire [2:0]  immSel;
    wire [2:0]  brOp;
    wire        brAns;
    wire        aSel;
    wire        bSel;
    wire [3:0]  aluSel; // 8几种运算 + NOOP
    wire [1:0]  wbSel;
    
    wire [31:0] data1;
    wire [31:0] sext_imm;
    
    control u_control(
        .funct3     (instruction[14:12]),
        .funct7     (instruction[31:25]),
        .opcode     (instruction[6:0]),
        .brAns      (brAns),    // B是否跳转结果
        .pcSel      (pcSel),    // 1pcsel
        .regWEn     (regWEn),   // 2regsel
        .immSel     (immSel),   // 3immsel
        .brOp       (brOp),
        .aSel       (aSel),
        .bSel       (bSel),
        .aluSel     (aluSel),
        .memRW      (memRW),
        .wbSel      (wbSel)
    );
    
    PC u1(
        .clk        (clk),
        .rst        (rst),
        .from_alu   (from_alu),
        .pc4        (pc4),
        .pcSel      (pcSel),
        .current_pc (pc)
    );

    regfile u2(
        .clk        (clk),
        .rst        (rst),
        .rR1        (instruction[19:15]),
        .rR2        (instruction[24:20]),
        .wE         (regWEn),
        .wR         (instruction[11:7]),
        .wD         (dataW),
        .rD1        (data1),
        .rD2        (data2)
    );
    
    ImmSel u3(
        .sext_op    (immSel),
        .ins        (instruction[31:7]),
        .sext_imm   (sext_imm)
    );
    
    BranchComp u4(
        .data1      (data1),
        .data2      (data2),
        .brOp       (brOp),
        .brAns      (brAns)
    );
    
    ALU u5(
        .pc         (pc),
        .data1      (data1),
        .aSel       (aSel),
        .data2      (data2),
        .sext_imm   (sext_imm),
        .bSel       (bSel),
        .aluSel     (aluSel),
        .result     (from_alu)
    );
    
    MUX_WB u6(
        .pc4        (pc4),
        .from_alu   (from_alu),
        .from_dm    (from_dm),
        .wbSel      (wbSel),
        .dataW      (dataW)
    );
endmodule

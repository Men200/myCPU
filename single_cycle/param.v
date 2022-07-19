`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/29 16:58:55
// Design Name: 
// Module Name: param
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
// file: param.v
`ifndef CPU_PARAM
`define CPU_PARAM

    // OPCODE
    `define R_TYPE  'b0110011
    `define I_TYPE  'b0010011   // exclude inst-lw/jalr
    `define LW_TYPE 'b0000011   // inst-lw
    `define JR_TYPE 'b1100111   // inst-jalr
    `define S_TYPE  'b0100011
    `define B_TYPE  'b1100011
    `define U_TYPE  'b0110111
    `define J_TYPE  'b1101111

    // SEXT_OP
    `define I_SEXT  'b000
    `define S_SEXT  'b001
    `define B_SEXT  'b010
    `define U_SEXT  'b011
    `define J_SEXT  'b100
    
    // ALU_OP
    `define ADD     'b0000
    `define SUB     'b0001
    `define AND     'b0010
    `define OR      'b0011
    `define XOR     'b0100
    `define SLL     'b0101
    `define SRL     'b0110
    `define SRA     'b0111
    `define LUI     'b1000
    `define NOOP    'b1111  // ÎÞÄÔ¸ø³ö
    
    // FUNCT3
    `define BEQ     'b000
    `define BNE     'b001
    `define BLT     'b100
    `define BGE     'b101
    
    // WD_SEL
    `define PC4         'b00
    `define FROM_ALU    'b01
    `define FROM_DM     'b10

//    `define STATE_IDLE 'b0001
//    `define STATE_WRIT 'b0010
//    `define STATE_WORK 'b0100
//    `define STATE_RETU 'b1000

`endif
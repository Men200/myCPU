`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/29 15:04:43
// Design Name: 
// Module Name: ALU
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


module ALU(
    input       [31:0]  pc,
    input       [31:0]  data1,
    input               aSel,
    input       [31:0]  data2,
    input       [31:0]  sext_imm,
    input               bSel,
    input       [ 3:0]  aluSel,
    output  reg [31:0]  result
    );
    
    reg [31:0]  a;
    reg [31:0]  b;
    
    always @(*) begin
        a = (aSel == 0) ? pc        : data1;
        b = (bSel == 1) ? sext_imm  : data2;
    end
    
    always @(*) begin
        case(aluSel)
            `ADD:
                result = a + b;
            `SUB:
                result = a - b;
            `AND:
                result = a & b;
            `OR:
                result = a | b;
            `XOR:
                result = a ^ b;
            `SLL:
                result = a << b[4:0];
            `SRL:
                result = a >> b[4:0];
            `SRA:
                result = ($signed(a)) >>> b[4:0];
            `LUI:
                result = b;
            default:
                result = 0;
        endcase
    end
endmodule

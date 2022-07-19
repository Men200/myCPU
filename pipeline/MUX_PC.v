`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/29 15:05:38
// Design Name: 
// Module Name: MUX_PC
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


module MUX_PC(
    input [31:0]from_alu,    // Ìø×ªµØÖ·
    input [31:0]pc4,        // pc+4
    input pcSel,
    output reg[31:0]next_pc

    );
    
    always @(*)begin
        case(pcSel)
            0:  next_pc = from_alu;
            1:  next_pc = pc4;
        endcase
    end
endmodule

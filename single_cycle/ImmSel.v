`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/29 15:03:30
// Design Name: 
// Module Name: ImmSel
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


module ImmSel(
    input       [ 2:0] sext_op,
    input       [24:0] ins,         // 32-7=25
    output reg  [31:0] sext_imm
    );
    always @(*) begin
        case (sext_op)
            `I_SEXT:
                sext_imm = {{20{ins[24]}}, ins[24:13]};
            `S_SEXT:
                sext_imm = {{20{ins[24]}}, ins[24:18], ins[4:0]};
            `B_SEXT:
                sext_imm = {{19{ins[24]}}, ins[24], ins[0], ins[23:18], ins[4:1], 1'b0};
            `U_SEXT:
                sext_imm = {ins[24:5], 12'b0};
            `J_SEXT:
                sext_imm = {{19{ins[24]}}, ins[24], ins[12:5], ins[13], ins[23:14], 1'b0};
            default:
                sext_imm = 0;
        endcase
    end
endmodule

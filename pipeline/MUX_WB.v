`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/29 15:06:49
// Design Name: 
// Module Name: MUX_WB
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


module MUX_WB(
    input       [31:0]  pc,
    input       [31:0]  from_alu,
    input       [31:0]  from_dm,
    input       [ 1:0]  wbSel,
    output  reg [31:0]  dataW
    );
    
    always @ (*) begin
        case(wbSel)
            `PC4:
                dataW = pc + 'd4;
            `FROM_ALU:
                dataW = from_alu;
            `FROM_DM:
                dataW = from_dm;
            default:
                dataW = 0;
        endcase
    end
endmodule
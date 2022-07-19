`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/29 15:04:09
// Design Name: 
// Module Name: BranchComp
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


module BranchComp(
    input   wire    [ 6:0]  opcode,
    input   wire    [31:0]  data1,
    input   wire    [31:0]  data2,
    input   wire    [ 2:0]  brOp,
    output  reg             pcSel
    );
    
    reg brAns;
    
    always @ (*)begin
        case(brOp)
            `BEQ:   
                brAns = (data1 == data2) ? 0 : 1;
            `BNE:
                brAns = (data1 == data2) ? 1 : 0;
            `BLT:
                if(data1[31] == data2[31])  // 同号，小于则跳转 0
                    brAns = (data1 <  data2) ? 0 : 1;
                else                    // 异号
                    brAns = (data1 >  data2) ? 0 : 1;
            `BGE:
                if(data1[31] == data2[31])  // 同号，小于则不跳转 1
                    brAns = (data1 <  data2) ? 1 : 0;
                else                    // 异号
                    brAns = (data1 >  data2) ? 1 : 0;
            default:
                brAns = 1;              // 默认不跳转
        endcase                
    end
    
     always @ (*) begin
        case (opcode)
            `R_TYPE, `I_TYPE, `LW_TYPE, `S_TYPE, `U_TYPE:
                pcSel = 1;
            `B_TYPE:
                pcSel = brAns;
            `JR_TYPE, `J_TYPE:
                pcSel = 0;
            default:
                pcSel = 1;
        endcase
    end
    
endmodule

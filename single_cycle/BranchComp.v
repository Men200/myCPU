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
    input [31:0]    data1,
    input [31:0]    data2,
    input [ 2:0]    brOp,
    output reg      brAns
    );
    
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
                brAns = 0;
        endcase                
    end
    
endmodule

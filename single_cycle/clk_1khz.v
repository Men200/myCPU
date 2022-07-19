`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/05 22:37:00
// Design Name: 
// Module Name: clk_1khz
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


module clk_1khz(
    input   wire    clk_i, 
    input   wire    rst_i,   
    output  reg     clk_1khz_o
    );
    
    // �����߼���ip����10mhz��������25mhz
    // �������ˢ��Ƶ��2msˢ��һ�Σ��������۾Ϳ�������˸����
    
    reg [26:0] cnt = 'b1;      
    //Ԥ��ʵ�֣�25MHz -> 1khz  
    always @(posedge clk_i, posedge rst_i) begin
        if(rst_i) begin
            cnt         <=  27'd0;
            clk_1khz_o  <=  'd0;
        end else begin
            if(cnt == 'd25000) begin
                clk_1khz_o  <=  ~clk_1khz_o;
                cnt         <=  'd0;
            end else begin
                cnt         <=  cnt + 'd1;
            end
        end    
    end
endmodule



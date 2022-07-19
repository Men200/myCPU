`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/07 15:19:32
// Design Name: 
// Module Name: shumaguan
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


module shumaguan(
    input   wire        clk_1khz,
    input   wire        rst_i,
    input   wire[31:0]  data,
    // 共同控制一个数字
    output wire led_ca_o,
    output wire led_cb_o,
    output wire led_cc_o,
    output wire led_cd_o,
    output wire led_ce_o,
    output wire led_cf_o,
    output wire led_cg_o,
    output wire led_dp_o,
    output reg[7:0]    led_en
    );
    
    // 16个显示的数字
    reg [3:0]   num;
    // 数码管显示的数字修改
    always @(posedge clk_1khz, posedge rst_i) begin
        if(rst_i)   num <=  4'b0;
        else begin
            case(led_en)
                8'b0111_1111:   num <=  data[ 3: 0];
                8'b1111_1110:   num <=  data[ 7: 4];
                8'b1111_1101:   num <=  data[11: 8];
                8'b1111_1011:   num <=  data[15:12];
                8'b1111_0111:   num <=  data[19:16];
                8'b1110_1111:   num <=  data[23:20];
                8'b1101_1111:   num <=  data[27:24];
                8'b1011_1111:   num <=  data[31:28];
                default:    num <=  num;
            endcase
        end
    end
    
    // 调整数码管使能（rst_i按下复位高电平）
    always @(posedge clk_1khz, posedge rst_i) begin
        if(rst_i)                           led_en  <=  8'b0111_1111;   // 预备备
        else                                led_en  <=  {led_en[6:0], led_en[7]};
    end
    
    // 调用数码管显示模块
    display u_display(
        .num    (num),
        .led_ca (led_ca_o),
        .led_cb (led_cb_o),
        .led_cc (led_cc_o),
        .led_cd (led_cd_o),
        .led_ce (led_ce_o),
        .led_cf (led_cf_o),
        .led_cg (led_cg_o),
        .led_dp (led_dp_o)
    );
    
endmodule

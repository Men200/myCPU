`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/29 14:56:01
// Design Name: 
// Module Name: top
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


module top(
    input  wire clk,    // 时钟信号(100Mhz),Y18，该频率对于单周期cpu而言太快
    input  wire rst_i,
    
    // 拨码开关
    input  wire [23:0]  switch,
	
    // 每个数码管一个使能信号，0为启动
    output wire [7:0] led_en,
    // 共同控制一个数字
    output wire led_ca_o,
    output wire led_cb_o,
    output wire led_cc_o,
    output wire led_cd_o,
    output wire led_ce_o,
    output wire led_cf_o,
    output wire led_cg_o,
    output wire led_dp_o,
    
    // led灯
    output reg  [23:0] led
);
    
    wire    clk_i;
    wire    locked;

    cpuclk uclk(
        .clk_in1    (clk),
        .clk_out1   (clk_i),
        .locked     (locked)
    );
    
    // 板上的复位信号默认输出低电平，按下时输出高电平，故rst_i是高电平复位
    wire rst_n = !rst_i;
    wire [31:0] instruction;
    wire [31:0] from_dm;
    wire [31:0] from_alu;
    wire [31:0] pc;
    wire [31:0] data2;
    wire [31:0] dataW;
    wire        regWEn;
    wire        memRW;
    reg [31:0]  data_shumaguan;
    reg [31:0]  rd;
    
    // 设计总线桥和I/O接口（必做外设接口：数码管、拨码开关、按键开关、LED）
    // 调整数码管使能（rst_i按下复位高电平）
    always @(posedge clk_i) begin
        if(rst_i) begin
            data_shumaguan  <=   0;
            led             <=   24'b0;
        end else if(memRW == 1 && from_alu == 'hffff_f000) begin                // 写数码管
            data_shumaguan  <=  data2;
        end else if(memRW == 1 && from_alu == 'hffff_f060) begin                // 写led
            led             <=   data2[23:0];
        end else begin
            data_shumaguan  <=  data_shumaguan;
            led             <=  led;
        end
    end
    
    always @(*) begin
        if(from_alu == 'hffff_f070) rd  =   {8'b0, switch[23:0]};               // 读拨码开关
        else                        rd  =   from_dm;
    end
    
    // 频率为1khz的时钟
    wire    clk_1khz;
    
    clk_1khz u_clk_1khz(
//    clk_1hz u_clk_1hz(
        .clk_i      (clk),
        .rst_i      (rst_i),
        .clk_1khz_o (clk_1khz)
    );
    
    shumaguan u_shumaguan(
        .clk_1khz   (clk_1khz),
        .rst_i      (rst_i),
        .data       (data_shumaguan),
        .led_ca_o   (led_ca_o),
        .led_cb_o   (led_cb_o),
        .led_cc_o   (led_cc_o),
        .led_cd_o   (led_cd_o),
        .led_ce_o   (led_ce_o),
        .led_cf_o   (led_cf_o),
        .led_cg_o   (led_cg_o),
        .led_dp_o   (led_dp_o),
        .led_en     (led_en)
    );

    mini_rv mini_rv(
        .clk            (clk_i),        // i时钟
        .rst_n          (rst_n),        // i复位
        .instruction    (instruction),  // i指令
        .from_dm        (rd),           // i数据寄存器数据
        .memRW          (memRW),        // o数据寄存器读写使能
        .from_alu       (from_alu),     // o数据寄存器地址
        .data2          (data2),        // o数据寄存器数据
        .pc             (pc),           // o指令寄存器pc
        .dataW          (dataW),        // 测试寄存器堆写数据
        .regWEn         (regWEn)        // 测试寄存器堆写使能
    );
    
    // 64KB IROM（原版）
    prgrom UO_irom (
        .a      (pc[15:2]),         // input wire [13:0] a
        .spo    (instruction)       // output wire [31:0] spo
    );
    
    // 统一编制，高12位用作I/O地址，低18位用作DRAM地址空间
    // 需对原DRAM的访存地址进行修改
    wire [31:0] waddr_tmp = from_alu - 16'h4000;
    
    // 64KB DRAM
    dram U_dram (
        .clk    (clk_i),            // input wire clk
        .a      (waddr_tmp[15:2]),  // input wire [13:0] from_alu 访存地址
        .spo    (from_dm),          // output wire [31:0] from_dm 读出数据
        .we     (memRW),            // input wire [0:0] memRW 读写内存信号
        .d      (data2)             // input wire [31:0] data2
    );
endmodule

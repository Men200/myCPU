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

/*
本项目用于流水线计算器下板：
下板信号中复位信号为高电平有效，im和dm均用.xci文件，数码管频率已降频，使用时钟ip核
 */

module top(
    input  wire clk,    // 时钟信号(100Mhz),Y18，流水线说要50hz
    input  wire rst,   // 上板和仿真
    
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
    
    wire [31:0] instruction;
    wire [31:0] from_dm;
    wire [31:0] from_alu;
    wire [31:0] pc;
    wire [31:0] data2;
    wire        memRW;
    reg [31:0]  data;
    reg [31:0]  rd;
    
    wire    clk_i;
    wire    locked;

    cpuclk uclk(
        .clk_in1    (clk),
        .clk_out1   (clk_i),
        .locked     (locked)
    );
    
    always @(posedge clk_i) begin
        if(rst) begin
            data    <=  0;
        end else if(memRW == 1 && from_alu == 'hffff_f000) begin               // 写数码管
            data    <=  data2;
        end  else   
            data    <=  data;   
    end
    
    
    always @(posedge clk_i) begin
        if(rst) begin
            led     <=  24'b0;
        end else if(memRW == 1 && from_alu == 'hffff_f060) begin            // 写led
            led     <=  data2[23:0];
        end else
            led     <=  led;
    end
    
    always @(*) begin
        if(from_alu == 'hffff_f070) rd  =  {8'b0, switch[23:0]};
        else                        rd  =  from_dm;
    end
    
    // 频率为1khz的时钟
    wire    clk_1khz;
    
    clk_1khz u_clk_1khz(
//    clk_1hz u_clk_1hz(
        .clk_i      (clk),
        .rst        (rst),
        .clk_1khz_o (clk_1khz)
    );
   
    shumaguan u_shumaguan(
        .clk_1khz       (clk_1khz),
        .rst            (rst),
        .data           (data),
        .led_ca_o       (led_ca_o),
        .led_cb_o       (led_cb_o),
        .led_cc_o       (led_cc_o),
        .led_cd_o       (led_cd_o),
        .led_ce_o       (led_ce_o),
        .led_cf_o       (led_cf_o),
        .led_cg_o       (led_cg_o),
        .led_dp_o       (led_dp_o),
        .led_en         (led_en)
    );

    mini_rv mini_rv(
        .clk            (clk_i),        // i时钟
        .rst            (rst),          // i复位
        .instruction    (instruction),  // i指令
        .from_dm_3      (rd),           // i数据寄存器数据
        .pc             (pc),           // o指令寄存器pc
        .memRW_3        (memRW),        // o数据寄存器读写使能
        .from_alu_3     (from_alu),     // o数据寄存器地址
        .data2_3        (data2)         // o数据寄存器数据
    );
    
    // 64KB IROM（原版）
    prgrom UO_irom (
        .a      (pc[15:2]),         // input wire [13:0] a
        .spo    (instruction)       // output wire [31:0] spo
    );
    
    // 统一编制，高12位用作I/O地址，低18位用作DRAM地址空间
    // 需对原DRAM的访存地址进行修改
    // 用于下板测试的汇编程序采用IROM和DRAM统一编址，因此需要对原DRAM的访存地址进行修改
    // 由于下板测试程序较大，导致导入.coe后重新综合工程耗时较长，因此课程指导书网站提供了已综合好的IROM和DRAM IP核，同学们可将其直接导入CPU工程中使用
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

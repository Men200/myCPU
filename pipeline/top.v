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
����Ŀ������ˮ�߼������°壺
�°��ź��и�λ�ź�Ϊ�ߵ�ƽ��Ч��im��dm����.xci�ļ��������Ƶ���ѽ�Ƶ��ʹ��ʱ��ip��
 */

module top(
    input  wire clk,    // ʱ���ź�(100Mhz),Y18����ˮ��˵Ҫ50hz
    input  wire rst,   // �ϰ�ͷ���
    
    // ���뿪��
    input  wire [23:0]  switch,
	
    // ÿ�������һ��ʹ���źţ�0Ϊ����
    output wire [7:0] led_en,
    // ��ͬ����һ������
    output wire led_ca_o,
    output wire led_cb_o,
    output wire led_cc_o,
    output wire led_cd_o,
    output wire led_ce_o,
    output wire led_cf_o,
    output wire led_cg_o,
    output wire led_dp_o,
    
    // led��
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
        end else if(memRW == 1 && from_alu == 'hffff_f000) begin               // д�����
            data    <=  data2;
        end  else   
            data    <=  data;   
    end
    
    
    always @(posedge clk_i) begin
        if(rst) begin
            led     <=  24'b0;
        end else if(memRW == 1 && from_alu == 'hffff_f060) begin            // дled
            led     <=  data2[23:0];
        end else
            led     <=  led;
    end
    
    always @(*) begin
        if(from_alu == 'hffff_f070) rd  =  {8'b0, switch[23:0]};
        else                        rd  =  from_dm;
    end
    
    // Ƶ��Ϊ1khz��ʱ��
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
        .clk            (clk_i),        // iʱ��
        .rst            (rst),          // i��λ
        .instruction    (instruction),  // iָ��
        .from_dm_3      (rd),           // i���ݼĴ�������
        .pc             (pc),           // oָ��Ĵ���pc
        .memRW_3        (memRW),        // o���ݼĴ�����дʹ��
        .from_alu_3     (from_alu),     // o���ݼĴ�����ַ
        .data2_3        (data2)         // o���ݼĴ�������
    );
    
    // 64KB IROM��ԭ�棩
    prgrom UO_irom (
        .a      (pc[15:2]),         // input wire [13:0] a
        .spo    (instruction)       // output wire [31:0] spo
    );
    
    // ͳһ���ƣ���12λ����I/O��ַ����18λ����DRAM��ַ�ռ�
    // ���ԭDRAM�ķô��ַ�����޸�
    // �����°���ԵĻ��������IROM��DRAMͳһ��ַ�������Ҫ��ԭDRAM�ķô��ַ�����޸�
    // �����°���Գ���ϴ󣬵��µ���.coe�������ۺϹ��̺�ʱ�ϳ�����˿γ�ָ������վ�ṩ�����ۺϺõ�IROM��DRAM IP�ˣ�ͬѧ�ǿɽ���ֱ�ӵ���CPU������ʹ��
    wire [31:0] waddr_tmp = from_alu - 16'h4000;
    
    // 64KB DRAM
    dram U_dram (
        .clk    (clk_i),            // input wire clk
        .a      (waddr_tmp[15:2]),  // input wire [13:0] from_alu �ô��ַ
        .spo    (from_dm),          // output wire [31:0] from_dm ��������
        .we     (memRW),            // input wire [0:0] memRW ��д�ڴ��ź�
        .d      (data2)             // input wire [31:0] data2
);
endmodule

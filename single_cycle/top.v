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
    input  wire clk,    // ʱ���ź�(100Mhz),Y18����Ƶ�ʶ��ڵ�����cpu����̫��
    input  wire rst_i,
    
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
    
    wire    clk_i;
    wire    locked;

    cpuclk uclk(
        .clk_in1    (clk),
        .clk_out1   (clk_i),
        .locked     (locked)
    );
    
    // ���ϵĸ�λ�ź�Ĭ������͵�ƽ������ʱ����ߵ�ƽ����rst_i�Ǹߵ�ƽ��λ
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
    
    // ��������ź�I/O�ӿڣ���������ӿڣ�����ܡ����뿪�ء��������ء�LED��
    // ���������ʹ�ܣ�rst_i���¸�λ�ߵ�ƽ��
    always @(posedge clk_i) begin
        if(rst_i) begin
            data_shumaguan  <=   0;
            led             <=   24'b0;
        end else if(memRW == 1 && from_alu == 'hffff_f000) begin                // д�����
            data_shumaguan  <=  data2;
        end else if(memRW == 1 && from_alu == 'hffff_f060) begin                // дled
            led             <=   data2[23:0];
        end else begin
            data_shumaguan  <=  data_shumaguan;
            led             <=  led;
        end
    end
    
    always @(*) begin
        if(from_alu == 'hffff_f070) rd  =   {8'b0, switch[23:0]};               // �����뿪��
        else                        rd  =   from_dm;
    end
    
    // Ƶ��Ϊ1khz��ʱ��
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
        .clk            (clk_i),        // iʱ��
        .rst_n          (rst_n),        // i��λ
        .instruction    (instruction),  // iָ��
        .from_dm        (rd),           // i���ݼĴ�������
        .memRW          (memRW),        // o���ݼĴ�����дʹ��
        .from_alu       (from_alu),     // o���ݼĴ�����ַ
        .data2          (data2),        // o���ݼĴ�������
        .pc             (pc),           // oָ��Ĵ���pc
        .dataW          (dataW),        // ���ԼĴ�����д����
        .regWEn         (regWEn)        // ���ԼĴ�����дʹ��
    );
    
    // 64KB IROM��ԭ�棩
    prgrom UO_irom (
        .a      (pc[15:2]),         // input wire [13:0] a
        .spo    (instruction)       // output wire [31:0] spo
    );
    
    // ͳһ���ƣ���12λ����I/O��ַ����18λ����DRAM��ַ�ռ�
    // ���ԭDRAM�ķô��ַ�����޸�
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

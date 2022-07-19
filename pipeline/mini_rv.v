`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/07/04 15:23:58
// Design Name: 
// Module Name: mini_rv
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


module mini_rv(
    input clk,
    input rst,
    input   [31:0]  instruction,    // 来自IM的指令
    input   [31:0]  from_dm_3,      // 来自DM的数据
    output  [31:0]  pc,             // 传给IM的地址  
    output          memRW_3,        // 传给DM的使能 
    output  [31:0]  from_alu_3,     // 传给DM的地址
    output  [31:0]  data2_3         // 传给DM的数据  
    );
    
    wire    [31:0]  pc4;
    assign  pc4 =   pc + 4;
    wire    [31:0]  pc_1;    // IF/ID存
    wire    [31:0]  pc_2;    // ID/EX存
    wire    [31:0]  pc_3;    // EX/MEM存
    wire    [31:0]  pc_4;
    wire    [ 4:0]  reg1;
    wire    [ 4:0]  reg2;
    reg     [31:0]  data1_1;
    reg     [31:0]  data2_1;
    wire    [31:0]  data1_2;
    wire    [31:0]  data2_2;
    wire    [ 4:0]  wreg_1;
    wire    [ 4:0]  wreg_2;
    wire    [ 4:0]  wreg_3;
    wire    [ 4:0]  wreg_4;
    wire    [24:0]  imm;
    wire    [31:0]  sext_imm_1;
    wire    [31:0]  sext_imm_2;
    
    wire    [ 6:0]  opcode_1;
    wire    [ 6:0]  opcode_2;
    wire    [ 6:0]  opcode_3;
    wire            pcSel_2;
    wire            regWEn;
    wire            regWEn_1;
    wire            regWEn_2;
    wire            regWEn_3;
    wire            regWEn_4;
    wire    [ 2:0]  brOp;
    wire    [ 2:0]  brOp_1;
    wire    [ 2:0]  brOp_2;
    wire            aSel;
    wire            aSel_1;
    wire            aSel_2;
    wire            bSel;
    wire            bSel_1;
    wire            bSel_2;
    wire    [ 3:0]  aluSel;
    wire    [ 3:0]  aluSel_1;
    wire    [ 3:0]  aluSel_2;
    wire            memRW;
    wire            memRW_1;
    wire            memRW_2;
    wire    [ 1:0]  wbSel_1;
    wire    [ 1:0]  wbSel;
    wire    [ 1:0]  wbSel_2;
    wire    [ 1:0]  wbSel_3;
    wire    [ 1:0]  wbSel_4;
    wire    [ 2:0]  immSel;     
    wire    [ 2:0]  immSel_1;     
    
    wire    [31:0]  from_alu_2;
    wire    [31:0]  from_alu_4;
    wire    [31:0]  from_dm_4;
    wire    [31:0]  dataW_4;
    
    wire            rr1;    // 读寄存器1
    wire            rr2;    // 读寄存器2
    wire            rr1_1;
    wire            rr2_1;
    wire            useful_1;
    wire            useful_2;
    wire            useful_3;
    wire            useful_4;

    // 停顿1个时钟周期
    reg pre11;
    reg pre21;
    wire    stop1   =   (opcode_2 == `LW_TYPE) & (wreg_2 == reg1) & rr1_1 & (!pre11);
    wire    stop2   =   (opcode_2 == `LW_TYPE) & (wreg_2 == reg2) & rr2_1 & (!pre21);
    wire    stop    =   stop1   | stop2;
    always @(posedge clk) begin
        if(rst)         pre11 <=  0;
        else            pre11 <= stop1;
    end
    wire  pre1    =   pre11 | ((opcode_3 == `LW_TYPE) & (wreg_3 == reg1) & rr1_1);
    always @(posedge clk) begin
        if(rst)         pre21 <=  0;
        else            pre21   <=  stop2;
    end
    wire  pre2    =   pre21 | ((opcode_3 == `LW_TYPE) & (wreg_3 == reg2) & rr2_1);
    
    // RAW情形a   xx1
    // jal x0, 4
    // addi x8, x0, 37
    wire rs1_id_ex_hazard = (wreg_2 == reg1) & regWEn_2 & rr1_1 & (wreg_2 != 0) & useful_2; 
    wire rs2_id_ex_hazard = (wreg_2 == reg2) & regWEn_2 & rr2_1 & (wreg_2 != 0) & useful_2; 
    // RAW情形b   x10
    wire rs1_id_mem_hazard = (wreg_3 == reg1) & regWEn_3 & rr1_1 & (wreg_3 != 0) & useful_3;
    wire rs2_id_mem_hazard = (wreg_3 == reg2) & regWEn_3 & rr2_1 & (wreg_3 != 0) & useful_3;
    // RAW情形c   100
    wire rs1_id_wb_hazard = (wreg_4 == reg1) & regWEn_4 & rr1_1 & (wreg_4 != 0) & useful_4;
    wire rs2_id_wb_hazard = (wreg_4 == reg2) & regWEn_4 & rr2_1 & (wreg_4 != 0) & useful_4;
    
    // 需将"pc+4"操作的相关逻辑前移到取值阶段
    // 将转移的判断结果和地址的得出放到执行阶段
    PC u1(
        .clk        (clk),
        .rst        (rst),
        .stop       (stop),
        .from_alu   (from_alu_2),
        .pc4        (pc4),
        .pcSel      (pcSel_2),
        .current_pc (pc)
    );
    
    control u_control(
        .funct3     (instruction[14:12]),
        .funct7     (instruction[31:25]),
        .opcode     (instruction[6:0]),
        .regWEn     (regWEn),
        .immSel     (immSel),
        .brOp       (brOp),
        .aSel       (aSel),
        .bSel       (bSel),
        .aluSel     (aluSel),
        .memRW      (memRW),
        .wbSel      (wbSel),
        .rr1        (rr1),
        .rr2        (rr2)
    );
    
    IF_ID IF_ID(
        .clk        (clk),
        .rst        (rst),
        .stop       (stop),
        .flush      (pcSel_2),      // 为0则清空
        .IF_pc      (pc),
        .IF_rR1     (instruction[19:15]),
        .IF_rR2     (instruction[24:20]),
        .IF_wR      (instruction[11: 7]),
        .IF_imm     (instruction[31: 7]),
        .IF_opcode  (instruction[6:0]),
        .IF_regWEn  (regWEn),
        .IF_immSel  (immSel),
        .IF_brOp    (brOp),
        .IF_aSel    (aSel),
        .IF_bSel    (bSel),
        .IF_aluSel  (aluSel),
        .IF_memRW   (memRW),
        .IF_wbSel   (wbSel),
        .IF_rr1     (rr1),
        .IF_rr2     (rr2),
        .ID_useful  (useful_1),
        .ID_pc      (pc_1),
        .ID_rR1     (reg1),
        .ID_rR2     (reg2),
        .ID_wR      (wreg_1),
        .ID_imm     (imm),
        .ID_opcode  (opcode_1),
        .ID_regWEn  (regWEn_1),
        .ID_immSel  (immSel_1),
        .ID_brOp    (brOp_1),
        .ID_aSel    (aSel_1),
        .ID_bSel    (bSel_1),
        .ID_aluSel  (aluSel_1),
        .ID_memRW   (memRW_1),
        .ID_wbSel   (wbSel_1),
        .ID_rr1     (rr1_1),
        .ID_rr2     (rr2_1)
    );

    wire    [31:0]  rD1;
    wire    [31:0]  rD2;
    regfile u2(
        .clk                (clk),
        .rst                (rst),
        .dataW              (dataW_4),      
        .rR1                (reg1),
        .rR2                (reg2),
        .wE                 (regWEn_4),
        .wR                 (wreg_4),
        .rD1                (rD1),
        .rD2                (rD2)
    );
    
    always @(*) begin
        if      (pre1)                  data1_1 =  from_dm_3;
        else if (rs1_id_ex_hazard)      data1_1 =  from_alu_2;
        else if (rs1_id_mem_hazard)     data1_1 =  from_alu_3;
        else if (rs1_id_wb_hazard)      data1_1 =  dataW_4;
        else                            data1_1 =   rD1;  
    end
    
    always @(*) begin
        if      (pre2)                  data2_1 =  from_dm_3;
        else if (rs2_id_ex_hazard)      data2_1 =  from_alu_2;
        else if (rs2_id_mem_hazard)     data2_1 =  from_alu_3;
        else if (rs2_id_wb_hazard)      data2_1 =  dataW_4;
        else                            data2_1 =   rD2;  
    end
    
    ImmSel u3(
        .sext_op    (immSel_1),
        .ins        (imm),
        .sext_imm   (sext_imm_1)
    );

    ID_EX ID_EX(
        .clk        (clk),
        .rst        (rst),
        .stop       (stop),
        .flush      (pcSel_2),      // 为0则清空
        .ID_useful  (useful_1),
        .ID_pc      (pc_1),
        .ID_wR      (wreg_1),
        .ID_imm_sex (sext_imm_1),
        .ID_data1   (data1_1),
        .ID_data2   (data2_1),
        .ID_opcode  (opcode_1),
        .ID_regWEn  (regWEn_1),
        .ID_brOp    (brOp_1),
        .ID_aSel    (aSel_1),
        .ID_bSel    (bSel_1),
        .ID_aluSel  (aluSel_1),
        .ID_memRW   (memRW_1),
        .ID_wbSel   (wbSel_1),
        .EX_useful  (useful_2),
        .EX_pc      (pc_2),
        .EX_wR      (wreg_2),
        .EX_imm_sex (sext_imm_2),
        .EX_data1   (data1_2),
        .EX_data2   (data2_2),
        .EX_opcode  (opcode_2),
        .EX_regWEn  (regWEn_2),
        .EX_brOp    (brOp_2),
        .EX_aSel    (aSel_2),
        .EX_bSel    (bSel_2),
        .EX_aluSel  (aluSel_2),
        .EX_memRW   (memRW_2),
        .EX_wbSel   (wbSel_2)
    );
    
    BranchComp u4(
        .opcode     (opcode_2),
        .data1      (data1_2),
        .data2      (data2_2),
        .brOp       (brOp_2),
        .pcSel      (pcSel_2)
    );
    
    ALU u5(
        .pc         (pc_2),
        .data1      (data1_2),
        .aSel       (aSel_2),
        .data2      (data2_2),
        .sext_imm   (sext_imm_2),
        .bSel       (bSel_2),
        .aluSel     (aluSel_2),
        .result     (from_alu_2)
    );
    
    EX_MEM EX_MEM(
        .clk            (clk),
        .rst            (rst),
        .EX_useful      (useful_2),
        .EX_pc          (pc_2),
        .EX_from_alu    (from_alu_2),
        .EX_wR          (wreg_2),
        .EX_data2       (data2_2),
        .EX_opcode      (opcode_2),
        .EX_regWEn      (regWEn_2),
        .EX_memRW       (memRW_2),
        .EX_wbSel       (wbSel_2),
        .MEM_useful     (useful_3),
        .MEM_pc         (pc_3),
        .MEM_from_alu   (from_alu_3),
        .MEM_wR         (wreg_3),
        .MEM_data2      (data2_3),
        .MEM_opcode     (opcode_3),
        .MEM_regWEn     (regWEn_3),
        .MEM_memRW      (memRW_3),
        .MEM_wbSel      (wbSel_3)
    );
    
    MEM_WB MEM_WB(
        .clk            (clk),
        .rst            (rst),
        .MEM_useful     (useful_3),
        .MEM_pc         (pc_3),
        .MEM_from_alu   (from_alu_3),
        .MEM_from_dm    (from_dm_3),
        .MEM_wR         (wreg_3),
        .MEM_regWEn     (regWEn_3),
        .MEM_wbSel      (wbSel_3),
        .WB_useful      (useful_4),
        .WB_pc          (pc_4),
        .WB_from_alu    (from_alu_4),
        .WB_from_dm     (from_dm_4),
        .WB_wR          (wreg_4),
        .WB_regWEn      (regWEn_4),
        .WB_wbSel       (wbSel_4)
    );
    
    MUX_WB u6(
        .pc         (pc_4),
        .from_alu   (from_alu_4),
        .from_dm    (from_dm_4),    // 读数据寄存器是组合逻辑
        .wbSel      (wbSel_4),
        .dataW      (dataW_4)
    );
    
endmodule

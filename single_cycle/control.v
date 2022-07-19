`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/29 16:29:36
// Design Name: 
// Module Name: control
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


module control(
    input       [2:0]   funct3,
    input       [6:0]   funct7,
    input       [6:0]   opcode,
    input               brAns,
    output reg          pcSel,
    output              regWEn,
    output reg  [2:0]   immSel,
    output reg  [2:0]   brOp,       // 4������Bָ�111ɶҲ������ѡ��ָ��Ű쿩
    output              aSel,
    output              bSel,
    output reg  [3:0]   aluSel,
    output              memRW,
    output reg  [1:0]   wbSel
    );

    assign regWEn   = (opcode == `S_TYPE || opcode == `B_TYPE) ? 0 : 1; // s��bָ�д�Ĵ���
    assign aSel     = (opcode == `B_TYPE || opcode == `J_TYPE) ? 0 : 1; // b��jָ�ѡdata1
    assign bSel     = (opcode == `R_TYPE) ? 0 : 1;                      // rָ��ѡdata2
    assign memRW    = (opcode == `S_TYPE) ? 1 : 0;                      // s��д
    
    
    always @ (*) begin
        case (opcode)
            `R_TYPE, `I_TYPE, `LW_TYPE, `S_TYPE, `U_TYPE:
                pcSel = 1;
            `B_TYPE:
                pcSel = brAns;
            `JR_TYPE, `J_TYPE:
                pcSel = 0;
            default:
                pcSel = 1;//  auipcָ��С��
        endcase
    end
    
    always @ (*) begin
        case (opcode)
            `I_TYPE, `LW_TYPE, `JR_TYPE:
                immSel = `I_SEXT;
            `S_TYPE:
                immSel = `S_SEXT;
            `B_TYPE:
                immSel = `B_SEXT;
            `U_TYPE:
                immSel = `U_SEXT;
            `J_TYPE:
                immSel = `J_SEXT;
            default:
                immSel = 'b111;
        endcase
    end
    
    always @ (*) begin
        if(opcode == `B_TYPE)   brOp = funct3;      // ��funct3��Ӧ�Ƚ�
        else                    brOp = 3'b111;      // �����Ƚ�
    end
    
    always @ (*) begin
        if(opcode == `R_TYPE)
            case(funct3)
                'b000:
                    aluSel = (funct7 == 'b010_0000) ? `SUB : `ADD;  // �ӡ���
                'b111:
                    aluSel = `AND;                                   // ��
                'b110:
                    aluSel = `OR;                                    // ��
                'b100:
                    aluSel = `XOR;                                  // ���
                'b001:
                    aluSel = `SLL;                                  // ����
                'b101:
                    aluSel = (funct7 == 'b000_0000) ? `SRL : `SRA; // �߼����ơ���������
                default:
                    aluSel = `NOOP;
            endcase
        else if(opcode == `I_TYPE)
            case(funct3)
                'b000:
                    aluSel = `ADD;
                'b111:
                    aluSel = `AND;
                'b110:
                    aluSel = `OR;
                'b100:
                    aluSel = `XOR;
                'b001:
                    aluSel = `SLL;
                'b101:
                    aluSel = (funct7 == 'b000_0000) ? `SRL : `SRA;
                default:
                    aluSel = `NOOP;
            endcase
        else if(opcode == `LW_TYPE || opcode == `JR_TYPE || opcode == `S_TYPE || opcode == `B_TYPE || opcode == `J_TYPE) 
                    aluSel = `ADD;
        else if(opcode == `U_TYPE)  
                    aluSel = `LUI;
        else       
                    aluSel = `NOOP;    // ������1111
    end
    
    always @ (*) begin
        case(opcode)
            `J_TYPE, `JR_TYPE:
                wbSel = `PC4;
            `LW_TYPE:
                wbSel = `FROM_DM;
            default:
                wbSel = `FROM_ALU;
        endcase
    end
    
endmodule

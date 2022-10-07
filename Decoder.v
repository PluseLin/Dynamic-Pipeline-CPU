`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/22 08:23:45
// Design Name: 
// Module Name: Decoder
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
`include "defines.vh"

module Decoder(
    input       [31:0]          instr,
    output      [4:0]           rsc,
    output      [4:0]           rtc,
    output      [4:0]           rdc,
    output      [4:0]           sa,
    output      [15:0]          immed,
    output      [25:0]          j_addr,
    output  reg [`CODE_NUM:0]   code
    );
    wire [5:0]opcode = instr[31:26];
    wire [5:0]func = instr[5:0];
    assign rsc=instr[25:21];
    assign rtc=instr[20:16];
    assign rdc=instr[15:11];
    assign sa =instr[10: 6];
    assign immed=instr[15:0];
    assign j_addr =instr[25:0];
    always @ * begin
        if(opcode==6'b0)begin
            case(func)
              12'h020:code=`ADD;            //add
              12'h021:code=`ADDU;            //addu
              12'h022:code=`SUB;            //sub
              12'h023:code=`SUBU;            //subu
              12'h024:code=`AND;            //and
              12'h025:code=`OR;            //or
              12'h026:code=`XOR;            //xor
              12'h027:code=`NOR;            //nor
              12'h02a:code=`SLT;            //slt
              12'h02b:code=`SLTU;            //sltu
              12'h000:code=`SLL;            //sll
              12'h002:code=`SRL;            //srl
              12'h003:code=`SRA;            //sra
              12'h004:code=`SLLV;            //sllv
              12'h006:code=`SRLV;            //srlv
              12'h007:code=`SRAV;            //srav
              12'h008:code=`JR;            //jr
              //6'b001101:code=56'h0000_0000_4000_00;//break
              12'h00d:code=`BRK;            //break
              default:code=32'h0;
            endcase
        end
        else begin
            case(opcode)
                6'b001000:code=`ADDI;  //addi
                6'b001001:code=`ADDIU;  //addiu
                6'b001100:code=`ANDI;  //andi                       
                6'b001101:code=`ORI;  //ori
                6'b001110:code=`XORI;  //xori
                6'b100011:code=`LW;  //lw                      
                6'b101011:code=`SW;  //sw
                6'b000100:code=`BEQ;  //beq
                6'b000101:code=`BNE;  //bne
                6'b001010:code=`SLTI;  //slti           
                6'b001011:code=`SLTIU;  //sltiu
                6'b001111:code=`LUI;  //lui
                6'b000010:code=`J;  //j
                6'b000011:code=`JAL;  //jal
                6'b011100:code=`MUL;    //mul
                default:  code=32'h0;                
            endcase
        end
    end    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/22 13:04:03
// Design Name: 
// Module Name: testDPCPU
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

module testDPCPU;
reg             clk,
                rst,
                stall;
wire    [31:0]  pc,
                inst,
                answer;
                
integer file_output;
integer times=7000;
integer cnt=0;

reg             flag=1'b1;
reg             output_flag=1'b0;

sccomp_dataflow uut(
    .clk(clk),
    .rst(rst),
    .stall(stall),  
    .inst(inst),
    .pc(pc),
    .answer(answer)
);
initial begin
    file_output = $fopen("D:\\CPU_AutoCheck\\yanshou1_result.txt");
    clk= 0;
    rst = 1;
    stall=1'b0;
    #0.1;
    rst = 0;
    repeat(times) #2 clk=~clk;
    flag=1'b0;
    #2;clk=~clk;
end

wire    [31:0]  reg28=uut.sccpu.cpu_ref.array_reg[28],
                reg16=uut.sccpu.cpu_ref.array_reg[16];
wire    [31:0]  
                II_IR=uut.sccpu.II_IR_out,
                IE_IR=uut.sccpu.IE_IR_out,
                EM_IR=uut.sccpu.EM_IR_out,
                MW_IR=uut.sccpu.MW_IR_out;
wire    [31:0]  ALUa=uut.sccpu.cpu_ALU.a,
                ALUb=uut.sccpu.cpu_ALU.b;
wire    [31:0]  ALU_res=uut.sccpu.MUX2_EM_res_out;
wire    [4:0]   is_pause=uut.sccpu.is_pause;
//wire    [31:0]  RF_data1=uut.sccpu.RF_data1,
//                RF_data2=uut.sccpu.RF_data2;
always @(posedge clk) begin
    if(!output_flag && EM_IR!=32'b0) begin
        output_flag<=1'b1;    
    end
    else begin
        output_flag<=output_flag;
    end 
    if(uut.sccpu.II_IR_out!=32'h0000000d) begin
        cnt=cnt+1;
    end
    else begin
        $display("instr num: %d",cnt);
    end 
    if(flag && output_flag)begin
        if(uut.sccpu.MW_IR_out!=32'h0)begin
        $fdisplay(file_output, "pc: %h", pc);
        $fdisplay(file_output, "instr: %h", uut.sccpu.MW_IR_out);
        $fdisplay(file_output, "regfile0: %h", uut.sccpu.cpu_ref.array_reg[0]);
        $fdisplay(file_output, "regfile1: %h", uut.sccpu.cpu_ref.array_reg[1]);
        $fdisplay(file_output, "regfile2: %h", uut.sccpu.cpu_ref.array_reg[2]);
        $fdisplay(file_output, "regfile3: %h", uut.sccpu.cpu_ref.array_reg[3]);
        $fdisplay(file_output, "regfile4: %h", uut.sccpu.cpu_ref.array_reg[4]);
        $fdisplay(file_output, "regfile5: %h", uut.sccpu.cpu_ref.array_reg[5]);
        $fdisplay(file_output, "regfile6: %h", uut.sccpu.cpu_ref.array_reg[6]);
        $fdisplay(file_output, "regfile7: %h", uut.sccpu.cpu_ref.array_reg[7]);
        $fdisplay(file_output, "regfile8: %h", uut.sccpu.cpu_ref.array_reg[8]);
        $fdisplay(file_output, "regfile9: %h", uut.sccpu.cpu_ref.array_reg[9]);
        $fdisplay(file_output,"regfile10: %h",uut.sccpu.cpu_ref.array_reg[10]);
        $fdisplay(file_output,"regfile11: %h",uut.sccpu.cpu_ref.array_reg[11]);
        $fdisplay(file_output,"regfile12: %h",uut.sccpu.cpu_ref.array_reg[12]);
        $fdisplay(file_output,"regfile13: %h",uut.sccpu.cpu_ref.array_reg[13]);
        $fdisplay(file_output,"regfile14: %h",uut.sccpu.cpu_ref.array_reg[14]);
        $fdisplay(file_output,"regfile15: %h",uut.sccpu.cpu_ref.array_reg[15]);
        $fdisplay(file_output,"regfile16: %h",uut.sccpu.cpu_ref.array_reg[16]);
        $fdisplay(file_output,"regfile17: %h",uut.sccpu.cpu_ref.array_reg[17]);
        $fdisplay(file_output,"regfile18: %h",uut.sccpu.cpu_ref.array_reg[18]);
        $fdisplay(file_output,"regfile19: %h", uut.sccpu.cpu_ref.array_reg[19]);
        $fdisplay(file_output,"regfile20: %h", uut.sccpu.cpu_ref.array_reg[20]);
        $fdisplay(file_output,"regfile21: %h", uut.sccpu.cpu_ref.array_reg[21]);
        $fdisplay(file_output,"regfile22: %h", uut.sccpu.cpu_ref.array_reg[22]);
        $fdisplay(file_output,"regfile23: %h", uut.sccpu.cpu_ref.array_reg[23]);
        $fdisplay(file_output,"regfile24: %h", uut.sccpu.cpu_ref.array_reg[24]);
        $fdisplay(file_output,"regfile25: %h", uut.sccpu.cpu_ref.array_reg[25]);
        $fdisplay(file_output,"regfile26: %h", uut.sccpu.cpu_ref.array_reg[26]);
        $fdisplay(file_output,"regfile27: %h", uut.sccpu.cpu_ref.array_reg[27]);
        $fdisplay(file_output,"regfile28: %h", uut.sccpu.cpu_ref.array_reg[28]);
        $fdisplay(file_output,"regfile29: %h", uut.sccpu.cpu_ref.array_reg[29]);
        $fdisplay(file_output,"regfile30: %h", uut.sccpu.cpu_ref.array_reg[30]);
        $fdisplay(file_output,"regfile31: %h", uut.sccpu.cpu_ref.array_reg[31]);
        end
    end
    else if(!flag)begin
        $fclose(file_output);
        $finish;
    end
end
endmodule
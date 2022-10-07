`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/22 13:09:56
// Design Name: 
// Module Name: DPCPU
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
`include    "defines.vh"

module DPCPU(
        input           clk,
        input           rst,
        input   [31:0]  instr_in,
        input   [31:0]  DMEM_out,
        
        input           stall,
        
        output  [31:0]  pc,
        output  [31:0]  DMEM_addr,
        output  [31:0]  DMEM_data,
        output          DMEM_wena,
        output          DMEM_rena,
        
        output  [31:0]  answer
    );
    //
    
    //连线
    //CU input
    wire            ID_is_branch;
    wire    [31:0]  II_IR_out,
                    IE_IR_out,
                    EM_IR_out,
                    MW_IR_out;
    //CU output
    wire            RF_wena,
                    RF_rena,
                    ID_equal,
                    ext16_sext,
                    MUX2_jpc_s,
                    MUX2_jump_s,
                    MUX2_II_IR_s,
                    MUX2_ext5_s,
                    MUX2_pusha_s,
                    MUX2_pushb_s,
                    MUX2_EM_res_s,
                    MUX2_MW_res_s;
    wire            MUX2_cmp_pusha_s,
                    MUX2_cmp_pushb_s;
    wire    [31:0]  MUX2_cmp_pusha_out,
                    MUX2_cmp_pushb_out;    
    wire    [1:0]   MUX4_PC_s,
                    MUX4_IE_ALUa_s,
                    MUX4_IE_ALUb_s;  
    wire    [3:0]   aluc;    
    wire    [4:0]   is_pause;  
    wire    [4:0]   WB_waddr,
                    ID_rsc,
                    ID_rtc,
                    ID_sa;
    wire    [15:0]  ID_immed;
    wire    [25:0]  ID_jaddr;

           
    //中间连线
    wire            zero,
                    carry,
                    negative,
                    overflow;
                    
    wire    [4:0]   MUX2_ext5_out;

    wire    [31:0]  MUX2_jpc_out;     
    wire    [31:0]  MUX4_PC_out,
                    PC_out;
    wire    [31:0]  NPC_out;
    wire    [31:0]  MUX2_jump_out;
    wire    [31:0]  MUX2_II_IR_out;
    wire    [31:0]  II_NPC_out;
    wire    [31:0]  MW_res_out,
                    RF_data1,
                    RF_data2;
    wire    [31:0]  ext5_out;
    wire    [31:0]  ext16_out;
    wire    [31:0]  j_pc;
    wire    [31:0]  b_pc;
    wire    [31:0]  ALU_r,
                    MUX2_pusha_out,
                    MUX2_pushb_out;
    wire    [31:0]  MUX4_IE_ALUa_out;
    wire    [31:0]  IE_ALUa_out;
    wire    [31:0]  MUX4_IE_ALUb_out;
    wire    [31:0]  IE_ALUb_out;
    wire    [31:0]  IE_wdata_out;
    wire    [31:0]  MUX2_EM_res_out;
    wire    [31:0]  EM_res_out;
    wire    [31:0]  EM_wdata_out;
    wire    [31:0]  MUX2_MW_res_out;
    wire    [31:0]  hi,
                    lo;
    assign pc=PC_out;
    assign  DMEM_addr=EM_res_out;
    assign  DMEM_data=EM_wdata_out;
    //CU
    Controller      CU(
        .II_IR_out      (II_IR_out),
        .IE_IR_out      (IE_IR_out),
        .EM_IR_out      (EM_IR_out),
        .MW_IR_out      (MW_IR_out),
        .ID_is_branch   (ID_is_branch),
        
        .stall          (stall),
        
        .RF_wena        (RF_wena),
        .RF_rena        (RF_rena),
        .DMEM_rena      (DMEM_rena),
        .DMEM_wena      (DMEM_wena),
        .ID_equal       (ID_equal),
        .ext16_sext     (ext16_sext),
        .MUX2_jpc_s     (MUX2_jpc_s),
        .MUX2_jump_s    (MUX2_jump_s),
        .MUX2_II_IR_s   (MUX2_II_IR_s),
        .MUX2_ext5_s    (MUX2_ext5_s),
        .MUX2_cmp_pusha_s   (MUX2_cmp_pusha_s),
        .MUX2_cmp_pushb_s   (MUX2_cmp_pushb_s),
        .MUX2_pusha_s   (MUX2_pusha_s),
        .MUX2_pushb_s   (MUX2_pushb_s),
        .MUX2_EM_res_s  (MUX2_EM_res_s),
        .MUX2_MW_res_s  (MUX2_MW_res_s),
        .MUX4_PC_s      (MUX4_PC_s),
        .MUX4_IE_ALUa_s (MUX4_IE_ALUa_s),
        .MUX4_IE_ALUb_s (MUX4_IE_ALUb_s),
        .aluc           (aluc),
        .is_pause       (is_pause),
        .WB_waddr       (WB_waddr),
        .ID_rsc         (ID_rsc),
        .ID_rtc         (ID_rtc),
        .ID_sa          (ID_sa),
        .ID_immed       (ID_immed),
        .ID_jaddr       (ID_jaddr)
    );
    //IF
    PCReg           cpu_PC(
        .clk        (clk),
        .rst        (rst),
        .pc_in      (MUX4_PC_out),
        .pc_out     (PC_out)              
    );
    /*IMEM*/
    NPC             cpu_NPC(
        .data_in    (PC_out),
        .data_out   (NPC_out)
    );   
                 
    MUX2            MUX2_jump(
        .data0      (MUX2_jpc_out),
        .data1      (b_pc),
        .s          (MUX2_jump_s),
        .out        (MUX2_jump_out)
    );
                 
    MUX4            MUX4_PC(
        .data0      (NPC_out),
        .data1      (PC_out),
        .data2      (MUX2_jump_out),
        .data3      (`INT_ENTRY),
        .s          (MUX4_PC_s),
        .out        (MUX4_PC_out)
    );
    //IF/ID

    MUX2            MUX2_II_IR(
        .data0      (instr_in),
        .data1      (32'b0),
        .s          (MUX2_II_IR_s),
        .out        (MUX2_II_IR_out)
    );    

    SegmentReg      II_IR(
        .clk        (clk),
        .rst        (rst),
        .prev_pause (is_pause[`IF_STATE]),
        .next_pause (is_pause[`ID_STATE]),
        .data_in    (MUX2_II_IR_out),
        .data_out   (II_IR_out)
    );

    SegmentReg      II_NPC(
        .clk        (clk),
        .rst        (rst),
        .prev_pause (is_pause[`IF_STATE]),
        .next_pause (is_pause[`ID_STATE]),
        .data_in    (NPC_out),
        .data_out   (II_NPC_out)    
    );
    //ID

    Regfiles        cpu_ref(
        .clk        (clk),
        .rst        (rst),
        .wena       (RF_wena),
        .rena       (RF_rena),
        .wdata      (MW_res_out),
        .waddr      (WB_waddr),
        .raddr1     (ID_rsc),
        .raddr2     (ID_rtc),
        .rdata1     (RF_data1),
        .rdata2     (RF_data2),
        .answer     (answer)
    );

    MUX2            MUX2_cmp_pusha(
        .data0      (RF_data1),
        .data1      (MUX2_pusha_out),
        .s          (MUX2_cmp_pusha_s),
        .out        (MUX2_cmp_pusha_out)        
    );
    MUX2            MUX2_cmp_pushb(
        .data0      (RF_data2),
        .data1      (MUX2_pushb_out),
        .s          (MUX2_cmp_pushb_s),
        .out        (MUX2_cmp_pushb_out)        
    );    
    cmp             cpu_cmp(
        .num1       (MUX2_cmp_pusha_out),
        .num2       (MUX2_cmp_pushb_out),
        .cmp_equal  (ID_equal),
        .is_branch  (ID_is_branch)
    );

    MUX25           MUX2_ext5(
        .data0      (ID_sa),
        .data1      (RF_data1[4:0]),
        .s          (MUX2_ext5_s),
        .out        (MUX2_ext5_out)
    );

    ext5            CPU_ext5(
        .a          (MUX2_ext5_out),
        .sext       (1'b0),
        .b          (ext5_out)
    );

    ext16           CPU_ext16(
        .a          (ID_immed),
        .sext       (ext16_sext),
        .b          (ext16_out)
    );

    II              CPU_II(
        .a          (II_NPC_out[31:28]),
        .b          (ID_jaddr),
        .r          (j_pc)
    );
            
    MUX2             MUX2_jpc(
        .data0      (j_pc),
        .data1      (RF_data1),
        .s          (MUX2_jpc_s),
        .out        (MUX2_jpc_out)
    );
   
    add             branch_add(
        .a          (II_NPC_out),
        .b          ({{(14){ID_immed[15]}},ID_immed,2'b0}),
        .r          (b_pc)
    );
    //ID/EXE

    MUX2            MUX2_pusha(
        .data0      (MUX2_EM_res_out),
        .data1      (MUX2_MW_res_out),
        .s          (MUX2_pusha_s),
        .out        (MUX2_pusha_out)
    );
    MUX2            MUX2_pushb(
        .data0      (MUX2_EM_res_out),
        .data1      (MUX2_MW_res_out),
        .s          (MUX2_pushb_s),
        .out        (MUX2_pushb_out)
    );
    MUX4            MUX4_IE_ALUa(
        .data0      (RF_data1),
        .data1      (ext5_out),
        .data2      (MUX2_pusha_out),
        .data3      (II_NPC_out),
        .s          (MUX4_IE_ALUa_s),
        .out        (MUX4_IE_ALUa_out)        
    );

    SegmentReg      IE_ALUa(
        .clk        (clk),
        .rst        (rst),
        .prev_pause (is_pause[`ID_STATE]),
        .next_pause (is_pause[`EXE_STATE]),
        .data_in    (MUX4_IE_ALUa_out),
        .data_out   (IE_ALUa_out)
    );

    MUX4            MUX4_IE_ALUb(
        .data0      (RF_data2),
        .data1      (ext16_out),
        .data2      (MUX2_pushb_out),
        .data3      (32'd4),
        .s          (MUX4_IE_ALUb_s),
        .out        (MUX4_IE_ALUb_out)        
    );

    SegmentReg      IE_ALUb(
        .clk        (clk),
        .rst        (rst),
        .prev_pause (is_pause[`ID_STATE]),
        .next_pause (is_pause[`EXE_STATE]),
        .data_in    (MUX4_IE_ALUb_out),
        .data_out   (IE_ALUb_out)
    );

    SegmentReg      IE_IR(
        .clk        (clk),
        .rst        (rst),
        .prev_pause (is_pause[`ID_STATE]),
        .next_pause (is_pause[`EXE_STATE]),
        .data_in    (II_IR_out),
        .data_out   (IE_IR_out)
    );

    SegmentReg      IE_wdata(
        .clk        (clk),
        .rst        (rst),
        .prev_pause (is_pause[`ID_STATE]),
        .next_pause (is_pause[`EXE_STATE]),
        .data_in    (RF_data2),
        .data_out   (IE_wdata_out)
    );
    //EXE

    ALU             cpu_ALU(
        .a          (IE_ALUa_out),
        .b          (IE_ALUb_out),
        .aluc       (aluc),
        .r          (ALU_r),
        .zero       (zero),
        .carry      (carry),
        .negative   (negative),
        .overflow   (overflow)
    );

    MULT            cpu_MULT(
        .a          (IE_ALUa_out),
        .b          (IE_ALUb_out),
        .hi         (hi),
        .lo         (lo)
    );
    //EXE/MEM

    SegmentReg      EM_IR(
        .clk        (clk),
        .rst        (rst),
        .prev_pause (is_pause[`EXE_STATE]),
        .next_pause (is_pause[`MEM_STATE]),
        .data_in    (IE_IR_out),
        .data_out   (EM_IR_out)
    );

    MUX2            MUX2_EM_res(
        .data0      (ALU_r),
        .data1      (lo),
        .s          (MUX2_EM_res_s),
        .out        (MUX2_EM_res_out)
    );

    SegmentReg      EM_res(
        .clk        (clk),
        .rst        (rst),
        .prev_pause (is_pause[`EXE_STATE]),
        .next_pause (is_pause[`MEM_STATE]),
        .data_in    (MUX2_EM_res_out),
        .data_out   (EM_res_out)        
    );  

    SegmentReg      EM_wdata(
        .clk        (clk),
        .rst        (rst),
        .prev_pause (is_pause[`EXE_STATE]),
        .next_pause (is_pause[`MEM_STATE]),
        .data_in    (IE_wdata_out),
        .data_out   (EM_wdata_out)        
    );
    //MEM
    //DMEM

    //wena,rena in CU
    //MEM/WB

    MUX2            MUX2_MW_res(
        .data0      (EM_res_out),
        .data1      (DMEM_out),
        .s          (MUX2_MW_res_s),
        .out        (MUX2_MW_res_out)
    );
    SegmentReg      MW_res(
        .clk        (clk),
        .rst        (rst),
        .prev_pause (is_pause[`MEM_STATE]),
        .next_pause (is_pause[`WB_STATE]),
        .data_in    (MUX2_MW_res_out),
        .data_out   (MW_res_out)        
    );     
    SegmentReg      MW_IR(
        .clk        (clk),
        .rst        (rst),
        .prev_pause (is_pause[`MEM_STATE]),
        .next_pause (is_pause[`WB_STATE]),
        .data_in    (EM_IR_out),
        .data_out   (MW_IR_out)        
    );
    //WB
    //Regfiles
endmodule

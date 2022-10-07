`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/20 13:24:03
// Design Name: 
// Module Name: Controller
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

module Controller(
    input   [31:0]  II_IR_out,
                    IE_IR_out,
                    EM_IR_out,
                    MW_IR_out,
    input           ID_is_branch,
    input           stall,
    
    output          RF_wena,            
                    RF_rena,            
                    DMEM_rena,          
                    DMEM_wena,          
                    ID_equal,           
                    ext16_sext,         
                    MUX2_jpc_s,
                    MUX2_jump_s,
                    MUX2_II_IR_s,
                    MUX2_cmp_pusha_s,
                    MUX2_cmp_pushb_s,
                    MUX2_ext5_s,
                    MUX2_pusha_s,
                    MUX2_pushb_s,
                    MUX2_EM_res_s,
                    MUX2_MW_res_s,
    
    output  [1:0]   MUX4_PC_s,
                    MUX4_IE_ALUa_s,
                    MUX4_IE_ALUb_s,  
    output  [3:0]   aluc,               
    output  [4:0]   is_pause,           
                    WB_waddr,           
                    ID_rsc,             
                    ID_rtc,             
                    ID_sa,              
    output  [15:0]  ID_immed,           
    output  [25:0]  ID_jaddr            
    );
    wire    [`CODE_NUM:0]   Code_type   [1:4];
    wire    [4:0]           rsc         [1:4];
    wire    [4:0]           rtc         [1:4];
    wire    [4:0]           rdc         [1:4];
    wire    [4:0]           sa          [1:4];
    wire    [15:0]          immed       [1:4];
    wire    [25:0]          j_addr      [1:4];
    /* ÒëÂëÆ÷ */
    Decoder     ID_Decoder(
        .instr      (II_IR_out),
        .rsc        (rsc[`ID_STATE]),
        .rtc        (rtc[`ID_STATE]),
        .rdc        (rdc[`ID_STATE]),
        .sa         (sa[`ID_STATE]),
        .immed      (immed[`ID_STATE]),
        .j_addr     (j_addr[`ID_STATE]),
        .code       (`IDC)
    );
    Decoder     EXE_Decoder(
        .instr      (IE_IR_out),
        .rsc        (rsc[`EXE_STATE]),
        .rtc        (rtc[`EXE_STATE]),
        .rdc        (rdc[`EXE_STATE]),
        .sa         (sa[`EXE_STATE]),
        .immed      (immed[`EXE_STATE]),
        .j_addr     (j_addr[`EXE_STATE]),
        .code       (`EXEC)
    );
    Decoder     MEM_Decoder(
        .instr      (EM_IR_out),
        .rsc        (rsc[`MEM_STATE]),
        .rtc        (rtc[`MEM_STATE]),
        .rdc        (rdc[`MEM_STATE]),
        .sa         (sa[`MEM_STATE]),
        .immed      (immed[`MEM_STATE]),
        .j_addr     (j_addr[`MEM_STATE]),
        .code       (`MEMC)
    );
    Decoder     WB_Decoder(
        .instr      (MW_IR_out),
        .rsc        (rsc[`WB_STATE]),
        .rtc        (rtc[`WB_STATE]),
        .rdc        (rdc[`WB_STATE]),
        .sa         (sa[`WB_STATE]),
        .immed      (immed[`WB_STATE]),
        .j_addr     (j_addr[`WB_STATE]),
        .code       (`WBC)
    );
    //conflict judge
    wire    IDCrRsc=~(`IDC[`_SLL]|`IDC[`_SRL]|`IDC[`_SRA]|
                    `IDC[`_LUI]|`IDC[`_J]|`IDC[`_JAL]|`IDC[`_BRK]);
    wire    IDCrRtc=~(`IDC[`_ADDI]|`IDC[`_ADDIU]|`IDC[`_ANDI]|`IDC[`_ORI]|`IDC[`_XORI]|
                    `IDC[`_SLTI]|`IDC[`_SLTIU]|`IDC[`_LUI]|`IDC[`_LW]|`IDC[`_SW]|
                    `IDC[`_J]|`IDC[`_JAL]|`IDC[`_JR]|`IDC[`_BRK]);
    wire    EXECwRF=~(`EXEC[`_SW]|`EXEC[`_BEQ]|`EXEC[`_BNE]|`EXEC[`_J]|`EXEC[`_JR]|
                    `EXEC[`_BRK]);
    wire    MEMCwRF=~(`MEMC[`_SW]|`MEMC[`_BEQ]|`MEMC[`_BNE]|`MEMC[`_J]|`MEMC[`_JR]|
                    `MEMC[`_BRK]);
    wire    [4:0]   
            EXEC_waddr= (`EXEC[`_JAL])? 5'd31:
                        (`EXEC[`_ADDI]|`EXEC[`_ADDIU]|`EXEC[`_ANDI]|`EXEC[`_ORI]|`EXEC[`_XORI]|
                        `EXEC[`_SLTI]|`EXEC[`_SLTIU]|`EXEC[`_LUI]|`EXEC[`_LW])?rtc[`EXE_STATE]:
                        rdc[`EXE_STATE],
            MEMC_waddr= (`MEMC[`_JAL])? 5'd31:
                        (`MEMC[`_ADDI]|`MEMC[`_ADDIU]|`MEMC[`_ANDI]|`MEMC[`_ORI]|`MEMC[`_XORI]|
                        `MEMC[`_SLTI]|`MEMC[`_SLTIU]|`MEMC[`_LUI]|`MEMC[`_LW])?rtc[`MEM_STATE]:
                        rdc[`MEM_STATE];
    //Ç°ÍÆ²»¿¼ÂÇnop                            
    wire    EXEC_pusha= (II_IR_out!=32'b0) && (IE_IR_out!=32'b0) &&
                        IDCrRsc &&  EXECwRF &&
                        (rsc[`ID_STATE]==EXEC_waddr)&& (EXEC_waddr!=5'b0) && (rsc[`ID_STATE]!=5'b0);
    wire    EXEC_pushb= (II_IR_out!=32'b0) && (IE_IR_out!=32'b0) &&
                        IDCrRtc &&  EXECwRF &&
                        (rtc[`ID_STATE]==EXEC_waddr)&& (EXEC_waddr!=5'b0) && (rtc[`ID_STATE]!=5'b0);           
    wire    MEMC_pusha= (II_IR_out!=32'b0) && (EM_IR_out!=32'b0) &&
                        IDCrRsc &&  MEMCwRF &&
                        (rsc[`ID_STATE]==MEMC_waddr)&& (MEMC_waddr!=5'b0) && (rsc[`ID_STATE]!=5'b0);
    wire    MEMC_pushb= (II_IR_out!=32'b0) && (EM_IR_out!=32'b0) &&
                        IDCrRtc &&  MEMCwRF &&
                        (rtc[`ID_STATE]==MEMC_waddr)&& (MEMC_waddr!=5'b0) && (rtc[`ID_STATE]!=5'b0);
    wire    ID_MustStop=(`EXEC[`_LW]) && (II_IR_out!=32'b0) &&(
                            (IDCrRsc &&(rtc[`EXE_STATE]==rsc[`ID_STATE]))||
                            (IDCrRtc &&(rtc[`EXE_STATE]==rtc[`ID_STATE]))
                        );
    reg     [4:0]   pause;
    always @(*) begin
        if(stall)begin
            pause=`HALT;
        end
        else if(ID_MustStop) begin
            pause=`ID_PAUSE;
        end
        else begin
            pause=`NO_PAUSE;
        end
    end
    assign  is_pause=pause;
    wire    II_IR_drop=`IDC[`_J]|`IDC[`_JAL]|`IDC[`_JR]|((`IDC[`_BEQ]|`IDC[`_BNE])& ID_is_branch);           
    assign  RF_wena=~(`WBC[`_SW]|`WBC[`_BEQ]|`WBC[`_BNE]|`WBC[`_J]|`WBC[`_JR]|`WBC[`_BRK]);
    assign  RF_rena=1'b1;
    assign  DMEM_rena=`MEMC[`_LW];
    assign  DMEM_wena=`MEMC[`_SW];
    assign  ID_equal=`IDC[`_BEQ];
    assign  ext16_sext=~(`IDC[`_ADDIU]|`IDC[`_ANDI]|`IDC[`_ORI]|`IDC[`_XORI]|
                        `IDC[`_SLTIU]|`IDC[`_LUI]|`IDC[`_LW]|`IDC[`_SW]);
    assign  WB_waddr=(`WBC[`_JAL])   ?   5'd31   :
                     (`WBC[`_ADDI]|`WBC[`_ADDIU]|`WBC[`_ANDI]|`WBC[`_ORI]|`WBC[`_XORI]|`WBC[`_SLTI]|`WBC[`_SLTIU]|`WBC[`_LUI]|`WBC[`_LW])?rtc[`WB_STATE]:
                    rdc[`WB_STATE];
    
    assign  aluc[0]=`EXEC[`_SUB]|`EXEC[`_SUBU]|`EXEC[`_OR]|`EXEC[`_NOR]|`EXEC[`_SLT]|`EXEC[`_SRL]|
                    `EXEC[`_SRLV]|`EXEC[`_ORI]|`EXEC[`_SLTI];
    assign  aluc[1]=`EXEC[`_ADD]|`EXEC[`_SUB]|`EXEC[`_XOR]|`EXEC[`_NOR]|`EXEC[`_SLT]|`EXEC[`_SLTU]|
                    `EXEC[`_SLL]|`EXEC[`_SLLV]|`EXEC[`_ADDI]|`EXEC[`_XORI]|`EXEC[`_LW]|`EXEC[`_SW]|
                    `EXEC[`_SLTI]|`EXEC[`_SLTIU];
    assign  aluc[2]=`EXEC[`_AND]|`EXEC[`_OR]|`EXEC[`_XOR]|`EXEC[`_NOR]|`EXEC[`_SLL]|`EXEC[`_SRL]|`EXEC[`_SRA]|
                    `EXEC[`_SLLV]|`EXEC[`_SRLV]|`EXEC[`_SRAV]|`EXEC[`_ANDI]|`EXEC[`_ORI]|`EXEC[`_XORI];
    assign  aluc[3]=`EXEC[`_SLT]|`EXEC[`_SLTU]|`EXEC[`_SLL]|`EXEC[`_SRL]|`EXEC[`_SRA]|`EXEC[`_SLLV]|`EXEC[`_SRLV]|
                    `EXEC[`_SLTI]|`EXEC[`_SLTIU]|`EXEC[`_LUI]; 
    
    assign  ID_rsc=rsc[`ID_STATE];
    assign  ID_rtc=rtc[`ID_STATE];
    assign  ID_sa=sa[`ID_STATE];
    assign  ID_immed=immed[`ID_STATE];
    assign  ID_jaddr=j_addr[`ID_STATE];   
    // MUX2_jpc_s: 0 j_pc from II,1 rdata1(jr)
    assign  MUX2_jpc_s=`IDC[`_JR];
    // MUX2_jump: 0 MUX2_jpc_out,1 branch_addr
    assign  MUX2_jump_s=(`IDC[`_BEQ]|`IDC[`_BNE])&ID_is_branch;
    //MUX2_II_IR: 0 instr_in,1 32'b0(drop)
    assign MUX2_II_IR_s=II_IR_drop;
    //MUX2_ext5_s 0:ID_sa 1: RF_data1
    assign MUX2_ext5_s=`IDC[`_SLLV]|`IDC[`_SRLV]|`IDC[`_SRAV];
    assign MUX2_cmp_pusha_s=EXEC_pusha || MEMC_pusha;
    assign MUX2_cmp_pushb_s=EXEC_pushb || MEMC_pushb;
    //MUX2_pusha: 0 ALU.r 1:MUX2_MW_res_out(MEM.res)
    //MUX2_pushb similar
    //both push,choose nearest EXE data
    assign MUX2_pusha_s=~EXEC_pusha && MEMC_pusha;
    assign MUX2_pushb_s=~EXEC_pushb && MEMC_pushb;
    //MUX2_EM_res: 0 ALU.r,1 MULT.lo
    assign MUX2_EM_res_s=`EXEC[`_MUL];
    //MUX2_MW_res: 0 EM_res_out,1 DMEM_data_out
    assign MUX2_MW_res_s=`MEMC[`_LW];
    //MUX4_PC_s[0] 0:NPC_out|MUX2_jump_out  1:PC_out|int_entry
    //MUX4_PC_s[1] 0:NPC_out|PC_out         1:MUX2_jump_out|int_entry
    assign MUX4_PC_s[0]=is_pause[`IF_STATE] |
                        `IDC[`_BRK];
    assign MUX4_PC_s[1]=`IDC[`_J]|`IDC[`_JAL]|`IDC[`_JR]|((`IDC[`_BEQ]|`IDC[`_BNE])& ID_is_branch)|
                        `IDC[`_BRK];
    //MUX4_IE_ALUa[0]   0:RF.data1|MUX2_pusha_out     1:ext5_out|NPC_out
    //MUX4_IE_ALUa[1]   0:RF.data1|ext5_out           1:MUX2_pusha_out|NPC_out
    assign MUX4_IE_ALUa_s[0]=   (`IDC[`_SLL]|`IDC[`_SRL]|`IDC[`_SRA]|
                                `IDC[`_SLLV]|`IDC[`_SRLV]|`IDC[`_SRAV]|
                                `IDC[`_JAL]) && !EXEC_pusha && !MEMC_pusha;     
    assign MUX4_IE_ALUa_s[1]=   EXEC_pusha|MEMC_pusha|
                                `IDC[`_JAL];
    //MUX4_IE_ALUb[0]:  0:RF.data2|MUX2_pushb_out   1:ext16_out|32'd4
    //MUX4_IE_ALUb[1]:  0:RF.data2|ext16_out        1:MUX2_pushb_out|32'd4
    assign  MUX4_IE_ALUb_s[0]=  (`IDC[`_ADDI]|`IDC[`_ADDIU]|`IDC[`_ANDI]|`IDC[`_ORI]|`IDC[`_XORI]|
                                `IDC[`_SLTI]|`IDC[`_SLTIU]|`IDC[`_LUI]|`IDC[`_LW]|`IDC[`_SW]|
                                `IDC[`_JAL])&& !EXEC_pushb && !MEMC_pushb;
    assign  MUX4_IE_ALUb_s[1]=  EXEC_pushb|MEMC_pushb|
                                `IDC[`_JAL]; 
endmodule

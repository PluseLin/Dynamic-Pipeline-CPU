`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/24 09:09:43
// Design Name: 
// Module Name: sccomp_dataflow
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

module sccomp_dataflow(
    input           clk,
    input           rst,
    input           stall,
    output  [31:0]  pc,
    output  [31:0]  inst,
    output  [31:0]  answer
    );
    /*数据通路*/
    wire    [31:0]  DMEM_out,DMEM_addr,DMEM_data;
    wire    [31:0]  IMEM_addr_in=(pc-`PC_INIT)>>2,
                    DMEM_addr_in=(DMEM_addr-`DMEM_BASE)>>2;
    wire            DMEM_wena,DMEM_rena;
    DPCPU           sccpu(
        .clk        (clk),
        .rst        (rst),
        .instr_in   (inst),
        .DMEM_out   (DMEM_out),
        .stall      (stall),
        .pc         (pc),
        .DMEM_addr  (DMEM_addr),
        .DMEM_data  (DMEM_data),
        .DMEM_wena  (DMEM_wena),
        .DMEM_rena  (DMEM_rena),
        .answer     (answer)
    );       
    DMEM            cpu_DMEM(
        .clk        (clk),
        .rst        (rst),
        .wena       (DMEM_wena),
        .rena       (DMEM_rena),
        .addr       (DMEM_addr_in[`ADDR_BYTES-1:0]),
        .data_in    (DMEM_data),
        .data_out   (DMEM_out)
    );
    IMEM            cpu_IMEM(
        .addr       (IMEM_addr_in[10:0]),
        .instr      (inst)
    );
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/24 20:52:38
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
    input           clk,
    input           rst,
    input           stall,
    
    output  [7:0]   seg,
    output  [7:0]   sel
    );
    wire    [31:0]  answer;
    wire    [31:0]  pc;
    wire    [31:0]  inst;
    wire            cpu_clk;
    Divider         clk_Divider(
        .clk_in     (clk),
        .reset      (rst),
        .clk_out    (cpu_clk)
    );
    sccomp_dataflow sccomp(
        .clk        (cpu_clk),
        .rst        (rst),
        .stall      (stall),
        .pc         (pc),
        .inst       (inst),
        .answer     (answer)
    );
    seg7x16         seg_driver(
        .clk        (clk),
        .reset      (rst),
        .cs         (1'b1),
        .i_data     (answer),
        .o_seg      (seg),
        .o_sel      (sel)
    );
endmodule

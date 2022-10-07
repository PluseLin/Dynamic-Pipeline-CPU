`timescale 1ns / 1ps
`include "defines.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/19 16:09:13
// Design Name: 
// Module Name: PCReg
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


module PCReg(
    input           clk,
    input           rst,
    input   [31:0]  pc_in,
    output  [31:0]  pc_out    
    );
    reg [31:0]  pc;
    always @ (posedge clk or posedge rst)begin
        if(rst)
            pc<=`PC_INIT;
         else
            pc<=pc_in;
    end
    assign pc_out=pc;
endmodule

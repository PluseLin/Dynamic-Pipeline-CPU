`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/19 16:09:13
// Design Name: 
// Module Name: SegmentReg
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


module SegmentReg(
    input           clk,
    input           rst,
    input           prev_pause,
    input           next_pause,
    input   [31:0]  data_in,
    
    output  [31:0]  data_out 
    );
    reg [31:0]  data;
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            data<=32'h0;
        end    
        else if(prev_pause&&~next_pause)
            data<=32'h0;
        else if(prev_pause)
            data<=data; 
        else begin
            data<=data_in;
        end
    end
    assign data_out=data;
endmodule
    
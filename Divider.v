`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/15 18:46:44
// Design Name: 
// Module Name: Divider
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


module Divider(
    input clk_in,
    input reset,
    output clk_out
    );
    reg clk=1'b0;
    reg [23:0]cnt;
    always @(posedge clk_in or posedge reset)begin
        if(reset)begin
            clk<=1'b0;
            cnt<=24'b0;
        end
        else begin
            if(cnt==24'h00ffff) begin
                clk<=~clk;
                cnt<=2'b0;
            end
            else begin
                cnt<=cnt+1;
            end
        end
    end
    assign clk_out=clk;
endmodule

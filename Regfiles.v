`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/19 20:33:27
// Design Name: 
// Module Name: Regfiles
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


module Regfiles(
    input           clk,
    input           rst,
    input           wena,
    input           rena,
    input   [31:0]  wdata,
    input   [4:0]   waddr,
    input   [4:0]   raddr1,
    input   [4:0]   raddr2,
    
    output  [31:0]  rdata1,
    output  [31:0]  rdata2,
    output  [31:0]  answer
    );
    reg [31:0]  array_reg   [31:0];
    integer i;
    always @(posedge clk or posedge rst)begin
        if(rst) begin
            for(i=0;i<=31;i=i+1)
                array_reg[i]<=32'b0;
        end
        else begin
            array_reg[waddr]<=(wena && waddr!=5'b0)?wdata:array_reg[waddr];
        end
    end
    assign rdata1=(rena)?((wena && waddr==raddr1 && waddr!=5'b0)?wdata:array_reg[raddr1]):32'bz;
    assign rdata2=(rena)?((wena && waddr==raddr2 && waddr!=5'b0)?wdata:array_reg[raddr2]):32'bz;
    assign answer=array_reg[16];
endmodule

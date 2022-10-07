`timescale 1ps / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/03/28 15:34:44
// Design Name: 
// Module Name: dram_test
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

module DMEM(
    input                   clk,
    input                   rst,
    input                   wena,
    input                   rena,
    input   [`ADDR_BYTES-1:0] addr,
    input   [31:0]          data_in,
    output  [31:0]          data_out
    );
    reg [31:0] ram_array[0:`MAX_MEMORY];
    integer i;
    always@(posedge clk or posedge rst) begin
        if (rst)begin
            for(i=0;i<=`MAX_MEMORY;i=i+1) begin
                ram_array[i]<=32'b0;
            end
        end
        else begin
            ram_array[addr]=(wena)?data_in:ram_array[addr];
        end
    end
    assign data_out=(rena)?ram_array[addr]:32'bz;
endmodule
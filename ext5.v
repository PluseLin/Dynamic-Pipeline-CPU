`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 16:39:41
// Design Name: 
// Module Name: EXT5
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


module ext5#(parameter WIDTH = 5)(
    input [WIDTH - 1:0] a, 
    input sext,     //sext 有效为符号扩展，否则 0 扩展
    output [31:0] b //32 位输出数据，
);
assign b=sext?{{(32-WIDTH){a[WIDTH-1]}},a}:{{(32-WIDTH){1'b0}},a};
endmodule

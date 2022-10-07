`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/22 20:37:24
// Design Name: 
// Module Name: MUX25
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


module MUX25(
    input       [4:0]  data0,
    input       [4:0]  data1,
    input               s,
    output      [4:0]  out  
    );
    assign out=(s)?data1:data0;
endmodule

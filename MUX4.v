`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 16:32:28
// Design Name: 
// Module Name: MUX4
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


module MUX4(
    input       [31:0]  data0,
    input       [31:0]  data1,
    input       [31:0]  data2,
    input       [31:0]  data3,
    input       [1:0]   s,
    output      [31:0]  out
    );
    assign out= (s==2'b00)?data0:
                (s==2'b01)?data1:
                (s==2'b10)?data2:
                data3;
endmodule

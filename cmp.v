`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/22 16:10:50
// Design Name: 
// Module Name: cmp
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


module cmp(
    input   [31:0]  num1,
    input   [31:0]  num2,
    input           cmp_equal,
    
    output          is_branch
    );
    reg     res;
    always @ * begin
        //beq use it
        if(cmp_equal) begin
            res=(num1==num2);
        end
        //bne use it
        else begin
            res=(num1!=num2);
        end
    end
    assign is_branch=res;
endmodule

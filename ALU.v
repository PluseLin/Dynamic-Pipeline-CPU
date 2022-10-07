`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/13 13:28:39
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] a,
    input [31:0] b,
    input [3:0] aluc,
    output [31:0] r,
    output zero,
    output carry,
    output negative,
    output overflow
    );
parameter
    addu=4'd0,
    add =4'd2,
    subu=4'd1,
    sub =4'd3,
    _and=4'd4,
    _or =4'd5,
    _xor=4'd6,
    _nor=4'd7,
    lui1=4'd8,
    lui2=4'd9,
    sltu=4'd10,
    slt =4'd11,
    sra =4'd12,
    srl =4'd13,
    sll =4'd14,
    slr =4'd15;
reg signed  [31:0]res;
reg         [32:0]sres;
wire signed [31:0]sa=a,sb=b;
always @ (*)begin
    sres=33'b0;
    case(aluc)
        add:begin
            res<=a+b;sres<={sa[31],sa}+{sb[31],sb};
        end
        addu:begin
            res<=sa+sb;
        end
        sub:begin
            res<=a-b;sres<={sa[31],sa}-{sb[31],sb};
        end
        subu:begin
            res<=sa-sb;
        end
        _and:begin
            res<=a&b;
        end
        _or:begin
            res<=a|b;
        end
        _xor:begin
            res<=a^b;
        end
        _nor:begin
            res<=~(a|b);
        end
        lui1:begin
            res<={b[15:0],16'b0};
        end
        lui2:begin
            res<={b[15:0],16'b0};
        end
        slt:begin
            res<=(sa<sb)?32'b1:32'b0;
        end
        sltu:begin
            res<=(a<b)?32'b1:32'b0;
        end
        sra:begin
            res<=sb>>>a[4:0];
        end
        sll,slr:begin
            res<=b<<a[4:0];
        end
        srl:begin
            res<=b>>a[4:0];
        end
        default:begin
            res<=32'b0;
        end
    endcase
end
assign r=res[31:0];
assign zero=(aluc==slt||aluc==sltu)?((a==b)?1'b1:1'b0):((r==32'b0)?1'b1:1'b0);
assign carry=(aluc==addu||aluc==subu||aluc==sltu||aluc==sra||aluc==sll||aluc==srl)?res[31]:1'b0;
assign negative=(aluc==slt)?((res==32'b1)?1'b1:1'b0):(res[31]);
assign overflow=(aluc==add||aluc==sub)?(sres[32]^sres[31]):1'b0;
endmodule

`timescale 1ns / 1ps

module FullAdder(
i_x,
i_y,
i_cin,
o_sum,
o_cout
);

input i_x, i_y, i_cin;
output o_sum, o_cout;

assign {o_cout, o_sum} = {1'b0, i_x} + {1'b0, i_y} + {1'b0, i_cin};

endmodule

module RippleAdder8 (
    input  [7:0] A,
    input  [7:0] B,
    input        i_cin,
    output [7:0] o_sum,
    output       o_cout
);

    wire [6:0] carry;

    FullAdder fa0 (.i_x(A[0]), .i_y(B[0]), .i_cin(i_cin),   .o_sum(o_sum[0]), .o_cout(carry[0]));
    FullAdder fa1 (.i_x(A[1]), .i_y(B[1]), .i_cin(carry[0]), .o_sum(o_sum[1]), .o_cout(carry[1]));
    FullAdder fa2 (.i_x(A[2]), .i_y(B[2]), .i_cin(carry[1]), .o_sum(o_sum[2]), .o_cout(carry[2]));
    FullAdder fa3 (.i_x(A[3]), .i_y(B[3]), .i_cin(carry[2]), .o_sum(o_sum[3]), .o_cout(carry[3]));
    FullAdder fa4 (.i_x(A[4]), .i_y(B[4]), .i_cin(carry[3]), .o_sum(o_sum[4]), .o_cout(carry[4]));
    FullAdder fa5 (.i_x(A[5]), .i_y(B[5]), .i_cin(carry[4]), .o_sum(o_sum[5]), .o_cout(carry[5]));
    FullAdder fa6 (.i_x(A[6]), .i_y(B[6]), .i_cin(carry[5]), .o_sum(o_sum[6]), .o_cout(carry[6]));
    FullAdder fa7 (.i_x(A[7]), .i_y(B[7]), .i_cin(carry[6]), .o_sum(o_sum[7]), .o_cout(o_cout));

endmodule

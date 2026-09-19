`timescale 1ns / 1ps

module ALU (
    input  [7:0] a, b,
    input        s0, s1, s2, s3, s4,
    output [7:0] o,
    output       cout
);

    wire [7:0] add_o, and_o;
    wire       inv_s4;
    wire [7:0] rep_s4, xor_b, b_in;

    // 1. s4 -> inv -> replicate (8비트)
    assign inv_s4 = ~s4;
    Repulicate   u_rep (.a(inv_s4), .o(rep_s4));

    // 2. b ^ s3 (s3=1이면 b의 보수)
    BitwiseXor   u_xor (.a(b), .en(s3), .o(xor_b));

    // 3. 1과 2를 AND -> RippleAdder8의 B 입력
    BitwiseAnd   u_bin (.a(rep_s4), .b(xor_b), .o(b_in));

    RippleAdder8 u_add (.A(a), .B(b_in), .i_cin(s2), .o_sum(add_o), .o_cout(cout));
    BitwiseAnd   u_and (.a(a), .b(b), .o(and_o));

    // mux 입력: 0=add, 1=and, 2=a, 3=b (선택은 {s1, s0})
    mux4x1 u_mux (.a(add_o), .b(and_o), .c(a), .d(b), .s0(s0), .s1(s1), .o(o));

endmodule

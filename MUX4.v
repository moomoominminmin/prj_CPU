`timescale 1ns / 1ps

module mux2x1 (
    input  a, b, s,
    output o
);

    assign o = s ? b : a;

endmodule

module mux4to1 (
    input  a, b, c, d,
    input  [1:0] s,
    output o
);

    wire lo, hi;

    // 1단: s[0]으로 (a,b), (c,d) 각각 선택
    mux2x1 m_lo (.a(a), .b(b), .s(s[0]), .o(lo));
    mux2x1 m_hi (.a(c), .b(d), .s(s[0]), .o(hi));

    // 2단: s[1]으로 최종 선택
    mux2x1 m_out (.a(lo), .b(hi), .s(s[1]), .o(o));

endmodule

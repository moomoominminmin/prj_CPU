`timescale 1ns / 1ps

module mux2x1 (
    input  a, b, s,
    output o
);

    assign o = s ? b : a;

endmodule

module mux4x1 (
    input  [7:0] a, b, c, d,
    input        s0, s1,
    output [7:0] o
);

    wire [7:0] lo, hi;

    // 비트마다 mux2x1 3개씩 (총 8비트)
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : g_bit
            // 1단: s0으로 (a,b), (c,d) 각각 선택
            mux2x1 m_lo (.a(a[i]), .b(b[i]), .s(s0), .o(lo[i]));
            mux2x1 m_hi (.a(c[i]), .b(d[i]), .s(s0), .o(hi[i]));

            // 2단: s1로 최종 선택
            mux2x1 m_out (.a(lo[i]), .b(hi[i]), .s(s1), .o(o[i]));
        end
    endgenerate

endmodule

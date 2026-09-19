module BitwiseXor (
    input  [7:0] a,
    input        en,
    output [7:0] o
);

    assign o = a ^ {8{en}};   // en=1이면 전체 반전, en=0이면 그대로

endmodule

`timescale 1ns / 1ps

module tb_MUX4;

    reg        a, b, c, d;
    reg  [1:0] s;
    wire       o;

    integer i;
    integer errors;
    reg     expected;

    mux4to1 dut (
        .a (a),
        .b (b),
        .c (c),
        .d (d),
        .s (s),
        .o (o)
    );

    task check;
        begin
            case (s)
                2'b00: expected = a;
                2'b01: expected = b;
                2'b10: expected = c;
                2'b11: expected = d;
            endcase
            #1;
            if (o !== expected) begin
                errors = errors + 1;
                $display("FAIL: a=%b b=%b c=%b d=%b s=%b -> o=%b (expected %b)",
                          a, b, c, d, s, o, expected);
            end else begin
                $display("PASS: a=%b b=%b c=%b d=%b s=%b -> o=%b",
                          a, b, c, d, s, o);
            end
        end
    endtask

    initial begin
        errors = 0;

        // 전수 테스트: {s, d, c, b, a} 6비트 = 64가지
        for (i = 0; i < 64; i = i + 1) begin
            {s, d, c, b, a} = i[5:0];
            #10;
            check;
        end

        if (errors == 0) $display("TEST DONE: ALL PASS");
        else             $display("TEST DONE: %0d FAIL", errors);
        $finish;
    end

endmodule

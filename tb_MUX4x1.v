`timescale 1ns / 1ps

module tb_MUX4x1;

    reg  [7:0] a, b, c, d;
    reg        s0, s1;
    wire [7:0] o;

    integer i;
    integer errors;
    reg  [7:0] expected;

    mux4x1 dut (
        .a  (a),
        .b  (b),
        .c  (c),
        .d  (d),
        .s0 (s0),
        .s1 (s1),
        .o  (o)
    );

    task check;
        begin
            case ({s1, s0})
                2'b00: expected = a;
                2'b01: expected = b;
                2'b10: expected = c;
                2'b11: expected = d;
            endcase
            #1;
            if (o !== expected) begin
                errors = errors + 1;
                $display("FAIL: a=%h b=%h c=%h d=%h s=%b%b -> o=%h (expected %h)",
                          a, b, c, d, s1, s0, o, expected);
            end else begin
                $display("PASS: a=%h b=%h c=%h d=%h s=%b%b -> o=%h",
                          a, b, c, d, s1, s0, o);
            end
        end
    endtask

    initial begin
        errors = 0;

        // 입력 조합이 너무 많아(2^34) 전수 대신 랜덤 테스트, 선택 4가지를 골고루
        for (i = 0; i < 100; i = i + 1) begin
            a = $random;
            b = $random;
            c = $random;
            d = $random;
            {s1, s0} = i[1:0];
            #10;
            check;
        end

        if (errors == 0) $display("TEST DONE: ALL PASS");
        else             $display("TEST DONE: %0d FAIL", errors);
        $finish;
    end

endmodule

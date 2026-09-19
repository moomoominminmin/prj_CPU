`timescale 1ns / 1ps

module tb_RippleCarryAdder8;

    reg  [7:0] a;
    reg  [7:0] b;
    reg        cin;
    wire [7:0] sum;
    wire       cout;

    integer i;
    reg  [8:0] expected;

    RippleCarryAdder8 dut (
        .a    (a),
        .b    (b),
        .cin  (cin),
        .sum  (sum),
        .cout (cout)
    );

    task check;
        begin
            expected = a + b + cin;
            #1;
            if ({cout, sum} !== expected) begin
                $display("FAIL: a=%d b=%d cin=%d -> sum=%d cout=%b (expected sum=%d cout=%b)",
                          a, b, cin, sum, cout, expected[7:0], expected[8]);
            end else begin
                $display("PASS: a=%d b=%d cin=%d -> sum=%d cout=%b",
                          a, b, cin, sum, cout);
            end
        end
    endtask

    initial begin
        // 기본 케이스
        a = 8'd0;   b = 8'd0;   cin = 1'b0; #10; check;
        a = 8'd1;   b = 8'd1;   cin = 1'b0; #10; check;
        a = 8'd15;  b = 8'd17;  cin = 1'b0; #10; check;
        a = 8'd255; b = 8'd1;   cin = 1'b0; #10; check;   // overflow -> cout=1
        a = 8'd255; b = 8'd255; cin = 1'b1; #10; check;   // overflow -> cout=1
        a = 8'd128; b = 8'd127; cin = 1'b0; #10; check;
        a = 8'd0;   b = 8'd0;   cin = 1'b1; #10; check;

        // 랜덤 테스트
        for (i = 0; i < 20; i = i + 1) begin
            a   = $random;
            b   = $random;
            cin = $random;
            #10;
            check;
        end

        $display("TEST DONE");
        $finish;
    end

endmodule

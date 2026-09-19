`timescale 1ns / 1ps

module tb_RippleAdder8;

    reg  [7:0] A;
    reg  [7:0] B;
    reg        i_cin;
    wire [7:0] o_sum;
    wire       o_cout;

    integer i;
    reg  [8:0] expected;

    RippleAdder8 dut (
        .A      (A),
        .B      (B),
        .i_cin  (i_cin),
        .o_sum  (o_sum),
        .o_cout (o_cout)
    );

    task check;
        begin
            expected = A + B + i_cin;
            #1;
            if ({o_cout, o_sum} !== expected) begin
                $display("FAIL: A=%d B=%d cin=%d -> sum=%d cout=%b (expected sum=%d cout=%b)",
                          A, B, i_cin, o_sum, o_cout, expected[7:0], expected[8]);
            end else begin
                $display("PASS: A=%d B=%d cin=%d -> sum=%d cout=%b",
                          A, B, i_cin, o_sum, o_cout);
            end
        end
    endtask

    initial begin
        // 기본 케이스
        A = 8'd0;   B = 8'd0;   i_cin = 1'b0; #10; check;
        A = 8'd1;   B = 8'd1;   i_cin = 1'b0; #10; check;
        A = 8'd15;  B = 8'd17;  i_cin = 1'b0; #10; check;
        A = 8'd255; B = 8'd1;   i_cin = 1'b0; #10; check;   // overflow -> cout=1
        A = 8'd255; B = 8'd255; i_cin = 1'b1; #10; check;   // overflow -> cout=1
        A = 8'd128; B = 8'd127; i_cin = 1'b0; #10; check;
        A = 8'd0;   B = 8'd0;   i_cin = 1'b1; #10; check;

        // 랜덤 테스트
        for (i = 0; i < 20; i = i + 1) begin
            A     = $random;
            B     = $random;
            i_cin = $random;
            #10;
            check;
        end

        $display("TEST DONE");
        $finish;
    end

endmodule

`timescale 1ns / 1ps

module tb_HalfAdder;

    reg  a;
    reg  b;
    wire sum;
    wire cout;

    reg [1:0] expected;

    HalfAdder dut (
        .a    (a),
        .b    (b),
        .sum  (sum),
        .cout (cout)
    );

    task check;
        begin
            expected = a + b;
            #1;
            if ({cout, sum} !== expected) begin
                $display("FAIL: a=%b b=%b -> sum=%b cout=%b (expected sum=%b cout=%b)",
                          a, b, sum, cout, expected[0], expected[1]);
            end else begin
                $display("PASS: a=%b b=%b -> sum=%b cout=%b", a, b, sum, cout);
            end
        end
    endtask

    initial begin
        a = 1'b0; b = 1'b0; #10; check;
        a = 1'b0; b = 1'b1; #10; check;
        a = 1'b1; b = 1'b0; #10; check;
        a = 1'b1; b = 1'b1; #10; check;

        $display("TEST DONE");
        $finish;
    end

endmodule

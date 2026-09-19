`timescale 1ns / 1ps

module tb_ALU;

    reg  [7:0] a, b;
    reg        s0, s1, s2, s3, s4;
    wire [7:0] o;
    wire       cout;

    integer i, j;
    integer errors;
    reg  [7:0] b_in;
    reg  [8:0] sum;
    reg  [7:0] exp_o;
    reg        exp_cout;

    ALU dut (
        .a    (a),
        .b    (b),
        .s0   (s0),
        .s1   (s1),
        .s2   (s2),
        .s3   (s3),
        .s4   (s4),
        .o    (o),
        .cout (cout)
    );

    task check;
        begin
            // 기대값: s4=1이면 B=0, 아니면 b ^ s3, 덧셈기 cin=s2
            b_in = s4 ? 8'h00 : (b ^ {8{s3}});
            sum  = a + b_in + s2;

            case ({s1, s0})
                2'b00: exp_o = sum[7:0];
                2'b01: exp_o = a & b;
                2'b10: exp_o = a;
                2'b11: exp_o = b;
            endcase
            exp_cout = sum[8];

            #1;
            if ({cout, o} !== {exp_cout, exp_o}) begin
                errors = errors + 1;
                $display("FAIL: a=%d b=%d s4..s0=%b%b%b%b%b -> o=%d cout=%b (expected o=%d cout=%b)",
                          a, b, s4, s3, s2, s1, s0, o, cout, exp_o, exp_cout);
            end else begin
                $display("PASS: a=%d b=%d s4..s0=%b%b%b%b%b -> o=%d cout=%b",
                          a, b, s4, s3, s2, s1, s0, o, cout);
            end
        end
    endtask

    task apply;
        input [7:0] ta, tb;
        input [4:0] ts;   // {s4, s3, s2, s1, s0}
        begin
            a = ta; b = tb;
            {s4, s3, s2, s1, s0} = ts;
            #10;
            check;
        end
    endtask

    initial begin
        errors = 0;

        // 기본 동작 (선택 신호: s4 s3 s2 s1 s0)
        apply(8'd10,  8'd20,  5'b00000);   // a + b = 30
        apply(8'd200, 8'd100, 5'b00000);   // 오버플로 -> cout=1
        apply(8'd50,  8'd20,  5'b01100);   // a - b = 30 (b 반전 + cin=1)
        apply(8'd20,  8'd50,  5'b01100);   // a - b < 0 (2의 보수 결과)
        apply(8'd10,  8'd20,  5'b10000);   // s4=1 -> B=0 -> a + 0 = 10
        apply(8'd255, 8'd1,   5'b00100);   // a + b + 1 = 257 -> cout=1
        apply(8'hF0,  8'h3C,  5'b00001);   // AND
        apply(8'hA5,  8'h5A,  5'b00010);   // a 통과
        apply(8'hA5,  8'h5A,  5'b00011);   // b 통과

        // 선택 신호 32가지 x 랜덤 입력 20개
        for (i = 0; i < 32; i = i + 1) begin
            for (j = 0; j < 20; j = j + 1) begin
                apply($random, $random, i[4:0]);
            end
        end

        if (errors == 0) $display("TEST DONE: ALL PASS");
        else             $display("TEST DONE: %0d FAIL", errors);
        $finish;
    end

endmodule

`timescale 1ns/1ps

module tb_ALU;
    reg  [7:0] A, B;
    reg  [4:0] S;
    wire [7:0] Z;
    wire Cout, Zero;

    ALU dut(.A(A), .B(B), .S(S), .Z(Z), .Cout(Cout), .Zero(Zero));

    task show(input [127:0] name);
        begin
            #1;
            $display("%-12s S=%b%b%b%b%b  A=%3d B=%3d -> Z=%3d Cout=%b Zero=%b",
                      name, S[4],S[3],S[2],S[1],S[0], A, B, Z, Cout, Zero);
        end
    endtask

    initial begin
        A = 123; B = 45;

        S = 5'b00000; show("ADD");         // 123+45 = 168
        S = 5'b00001; show("AND");         // 123&45
        S = 5'b00010; show("INPUT A");     // 123
        S = 5'b00011; show("INPUT B");     // 45
        S = 5'b01100; show("SUBTRACT");    // 123-45 = 78
        S = 5'b10100; show("INCREMENT");   // 123+1 = 124  (B 무시)
        S = 5'b10000; show("INPUT A(2)");  // 123
        S = 5'b00100; show("ADD+1");       // 123+45+1 = 169
        S = 5'b01000; show("SUB-1");       // 123-45-1 = 77

        // overflow / carry 확인
        A = 250; B = 10;
        S = 5'b00000; show("ADD ovf");     // 250+10=260 -> Z=4, Cout=1

        // zero flag 확인
        A = 45; B = 45;
        S = 5'b01100; show("SUB=0");       // 45-45=0 -> Zero=1

        $finish;
    end
endmodule

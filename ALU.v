// =============================================================
//  8-bit ALU  (Simple CPU v1 문서 Figure 12/13/15/16/18 기반)
// -------------------------------------------------------------
//  구조:
//    1) bitwise_inv  : B를 XOR로 선택적 반전 (뺄셈용 2의보수 준비)
//    2) mask (AND)   : B를 0으로 만듦 (INC 등에서 사용)
//    3) ripple adder : A + B_masked + Cin
//    4) bitwise AND  : A & B (원본 입력 기준)
//    5) 4:1 MUX      : S1,S0 으로 ADD / AND / A / B 결과 중 선택
//
//  제어신호 S[4:0] = {S4,S3,S2,S1,S0}
//    S3 : 1이면 B를 반전(뺄셈 준비)
//    S4 : 1이면 B를 0으로 마스킹 (INC 등에서 사용)
//    S2 : 가산기 Cin (캐리인)으로 직접 연결
//    S1,S0 : 최종 4:1 MUX 선택
//        00 -> 가산기 결과 (ADD/SUB/INC 등)
//        01 -> A AND B
//        10 -> A 통과
//        11 -> B 통과
//
//  기능표 (문서 Figure 18 그대로 재현됨):
//    S4 S3 S2 S1 S0 | 기능
//     0  0  0  0  0 | ADD        (A+B)
//     0  0  0  0  1 | AND        (A&B)
//     0  0  0  1  0 | INPUT A
//     0  0  0  1  1 | INPUT B
//     0  1  1  0  0 | SUBTRACT   (A-B)
//     1  0  1  0  0 | INCREMENT  (A+1)
//     1  0  0  0  0 | INPUT A    (B가 0으로 마스킹되어 결과적으로 A)
//     0  0  1  0  0 | ADD+1      ((A+B)+1)
//     0  1  0  0  0 | SUB-1      ((A-B)-1)
// =============================================================

module alu_8bit (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire [4:0] S,      // {S4,S3,S2,S1,S0}
    output wire [7:0] Z,
    output wire        Cout,
    output wire        Zero
);

    wire S0 = S[0];
    wire S1 = S[1];
    wire S2 = S[2];
    wire S3 = S[3];
    wire S4 = S[4];

    // ---- 1) B 반전 (bitwise_inv_v1, Figure 13) ----
    // S3=1 이면 B의 각 비트를 XOR로 반전 (2의 보수 준비 단계)
    wire [7:0] B_inv = B ^ {8{S3}};

    // ---- 2) B 마스킹 (replicate_v1 + bitwise_and_v1, Figure 15/16) ----
    // S4=1 이면 B를 전부 0으로 만든다 (INC에서 사용)
    wire [7:0] B_masked = B_inv & {8{~S4}};

    // ---- 3) 8비트 리플 캐리 가산기 (Figure 12) ----
    // Cin은 S2를 그대로 사용 (뺄셈시 +1, INC시 +1 역할)
    wire [8:0] adder_result = {1'b0, A} + {1'b0, B_masked} + {8'b0, S2};
    wire [7:0] add_sub_result = adder_result[7:0];
    wire       adder_cout     = adder_result[8];

    // ---- 4) 비트단위 AND (bitwise_and_v1, Figure 16) ----
    wire [7:0] and_result = A & B;

    // ---- 5) 최종 4:1 MUX (S1,S0 선택) ----
    reg [7:0] Z_reg;
    always @(*) begin
        case ({S1, S0})
            2'b00: Z_reg = add_sub_result; // ADD / SUB / INC 등 (가산기 결과)
            2'b01: Z_reg = and_result;     // AND
            2'b10: Z_reg = A;              // INPUT A
            2'b11: Z_reg = B;              // INPUT B
            default: Z_reg = 8'bx;
        endcase
    end

    assign Z    = Z_reg;
    // Cout은 가산기 경로(ADD/SUB/INC)를 선택했을 때만 의미가 있음
    assign Cout = adder_cout;
    // Zero 플래그: 결과가 0이면 1 (8bit NOR, 문서의 ZERO 신호)
    assign Zero = (Z_reg == 8'b0);

endmodule
module ALU #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input  [2:0]        op,      // 연산 선택
    output reg [WIDTH-1:0] result,
    output              zero     // result가 0이면 1
);

    localparam ADD = 3'b000;
    localparam SUB = 3'b001;
    localparam AND = 3'b010;
    localparam OR  = 3'b011;
    localparam XOR = 3'b100;
    localparam NOT = 3'b101;
    localparam SLL = 3'b110;   // shift left logical
    localparam SRL = 3'b111;   // shift right logical

    always @(*) begin
        case (op)
            ADD: result = a + b;
            SUB: result = a - b;
            AND: result = a & b;
            OR : result = a | b;
            XOR: result = a ^ b;
            NOT: result = ~a;
            SLL: result = a << b[2:0];
            SRL: result = a >> b[2:0];
            default: result = {WIDTH{1'b0}};
        endcase
    end

    assign zero = (result == {WIDTH{1'b0}});

endmodule

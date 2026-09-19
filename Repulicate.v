module Repulicate (
    input a,
    output [7:0] o
);

    assign o = {8{a}};

endmodule

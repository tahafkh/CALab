`timescale 1ns/1ns
module mux2_32(
    input [31:0] a, b,
    input s,
    output [31:0] w
);
    assign w = s ? b : a;
endmodule
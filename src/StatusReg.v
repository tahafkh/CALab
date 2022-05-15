`timescale 1ns/1ns
module StatusReg(
    input clk, rst, s,
    input [3:0] status_in,
    output reg [3:0] status_out
);
    always@(negedge clk, posedge rst) begin
        if (rst == 1'b1)
            status_out <= 4'd0;
        else if (s)
            status_out <= status_in;
    end
endmodule
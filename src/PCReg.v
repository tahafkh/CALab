`timescale 1ns/1ns
module PC_reg(
    input clk, rst, freeze,
    input [31:0] next_pc,
    output reg [31:0] pc
);
    always @(posedge clk, posedge rst) begin
		if (rst == 1'b1)
			pc <= 32'd0;
		else if (freeze == 1'b0)
			pc <= next_pc;
    end
endmodule

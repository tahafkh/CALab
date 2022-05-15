`timescale 1ns/1ns
module IF_reg(
    input clk, rst, freeze, flush,
    input [31:0] pc_in, instruction_in,
    output reg [31:0] pc, instruction
);
    always@(posedge clk, posedge rst) begin
		if (rst == 1'b1) begin
			pc <= 32'd0;
			instruction <= 32'd0;
		end
		else begin
		  if (flush && (freeze == 1'b0))
				pc <= 32'd0;
		  else if (freeze == 1'b0) begin
				pc <= pc_in;
			instruction <= instruction_in;
		  end
	  end
	 end
endmodule
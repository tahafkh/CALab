`timescale 1ns/1ns

module register #(parameter n = 16) (input clk, rst, ld, input[n-1:0] in, 
										output reg[n-1:0] out);

    always @(posedge clk, posedge rst) begin
		if(rst)
            out <= 'd0;
		else if(ld)
            out <= in;
	end

endmodule
 
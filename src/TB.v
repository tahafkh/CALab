`timescale 1ns/1ns
module tb();
    reg clk, rst, forward_en;
    ARM arm(clk, rst, forward_en);
    
    initial begin
		forward_en = 0;
		#10 clk = 0;
		rst = 1;
		#10 rst = 0;
		repeat(1000) begin
			#10 clk = ~clk;
		end
	end
	
endmodule
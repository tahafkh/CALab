`timescale 1ns/1ns

module tb();

	wire[15:0] SRAM_DQ;
	wire[17:0] SRAM_ADDR;
	wire SRAM_WE_N;

    reg clk, rst, forward_en;
    ARM arm(clk, rst, forward_en, SRAM_DQ, SRAM_ADDR, SRAM_WE_N);
	SRAM SRAM (clk, rst, SRAM_WE_N, SRAM_ADDR, SRAM_DQ);

    initial begin
		forward_en = 0;
		#10 clk = 0;
		rst = 1;
		#10 rst = 0;
		repeat(10000) begin
			#10 clk = ~clk;
		end
	end
	
endmodule
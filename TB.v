module TB();

	reg clk = 1'b0, rst = 1'b0;

	ARM arm(.clk(clk), .rst(rst));

    always #50 clk = ~clk;

	initial begin
		#150
		rst = 1'b1;
		#100
		rst = 1'b0;
        #10000 $stop;
	end

endmodule 

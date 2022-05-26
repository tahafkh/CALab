`timescale 1ns/1ns
module alutb();
    reg [31:0] val1, val2;
    reg [3:0] exe_cmd;
    reg c;
    reg [3:0] state_out;
    reg [31:0] out;
    ALU alu(val1, val2, exe_cmd, c, state_out, out);
    
    initial begin
		val1 = 32'b01111111111111111111111111111111;
        val2 = 32'b01111111111111111111111111111111;
        c = 1'b1;
        #10 exe_cmd = 4'b0001;
        #10 exe_cmd = 4'b1001;
        #10 exe_cmd = 4'b0010;
        #10 exe_cmd = 4'b0011;
        #10 exe_cmd = 4'b0100;
        #10 exe_cmd = 4'b0101;
        #10 exe_cmd = 4'b0110;
        #10 exe_cmd = 4'b0111;
        #10 exe_cmd = 4'b1000;
        #10 exe_cmd = 4'b0100;
        #10 exe_cmd = 4'b0110;
        #10 exe_cmd = 4'b0010;
        #10 exe_cmd = 4'b0010;
	end
	
endmodule
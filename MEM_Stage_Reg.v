module MEM_Stage_Reg (
    input clk,
	input rst,
	input [31:0] PC_in,
	output reg[31:0] PC
);

	always @(posedge clk, posedge rst) 
        if (rst)
            PC <= 'd0;
        else
            PC <= PC_in;
			
endmodule

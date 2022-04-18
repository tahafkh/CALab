module EXE_Stage_Reg (
	input clk, rst,
	input [32 - 1 : 0] PC_in,
	input WB_EN_IN, MEM_R_IN, MEM_W_IN,
	input [32 - 1 : 0] ALU_Res_in, Val_Rm_in,
	input [4 - 1 : 0] Dest_in,

	output reg[32 - 1 : 0] PC,
	output reg WB_EN, MEM_R_EN, MEM_W_EN,
	output reg [32 - 1 : 0] ALU_Res, Val_Rm,
	output reg [4 - 1 : 0] Dest
);
	always @(posedge clk, posedge rst) 
        if (rst) begin
            PC <= 'd0;
			{WB_EN, MEM_R_EN, MEM_W_EN} <= 'd0;
			{ALU_Res, Val_Rm} <= 'd0;
			Dest <= 'd0;
		end
        else begin
            PC <= PC_in;
			{WB_EN, MEM_R_EN, MEM_W_EN} <= {WB_EN_IN, MEM_R_IN, MEM_W_IN};
			{ALU_Res, Val_Rm} <= {ALU_Res_in, Val_Rm_in};
			Dest <= Dest_in;
		end
endmodule

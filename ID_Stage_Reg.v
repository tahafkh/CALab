module ID_Stage_Reg(
	input clk, rst, flush,

	input MEM_R_EN_in, MEM_W_EN_in, WB_EN_in,
	input B_in, S_in,
    input [4 - 1:0] EXE_CMD_in,

	input [31:0] VAL_Rn_in, VAL_Rm_in,

	input[32 - 1: 0] PC_in,

	input [4 - 1:0] Dest_in,
	input [23:0] Signed_imm_in,
	input imm_in,
	input [12 - 1:0] Shift_operand_in,

	input [3:0] status_register_in,

	output reg MEM_R_EN, MEM_W_EN, WB_EN,
	output reg B, S,
	output reg [4 - 1:0] EXE_CMD,
    
	output reg [31:0] VAL_Rn, VAL_Rm,

    output reg[32 - 1: 0] PC,
	
	output reg [3:0] Dest,
	output reg [23:0] Signed_imm,
	output reg imm,
	output reg [11:0] Shift_operand,

	output reg [3:0] status_register_out
);
	
	always @(posedge clk, posedge rst) 
        if (rst) begin
			PC <= 32'd0;

			{MEM_R_EN, MEM_W_EN, WB_EN} <= {3'd0};
			{B, S} <= {2'd0};
			EXE_CMD <= 4'd0;

			{VAL_Rn, VAL_Rm} <= {32'd0, 32'd0};

			Dest <= 4'd0;
			Signed_imm <= 24'd0;
			imm <= 1'b0;

			Shift_operand <= 12'd0;
			status_register_out <= 4'd0;
		end
        else begin
			if (flush) begin
				PC <= 32'd0;

                {MEM_R_EN, MEM_W_EN, WB_EN} <= {3'd0};
                {B, S} <= {2'd0};
                EXE_CMD <= 4'd0;

                {VAL_Rn, VAL_Rm} <= {32'd0, 32'd0};

                Dest <= 4'd0;
                Signed_imm <= 24'd0;
                imm <= 1'b0;

                Shift_operand <= 12'd0;
                status_register_out <= 4'd0;
			end
			else begin
			  	PC <= PC_in;
		
        		{MEM_R_EN, MEM_W_EN, WB_EN} <= {MEM_R_EN_in, MEM_W_EN_in, WB_EN_in};
				{B, S} <= {B_in, S_in};
				EXE_CMD <= EXE_CMD_in;
		
        		{VAL_Rn, VAL_Rm} <= {VAL_Rn_in, VAL_Rm_in};
		
				Dest <= Dest_in;
				Signed_imm <= Signed_imm_in;
        		imm <= imm_in;
				Shift_operand <= Shift_operand_in;

				status_register_out <= status_register_in;
            	
			end
		end
endmodule

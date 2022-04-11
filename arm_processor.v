module ARM(input clk, rst);

	wire freeze, Branch_taken, flush, hazard;
	wire[31:0]  BranchAddr,
                instruction_IF, instruction_IF_Reg;

	wire[31:0] 	PC_IF, PC_IF_Reg,
                PC_ID, PC_ID_Reg,
                PC_EX, PC_EX_Reg,
                PC_MEM, PC_MEM_Reg,
                PC_WB;
			
    //---------------Initialization---------------\\

	assign Branch_taken = 1'd0;
	assign freeze = 1'd0;
	assign BranchAddr = 32'd0;
    assign flush = 1'd0;
	assign hazard = 1'b0;

    //---------------Instruction Fetch---------------\\

	IF_Stage if_stage(
		.clk(clk), .rst(rst),
		.freeze(freeze), .Branch_taken(Branch_taken),
		.BranchAddr(BranchAddr),
		.PC(PC_IF),
		.Instruction(instruction_IF)
		);

	IF_Stage_Reg if_stage_reg(.clk(clk), .rst(rst),
			.freeze(freeze), .flush(flush),
			.PC_in(PC_IF), .Instruction_in(instruction_IF),
			.PC(PC_IF_Reg), .Instruction(instruction_IF_Reg));


    //---------------Instruction Decode---------------\\
	
	// other outputs
	wire imm, imm_reg;
	wire[24-1:0] Signed_imm_24, Signed_imm_24_reg;
	wire[12-1:0] Shift_operand, Shift_operand_reg;
	wire[4-1:0] Dest, Dest_reg;
	
	// output of register file
	wire[31:0] Val_Rn, Val_Rm, Val_Rn_reg, Val_Rm_reg;

	// output of control unit mux
	wire MEM_R_EN, MEM_W_EN, WB_EN, MEM_R_EN_reg, MEM_W_EN_reg, WB_EN_reg;
	wire[3:0] EXE_CMD, EXE_CMD_reg;
	wire B, S, B_reg, S_reg;

	ID_Stage id_stage(.clk(clk), .rst(rst), .Hazard(hazard),
		.PC_in(PC_IF_Reg), .Instruction_in(instruction_IF_Reg), .PC(PC_ID),
		.imm(imm),
		.Signed_imm_24(Signed_imm_24),
		.Shift_operand(Shift_operand),
		.Dest(Dest),
		.Val_Rn(Val_Rn),
		.Val_Rm(Val_Rm),
		.MEM_R_EN(MEM_R_EN), .MEM_W_EN(MEM_W_EN), .WB_EN(WB_EN),
		.EXE_CMD(EXE_CMD),
		.B(B), .S(S)
		);

	wire [3:0] status_register;
	assign status_register = 'd0;

	ID_Stage_Reg id_stage_reg(
		.clk(clk), .rst(rst), .flush(flush), 
		.PC_in(PC_ID), .PC(PC_ID_Reg)

		.MEM_R_EN_in(MEM_R_EN), .MEM_W_EN_in(MEM_W_EN), .WB_EN_in,(WB_EN)
		.B_in(B), .S_in(S),
		.EXE_CMD_in(EXE_CMD),

		.VAL_Rn_in(Val_Rn), .VAL_Rm_in(VAL_Rm),

		.Dest_in(Dest),
		.Signed_imm_in(Signed_imm_24),
		.imm_in(imm),
		.Shift_operand_in(Shift_operand),

		.status_register_in(status_register),

		.MEM_R_EN(MEM_R_EN_reg), .MEM_W_EN(MEM_W_EN_reg), .WB_EN,(WB_EN_reg)
		.B(B_reg), .S(S_reg),
		.EXE_CMD(EXE_CMD_reg),

		.VAL_Rn(Val_Rn_reg), .VAL_Rm(VAL_Rm_reg),

		.Dest(Dest_reg),
		.Signed_imm(Signed_imm_24_reg),
		.imm(imm_reg),
		.Shift_operand(Shift_operand_reg),

		.status_register_out()
	);

    //---------------Execution---------------\\

	EXE_Stage exe_stage(.clk(clk), .rst(rst), .PC_in(PC_ID_Reg), .PC(PC_EX));

	EXE_Stage_Reg exe_stage_reg(.clk(clk), .rst(rst), .PC_in(PC_EX), .PC(PC_EX_Reg));

    //---------------Memory---------------\\

	MEM_Stage mem_stage(.clk(clk), .rst(rst), .PC_in(PC_EX_Reg), .PC(PC_MEM));

	MEM_Stage_Reg mem_stage_reg(.clk(clk), .rst(rst), .PC_in(PC_MEM), .PC(PC_MEM_Reg));

    //---------------Write Back---------------\\

	WB_Stage wb_stage(.clk(clk), .rst(rst), .PC_in(PC_MEM_Reg), .PC(PC_WB));

endmodule
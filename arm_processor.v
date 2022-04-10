module ARM(input clk, rst);

	wire freeze, Branch_taken, flush;
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
    assign flub = 1'd0;

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

	ID_Stage id_stage(.clk(clk), .rst(rst), .PC_in(PC_IF_Reg), .PC(PC_ID));

	ID_Stage_Reg id_stage_reg(.clk(clk), .rst(rst), .PC_in(PC_ID), .PC(PC_ID_Reg));

    //---------------Execution---------------\\

	EX_Stage ex_stage(.clk(clk), .rst(rst), .PC_in(PC_ID_Reg), .PC(PC_EX));

	EX_Stage_Reg ex_stage_reg(.clk(clk), .rst(rst), .PC_in(PC_EX), .PC(PC_EX_Reg));

    //---------------Memory---------------\\

	MEM_Stage mem_stage(.clk(clk), .rst(rst), .PC_in(PC_EX_Reg), .PC(PC_MEM));

	MEM_Stage_Reg mem_stage_reg(.clk(clk), .rst(rst), .PC_in(PC_MEM), .PC(PC_MEM_Reg));

    //---------------Write Back---------------\\

	WB_Stage wb_stage(.clk(clk), .rst(rst), .PC_in(PC_MEM_Reg), .PC(PC_WB));

endmodule
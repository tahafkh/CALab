module EXE_Stage (
    input clk,
	input rst,
	input S, MEM_R_EN, MEM_W_EN, WB_EN,
	input [31:0] PC_in,
	input [4 - 1 : 0] EXE_CMD,
	input immediate,
	input [23:0] signed_imm_24,
	input [12 - 1 : 0] shift_operand_in,
	input [32 - 1: 0] Val1, Val_Rm,
	input [3:0] status_register_in, 
	output [32 - 1: 0] PC,
	output [3:0] status_bits,
	output [32 - 1 : 0] ALU_Res,
	output [32 - 1 : 0] branch_address
);
	//-------------PC Register-------------//
	assign PC = PC_in;

	//-------------Val2 Generator-------------//
	wire [32 - 1 : 0] Val2;
	wire is_mem_command;
	assign is_mem_command = MEM_R_EN | MEM_W_EN;

	Val2Generator val2generator(
		.val_rm(Val_Rm),
        .shift_operand(shift_operand_in),
        .immediate(immediate), 
		.is_mem_command(is_mem_command),
        .Val2(Val2)
		);

	//-------------ALU-------------//
	wire [32 - 1 : 0] alu_out;
	wire [3:0] alu_status_bits;
	ALU alu(
    	.Val1(Val1), 
		.Val2(Val2),
    	.alu_command(EXE_CMD),
    	.status_register(status_register_in),
    	.ALU_Res(alu_out),
    	.Status_bits(status_bits)
    );
	assign ALU_Res = alu_out;


	//-------------Branch Address Generation-------------//
	wire [32 - 1 : 0] adder_out;
	wire [32 - 1 : 0] signed_imm_extended = { {8{signed_imm_24[23]}}, signed_imm_24}; 
	assign adder_out = PC_in + (signed_imm_extended << 2);
	assign branch_address = adder_out;

	//-------------Status Register-------------//
	StatusRegister status_register(
		.clk(clk),
		.rst(rst),
		.ld(S),
		.in(alu_status_bits),
		.out(status_bits)
	);

endmodule 

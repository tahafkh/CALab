module ID_Stage (
    input clk,
	input rst,
	input Hazard,
	input [31:0] PC_in,
	input [31:0] Instruction_in,
	output[31:0] PC,

	// other outputs
	output imm,
	output [24-1:0] Signed_imm_24,
	output [12-1:0] Shift_operand,
	output [4-1:0] Dest,
	
	// output of register file
	output [31:0] Val_Rn, Val_Rm,

	// output of control unit mux
	output MEM_R_EN, MEM_W_EN, WB_EN,
	output [3:0] EXE_CMD,
	output B, S
);

	//-----------------IF Stage signals-----------------//
	assign Shift_operand = Instruction_in[11:0]; // 11 is shift operand index
	assign Signed_imm_24 = Instruction_in[23:0];
	assign Dest = Instruction_in[15:12];

	//-----------------Control Unit-----------------//
	wire mem_read, mem_write, wb_enable, branch_taken, status_write_enable;
	wire [3:0] execute_command;

	ControlUnit control_unit(
		.s(Instruction_in[20]),
		.Mode(Instruction_in[27:26]),
		.Opcode(Instruction_in[24:21]),
		.exe_cmd(execute_command), 
		.MEM_R_EN(mem_read), .MEM_W_EN(mem_write),
		.WB_EN(wb_enable),
		.B(branch_taken),
		.S(status_write_enable)
		);

	//-----------------Register File-----------------//
	wire[3:0] src1, src2;
	assign src1 = Instruction_in[19:16];
	assign src2 = mem_write ? Instruction_in[15:12] : Instruction_in[3:0];

	//TODO: Assign these to wires coming from WB Stage
	wire[31:0] WB_Value;
	wire[3:0] WB_Dest;
	wire WB_WB_EN;
	assign WB_Value = 'd13;
	assign WB_Value = 'd7;
	assign WB_WB_EN = 'd0;

	RegisterFile register_file(.clk(clk), .rst(rst),
    		.src1(src1), .src2(src2),
			.WB_Dest(WB_Dest),
			.WB_Value(WB_Value),
    		.WB_EN(WB_WB_EN),
			.Val_Rm(Val_Rm), .Val_Rn(Val_Rn)
	);

	//-----------------PC Register-----------------//
	assign PC = PC_in;
	
	//-----------------Condition Check-----------------//

	wire Cond_state;
	// TODO: Assign status_register to wire coming from the status register
	wire [3:0] status_register;
	assign status_register = 4'b0011;

	Condition_Check condition_check(
		.Cond(Instruction_in[31:28]),
		.stat_reg(status_register),
		.Cond_state(Cond_state)
    );

	//-----------------Control Unit MUX-----------------//
	wire CU_MUX_EN;
	// Needs to be checked in the future
	assign CU_MUX_EN = ~Cond_state | Hazard;

	assign MEM_R_EN = CU_MUX_EN ? mem_read : 1'b0;
	assign MEM_W_EN = CU_MUX_EN ? mem_write : 1'b0;
	assign WB_EN = CU_MUX_EN ? wb_enable : 1'b0;
	assign B = CU_MUX_EN ? branch_taken : 1'b0;
	assign S = CU_MUX_EN ? status_write_enable : 1'b0;
	assign EXE_CMD = CU_MUX_EN ? execute_command : 'd0;

endmodule

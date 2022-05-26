`timescale 1ns/1ns
module EXE_stage(
  input clk, rst,
    input [3:0] exe_cmd_in,
    input [1:0] sel_src1, sel_src2,
    input MEM_R_EN_IN, MEM_W_EN_IN,
    input imm_in, s, c,
    input [11:0] shifter_operand,
    input [23:0] signed_imm_24,
    input [31:0] pc_in, val_rm, val_rn, alu_in, WB_value,
    
    output [31:0] alu_out, branch_address, val_rm_out,
    output [3:0] status_out
);

    wire mem_en;
    wire [31:0] val2, alu_val1, alu_val2;


    assign alu_val1 = sel_src1 == 2'd0 ? val_rn : sel_src1 == 2'd1 ? alu_in : sel_src1 == 2'd2 ? WB_value : alu_val1;
    assign alu_val2 = sel_src2 == 2'd0 ? val_rm : sel_src2 == 2'd1 ? alu_in : sel_src2 == 2'd2 ? WB_value : alu_val2;

    assign val_rm_out = alu_val2;

    ALU alu(alu_val1, val2, exe_cmd_in, c, status_out, alu_out);
    
    or(mem_en, MEM_R_EN_IN, MEM_W_EN_IN);

    Val2Gen val2gen(alu_val2, shifter_operand, imm_in, mem_en, val2);
    
    assign branch_address = {{6{signed_imm_24[23]}},signed_imm_24,2'b0} + pc_in;

endmodule
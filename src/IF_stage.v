`timescale 1ns/1ns
module IF_stage(
    input clk, rst, freeze, branch_taken,
    input [31:0] branch_addr,
    output [31:0] pc, instruction
);
    wire [31:0] pc_inc, pc_out;
    
    mux2_32 mux(pc, branch_addr, branch_taken, pc_inc);
    PC_reg pc_reg(clk, rst, freeze, pc_inc, pc_out);
    InstructionMemory instmem(pc_out, instruction);
    assign pc = pc_out + 32'd4;
endmodule

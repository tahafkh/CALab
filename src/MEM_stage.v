`timescale 1ns/1ns
module MEM_stage(
    input clk, rst,
    input MEM_R_EN, MEM_W_EN, WB_EN,
    input [31:0] alu_res, val_rm,
    input [3:0] Dest,
    output reg MEM_R_EN_out, WB_EN_out,
    output reg [31:0] alu_res_out,
    output [31:0]mem_data_out,
    output reg [3:0] Dest_out
);
  
  Memory memory(
    .clk(clk),
    .MEMread(MEM_R_EN),
    .MEMwrite(MEM_W_EN),
    .address(alu_res),
    .data(val_rm),
    .MEM_result(mem_data_out)
  );
  
  assign MEM_R_EN_out = MEM_R_EN;
  assign WB_EN_out = WB_EN;
  assign alu_res_out = alu_res;
  assign Dest_out = Dest;
  
endmodule
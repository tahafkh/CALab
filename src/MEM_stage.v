`timescale 1ns/1ns

module MEM_stage(
    input clk, rst,
    input MEM_R_EN, MEM_W_EN, WB_EN,
    input [31:0] alu_res, val_rm,
    input [3:0] Dest,
    output MEM_R_EN_out, WB_EN_out,
    output [31:0] alu_res_out,
    output [31:0]mem_data_out,
    output [3:0] Dest_out,
    output sram_ready,
    inout [15:0] SRAM_DQ,
    output [17:0] SRAM_ADDR,
    output SRAM_UB_N,
    output SRAM_LB_N,
    output SRAM_WE_N,
    output SRAM_CE_N,
    output SRAM_OE_N
);

  SRAMController sramCtrl(.clk(clk), .rst(rst), .write_en(MEM_W_EN),
  .read_en(MEM_R_EN), .addr(alu_res), .st_val(val_rm),
  .read_data(mem_data_out), .ready(sram_ready), .SRAM_DQ(SRAM_DQ), .SRAM_ADDR(SRAM_ADDR),
  .SRAM_UB_N(SRAM_UB_N), .SRAM_LB_N(SRAM_LB_N), .SRAM_WE_N(SRAM_WE_N),
  .SRAM_CE_N(SRAM_CE_N), .SRAM_OE_N(SRAM_OE_N));

  // Memory memory(
  //   .clk(clk),
  //   .MEMread(MEM_R_EN),
  //   .MEMwrite(MEM_W_EN),
  //   .address(alu_res),
  //   .data(val_rm),
  //   .MEM_result(mem_data_out)
  // );
  
  assign MEM_R_EN_out = ~sram_ready ? 'd0 : MEM_R_EN;
  assign WB_EN_out = WB_EN;
  assign alu_res_out = alu_res;
  assign Dest_out = Dest;
  
endmodule

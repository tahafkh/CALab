`timescale 1ns/1ns

module ID_stage(
  input clk, rst,
  input [31:0] Instruction,
  input [31:0] Result_WB,
  input writeBackEn,
  input [3:0] Dest_wb,
  input hazard,
  input [3:0] SR,
  
  output WB_EN, MEM_R_EN, MEM_W_EN, B, S,
  output [3:0] EXE_CMD,
  output [31:0] Val_Rn, Val_Rm,
  output imm,
  output [11:0] Shift_operand,
  output [23:0] Signed_imm_24,
  output [3:0] Dest,
  output [3:0] src1, src2,
  output Two_src
);
  
  assign src1 = Instruction[19:16];
  assign src2 = MEM_W_EN ? Instruction[15:12] : Instruction[3:0];
  assign imm = Instruction[25];
  assign Shift_operand = Instruction[11:0];
  assign Signed_imm_24 = Instruction[23:0];
  assign Dest = Instruction[15:12];


  or(Two_src, MEM_W_EN, ~imm);
  
  RegisterFile RegFile(
  .clk(clk),
  .rst(rst),
  .src1(src1),
  .src2(src2),
  .Dest_wb(Dest_wb),
  .Result_WB(Result_WB),
  .writeBackEn(writeBackEn),
  .reg1(Val_Rn),
  .reg2(Val_Rm)
);

  wire B_before, WB_EN_before, MEM_R_EN_before, MEM_W_EN_before;
  wire [3:0] EXE_CMD_before;
  wire S_before;

  ControlUnit CtrlUnit(
  .s(Instruction[20]),
  .mode(Instruction[27:26]),
  .opcode(Instruction[24:21]),
  .B_jump(B_before),
  .wb_en(WB_EN_before),
  .mem_rd(MEM_R_EN_before),
  .mem_wr(MEM_W_EN_before),
  .exec_cmd(EXE_CMD_before),
  .s_out(S_before)
  );
  
  wire cond_sel;
  
  ConditionCheck CondCheck(
  .cond(Instruction[31:28]),
  .sr(SR),
  .out(cond_sel)
  );
  
  wire after_hazard_mux_sel;
  
  or before_mux_sel(after_hazard_mux_sel, ~cond_sel, hazard);
  
  assign B = (~after_hazard_mux_sel) ? B_before : 0;
  assign WB_EN = (~after_hazard_mux_sel) ? WB_EN_before : 0;
  assign MEM_R_EN = (~after_hazard_mux_sel) ? MEM_R_EN_before : 0;
  assign MEM_W_EN = (~after_hazard_mux_sel) ? MEM_W_EN_before : 0;
  assign EXE_CMD = (~after_hazard_mux_sel) ? EXE_CMD_before : 0;
  assign S = (~after_hazard_mux_sel) ? S_before : 0;

endmodule

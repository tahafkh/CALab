`timescale 1ns/1ns
module ARM(
    input clk, rst, forward_en
);
  wire B;
  wire [31:0] branch_addr, 
      if_pc_out, if_inst_out, if_reg_pc_out, if_reg_inst_out, 
      id_pc_out, id_reg_pc_out, exe_pc_out, exe_reg_pc_out,
      mem_pc_out, mem_reg_pc_out, wb_pc_out, wb_reg_pc_out;
    
  wire hazard;

  IF_stage if_stage(clk, rst, hazard, B, branch_addr, if_pc_out, if_inst_out);
  IF_reg if_reg(clk, rst, hazard, B, if_pc_out, if_inst_out, if_reg_pc_out, if_reg_inst_out);
    
  wire WB_EN_before, MEM_R_EN_before, MEM_W_EN_IN_before, B_IN_before, S_IN_before;
  wire [3:0] EXE_CMD_IN_before;
  wire [31:0] Val_Rn_IN_before;
  wire [31:0] Val_Rm_IN_before;
  wire imm_IN_before;
  wire [11:0] Shift_operand_IN_before;
  wire [23:0] Signed_imm_24_IN_before;
  wire [3:0] Dest_IN_before;
    
  wire [31:0] Result_WB;
  wire [3:0] Dest_wb;
  wire [3:0] SR;
  
  wire WB_EN, MEM_R_EN, MEM_W_EN, S;
  wire [3:0] EXE_CMD;
  wire [31:0] Val_Rn;
  wire [31:0] Val_Rm;
  wire imm;
  wire [11:0] Shift_operand;
  wire [23:0] Signed_imm_24;
  wire [3:0] Dest;
  
  wire ID_reg_C_out;
  
  wire [3:0] src1, id_reg_src1_out;
  wire [3:0] src2, id_reg_src2_out;
  wire Two_src;

  wire [31:0] exe_alu_out;
  wire EXE_reg_WB_en_out, EXE_reg_MEM_R_EN_out, EXE_reg_MEM_W_EN_out;
  wire [31:0] exe_reg_alu_out, exe_reg_ST_val_out;
  wire [3:0] Exe_reg_Dest_out;

  wire WB_EN_id_reg_out;

  ID_stage id_stage(
    .clk(clk),
    .rst(rst),
    .Instruction(if_inst_out),
    .Result_WB(Result_WB),
    .writeBackEn(WB_EN),
    .Dest_wb(Dest_wb),
    .hazard(hazard),
    .SR(SR),
    .WB_EN(WB_EN_before),
    .MEM_R_EN(MEM_R_EN_before),
    .MEM_W_EN(MEM_W_EN_IN_before),
    .B(B_IN_before),
    .S(S_IN_before),
    .EXE_CMD(EXE_CMD_IN_before),
    .Val_Rn(Val_Rn_IN_before),
    .Val_Rm(Val_Rm_IN_before),
    .imm(imm_IN_before),
    .Shift_operand(Shift_operand_IN_before),
    .Signed_imm_24(Signed_imm_24_IN_before),
    .Dest(Dest_IN_before),
    .src1(src1),
    .src2(src2),
    .Two_src(Two_src)
);
  
  ID_Reg id_reg(
    .clk(clk),
    .rst(rst),
    .flush(B),
    .WB_EN_IN(WB_EN_before),
    .MEM_R_EN_IN(MEM_R_EN_before),
    .MEM_W_EN_IN(MEM_W_EN_IN_before),
    .B_IN(B_IN_before),
    .S_IN(S_IN_before),
    .C_IN(SR[2]),
    .EXE_CMD_IN(EXE_CMD_IN_before), .src1_in(src1), .src2_in(src2),
    .PC_IN(if_pc_out),
    .Val_Rn_IN(Val_Rn_IN_before),
    .Val_Rm_IN(Val_Rm_IN_before),
    .imm_IN(imm_IN_before),
    .Shift_operand_IN(Shift_operand_IN_before),
    .Signed_imm_24_IN(Signed_imm_24_IN_before),
    .Dest_IN(Dest_IN_before),
  
    .WB_EN(WB_EN_id_reg_out),
    .MEM_R_EN(MEM_R_EN),
    .MEM_W_EN(MEM_W_EN),
    .B(B),
    .S(S),
    .C(ID_reg_C_out),
    .EXE_CMD(EXE_CMD), .src1_out(id_reg_src1_out), .src2_out(id_reg_src2_out),
    .PC(id_reg_pc_out),
    .Val_Rn(Val_Rn),
    .Val_Rm(Val_Rm),
    .imm(imm),
    .Shift_operand(Shift_operand),
    .Signed_imm_24(Signed_imm_24),
    .Dest(Dest)
  );

  wire [31:0] exe_val_rm_out;
  wire [1:0] sel_src1, sel_src2;
  
  EXE_stage exe_stage(
    .clk(clk), .rst(rst),
    .exe_cmd_in(EXE_CMD),
    .sel_src1(sel_src1), .sel_src2(sel_src2),
    .MEM_R_EN_IN(MEM_R_EN), .MEM_W_EN_IN(MEM_W_EN),
    .imm_in(imm), .s(S), .c(ID_reg_C_out), 
    .shifter_operand(Shift_operand),
    .signed_imm_24(Signed_imm_24),
    .pc_in(id_reg_pc_out), .val_rm(Val_Rm), .val_rn(Val_Rn), .alu_in(exe_reg_alu_out), .WB_value(Result_WB),
    
    .alu_out(exe_alu_out), .branch_address(branch_addr), .val_rm_out(exe_val_rm_out),
    .status_out(SR)
  );

  wire MEM_R_EN_exe_reg_out, MEM_W_EN_exe_reg_out, MEM_R_EN_mem_out;
  wire MEM_R_EN_mem_reg_out, WB_EN_mem_reg_out;
  wire [3:0] Dest_mem_reg_out;
  wire [31:0] alu_res_mem_out, mem_data_reg_out, alu_res_mem_reg_out, mem_data_mem_reg_out;

  EXE_reg exe_reg(
    .clk(clk), .rst(rst), 
    .WB_en_in(WB_EN_id_reg_out), .MEM_R_EN_in(MEM_R_EN), .MEM_W_EN_in(MEM_W_EN),
    .alu_result_in(exe_alu_out), .ST_val_in(exe_val_rm_out),
    .Dest_in(Dest),
    .WB_en(EXE_reg_WB_en_out), .MEM_R_EN(MEM_R_EN_exe_reg_out), .MEM_W_EN(MEM_W_EN_exe_reg_out),
    .alu_result(exe_reg_alu_out), .ST_val(exe_reg_ST_val_out),
    .Dest(Exe_reg_Dest_out)
  );

  wire [3:0] dest_mem_out_temp;
  wire WB_EN_mem_temp;
  MEM_stage mem_stage(
    .clk(clk), .rst(rst),
    .MEM_R_EN(MEM_R_EN_exe_reg_out), .MEM_W_EN(MEM_W_EN_exe_reg_out), .WB_EN(EXE_reg_WB_en_out),
    .alu_res(exe_reg_alu_out), .val_rm(exe_reg_ST_val_out),
    .Dest(Exe_reg_Dest_out),
    .MEM_R_EN_out(MEM_R_EN_mem_out),
    .WB_EN_out(WB_EN_mem_temp),
    .alu_res_out(alu_res_mem_out), .mem_data_out(mem_data_reg_out),
    .Dest_out(dest_mem_out_temp)
  );
  
  MEM_reg mem_reg(
    .clk(clk), .rst(rst),
    .MEM_R_EN(MEM_R_EN_mem_out), .WB_EN(EXE_reg_WB_en_out),
    .alu_res(alu_res_mem_out), .data_mem(mem_data_reg_out),
    .Dest(dest_mem_out_temp),
    .MEM_R_EN_out(MEM_R_EN_mem_reg_out), .WB_EN_out(WB_EN_mem_reg_out),
    .alu_res_out(alu_res_mem_reg_out), .data_mem_out(mem_data_mem_reg_out),
    .Dest_out(Dest_mem_reg_out)
  );

  WB_stage wb_stage(
    .ALU_Result(alu_res_mem_reg_out), .MEM_result(mem_data_mem_reg_out),
    .Dest(Dest_mem_reg_out),
    .MEM_R_en(MEM_R_EN_mem_reg_out),
    .WB_EN(WB_EN_mem_reg_out),
    .out(Result_WB),
    .WB_EN_out(WB_EN),
    .Dest_out(Dest_wb)
  );
  
  HazardDetection hazard_detection(
  .src1(src1), .src2(src2), .EXE_dest(Dest), .MEM_dest(Exe_reg_Dest_out),
  .EXE_WB_en(WB_EN_id_reg_out), .EXE_MEM_R_en(MEM_R_EN),
  .MEM_WB_en(EXE_reg_WB_en_out), .forward_en(forward_en),
  .has_two_src(Two_src),
  .hazard(hazard)
  );

  ForwardingUnit forwarding_unit(
    .MEM_WB_en(EXE_reg_WB_en_out), .WB_WB_en(WB_EN), .forward_en(forward_en),
    .src1(id_reg_src1_out), .src2(id_reg_src2_out), .Dest_wb(Dest_wb), .mem_dst(Exe_reg_Dest_out),
    .sel_src1(sel_src1), .sel_src2(sel_src2)
  );

endmodule
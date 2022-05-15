`timescale 1ns/1ns
module ID_Reg (
  input clk, rst, flush,
  input WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN,
  input B_IN, S_IN, C_IN,
  input [3:0] EXE_CMD_IN, src1_in, src2_in,
  input [31:0] PC_IN,
  input [31:0] Val_Rn_IN, Val_Rm_IN,
  input imm_IN,
  input [11:0] Shift_operand_IN,
  input [23:0] Signed_imm_24_IN,
  input [3:0] Dest_IN,
  
  output reg WB_EN, MEM_R_EN, MEM_W_EN, B, S, C,
  output reg [3:0] EXE_CMD, src1_out, src2_out,
  output reg [31:0] PC,
  output reg [31:0] Val_Rn, Val_Rm,
  output reg imm,
  output reg [11:0] Shift_operand,
  output reg [23:0] Signed_imm_24,
  output reg [3:0] Dest
  );

  always @ (posedge clk, posedge rst) begin
    if (rst) begin
      WB_EN <= 1'b0;
      MEM_R_EN <= 1'b0;
      MEM_W_EN <= 1'b0;
      EXE_CMD <= 4'd0;
      PC <= 32'd0;
      Val_Rn <= 32'd0;
      Val_Rm <= 32'd0;
      B <= 1'b0;
      S <= 1'b0;
      C <= 1'b0;
      imm <= 1'b0;
      Shift_operand <= 12'd0;
      Signed_imm_24 <= 24'd0;
      Dest <= 4'd0;
      src1_out <= 4'd0;
      src2_out <= 4'd0;
    end
    else if (flush) begin
      WB_EN <= 1'b0;
      MEM_R_EN <= 1'b0;
      MEM_W_EN <= 1'b0;
      EXE_CMD <= 4'd0;
      PC <= 32'd0;
      Val_Rn <= 32'd0;
      Val_Rm <= 32'd0;
      B <= 1'b0;
      S <= 1'b0;
      C <= 1'b0;
      imm <= 1'b0;
      Shift_operand <= 12'd0;
      Signed_imm_24 <= 24'd0;
      Dest <= 4'd0;
      src1_out <= 4'd0;
      src2_out <= 4'd0;
    end
    else begin
      WB_EN <= WB_EN_IN;
      MEM_R_EN <= MEM_R_EN_IN;
      MEM_W_EN <= MEM_W_EN_IN;
      EXE_CMD <= EXE_CMD_IN;
      PC <= PC_IN;
      Val_Rn <= Val_Rn_IN;
      Val_Rm <= Val_Rm_IN;
      B <= B_IN;
      S <= S_IN;
      C <= C_IN;
      imm <= imm_IN;
      Shift_operand <= Shift_operand_IN;
      Signed_imm_24 <= Signed_imm_24_IN;
      Dest <= Dest_IN;
      src1_out <= src1_in;
      src2_out <= src2_in;
    end
  end

endmodule
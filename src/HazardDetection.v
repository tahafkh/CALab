`timescale 1ns/1ns
module HazardDetection(
  input [3:0] src1, src2, EXE_dest, MEM_dest,
  input EXE_WB_en, EXE_MEM_R_en,
  input MEM_WB_en, forward_en,
  input has_two_src,
  output reg hazard
);

  always @(src1, src2, EXE_dest, MEM_dest, EXE_WB_en, MEM_WB_en, has_two_src) 
  begin
    hazard = 1'b0;

    if (forward_en) 
    begin
      if (EXE_MEM_R_en && EXE_WB_en && (src1 == EXE_dest)) 
        hazard = 1'b1;
      else if (EXE_MEM_R_en && EXE_WB_en && (src2 == EXE_dest) && has_two_src) 
        hazard = 1'b1;
    end
    
    else 
    begin
      if ((src1 == EXE_dest) && (EXE_WB_en))
        hazard = 1'b1;

      else if ((src2 == EXE_dest) && (EXE_WB_en) && (has_two_src))
        hazard = 1'b1;

      else if ((src1 == MEM_dest) && (MEM_WB_en))
        hazard = 1'b1;

      else if ((src2 == MEM_dest) && (has_two_src) && (MEM_WB_en))
        hazard = 1'b1;

    end
  end

endmodule
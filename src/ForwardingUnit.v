`timescale 1ns/1ns

module ForwardingUnit (
  input MEM_WB_en, WB_WB_en, forward_en,
  input [3:0] src1, src2, Dest_wb, mem_dst,
  output reg [1:0] sel_src1, sel_src2
);

    always @(*) begin
        sel_src1 = 2'd0;
        sel_src2 = 2'd0;
        if (forward_en) begin 
            if (MEM_WB_en && (src1 == mem_dst)) 
                sel_src1 = 2'd1;
            else if (WB_WB_en && (src1 == Dest_wb))
                sel_src1 = 2'd2;

            if (MEM_WB_en && (src2 == mem_dst)) 
                sel_src2 = 2'd1;
            else if (WB_WB_en && (src2 == Dest_wb))
                sel_src2 = 2'd2;
        end      
    end

endmodule
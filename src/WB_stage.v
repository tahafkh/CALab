`timescale 1ns/1ns
module WB_stage(
    input [31:0] ALU_Result, MEM_result,
    input [3:0] Dest,
    input WB_EN, 
    input MEM_R_en,
    output[31:0] out,
    output WB_EN_out,
    output [3:0] Dest_out
);
    assign out = MEM_R_en ? MEM_result : ALU_Result;
    assign WB_EN_out = WB_EN;
    assign Dest_out = Dest;
endmodule
`timescale 1ns/1ns
module EXE_reg(
    input clk, rst, ld, WB_en_in, MEM_R_EN_in, MEM_W_EN_in,
    input [31:0] alu_result_in, ST_val_in,
    input [3:0] Dest_in,
    output reg WB_en, MEM_R_EN, MEM_W_EN,
    output reg [31:0] alu_result, ST_val,
    output reg [3:0] Dest
);
    always@(posedge clk, posedge rst) begin
        if (rst == 1'b1) begin
            {WB_en, MEM_R_EN, MEM_W_EN} <= 3'd0;
            alu_result <= 32'd0;
            ST_val <= 32'd0;
            Dest <= 4'd0;
        end
        else if (ld) begin
            WB_en <= WB_en_in; 
            MEM_R_EN <= MEM_R_EN_in; 
            MEM_W_EN <= MEM_W_EN_in;
            alu_result <= alu_result_in;
            ST_val <= ST_val_in;
            Dest <= Dest_in;
        end
    end
endmodule
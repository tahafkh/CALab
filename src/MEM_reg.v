`timescale 1ns/1ns

module MEM_reg(
    input clk, rst, ld,
    input MEM_R_EN, WB_EN,
    input [31:0] alu_res, data_mem,
    input [3:0] Dest,
    output reg MEM_R_EN_out, WB_EN_out,
    output reg [31:0] alu_res_out, data_mem_out,
    output reg [3:0] Dest_out
);
    always @(posedge clk, posedge rst) begin
        if (rst == 1'b1) begin
            MEM_R_EN_out <= 1'b0;
            data_mem_out <= 32'd0;
            Dest_out <= 32'd0;
            alu_res_out <= 32'd0;
            WB_EN_out <= 1'b0;
        end
        else if (ld == 1'b1) begin
            MEM_R_EN_out <= MEM_R_EN;
            alu_res_out <= alu_res;
            data_mem_out <= data_mem;
            Dest_out <= Dest;
            WB_EN_out <= WB_EN;
        end
    end
endmodule

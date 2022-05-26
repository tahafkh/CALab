`timescale 1ns/1ns

module SRAM(
    input clk,
    input rst,
    input SRAM_WE_N,
    input [17 : 0] SRAM_ADDR,
    inout [15 : 0] SRAM_DQ
);
    reg [15 : 0] sram_memory [0 : 16383]; 

    // Store data into SRAM memory
    always @(posedge clk) begin
        if(~SRAM_WE_N) begin
            sram_memory[SRAM_ADDR] <= SRAM_DQ;
        end
    end

    // Load data from SRAM memory
    assign SRAM_DQ = SRAM_WE_N ? sram_memory[SRAM_ADDR] : 16'bz;

endmodule

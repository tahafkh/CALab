`timescale 1ns/1ns

module RegisterFile (
  input clk, rst,
  input[3:0] src1, src2, Dest_wb,
  input[31:0] Result_WB,
  input writeBackEn,
  output[31:0] reg1, reg2
);

  reg [31:0] rf_arr [0:14];
  
  integer i;
  initial begin
      for (i = 0; i < 15; i = i + 1)
        rf_arr[i] = i;
  end
  
  always @(posedge rst, negedge clk) begin
    if (rst) begin
      for (i = 0; i < 15; i = i + 1)
        rf_arr[i] = i;
    end
    else if (writeBackEn)
      rf_arr[Dest_wb] = Result_WB;
  end

  assign reg1 = rf_arr[src1];
  assign reg2 = rf_arr[src2];
endmodule
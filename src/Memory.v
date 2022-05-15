`timescale 1ns/1ns
module Memory(
  input clk, MEMread, MEMwrite,
  input [31:0] address, data,
  output [31:0] MEM_result
);
  reg [31:0] memory [0:63];
  wire [31:0] true_addr = address - 32'd1024;
  wire [31:0] div_addr = {2'b0, true_addr[31:2]};
  
  integer i;
  initial begin
    for (i = 0; i < 64; i = i + 1) begin
      memory[i] = 0;
    end
  end
  
  assign MEM_result = MEMread ? memory[div_addr] : 32'bz;
  
  always @(posedge clk) begin
    if (MEMwrite) begin
      memory[div_addr] = data;
    end
  end

endmodule
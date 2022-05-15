`timescale 1ns/1ns

module ConditionCheck (
  input [3:0] cond,
  input [3:0] sr,
  output reg out
  );
  
  parameter [3:0] EQ = 4'b0000;
  parameter [3:0] NE = 4'b0001;
  parameter [3:0] CS_HS = 4'b0010;
  parameter [3:0] CC_LO = 4'b0011;
  parameter [3:0] MI = 4'b0100;
  parameter [3:0] PL = 4'b0101;
  parameter [3:0] VS = 4'b0110;
  parameter [3:0] VC = 4'b0111;
  parameter [3:0] HI = 4'b1000;
  parameter [3:0] LS = 4'b1001;
  parameter [3:0] GE = 4'b1010;
  parameter [3:0] LT = 4'b1011;
  parameter [3:0] GT = 4'b1100;
  parameter [3:0] LE = 4'b1101;
  parameter [3:0] AL = 4'b1110;
  
  wire z, c, n, v;
  assign {z, c, n, v} = sr;
  
  always @ (cond, sr) begin
    out = 1'b0;
    
    case (cond)
      EQ: out = z;
      NE: out = ~z;
      CS_HS: out = c;
      CC_LO: out = ~c;
      MI: out = n;
      PL: out = ~n;
      VS: out = v;
      VC: out = ~v;
      HI: out = c & ~z;
      LS: out = ~c & z;
      GE: out = (n & v) | (~n & ~v);
      LT: out = (n & ~v) | (~n & v);
      GT: out = (~z) & ((n & v) | (~n & ~v));
      LE: out = z & ((n & ~v) | (~n & v));
      AL: out = 1'b1;
    endcase
    
  end
  
  
endmodule
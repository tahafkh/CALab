`timescale 1ns/1ns

module ControlUnit(
  input s,
  input [1:0] mode,
  input [3:0] opcode,
  output reg B_jump,
  output reg wb_en,
  output reg mem_rd, mem_wr,
  output reg [3:0] exec_cmd,
  output reg s_out
  );
  
  parameter [3:0] NOP = 4'b0000;
  parameter [3:0] MOV = 4'b1101;
  parameter [3:0] MVN = 4'b1111;
  parameter [3:0] ADD = 4'b0100;
  parameter [3:0] ADC = 4'b0101;
  parameter [3:0] SUB = 4'b0010;
  parameter [3:0] SBC = 4'b0110;
  parameter [3:0] AND = 4'b0000;
  parameter [3:0] ORR = 4'b1100;
  parameter [3:0] EOR = 4'b0001;
  parameter [3:0] CMP = 4'b1010;
  parameter [3:0] TST = 4'b1000;
  
  parameter LDR = 1'b1;
  parameter STR = 1'b0;
  
  parameter [1:0] B = 2'b10;
  parameter [1:0] ST_LD = 2'b01;
  parameter [1:0] LOGIC = 2'b00;
  
  
  always @(mode, opcode, s) begin
    B_jump = 1'b0;
    wb_en = 1'b0;
    mem_rd = 1'b0;
    mem_wr = 1'b0;
    exec_cmd = 4'd0;
    s_out = 1'b0;
    
    case (mode)
      B: begin
        B_jump = 1'b1;
      end
      
      ST_LD: begin
        case (s)
          STR: begin
            mem_wr = 1'b1;
            exec_cmd = 4'b0010;
            s_out = 1'b1;
          end
          LDR: begin
            mem_rd = 1'b1;
            wb_en = 1'b1;
            exec_cmd = 4'b0010;
            s_out = 1'b1;
          end
        endcase
      end
      
      LOGIC: begin
        s_out = s;
        case (opcode)
          MOV: begin
            exec_cmd = 4'd1;
            wb_en = 1'b1;
          end
          MVN: begin
            exec_cmd = 4'd9;
            wb_en = 1'b1;
          end
          ADD: begin
            exec_cmd = 4'd2;
            wb_en = 1'b1;
          end
          ADC: begin
            exec_cmd = 4'd3;
            wb_en = 1'b1;
          end
          SUB: begin
            exec_cmd = 4'd4;
            wb_en = 1'b1;
          end
          SBC: begin
            exec_cmd = 4'd5;
            wb_en = 1'b1;
          end
          AND: begin
            exec_cmd = 4'd6;
            wb_en = 1'b1;
          end
          ORR: begin
            exec_cmd = 4'd7;
            wb_en = 1'b1;
          end
          EOR: begin
            exec_cmd = 4'd8;
            wb_en = 1'b1;
          end
          CMP: begin
            exec_cmd = 4'd4;
            s_out = 1'b1;
          end
          TST: begin
            exec_cmd = 4'd6;
            s_out = 1'b1;
          end
        endcase
      end
      
    endcase
  end
  
endmodule

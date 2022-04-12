`include "instructions.v"

module ControlUnit(
	input s,
	input[1 : 0] Mode,
	input[3 : 0] Opcode,
	output reg[3 : 0] exe_cmd,
	output reg MEM_R_EN, MEM_W_EN, // Mem read/write
			WB_EN, //write back enable
			B, // Branch taken
			S // STATUS WRITE ENABLE
	);

	always @(Mode, Opcode, s) begin
		exe_cmd = 'd0; 
        MEM_R_EN = 'd0;
        MEM_W_EN = 'd0; 
        WB_EN = 'd0;
		B = 'd0;
		S = 'd0;

		case (Mode)
			`ARITHMETHIC_TYPE : begin
				case (Opcode) 
					`MOV : begin
						WB_EN = 1'b1;
						S = s;
						exe_cmd = `MOV;
					end
					
					`MVN : begin
						WB_EN = 1'b1;
						S = s;
						exe_cmd = `MVN;
					end
					
					`ADD : begin
						WB_EN = 1'b1;
						S = s;
						exe_cmd = `ADD;
					end
					
					`ADC : begin
						WB_EN = 1'b1;
						S = s;
						exe_cmd = `ADC;
					end
					
					`SUB : begin
						WB_EN = 1'b1;
						S = s;
						exe_cmd = `SUB;
					end		
					
					`SBC : begin
						WB_EN = 1'b1;
						S = s;
						exe_cmd = `SBC;
					end
					
					`AND : begin
						WB_EN = 1'b1;
						S = s;
						exe_cmd = `AND;
					end
					
					`OR  : begin
						WB_EN = 1'b1;
						S = s;
						exe_cmd = `OR;
					end

					`EOR : begin
						WB_EN = 1'b1;
						S = s;
						exe_cmd = `EOR;
					end
					
					`CMP : begin
						WB_EN = 1'b0;
						S = 1'b1;
						exe_cmd = `CMP;
					end

					`TST: begin
						WB_EN = 1'b0;
						S = 1'b1;
						exe_cmd = `TST;
					end

				endcase
			end

			`MEMORY_TYPE : begin
				case (s) 
					`S_LDR: begin
						WB_EN = 1'b1;
						S = 1'b1;
						exe_cmd = `LDR;
						MEM_R_EN = 1'b1;
					end

					`S_STR: begin
						WB_EN = 1'b0;
						S = 1'b0;
						exe_cmd = `STR;
						MEM_W_EN = 1'b1;
					end
				endcase
			end

			`BRANCH_TYPE : begin
				B = 1'b1;
			end
		endcase

	end
	
endmodule
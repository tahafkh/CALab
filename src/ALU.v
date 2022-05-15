`timescale 1ns/1ns
module ALU(
    input signed [31:0] val1, val2,
    input [3:0] exe_cmd,
    input c,
    output reg [3:0] status_out,
    output reg signed [31:0] out
);

    parameter [3:0] MOV = 4'b0001;
    parameter [3:0] MVN = 4'b1001;
    parameter [3:0] ADD = 4'b0010;
    parameter [3:0] ADC = 4'b0011;
	parameter [3:0] SUB = 4'b0100;
	parameter [3:0] SBC = 4'b0101;
	parameter [3:0] AND = 4'b0110;
	parameter [3:0] ORR = 4'b0111;
	parameter [3:0] EOR = 4'b1000;
	parameter [3:0] CMP = 4'b0100;
	parameter [3:0] TST = 4'b0110;
	parameter [3:0] LDR = 4'b0010;
	parameter [3:0] STR = 4'b0010;


    reg co, v;

    always @(*) begin
        {co, out} = 33'd0;
        v = 1'b0;

		case(exe_cmd) 
            MOV: out = val2;
            MVN: out = ~val2;
            ADD: begin
                {co, out} = {val1[31], val1} + {val2[31], val2};
                v = (val1 < 0 && val2 < 0 && out > 0) || (val1 > 0 && val2 > 0 && out < 0);
            end
            ADC: begin
                {co, out} = {val1[31], val1} + {val2[31], val2} + {31'd0, c};
                v = (val1 < 0 && val2 < 0 && out > 0) || (val1 > 0 && val2 > 0 && out < 0);
                $display(c, v);
            end
            SUB: begin
                {co, out} = {val1[31], val1} - {val2[31], val2};
                v = (val1 < 0 && val2 > 0 && out > 0) || (val1 > 0 && val2 < 0 && out < 0);
            end
            SBC: begin
                {co, out} = {val1[31], val1} - {val2[31], val2} - {31'd0, ~c};
                v = (val1 < 0 && val2 > 0 && out > 0) || (val1 > 0 && val2 < 0 && out < 0);
            end
            AND: begin
                out = val1 & val2;
            end
            ORR: begin
                out = val1 | val2;
            end
            EOR: begin
                out = val1 ^ val2;
            end
            CMP: begin
                {co, out} = {val1[31], val1} - {val2[31], val2};
                v = (val1 < 0 && val2 > 0 && out > 0) || (val1 > 0 && val2 < 0 && out < 0);
            end
            TST: out = val1 & val2;
            LDR: begin
                {co, out} = {val1[31], val1} + {val2[31], val2};
                v = (val1 < 0 && val2 < 0 && out > 0) || (val1 > 0 && val2 > 0 && out < 0);
            end
            STR: begin
                {co, out} = {val1[31], val1} + {val2[31], val2};
                v = (val1 < 0 && val2 < 0 && out > 0) || (val1 > 0 && val2 > 0 && out < 0);
            end
	  	endcase
	end

    assign status_out = {out == 32'd0, co, out[31], v};

endmodule
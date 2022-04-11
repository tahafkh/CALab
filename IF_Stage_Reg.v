module IF_Stage_Reg (
    input clk, rst, freeze, flush,
    input[31:0] PC_in, Instruction_in,
    output reg [31:0] PC, Instruction
);
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            PC <= 32'd0;
            Instruction <= 32'd0;
        end 
		else if (freeze != 1'b1) begin
			PC <= PC_in;
			if (flush) begin
				Instruction <= 32'd0;
			end 
			else begin
				Instruction <= Instruction_in;
			end
        end
    end
    
endmodule

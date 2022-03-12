module IF_Stage (
    input clk, rst, freeze, Branch_taken, 
    input [31:0] BranchAdr,
    output reg [31:0] PC, Instruction
);
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            PC <= 32'd0;
        end
        else if (freeze != 1'b1) begin
            PC <= Branch_taken ? BranchAdr : PC + 32'd4;
        end
    end
	
    InstructionMemory int_mem(.rst(rst), .PC(PC), .Instruction(Instruction));
endmodule

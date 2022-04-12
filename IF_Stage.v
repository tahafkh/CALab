module IF_Stage (
    input clk, rst, freeze, Branch_taken, 
    input [31:0] BranchAddr,
    output [31:0] PC, Instruction
);

    reg [31:0] PC_reg;

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            PC_reg <= 32'd0;
        end
        else if (freeze != 1'b1) begin
            PC_reg <= Branch_taken ? BranchAddr : PC_reg + 32'd4;
        end
    end

    assign PC = {2'd0, PC_reg[31:2]};
	
    InstructionMemory inst_mem(.rst(rst), .PC(PC), .Instruction(Instruction));
endmodule

module InstructionMemory (
    input rst,
    input [31:0] PC,
    output [31:0] Instruction
);
    reg [31:0] memory [0:1023];
	
    always @(posedge rst) begin
        $readmemb("instructions.mem", memory);
    end
    assign Instruction = memory[PC];
	
endmodule

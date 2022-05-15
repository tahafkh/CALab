`timescale 1ns/1ns
module Val2Gen(
    input [31:0] val_rm,
    input [11:0] shifter_operand,
    input imm, mem_en,
    output reg [31:0] val2
);

    parameter [1:0] LSL = 2'd0;
    parameter [1:0] LSR = 2'd1;
    parameter [1:0] ASR = 2'd2;
    parameter [1:0] ROR = 2'd3;
    

    integer i;
    always @(*) begin
        if (mem_en)
            val2 = {20'd0, shifter_operand};
            
        else if (imm) begin
            val2 = {24'd0, shifter_operand[7:0]};

            for (i=0; i<{shifter_operand[11:8], 1'b0}; i=i+1) begin
                val2 = {val2[0], val2[31:1]};
            end
        end

        else begin
            case (shifter_operand[6:5])
                LSL: begin
                    val2 = val_rm << shifter_operand[11:7];
                end
                LSR: begin
                    val2 = val_rm >> shifter_operand[11:7];
                end
                ASR: begin
                    val2 = val_rm >>> shifter_operand[11:7];
                end
                ROR: begin
                    val2 = val_rm;
                    for (i=0; i<{shifter_operand[11:7]}; i=i+1) begin
                        val2 = {val2[0], val2[31:1]};
                    end
                end
                default: begin
                    val2 = val_rm << shifter_operand[11:7];
                end
            endcase
        end

    end


endmodule
`include "instructions.v"

module Val2Generator(
    input [31:0] val_rm,
    input [11:0] shift_operand,
    input immediate, is_mem_command,

    output reg [31:0] Val2
    );


    reg [2 * (32) - 1 : 0] tmp;
    always @(val_rm, shift_operand, immediate, is_mem_command) begin
        Val2 = 32'b0;
        tmp = 0;
        if (is_mem_command == 1'b0) begin
            if (immediate == 1'b1) begin
                Val2 = {24'b0 ,shift_operand[7 : 0]};
                tmp = {Val2, Val2} >> (({{2'b0},shift_operand[11 : 8]}) << 1);
                Val2 = tmp[31 : 0];

            end 
            else if(immediate == 1'b0 && shift_operand[4] == 0) begin
                case(shift_operand[6:5])
                    `LSL_SHIFT : begin
                        Val2 = val_rm << shift_operand[11 : 7];
                    end
                    `LSR_SHIFT : begin
                        Val2 = val_rm >> shift_operand[11 : 7];
                    end
                    `ASR_SHIFT : begin
                        Val2 = val_rm >>> shift_operand[11 : 7];
                    end
                    `ROR_SHIFT : begin
                        tmp = {val_rm, val_rm} >> (shift_operand[11 : 7]);
                        Val2 = tmp[31 : 0];
                    end
                endcase
            end
        end 
        else
            Val2 = { {20{shift_operand[11]}} , shift_operand[11 : 0]}; 
    end
endmodule 
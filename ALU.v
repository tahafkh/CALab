`include "instructions.v"
//TODO Change
module ALU (
    input [31:0] Val1, Val2,
    input [3:0] alu_command,
    input [3:0] status_register,

    output reg [31:0] ALU_Res,
    output [3:0] Status_bits
    );

    wire cin;
    assign cin = status_register[1];

    wire z, n; 
    assign z = (ALU_Res == 32'b0) ? 1'b1 : 1'b0;
    assign n = (ALU_Res[31]); 
    
    reg v, cout; 
    assign Status_bits = {z, cout, n, v};

    always @(*) begin
        cout = 1'b0;
        v = 1'b0;

        case (alu_command)
            `MOV:
                ALU_Res = Val2;
            `MVN:
                ALU_Res = ~Val2; 

            `ADD: begin
                {cout, ALU_Res} = Val1 + Val2;
                v = ((Val1[31] == Val2[31])
                        & (ALU_Res[31] != Val1[31]));
            end

            `ADC: begin
                {cout, ALU_Res} = Val1 + Val2 + cin;
                v = ((Val1[31] == Val2[31]) 
                    & (ALU_Res[31] != Val1[31]));
            end

            `SUB: 
                {cout, ALU_Res} = Val1 - Val2;
                v = ((Val1[31] == ~Val2[31])
                    & (ALU_Res[31] != Val1[31]));
            end

            `SBC: begin
                {cout, ALU_Res} = Val1 - Val2 - 1 + cin;
                v = ((Val1[31] == Val2[31])
                    & (ALU_Res[31] != Val1[31]));
            end

            `AND:
                ALU_Res	 = 	Val1 & Val2;

            `OR :
                ALU_Res	 = 	Val1 | Val2;

            `EOR:
                ALU_Res	 = 	Val1 ^ Val2;

            `CMP: begin
                {cout, ALU_Res} = {Val1[31], {Val1}} - 
                                    {Val2[31], {Val2}};
                v = ((Val1[31] == ~Val2[31]) 
                    & (ALU_Res[31] != Val1[31]));
            end
    

            `TST:
                ALU_Res	 = 	Val1 & Val2;
            
            `LDR:
                ALU_Res	 = 	Val1 + Val2;

            `STR:
                ALU_Res	 = 	Val1 + Val2;

        endcase

    end    

endmodule
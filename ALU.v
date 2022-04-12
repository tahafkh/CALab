`include "instructions.v"
//TODO Change
module ALU (
    alu_in1, 
    alu_in2,
    alu_command,
    status_register,

    alu_out,
    alu_status_register_out
    );

    input [31:0] alu_in1, alu_in2;
    input [3:0] alu_command;
    input [3:0] status_register;

    output reg [31:0] alu_out;
    output [3:0] alu_status_register_out;


    wire cin;
    assign cin = status_register[1];

    wire z, n; 
    assign z = (alu_out == 32'b0) ? 1'b1 : 1'b0;
    assign n = (alu_out[31]); 
    
    reg v, cout; 
    assign alu_status_register_out = {z, cout, n, v};

    always @(*) begin
        cout = 1'b0;
        v = 1'b0;

        case (alu_command)
            `MOV:
                alu_out = alu_in2;
            `MVN:
                alu_out = ~alu_in2; 

            `ADD: begin
                {cout, alu_out} = alu_in1 + alu_in2;
                v = ((alu_in1[31] == alu_in2[31])
                        & (alu_out[31] != alu_in1[31]));
            end

            `ADC: begin
                {cout, alu_out} = alu_in1 + alu_in2 + cin;
                v = ((alu_in1[31] == alu_in2[31]) 
                    & (alu_out[31] != alu_in1[31]));
            end

            `SUB: 
                {cout, alu_out} = alu_in1 - alu_in2;
                v = ((alu_in1[31] == ~alu_in2[31])
                    & (alu_out[31] != alu_in1[31]));
            end

            `SBC: begin
                {cout, alu_out} = alu_in1 - alu_in2 - 1 + cin;
                v = ((alu_in1[31] == alu_in2[31])
                    & (alu_out[31] != alu_in1[31]));
            end

            `AND:
                alu_out	 = 	alu_in1 & alu_in2;

            `OR :
                alu_out	 = 	alu_in1 | alu_in2;

            `EOR:
                alu_out	 = 	alu_in1 ^ alu_in2;

            `CMP: begin
                {cout, alu_out} = {alu_in1[31], {alu_in1}} - 
                                    {alu_in2[31], {alu_in2}};
                v = ((alu_in1[31] == ~alu_in2[31]) 
                    & (alu_out[31] != alu_in1[31]));
            end
    

            `TST:
                alu_out	 = 	alu_in1 & alu_in2;
            
            `LDR:
                alu_out	 = 	alu_in1 + alu_in2;

            `STR:
                alu_out	 = 	alu_in1 + alu_in2;

        endcase

    end    

endmodule
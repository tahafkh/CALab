`include "instructions.v"

module Condition_Check (
    input [3 : 0] Cond;
    input [3 : 0] stat_reg;
    output Cond_state;
);
    wire z, c, n, v;
    assign {z, c, n, v} = stat_reg;

    reg Cond_state_reg;

    always @(Cond, z, c, n, v) begin
        Cond_state_reg <= 1'b0;
        case(Cond)
            `EQ :
                Cond_state_reg <= z;

            `NE :
                Cond_state_reg <= ~z;

            `CS_HS : 
                Cond_state_reg <= c;

            `CC_LO : 
                Cond_state_reg <= ~c;

            `MI : 
                Cond_state_reg <= n;

            `PL : 
                Cond_state_reg <= ~n;

            `VS : 
                Cond_state_reg <= v;
            
            `VC : 
                Cond_state_reg <= ~v;

            `HI : 
                Cond_state_reg <= c & ~z;

            `LS : 
                Cond_state_reg <= ~c | z;

            `GE : 
                Cond_state_reg <= (n & v) | (~n & ~v);

            `LT : 
                Cond_state_reg <= (n & ~v) | (~n & v);

            `GT : 
                Cond_state_reg <= ~z & ((n & v) | (~n & ~v));

            `LE : 
                Cond_state_reg <= z | (n & ~v) | (~n & ~v);

            `AL : 
                Cond_state_reg <= 1'b1;
            
        endcase
    end
    
    assign Cond_state = Cond_state_reg;
endmodule
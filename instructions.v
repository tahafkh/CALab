`ifndef instructions_v
`define instructions_v

`define ARITHMETHIC_TYPE        2'b00

`define MOV 4'b1101
`define MVN 4'b1111
`define ADD 4'b0100
`define ADC 4'b0101
`define SUB 4'b0010
`define SBC 4'b0110
`define AND 4'b0000
`define OR  4'b1100
`define EOR 4'b0001
`define CMP 4'b1010
`define TST 4'b1000
`define LDR 4'b0100
`define STR 4'b0100

`define MEMORY_TYPE             2'b01
`define S_LDR 1'b1
`define S_STR 1'b0


`define BRANCH_TYPE             2'b10


// Conditional Opcodes

`define EQ    4'b0000
`define NE    4'b0001
`define CS_HS 4'b0010
`define CC_LO 4'b0011
`define MI    4'b0100
`define PL    4'b0101
`define VS    4'b0110
`define VC    4'b0111
`define HI    4'b1000
`define LS    4'b1001
`define GE    4'b1010
`define LT    4'b1011
`define GT    4'b1100
`define LE    4'b1101
`define AL    4'b1110

`endif
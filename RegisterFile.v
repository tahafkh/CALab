module RegisterFile (
	input clk, rst, 
    input [3 : 0] src1, src2, WB_Dest, 
	input[32 - 1:0] WB_Value,
    input WB_EN,
	output [32 - 1:0] Val_Rm, Val_Rn
);
    reg[32 - 1:0] data[0:16 - 1];

    
    always @(negedge clk, posedge rst) begin
		if (rst) begin
            data[0] <= 32'd0;
            data[1] <= 32'd1;
            data[2] <= 32'd2;
            data[3] <= 32'd3;
            data[4] <= 32'd4;
            data[5] <= 32'd5;
            data[6] <= 32'd6;
            data[7] <= 32'd7;
            data[8] <= 32'd8;
            data[9] <= 32'd9;
            data[10] <= 32'd10;
            data[11] <= 32'd11;
            data[12] <= 32'd12;
            data[13] <= 32'd13;
            data[14] <= 32'd14;
            data[15] <= 32'd15;
            
        end
        else if (WB_EN) 
            data[WB_Dest] <= WB_Value;
	end

    assign Val_Rm = data[src1];
    assign Val_Rn = data[src2];
endmodule 
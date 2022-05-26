`timescale 1ns/1ns

module SRAMController(
    input clk, rst,
    input write_en, read_en,
    input [31 : 0] addr, 
    input [31 : 0] st_val,
    output [31 : 0] read_data,
    output ready,
    inout [15:0] SRAM_DQ,
    output reg[17:0] SRAM_ADDR,
    output SRAM_UB_N,
    output SRAM_LB_N,
    output SRAM_WE_N,
    output SRAM_CE_N,
    output SRAM_OE_N

);

    assign SRAM_UB_N = 1'b0;
    assign SRAM_LB_N = 1'b0;
    assign SRAM_CE_N = 1'b0;
    assign SRAM_OE_N = 1'b0;
    
    reg [2 : 0] cnt;
    reg [1 : 0] ps, ns;
    reg cnt_enable;

    // Set SRAM_WE_N based on the state of the controller
    assign SRAM_WE_N = write_en ? ~(cnt == 3'd1 || cnt == 3'd2) : read_en ? (cnt == 3'd1 || cnt == 3'd2) : 1'b1;

    // Set SRAM_ADDR based on the state of the controller
    wire[31:0] base_addr  = addr - 32'd1024;
	 always @(cnt, base_addr)  begin
		SRAM_ADDR = (cnt == 3'd1) ?  {base_addr[18 : 2], 1'b0}  :  (cnt == 3'd2) ? {base_addr[18 : 2], 1'b0} + 18'd1 : 'bz;
	 end
	 
    // Set SRAM_DQ based on the state of the controller
    assign SRAM_DQ = (write_en && cnt == 3'd1) ? {st_val[15:0]} : ( write_en && cnt == 3'd2) ? {st_val[31:16]} : 'bz;

    // Set ready based on the state of the controller
    assign ready = ~(read_en || write_en) ? 1'b1 : (cnt == 3'd5);

    //--------------Set Read Data--------------\\
    wire [15:0] low_temp ,low;
    wire [31:0] read_data_temp;
    wire ld = (cnt == 3'd2);

    assign low_temp = (cnt == 3'd1) ? SRAM_DQ : 'bz;
    register #16 read_data_reg(clk, rst, 1'b1, low_temp, low);

    assign read_data_temp = (cnt == 3'd2) ? {SRAM_DQ,  low} : 'bz;
    register #32 read_data_reg2(clk, rst, ld, read_data_temp, read_data);

    //--------------State Controller--------------\\
    parameter [1 : 0] IDLE = 2'd0, WRITE = 2'd1, READ = 2'd2;

    always @(posedge clk, posedge rst) begin
        if (rst)
            ps <= 'd0;
        else
            ps <= ns;
    end

    always @(ps, read_en, write_en, cnt) begin
        case (ps)
            IDLE: begin
                if (read_en)
                    ns = READ;
                else if (write_en)
                    ns = WRITE;
                else
                    ns = IDLE;
            end

            WRITE: begin
                if (cnt != 3'd5)
                    ns = WRITE;
                else
                    ns = IDLE;
            end

            READ: begin
                if (cnt != 3'd5)
                    ns = READ;
                else
                    ns = IDLE;
            end
        endcase
    end

    always @(ps) begin
        cnt_enable = 1'b0;
        case (ps)
            WRITE: cnt_enable = 1'b1;
            READ: cnt_enable = 1'b1;
        endcase
    end

    // Modulo 6 Counter    
    always @(posedge clk, posedge rst) begin
        if (rst)
            cnt <= 3'd0;
        else if (cnt_enable) begin
            if (cnt == 3'd6)
                cnt <= 3'd0;
            else
                cnt <= cnt + 1;
        end
    end

endmodule

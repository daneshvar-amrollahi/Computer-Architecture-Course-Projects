module IFID(clk, rst, ld, flush, inst, adder1, inst_out, adder1_out);
    input clk, rst, flush;
    input [31:0] inst, adder1;
    input ld;

    output reg [31:0] inst_out, adder1_out;

    always @(posedge clk, posedge flush) //shayad ham flush e khaali
    begin
        if (flush)
        begin
            adder1_out <= 32'b0;
            inst_out <= {6'b111111, 26'b0}; //nop
        end
        else
        if (rst)
        begin
            adder1_out <= 32'b0;
            inst_out <= 32'b0;
        end
        else
        begin
            if (ld) begin
                inst_out <= inst;
                adder1_out <= adder1;    
            end
        end
    end
endmodule
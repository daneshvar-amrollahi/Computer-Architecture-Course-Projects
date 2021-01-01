module IFID(clk, rst, flush, inst, adder1, inst_out, adder1_out);
    input clk, rst, flush;
    input [31:0] inst, adder1;

    output reg [31:0] inst_out, adder1_out;

    always @(posedge clk, posedge flush)
    begin
        if (flush)
        begin
            adder1_out <= 32'b0;
            inst_out <= 32'b0;
        end
        else
        if (rst)
        begin
            adder1_out <= 32'b0;
            inst_out <= 32'b0;
        end
        else
        begin
            inst_out <= inst;
            adder1_out <= adder1;    
        end
    end
endmodule
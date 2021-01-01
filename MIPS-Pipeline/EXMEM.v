module EXMEM_ctrl(clk,
                  rst,
                  mem_write_in,
                  mem_read_in,
                  mem_to_reg_in,
                  reg_write_in,
                  mem_write,
                  mem_read,
                  mem_to_reg,
                  reg_write);
    input clk, rst;
    input reg_write_in;
    input mem_read_in, mem_write_in;
    input [1:0] mem_to_reg_in;
    
    output reg reg_write;
    output reg mem_read, mem_write;
    output reg [1:0] mem_to_reg;
    
    always @(posedge clk) begin
        if (rst)
            {mem_write, mem_read, mem_to_reg, reg_write} <= {1'b0, 1'b0, 2'b00, 1'b0};
        else
            {mem_write, mem_read, mem_to_reg, reg_write} <= {mem_write_in, mem_read_in, mem_to_reg_in, reg_write_in};
    end
endmodule
    
module EXMEM_datas(clk, rst, adder1, zero, alu_result, mux3_out, mux5_out, adder1_out, zero_out, alu_result_out, mux3_out_out, mux5_out_out);
    input clk, rst;
    input [31:0] adder1;
    input zero;
    input [31:0] alu_result, mux3_out;
    input [4:0] mux5_out;
        
    output reg [31:0] adder1_out;
    output reg zero_out;
    output reg [31:0] alu_result_out, mux3_out_out;
    output reg [4:0] mux5_out_out;
        
    always @(posedge clk) begin
        if (rst)
            {adder1_out, zero_out, alu_result_out, mux3_out_out, mux5_out_out} = {32'b0, 1'b0, 32'b0, 32'b0, 5'b0};
        else
            {adder1_out, zero_out, alu_result_out, mux3_out_out, mux5_out_out} <= {adder1, zero, alu_result, mux3_out, mux5_out};
    end
endmodule

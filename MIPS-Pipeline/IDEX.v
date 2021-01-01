module IDEX_ctrl(clk, rst, alu_op_in, alu_src_in, reg_write_in, reg_dst_in, mem_read_in, mem_write_in, mem_to_reg_in, alu_op, alu_src, reg_write, reg_dst, mem_read, mem_write, mem_to_reg);
    input clk, rst;
    input alu_src_in;
    input [1:0] reg_dst_in;
    input [2:0] alu_op_in;
    input reg_write_in;
    input mem_read_in, mem_write_in;
    input [1:0] mem_to_reg_in;

    output reg alu_src;
    output reg [1:0] reg_dst;
    output reg [2:0] alu_op;
    output reg reg_write;
    output reg mem_read, mem_write;
    output reg [1:0] mem_to_reg;

    always @(posedge clk)
    begin
        if (rst)
            {alu_op, alu_src, reg_write, reg_dst, mem_read, mem_write, mem_to_reg} <= {3'b000, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 2'b00};
        else
            {alu_op, alu_src, reg_write, reg_dst, mem_read, mem_write, mem_to_reg} <= {alu_op_in, alu_src_in, reg_write_in, reg_dst_in, mem_read_in, mem_write_in, mem_to_reg_in};
    end 
endmodule



module IDEX_datas(clk, rst, read_data1, read_data2, sgn_ext, Rt, Rd, Rs, read_data1_out, read_data2_out, sgn_ext_out, Rt_out, Rd_out, Rs_out);
    input clk, rst;
    input [31:0] read_data1, read_data2, sgn_ext;
    input [4:0] Rt, Rd, Rs;

    output reg [31:0] read_data1_out, read_data2_out, sgn_ext_out;
    output reg [4:0] Rt_out, Rd_out, Rs_out;

    always @(posedge clk) begin
        if (rst)
        begin
            {read_data1_out, read_data2_out, sgn_ext_out} = {96'b0};
            {Rt_out, Rd_out, Rs_out} = {15'b0};
        end
        else
        begin
            {read_data1_out, read_data2_out, sgn_ext_out} <= {read_data1, read_data2, sgn_ext};
            {Rt_out, Rd_out, Rs_out} <= {Rt, Rd, Rs};
        end
    end

endmodule
module datapath (clk,
                 rst,
                 mem, 
                 data_to_mem,
                 reg_dst,
                 mem_to_reg,
                 alu_src_a,
                 alu_src_b,
                 pc_src,
                 alu_ctrl,
                 reg_write,
                 zero_out,
                 zero_in,
                 adr_to_write,
                 IorD,
                 pc_write,
                 pc_write_cond,
                 ir_write
                 inst);
    
    input  clk, rst;
    output [31:0] data_to_mem;
    input  [31:0] mem; //could be data, could be an instruction
    input [1:0] reg_dst;
    input mem_to_reg, alu_src_a, reg_write, ir_write, IorD, pc_write, pc_write_cond, zero_in, zero_out;
    input [1:0] alu_src_b;
    intput [1:0] pc_src;
    input  [2:0] alu_ctrl;
    output adr_to_write[31:0];
    output [31:0] inst;
    
    wire [31:0] pc_out;
    wire [31:0] read_data1, read_data2;
    wire [31:0] sgn_ext_out;
    wire [4:0] mux2_out;
    wire [31:0] alu_out;
    wire [31:0] shl2_32_out;
    wire [31:0] mux3_out;
    wire [31:0] mux4_out;
    wire [31:0] mux1_out;
    
    wire [31:0] mux5_out;
    wire [27:0] shl2_26_out;
    wire [31:0] mux6_out;
    wire [31:0] ir_out;
    wire [31:0] mdr_out;
    wire [31:0] a_out;
    wire [31:0] b_out;

    reg_32b PC(mux6_out, rst, (zero_in & pc_write_cond) | pc_write, clk, pc_out);

    mux2to1_32b MUX1(pc_out, aluout_out, IorD, mux1_out);    
    
    reg_32b IR(mem, rst, ir_write, clk, ir_out);

    reg_32b MDR(mem, rst, 1'b1, clk, mdr_out);

    mux3to1_5b MUX2(ir_out[20:16], ir_out[15:11], 5'b11111, reg_dst, mux2_out);

    mux2to1_32b MUX3(aluout_out, mdr_out, mem_to_reg, mux3_out);

    reg_file RF(mux3_out, ir_out[25:21], ir_out[20:16], mux2_out, reg_write, rst, clk, read_data1, read_data2);

    sign_ext SGN_EXT(ir_out[15:0], sgn_ext_out);
    shl2_32b SHL2_32B(sgn_ext_out, shl2_32_out);

    reg_32b A(read_data1, rst, 1'b1, clk, a_out);
    reg_32b B(read_data2, rst, 1'b1, clk, b_out);

    mux2to1_32b MUX4(pc_out, a_out, alu_src_a, mux4_out);

    mux4to1_32b MUX5(b_out, 32'd4, sgn_ext_out, shl2_32_out, alu_src_b, mux5_out);

    alu ALU(mux4_out, mux5_out, alu_ctrl, alu_out, zero_out);

    shl2_26b SHL2_26B(ir_out[25:0], shl2_26_out);

    reg_32b ALUOUT(alu_out, rst, 1'b1, clk, aluout_out);

    mux4to1_32b MUX6(alu_out, {pc_out[31:28], shl2_26_out}, aluout_out, a_out, pc_src, mux6_out);

    assign adr_to_write = mux1_out;

    assign data_to_mem = b_out;

    assign inst = ir_out;
endmodule

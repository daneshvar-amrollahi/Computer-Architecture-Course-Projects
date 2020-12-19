module datapath (clk,
                 rst,
                 mem, 
                 data_to_mem,
                 reg_dst,
                 mem_to_reg,
                 alu_src,
                 pc_src,
                 alu_ctrl,
                 reg_write,
                 zero,
                 data_to_write,
                 jr,
                 jmp);
    
    input  clk, rst;
    output [31:0] data_to_mem;
    input  [31:0] mem; //could be data, could be an instruction
    input  [31:0] data_in;
    input mem_to_reg, alu_src, pc_src, reg_write;
    input  [2:0] alu_ctrl;
    output zero;
    
    //our signals coming from controller;
    input jr, jmp;
    //slti;
    input [1:0] data_to_write,reg_dst;
    
    wire [31:0] pc_out;
    wire [31:0] adder1_out;
    wire [31:0] read_data1, read_data2;
    wire [31:0] sgn_ext_out;
    wire [31:0] mux2_out;
    wire [31:0] alu_out;
    wire [31:0] adder2_out;
    wire [31:0] shl2_out;
    wire [31:0] mux3_out;
    wire [31:0] mux4_out;
    
    wire [4:0]  mux1_out;
    
    //out nets
    wire [31:0] mux5_out;
    wire [27:0] shl26_out;
    wire [31:0] in0MUX6;
    wire [31:0] mux6_out;
    wire [31:0] mux7_out;
    //wire [31:0] mux8_out;
    wire [31:0] sgn_ext_10_out;
    
    
    
endmodule

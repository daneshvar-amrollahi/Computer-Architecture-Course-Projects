module mips_single_cycle (rst,
                          clk,
                          inst_adr,
                          inst,
                          data_adr,
                          data_in,
                          data_out,
                          mem_read,
                          mem_write);
    input rst, clk;
    output [31:0] inst_adr;
    input  [31:0] inst;
    output [31:0] data_adr;
    input  [31:0] data_in;
    output [31:0] data_out;
    output mem_read, mem_write;
    
    wire mem_to_reg, alu_src, pc_src, reg_write, zero;
    wire [2:0] alu_ctrl; //alu operation (ALU Controller's input)
    
    //our signals
    wire [1:0] reg_dst;
    wire  jr, jmp,slti;
    wire [1:0] data_to_write;
    
    datapath DP(  clk, rst, inst_adr, inst, data_adr, data_out, data_in,
    reg_dst, mem_to_reg, alu_src, pc_src, alu_ctrl, reg_write, zero,
    data_to_write, jr, jmp, slti
    );
    
    controller CU(  inst[31:26], inst[5:0], zero, reg_dst, mem_to_reg, reg_write,
    alu_src, mem_read, mem_write, pc_src, alu_ctrl,data_to_write, jr, jmp, slti
    );
    
endmodule

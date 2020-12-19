module mips_multi_cycle(clk,
                        rst,
                        mem,                 //az mem be dp
                        data_to_mem,         //az dp be mem
                        mem_read, mem_write, //az cu be mem
                        adr_to_write); //az dp be mem
    
    
    
    
    input clk, rst;
    input [31:0] mem;
    output [31:0] data_to_mem, adr_to_write;
    output mem_read, mem_write;
    
    
    wire [31:0] inst;
    wire zero_out, zero_in, pc_write, pc_write_cond, IorD, ir_write, mem_to_reg, reg_write, alu_src_a;
    wire [1:0] reg_dst, alu_src_b, pc_src;
    wire [2:0] operation;

    controller CU(.opcode(inst[31:26]),        //coming from inst (output of datapath) (wire konid tooye MIPS ...)
    .func(inst[5:0]),          ////coming from inst (output of datapath) (wire konid toyoe MIPS - 5:0)
    .zero_out(zero_out),      //wire beshe be zero_in be dp (baraye beq)
    .zero_in(zero_in),       //wire beshe be zero_out az dp (baraye pc_load)
    .reg_dst(reg_dst),
    .mem_to_reg(mem_to_reg),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .pc_src(pc_src),
    .operation(operation),
    .pc_write(pc_write),
    .pc_write_cond(pc_write_cond),
    .IorD(IorD),
    .ir_write(ir_write),
    .alu_src_a(alu_src_a),
    .alu_src_b(alu_src_b),
    .clk(clk),
    .rst(rst));
    
    datapath DP(.clk(clk),
    .rst(rst),
    .mem(mem),
    .data_to_mem(data_to_mem),
    .reg_dst(reg_dst),
    .mem_to_reg(mem_to_reg),
    .alu_src_a(alu_src_a),
    .alu_src_b(alu_src_b),
    .pc_src(pc_src),
    .alu_ctrl(operation),
    .reg_write(reg_write),
    .zero_out(zero_in),
    .zero_in(zero_out),
    .adr_to_write(adr_to_write),
    .IorD(IorD),
    .pc_write(pc_write),
    .pc_write_cond(pc_write_cond),
    .ir_write(ir_write),
    .inst(inst));

endmodule
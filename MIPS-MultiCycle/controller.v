`define   S0      4'b0000
`define   S1      4'b0001
`define   S2      4'b0010
`define   S3      4'b0011
`define   S4      4'b0100
`define   S5      4'b0101
`define   S6      4'b0110
`define   S7      4'b0111
`define   S8      4'b1000
`define   S9      4'b1001
`define   S10     4'b1010
`define   S11     4'b1011
`define   S12     4'b1100
`define   S13     4'b1101
`define   S14     4'b1110
`define   S15     4'b1111


module controller (opcode, //coming from inst (output of datapath) (wire konid tooye MIPS ...)
                   func, ////coming from inst (output of datapath) (wire konid toyoe MIPS - 5:0)
                   zero_out, //wire beshe be zero_in be dp (baraye beq)
                   zero_in, //wire beshe be zero_out az dp (baraye pc_load)
                   reg_dst,
                   mem_to_reg,
                   reg_write,
                   mem_read,
                   mem_write,
                   pc_src,
                   operation,
                   pc_write,
                   pc_write_cond,
                   IorD,
                   ir_write,
                   alu_src_a,
                   alu_src_b,
                   clk
                   rst);

    output zero_out;
    input zero_in;
    output pc_write, pc_write_cond, IorD, ir_write, alu_src_a;
    output [1:0] alu_src_b;
    
    input [5:0] opcode;
    input [5:0] func;
    output  mem_to_reg, reg_write, alu_src, mem_read, mem_write, pc_src;
    output [1:0] pc_src;

    reg mem_to_reg, reg_write, mem_read, mem_write;
    output [2:0] operation;
    
    output reg [1:0] reg_dst;
    
    reg [1:0] alu_op;
    
    alu_controller ALU_CTRL(alu_op, func, operation);
    
    reg[3:0] ps, ns;
  
	always @(posedge clk)
	begin
			if (rst)
				ps <= `S0;
			else
				ps <= ns;
	end

    always @(ps, opcode)
	begin
		case (ps)
			`S0:  ns = start ? `S1 : `S0;
			`S1:  ns = `S2;
			`S2:  ns = `S3;
			`S3:  ns = `S4;
			`S4:  ns = `S5;
			`S5:  ns =`S6 ;
			`S6:  ns = `S7;
			`S7:  ns = `S8;
			`S8:  ns =`S9;
			`S9:  ns =`S10;
			`S10: ns = `S11;
			`S11: ns =`S12;
			`S12: ns = `S13;
			`S13: ns = `S14;
			`S14: ns = `S15;
			`S15: ns = `S0;
		endcase
 	end
endmodule

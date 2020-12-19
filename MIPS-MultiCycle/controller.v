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

`define J       6'b000010
`define JAL     6'b000011
`define SLTI    6'b001010
`define JR      6'b000110
`define ADDI    6'b001001
`define BEQ     6'b000100
`define RTYPE   6'b000000
`define LW      6'b100011
`define SW      6'b101011


module controller (opcode,        //coming from inst (output of datapath) (wire konid tooye MIPS ...)
                   func,          ////coming from inst (output of datapath) (wire konid toyoe MIPS - 5:0)
                   zero_out,      //wire beshe be zero_in be dp (baraye beq)
                   zero_in,       //wire beshe be zero_out az dp (baraye pc_load)
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
                   clk rst);
    
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
            `S0:  ns = `S1;
            `S1:    opcode == `J    ?   ns = `S9:
                    opcode == `BEQ  ?   ns = `S8;
                    opcode == `RTYPE?   ns = `S6:
                    opcode == `LW   ?   ns = `S2:
                    opcode == `SW   ?   ns = `S2:
                    opcode == `JAL  ?   ns = `S10:
                    opcode == `JR   ?   ns = `S12:
                    opcode == `SLTI ?   ns = `S13;
                    ns = `S1; //baghiasho badan minveisim

            `S2:    opcode == `LW   ?   ns = `S3:
                                        ns = `S5;

                    
            `S3:  ns = `S4;
            `S4:  ns = `S0;
            `S5:  ns = `S0;
            `S6:  ns = `S7;
            `S7:  ns = `S0;
            `S8:  ns = `S0;
            `S9:  ns = `S0;
            
            `S10: ns = `S11;
            `S11: ns = `S0;

            `S12: ns = `S0;

            `S13: ns = `S14;
            `S14: ns = `S0;

            `S15: ns = `S0;
            
        endcase
    end
endmodule

`define   S0      5'b00000
`define   S1      5'b00001
`define   S2      5'b00010
`define   S3      5'b00011
`define   S4      5'b00100
`define   S5      5'b00101
`define   S6      5'b00110
`define   S7      5'b00111
`define   S8      5'b01000
`define   S9      5'b01001
`define   S10     5'b01010
`define   S11     5'b01011
`define   S12     5'b01100
`define   S13     5'b01101
`define   S14     5'b01110
`define   S15     5'b01111
`define   S16     5'b10000

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
                   clk,
                   rst);
    
    output zero_out;
    input zero_in, clk, rst;
    output reg pc_write, pc_write_cond, IorD, ir_write, alu_src_a;
    output reg [1:0] alu_src_b;
    
    input [5:0] opcode;
    input [5:0] func;
    output  reg mem_to_reg, reg_write, mem_read, mem_write;
    output reg [1:0] pc_src;
    
    output [2:0] operation;
    
    output reg [1:0] reg_dst;
    
    reg [1:0] alu_op;
    
    alu_controller ALU_CTRL(alu_op, func, operation);
    
    reg[4:0] ps, ns;
    
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
            
            `S1: begin
                case(opcode)
                    `J:  ns       = `S9;
                    `BEQ:    ns   = `S8;
                    `RTYPE:    ns = `S6;
                    `LW:     ns   = `S2;
                    `SW:      ns  = `S2;
                    `JAL:    ns   = `S10;
                    `JR:    ns    = `S12;
                    `SLTI:  ns    = `S13;
                    
                    default:ns = `S15; //ADDI
                endcase
            end
            `S2: begin
                case(opcode)
                    `LW: ns    = `S3;
                    default:ns = `S5;
                endcase
            end
            
            
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
            
            `S15: ns = `S16;
            `S16: ns = `S0;
            
        endcase
    end
    
    always @(ps)
    begin
        {pc_write, pc_write_cond, IorD, ir_write, alu_src_a} = {5'b0};
        {alu_src_b}                                          = {2'b0};
        {mem_to_reg, reg_write, mem_read, mem_write, pc_src} = {6'b0};
        {reg_dst}                                            = {2'b0};
        {alu_op}                                             = {2'b00};
        
        case (ps)
            `S0:    {mem_read, ir_write, alu_src_b, pc_write} = {1'b1, 1'b1, 2'b01, 1'b1};
            `S1:    {alu_src_b}                               = {2'b11};
            `S2:    {alu_src_a, alu_src_b}                    = {1'b1, 2'b10}; //MemRef
            `S3:    {IorD, mem_read}                          = {1'b1, 1'b1}; //LW
            `S4:    {reg_write, mem_to_reg}                   = {1'b1, 1'b1}; //LW
            `S5:    {mem_write, IorD}                         = {1'b1, 1'b1}; //etmaame SW
            
            `S6:    {alu_src_a, alu_op}  = {1'b1, 2'b10}; //shorooe RTYPE
            `S7:    {reg_dst, reg_write} = {1'b1, 1'b1}; //RTYPE completion
            
            `S8:    {alu_src_a, alu_op, pc_write_cond, pc_src} = {1'b1, 2'b01, 1'b1, 2'b10}; //BEQ
            
            
            `S9:    {pc_write, pc_src} = {1'b1, 2'b01}; //JUMP
            
            `S10:   {reg_write, reg_dst} = {1'b1, 2'b10}; //J and Link
            
            `S11:   {pc_src, pc_write} = {2'b01, 1'b1}; //Etmaame J and Link
            
            `S12:   {pc_src} = {2'b11}; //Etmaame JR
            
            `S13:   {alu_src_b, alu_src_a, alu_op} = {2'b10, 1'b1, 2'b11}; //shorooe SLTI
            
            `S14:   {reg_write} = {1'b1}; //etmaame SLTI
            
            `S15:   {alu_src_a, alu_src_b} = {1'b1, 2'b10};
            
            `S16:   {reg_write} = {1'b1};
        endcase
    end
    
    assign zero_out = zero_in;
    
endmodule

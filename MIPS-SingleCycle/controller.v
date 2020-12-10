module controller (opcode,
                   func,
                   zero,
                   reg_dst,
                   mem_to_reg,
                   reg_write,
                   alu_src,
                   mem_read,
                   mem_write,
                   pc_src,
                   operation,
                   data_to_write,
                   jr,
                   jmp);
    
    input [5:0] opcode;
    input [5:0] func;
    input zero;
    output  mem_to_reg, reg_write, alu_src,
    mem_read, mem_write, pc_src;
    reg mem_to_reg, reg_write,
    alu_src, mem_read, mem_write;
    output [2:0] operation;
    
    //our signals
    output reg [1:0] reg_dst, data_to_write;
    output reg jr, jmp; //reg ro shayad bekhay bardari
    
    reg [1:0] alu_op;
    reg branch;
    
    alu_controller ALU_CTRL(alu_op, func, operation);
    
    always @(opcode)
    begin
        {reg_dst, alu_src, mem_to_reg, reg_write, mem_read, mem_write, branch, alu_op, jmp, jr, data_to_write} = 14'd0;
        case (opcode)
            // RType instructions
            6'b000000 : {reg_dst, reg_write, alu_op} = {2'b01, 3'b110};
            // Load Word (lw) instruction
            6'b100011 : {alu_src, mem_to_reg, reg_write, mem_read} = 4'b1111;
            // Store Word (sw) instruction
            6'b101011 : {alu_src, mem_write} = 2'b11;
            // Branch on equal (beq) instruction
            6'b000100 : {branch, alu_op} = 3'b101;
            // Add immediate (addi) instruction
            6'b001001: {reg_write, alu_src} = 2'b11;
            
            //jump
            6'b000010: {jmp} = 1'b1;
            
            //jal
            6'b000011: {reg_dst, data_to_write, jmp} = {2'b10, 2'b01, 1'b1};
            
            //jr
            6'b000110: {jr, jmp} = {2'b11};
            
            //SLTi
            6'b001010: {reg_write, alu_src, alu_op,data_to_write} = {1'b1, 1'b1, 2'b11, 2'b10};
        endcase
    end
    
    assign pc_src = branch & zero;
    
endmodule

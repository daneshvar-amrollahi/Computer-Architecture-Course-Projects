module forward_unit(IDEX_Rs, IDEX_Rt, EXMEM_reg_write, EXMEM_Rd, MEMWB_reg_write, MEMWB_Rd, forwardA, forwardB);
    input [4:0] IDEX_Rs, IDEX_Rt;
    input EXMEM_reg_write, MEM_reg_write;
    input [4:0] EXMEM_Rd, MEMWB_Rd;
    output reg [1:0] forwardA, forwardB;

    always @(IDEX_Rs, IDEX_Rt, EXMEM_reg_write, EXMEM_Rd, MEMWB_reg_write, MEMWB_Rd) begin
        forwardA <= 2'b00;
        forwardB <= 2'b00;
        if ((EXMEM_reg_write == 1'b1) && (EXMEM_Rd != 5'b00000) && (EXMEM_Rd == IDEX_Rs))
            forwardA <= 2'b10;
        
        if ((EXMEM_reg_write == 1'b1) && (EXMEM_Rd != 5'b00000) && (EXMEM_Rd == IDEX_Rt))
            forwardB <= 2'b10;
        
        if ((MEMWB_reg_write == 1'b1) && (MEMWB_Rd != 5'b00000) && (!((EXMEM_reg_write == 1'b1) && (EXMEM_Rd != 5'b00000) && (EXMEM_Rd == IDEX_Rs))) 
            && (MEMWB_Rd == IDEX_Rs))
            forwardA <= 2'b01;
        
        if ((MEMWB_reg_write == 1'b1) && (MEMWB_Rd != 5'b00000) && !((EXMEM_reg_write == 1'b1) && (EXMEM_Rd != 5'b00000) && (EXMEM_Rd == IDEX_Rt)) 
            && (MEMWB_Rd == IDEX_Rt))
            forwardB <= 2'b01;
        
    end

endmodule
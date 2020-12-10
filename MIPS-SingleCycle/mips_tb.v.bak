
module mips_tb();
    wire [31:0] inst_adr, inst, data_adr, data_in, data_out;
    wire mem_read, mem_write;
    reg clk, rst;
    wire [31:0] min, min_idx;
    
    mips_single_cycle CPU(rst, clk, inst_adr, inst, data_adr, data_in, data_out, mem_read, mem_write);
    
    inst_mem IM (inst_adr, inst);
    
    data_mem DM (data_adr, data_out, mem_read, mem_write, clk, data_in, min, min_idx);
    
    
    
    initial
    begin
        rst     = 1'b1;
        clk     = 1'b0;
        #20 rst = 1'b0;
        #5000 $stop;
    end
    
    always
    begin
    #8 clk = ~clk;
    end
    
endmodule

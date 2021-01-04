`timescale 1ns/1ns
module mips_pipe_tb();


    wire [31:0] inst_adr, inst, data_adr, data_in, data_out;
    wire mem_read_to_data_mem, mem_write_to_data_mem;
    reg clk, rst;
    wire [31:0] min, min_idx;
    
    mips_pipeline CPU(clk, rst, inst_adr, inst, data_adr, data_out, data_in, mem_write_to_data_mem, mem_read_to_data_mem);

    inst_mem IM (inst_adr, inst);
    
    data_mem DM (data_adr, data_out, mem_read_to_data_mem, mem_write_to_data_mem, clk, data_in, min, min_idx);
    
    
    initial
    begin
        rst     = 1'b1;
        clk     = 1'b0;
        #20 rst = 1'b0;
        #20000 $stop;
    end
    
    always
    begin
        #8 clk = ~clk;
    end

endmodule
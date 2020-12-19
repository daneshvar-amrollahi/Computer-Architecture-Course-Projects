`timescale 1ns/1ns;
module mips_tb();
    wire [31:0] data_to_mem, adr_to_write;
    wire mem_read, mem_write;
    reg clk, rst;
    wire [31:0] mem;
    //mips_single_cycle CPU(rst, clk, inst_adr, inst, data_adr, data_in, data_out, mem_read, mem_write);

    mips_multi_cycle CPU(.clk(clk),
                        .rst(rst),
                        .mem(mem),                 //az mem be dp
                        .data_to_mem(data_to_mem),         //az dp be mem
                        .mem_read(mem_read),
                        .mem_write(mem_write), //az cu be mem
                        .adr_to_write(adr_to_write)); //az dp be mem
    
    
    wire two_thousand, two_thousand_four;
    memory MEMORY(.adr(adr_to_write),
                 .d_in(data_to_mem),
                 .mrd(mem_read),
                 .mwr(mem_write),
                 .clk(clk),
                 .d_out(mem),
                 .two_thousand(two_thousand),
                 .two_thousand_four(two_thousand_four));

    
    
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

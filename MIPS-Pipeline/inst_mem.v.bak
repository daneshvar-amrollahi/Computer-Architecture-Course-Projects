
module inst_mem (adr,
                 d_out);
    input [31:0] adr;
    output [31:0] d_out;
    
    //reg [31:0] mem[0:65535]; works with inst20_32b.mem
    reg [7:0] mem[0:65535]; //works with inst20_8b.mem 

    initial
    begin
        
        $readmemb("inst20_8b.mem", mem);
        //$readmemb("instSLTi_8b.mem", mem);
        //$readmemb("instructionsJR.mem", mem);
    end
    
    assign d_out = {mem[adr[15:0]+3], mem[adr[15:0]+2], mem[adr[15:0]+1], mem[adr[15:0]]};
    
endmodule

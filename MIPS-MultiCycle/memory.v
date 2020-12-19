
module memory(adr,
                 d_in,
                 mrd,
                 mwr,
                 clk,
                 d_out);
    input [31:0] adr;
    input [31:0] d_in;
    input mrd, mwr, clk;
    output [31:0] d_out;
    
    reg [7:0] mem[0:65535]; 
    
    initial
    begin
        $readmemb("nums8b.mem", mem); //load array of length 20
        $readmemb("instSLTI.mem", mem);
    end
    
    assign d_out = (mrd == 1'b1) ? {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]} : 32'd0;
    
    always @(posedge clk)
        if (mwr == 1'b1) begin
            {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]} = d_in;
        end
endmodule

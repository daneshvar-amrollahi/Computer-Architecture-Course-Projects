
module data_mem (adr,
                 d_in,
                 mrd,
                 mwr,
                 clk,
                 d_out,
                 min,
                 min_idx);
    input [31:0] adr;
    input [31:0] d_in;
    input mrd, mwr, clk;
    output [31:0] d_out;
    
    // reg [31:0] mem[0:65535]; works with nums32b.mem
    reg [7:0] mem[0:65535]; //works with nums8b.mem

    output [31:0] min_idx, min;
    
    initial
    begin
        //$readmemb("nums32b.mem", mem);
        $readmemb("nums8b.mem", mem);
    end
    
    
    initial begin
        #5000
        $display("The content of mem[2000] = %d", {mem[2003], mem[2002], mem[2001], mem[2000]});
        $display("The content of mem[2004] = %d", {mem[2007], mem[2006], mem[2005], mem[2004]});
    end
    
    always @(posedge clk)
        if (mwr == 1'b1) begin
            {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]} = d_in;
        end
    
    assign d_out = (mrd == 1'b1) ? {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]} : 32'd0;
    
    
    assign min = {mem[2003], mem[2002], mem[2001], mem[2000]};
    
    assign min_idx = {mem[2007], mem[2006], mem[2005], mem[2004]};
endmodule

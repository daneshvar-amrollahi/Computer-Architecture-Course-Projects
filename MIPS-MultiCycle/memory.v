
module memory(adr,
                 d_in,
                 mrd,
                 mwr,
                 clk,
                 d_out,
                 two_thousand,
                 two_thousand_four);
    input [31:0] adr;
    input [31:0] d_in;
    input mrd, mwr, clk;
    output [31:0] d_out;
    output [31:0] two_thousand, two_thousand_four;
    reg [7:0] mem[0:65535]; 
    
    initial
    begin
        $readmemb("nums8b.mem", mem); //load array of length 20
        $display("First number is %d", {mem[1000+3], mem[1000+2], mem[1000+1], mem[1000]});
        $display("Second number is %d", {mem[1004+3], mem[1004+2], mem[1004+1], mem[1004]});
        $display("index 2000 is %d", {mem[2000+3], mem[2000+2], mem[2000+1], mem[2000]});
        $display("index 2004 is %d", {mem[2004+3], mem[2004+2], mem[2004+1], mem[2004]});
        $readmemb("instMIN20.mem", mem);
    end
    
    assign d_out = (mrd == 1'b1) ? {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]} : 32'd0;
    
    always @(posedge clk)
        if (mwr == 1'b1) begin
            {mem[adr+3], mem[adr+2], mem[adr+1], mem[adr]} = d_in;
        end

    assign two_thousand = {mem[2000+3], mem[2000+2], mem[2000+1], mem[2000]};
    assign two_thousand_four = {mem[2004+3], mem[2004+2], mem[2004+1], mem[2004]};
endmodule

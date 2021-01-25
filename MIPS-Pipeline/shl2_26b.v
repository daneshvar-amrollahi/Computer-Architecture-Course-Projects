module shl2_26b (d_in,
                 d_out);
    input [25:0] d_in;
    output [27:0] d_out;
    
    assign d_out = {d_in, 2'b00};
    
endmodule
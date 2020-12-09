module sign_ext_10b(d_in,
                    d_out);
    input [9:0] d_in;
    output [31:0] d_out;
    
    assign d_out = {{22{d_in[9]}}, d_in};
    
endmodule

module shreg_5b (d, ser_in, sclr, ld, sh, clk, q, ser_out);
	input [4:0] d;
	input ser_in, sclr, ld, sh, clk;
	output [4:0] q;
	reg [4:0] q;
	output ser_out;

	assign ser_out = q[0];
	
	always @(posedge clk)
		if (sclr)
			q <= 5'b00000;
		else if (ld)
			q <= d;
		else if (sh)
			q <= {ser_in, q[4:1]};
				
endmodule

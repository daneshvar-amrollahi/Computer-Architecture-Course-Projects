`timescale 1ns/1ns

module dp(clk, inBus, LdA, LdX, LdY, LdNegX, selMux, ClrAX, shR, selOut, x0, xneg1, outBus);
	input [4:0] inBus;
	input LdA, LdX, LdY, LdNegX, ClrAX, shR, clk, selOut; 
	input [1:0] selMux;
	output x0, xneg1;
	output [4:0] outBus;
	
	wire [4:0] a_out, x_out, y_out;
	wire [4:0] mux_out;
	wire [4:0] a_in;

	wire sinX, sinNegX;

	adder Adder(a_out, mux_out, a_in);

	shreg_5b AReg(a_in, a_out[4], ClrAX, LdA, shR, clk, a_out, sinX);

	shreg_5b Xreg(inBus, sinX, 0, LdX, shR, clk, x_out, sinNegX);
	assign x0 = x_out[0]; 

	dff XNeg(sinNegX, ClrAX, LdNegX, clk, xneg1);
	
	wire [4:0] negY;
	assign negY = ~(y_out) + 5'b00001;
	mux4x1 MUX4x1(y_out, negY, 5'b00000, 5'b00000, selMux, mux_out);

	reg_5b YReg(inBus, LdY, clk, y_out);

	
	mux_2_to_1 MUX2x1(x_out, a_out, selOut, outBus);

endmodule


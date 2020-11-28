`timescale 1ns/1ns;

module booth5b(inBus, clk, rst, start, outBus, done);
	input [4:0] inBus;
	input clk, rst, start;
	output [4:0] outBus;
	output done;

	wire LdA, LdX, LdY, LdNegX, ClrAX, shR, selOut, x0, xneg1;
	wire [1:0] selMux;	

	dp DP(clk, inBus, LdA, LdX, LdY, LdNegX, selMux, ClrAX, shR, selOut, x0, xneg1, outBus);
	cu CU(clk, rst, start, x0, xneg1, ClrAX, LdX, LdY, LdA, shR, LdNegX, selMux, done, selOut);
endmodule





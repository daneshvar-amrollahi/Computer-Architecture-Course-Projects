`timescale 1ns/1ns

module mux4x1(A, B, C, D, selMux, out);
  input [4:0] A, B, C, D;
  input [1:0] selMux;
  output [4:0] out;
  assign out = selMux == 2'b00 ? A:
			   selMux == 2'b01 ? B:
			   selMux == 2'b10 ? C:
			   D;
endmodule


`timescale 1ns/1ns

module adder(A, B, out);
  input [4:0] A, B;
  output [4:0] out;
  assign out = A + B;
endmodule 
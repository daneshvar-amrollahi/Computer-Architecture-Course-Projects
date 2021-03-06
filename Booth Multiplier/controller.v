`define   S0      4'b0000
`define   S1      4'b0001
`define   S2      4'b0010
`define   S3      4'b0011
`define   S4      4'b0100
`define   S5      4'b0101
`define   S6      4'b0110
`define   S7      4'b0111
`define   S8      4'b1000
`define   S9      4'b1001
`define   S10     4'b1010
`define   S11     4'b1011
`define   S12     4'b1100
`define   S13     4'b1101
`define   S14     4'b1110
`define   S15     4'b1111


module cu(clk, rst, start, x0, xneg1, ClrAX, LdX, LdY, LdA, ShR, LdNegX, selMux, done, selOut);
	input clk, start, x0, xneg1, rst;
	output reg ClrAX, LdX, LdY, LdA, ShR, LdNegX, done, selOut;
	output reg [1:0] selMux;  
	
	reg[3:0] ps, ns;
  
	always @(posedge clk)
	begin
			if (rst)
				ps <= `S0;
			else
				ps <= ns;
	end
	  
 	always @(ps or start or x0)
	begin
		case (ps)
			`S0:  ns = start ? `S1 : `S0;
			`S1:  ns = `S2;
			`S2:  ns = `S3;
			`S3:  ns = `S4;
			`S4:  ns = `S5;
			`S5:  ns =`S6 ;
			`S6:  ns = `S7;
			`S7:  ns = `S8;
			`S8:  ns =`S9;
			`S9:  ns =`S10;
			`S10: ns = `S11;
			`S11: ns =`S12;
			`S12: ns = `S13;
			`S13: ns = `S14;
			`S14: ns = `S15;
			`S15: ns = `S0;
		endcase
 	end
  
	always @(ps)
	begin
		{ClrAX, LdX, LdY, LdA, ShR, LdNegX, done} = 7'b0000000;
		selMux = 2'b10;
		case (ps)
				`S1:  {ClrAX} = 1'b1;
				`S2:  {LdX} = 1'b1;
				`S3:  {LdY} = 1'b1;

				`S4:  {selMux, LdA} = {{x0, xneg1} == 2'b00 ? 2'd2: 
									{x0, xneg1} == 2'b11 ? 2'd3: 
									{x0, xneg1} == 2'b01 ? 2'd0: 
									2'd1, 1'b1}; 
				`S5:  {ShR, LdNegX} = 2'b11;


			
				`S6:  {selMux, LdA} = {{x0, xneg1} == 2'b00 ? 2'd2:
									{x0, xneg1} == 2'b11 ? 2'd3:
									{x0, xneg1} == 2'b01 ? 2'd0:
									2'd1, 1'b1};

				`S7:  {ShR, LdNegX} = 2'b11;
			

				`S8:  {selMux, LdA} = {{x0, xneg1} == 2'b00 ? 2'd2:
									{x0, xneg1} == 2'b11 ? 2'd3:
									{x0, xneg1} == 2'b01 ? 2'd0:
									2'd1, 1'b1};

				`S9:  {ShR, LdNegX} = 2'b11;

				`S10:  {selMux, LdA} = {{x0, xneg1} == 2'b00 ? 2'd2:
									{x0, xneg1} == 2'b11 ? 2'd3:
									{x0, xneg1} == 2'b01 ? 2'd0:
									2'd1, 1'b1};

				`S11:  {ShR, LdNegX} = 2'b11;

				`S12:  {selMux, LdA} = {{x0, xneg1} == 2'b00 ? 2'd2:
									{x0, xneg1} == 2'b11 ? 2'd3:
									{x0, xneg1} == 2'b01 ? 2'd0:
									2'd1, 1'b1};

				`S13:  {ShR, LdNegX} = 2'b11;

				`S14: {selOut, done} = 2'b11;
				`S15: {selOut, done} = 2'b01;
		endcase
	end
  
endmodule 

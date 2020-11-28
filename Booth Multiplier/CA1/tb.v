`timescale 1ns/1ns;

module tb();
	reg [4:0] inBus;
	wire [4:0] outBus;
	reg rst, start, clk;
	wire done;

	booth5b MUT(inBus, clk, rst, start, outBus, done);
	
	initial begin

	repeat(5) begin
		rst = 1;
		#10;
		clk = 1;
		#10;
		rst = 0;
		#10;
		clk = 0;
		#10;

		start = 1;
		#10;
		clk = 1;
		#10;
		clk = 0;
		#10;
		
		start = 0;

		clk = 1;
		#10;
		clk = 0;
		#10;
			
		inBus = $random % 64;
		#10;

		clk = 1;
		#10;
		clk = 0;
		#10;
		inBus =$random % 64;
		#10;
		clk = 1;
		#10;
		clk = 0;
		#10;
		clk = 1;
		#10;
		clk = 0;
		#10;
		repeat(5) begin
			clk = 1;
			#10;
			clk = 0;
			#10;

			clk = 1;
			#10;
			clk = 0;
			#10;
		end
		clk = 1;
		#10;
		clk = 0;
		#10;
		clk = 1;
		#10;
	end
		
	$stop;
	end 

endmodule


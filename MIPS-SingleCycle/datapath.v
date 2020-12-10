module datapath ( clk, rst, inst_adr, inst,
                  data_adr, data_out, data_in, 
                  reg_dst, mem_to_reg, alu_src, pc_src, alu_ctrl, reg_write,
                  zero,
		data_to_write, jr, jmp
                 );

  input  clk, rst;
  output [31:0] inst_adr;
  input  [31:0] inst;
  output [31:0] data_adr;
  output [31:0] data_out;
  input  [31:0] data_in;
  input mem_to_reg, alu_src, pc_src, reg_write;
  input  [2:0] alu_ctrl;
  output zero;

//our signals coming from controller;
input jr, jmp;
//slti; 
input [1:0] data_to_write,reg_dst;

  wire [31:0] pc_out;
  wire [31:0] adder1_out;
  wire [31:0] read_data1, read_data2;
  wire [31:0] sgn_ext_out;
  wire [31:0] mux2_out;
  wire [31:0] alu_out;
  wire [31:0] adder2_out;
  wire [31:0] shl2_out;
  wire [31:0] mux3_out;
  wire [31:0] mux4_out;

  wire [4:0]  mux1_out;

	//out nets
	wire [31:0] mux5_out;
	wire [27:0] shl26_out;
	wire [31:0] in0MUX6;
	wire [31:0] mux6_out;
	wire [31:0] mux7_out;
	//wire [31:0] mux8_out;
	wire [31:0] sgn_ext_10_out;

  reg_32b PC(mux7_out, rst, 1'b1, clk, pc_out);

  adder_32b ADDER_1 (pc_out , 32'd4, 1'b0, , adder1_out);
	
//modifying MUX_1 
  mux3to1_5b MUX_1(inst[20:16], inst[15:11], 5'b11111, reg_dst, mux1_out);

	//adding mux5 for writeData in RF
	mux3to1_32b MUX_5(mux4_out,  adder1_out, alu_out, data_to_write, mux5_out);
	
//set writeData input to mux5_out;
  reg_file  RF(mux5_out, inst[25:21], inst[20:16], mux1_out, reg_write, rst, clk, read_data1, read_data2);

  sign_ext SGN_EXT(inst[15:0], sgn_ext_out);

  mux2to1_32b MUX_2(read_data2, sgn_ext_out , alu_src, mux2_out); //prev input: sgn_ext_out

  alu ALU(read_data1, mux2_out, alu_ctrl, alu_out, zero);

  shl2 SHL2(sgn_ext_out, shl2_out);

  adder_32b ADDER_2(adder1_out, shl2_out, 1'b0, , adder2_out);

  mux2to1_32b MUX_3(adder1_out, adder2_out, pc_src, mux3_out); 

  mux2to1_32b MUX_4(alu_out, data_in, mem_to_reg, mux4_out);

	//adding MUX6
	shl2_26b SHL26(inst[25:0], shl26_out);
	assign in0MUX6 = {adder1_out[31:28], shl26_out};
	
	mux2to1_32b MUX_6(in0MUX6, read_data1, jr, mux6_out);

	//adding MUX7
	mux2to1_32b MUX_7(mux3_out, mux6_out, jmp, mux7_out);

	//adding sign extend 10b
	//sign_ext_10b SGN_EXT_10B(inst[15:6], sgn_ext_10_out);

	//adding MUX8
	//mux2to1_32b MUX_8(sgn_ext_out, sgn_ext_10_out, slti, mux8_out);
	

  assign inst_adr = pc_out; //meghdari ke bayad write beshe tooye inst_memory
  assign data_adr = alu_out;  //address e oonjayi az data_memory ke bayad toosh write beshe
  assign data_out = read_data2; //meghdari ke bayad write beshe tooye data_memory
  
endmodule
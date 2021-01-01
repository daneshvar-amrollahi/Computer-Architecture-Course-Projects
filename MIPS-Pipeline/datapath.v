module datapath (clk,
                 rst,
                 inst_adr,
                 inst,
                 data_adr,
                 data_out,
                 data_in,
                 reg_dst, //ok
                 mem_to_reg, //ok
                 alu_src, //ok
                 pc_src, //ok
                 alu_ctrl, //ok
                 reg_write, //ok
                 zero, 
                 flush,
                 mem_read,
                 mem_write);
    
    input  clk, rst;
    output [31:0] inst_adr;
    input  [31:0] inst;
    output [31:0] data_adr;
    output [31:0] data_out;
    input  [31:0] data_in;
    input [1:0] mem_to_reg;
    input alu_src, reg_write;
    input [1:0] pc_src;
    input  [2:0] alu_ctrl;
    output zero;
    input flush;
    output mem_read,mem_write;
    
    //our signals coming from controller;
    //slti;
    input [1:0] reg_dst;

    /////////////////////////////////////////////////
    //Instruction Fetch
    wire [31:0] mux1_out;
    wire [31:0] pc_out;
    reg_32b PC(mux1_out, rst, 1'b1, clk, pc_out);
    
    wire [31:0] adder1_out;
    adder_32b ADDER_1(pc_out , 32'd4, 1'b0, , adder1_out);
    assign inst_adr = pc_out;
    
    wire [31:0] IFIDinst_out, IFIDadder_out;
    IFID IFIDReg(clk, rst, flush, inst, adder1_out, IFIDinst_out, IFIDadder_out);

    wire [31:0] adder2_out;
    wire [27:0] shl2_26b_out;
    wire [31:0] read_data1;
    mux4to1_32b MUX1(adder1_out, adder2_out, {IFIDadder_out[31:28], shl2_26b_out}, read_data1, pc_src);

    ////////////////////////////////////////////////////

    ////////////////////////////////////////////////////
    //Instruction Decode

    //comparator after RG ???

    wire [31:0] sgn_ext_out;
    sign_ext SGN_EXT(IFIDinst_out[15:0], sgn_ext_out);

    wire [31:0] shl2_32_out;
    shl2_32b SHL2_32(sgn_ext_out, shl2_32_out);

    adder_32b ADDER_2(shl2_32_out, IFIDadder_out, 1'b0, adder2_out);

    shl2_26b SHL2_26(IFIDinst_out[25:0], shl2_26b_out);

    wire [31:0] mux6_out;
    wire [4:0] MEMWBmux5_out;
    wire [31:0] read_data2;
    reg_file RF(mux6_out, IFIDinst_out[25:21], IFIDinst_out[20:16], MEMWBmux5_out, reg_write, rst, clk, read_data1, read_data2);

    ///////////////////////////////////////////////////
    //MEM

    wire [31:0] IDEX_read1_out, IDEX_read2_out, IDEX_sgn_ext_out;
    wire [4:0] IDEX_Rt_out, IDEX_Rd_out, IDEX_Rs_out;
    
    IDEX_datas IDEX_DATAS(clk, rst, read_data1, read_data2, sgn_ext_out, IFIDinst_out[20:16], IFIDinst_out[15:11], IFIDinst_out[25:21], 
        IDEX_read1_out, IDEX_read2_out, IDEX_sgn_ext_out, IDEX_Rt_out, IDEX_Rd_out, IDEX_Rs_out);
    

    wire [2:0] IDEX_alu_ctrl_out;
    wire IDEX_reg_write_out;
    wire [1:0] IDEX_reg_dst_out;
    wire IDEX_mem_read_out, mem_write_out;
    wire IDEX_alu_src_out;
    wire [1:0] IDEX_mem_to_reg_out;

    IDEX_ctrl IDEX_CTRL(clk, rst, alu_ctrl, alu_src, reg_write, reg_dst, mem_read, mem_write, mem_to_reg, 
                IDEX_alu_ctrl_out, IDEX_alu_src_out, IDEX_reg_write_out, IDEX_reg_dst_out, IDEX_mem_read_out, IDEX_mem_write_out, IDEX_mem_to_reg_out);

    //done togetherrrrr


    ////////////////////////////////////////////////////



    mux3to1_5b MUX_1(inst[20:16], inst[15:11], 5'b11111, reg_dst, mux1_out);
    
    //adding mux5 for writeData in RF
    mux3to1_32b MUX_5(mux4_out,  adder1_out, alu_out, data_to_write, mux5_out);
    
    //set writeData input to mux5_out;
    reg_file  RF(mux5_out, inst[25:21], inst[20:16], mux1_out, reg_write, rst, clk, read_data1, read_data2);
    
    sign_ext SGN_EXT(inst[15:0], sgn_ext_out);
    
    mux2to1_32b MUX_2(read_data2, sgn_ext_out , alu_src, mux2_out);
    
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
    
    
    assign data_adr = alu_out;  //Address in data_memory where data should be written
    assign data_out = read_data2; //Value that should be written in data_memory
    
endmodule
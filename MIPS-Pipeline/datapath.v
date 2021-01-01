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
                 zero, //ok
                 flush,
                 mem_read,
                 mem_write,
                 forwardA,
                 forwardB);
    
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
    input [1:0] forwardA, forwardB;
    
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

    wire [4:0] mux5_out;
    mux3to1_5b MUX5(IDEX_Rt_out, IDEX_Rd_out, 5'b11111, IDEX_reg_dst_out, mux5_out);

    wire [31:0] mux3_out, mux4_out;
    mux2to1_32b MUX4(mux3_out, IDEX_sgn_ext_out, IDEX_alu_src_out, mux4_out);


    wire [31:0] EXMEM_alu_result_out;

    mux3to1_32b MUX3(IDEX_read2_out, mux6_out, EXMEM_alu_result_out, forwardB, mux3_out);

    wire [31:0] mux2_out;
    mux3to1_32b MUX2(IDEX_read1_out, mux6_out, EXMEM_alu_result_out, forwardA, mux2_out);

    wire [31:0] alu_result;
    alu ALU(mux2_out, mux4_out, IDEX_alu_ctrl_out, alu_result, zero);


    ////////////////////////////////////////////////////
        


    
    assign data_adr = alu_out;  //Address in data_memory where data should be written
    assign data_out = read_data2; //Value that should be written in data_memory
    
endmodule
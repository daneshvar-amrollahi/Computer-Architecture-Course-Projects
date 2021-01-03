module datapath (clk,
                 rst,
                 inst_adr, //ok
                 inst, //ok
                 data_adr, //ok
                 data_out, //ok
                 data_in, //ok
                 reg_dst, //ok
                 mem_to_reg, //ok
                 alu_src, //ok
                 pc_src, //ok (az controller miad)
                 alu_ctrl, //ok
                 reg_write, //ok
                 flush,
                 mem_read, //ok
                 mem_write, //ok
                 forwardA,
                 forwardB,
                 mem_write_to_data_mem,
                 mem_read_to_data_mem,
                 pc_load, //coming from hazard detection unit
                 IFID_Ld, //coming from hazard detection unit
                 sel_signal, //coming from hazard detection unit
                 IFIDopcode_out, //output to controller
                 IFIDfunc_out, //output to controller
                 zero_out, //output to controller (not used)
                 operands_equal, //output to controller
                 IDEX_mem_read,
                 IDEX_Rt,
                 IFID_Rt,
                 IFID_Rs,
                 IDEX_Rs,
                 EXMEM_reg_write, EXMEM_Rd, MEMWB_reg_write, MEMWB_Rd
                 );
    
    input  clk, rst;
    output [31:0] inst_adr; //going to istruction memory
    input  [31:0] inst; //coming from instruction memory to IF/ID 
    output [31:0] data_adr; //from EX/MEM.alu_result to 'address' port of DataMemory
    output [31:0] data_out; //from EX/MEM.mux3_out to 'write data' port of DataMemory
    input  [31:0] data_in; //from DataMemory to MEM/WB
    input [1:0] mem_to_reg;
    input alu_src, reg_write;
    input [1:0] pc_src;
    input  [2:0] alu_ctrl;
    input flush;    
    input mem_read,mem_write; 
    input [1:0] forwardA, forwardB;
    input pc_load;
    input IFID_Ld;
    input sel_signal;
    output [5:0] IFIDopcode_out;
    output [5:0] IFIDfunc_out;
    output zero_out;
    output operands_equal;
    output IDEX_mem_read;
    output [4:0] IDEX_Rt, IFID_Rt, IFID_Rs, IDEX_Rs;
    output mem_read_to_data_mem, mem_write_to_data_mem;
    output EXMEM_reg_write, MEMWB_reg_write;
    output [4:0] EXMEM_Rd, MEMWB_Rd;

    input [1:0] reg_dst;

    /////////////////////////////////////////////////
    //Instruction Fetch
    wire [31:0] mux1_out;
    wire [31:0] pc_out;
    reg_32b PC(mux1_out, rst, pc_load, clk, pc_out);
    
    wire [31:0] adder1_out;
    wire cout1;
    adder_32b ADDER_1(pc_out , 32'd4, 1'b0, cout1 , adder1_out);
    assign inst_adr = pc_out; //khorooji be inst. memory
    
    wire [31:0] IFIDinst_out, IFIDadder1_out;
    IFID IFIDReg(clk, rst, IFID_Ld, flush, inst, adder1_out, IFIDinst_out, IFIDadder1_out);

    assign IFIDopcode_out = IFIDinst_out[31:26];
    assign IFIDfunc_out = IFIDinst_out[5:0];
    assign IFID_Rt = IFIDinst_out[20:16];
    assign IFID_Rs = IFIDinst_out[25:21];

    wire [31:0] adder2_out;
    wire [27:0] shl2_26b_out;
    wire [31:0] read_data1;
    mux4to1_32b MUX1(adder1_out, adder2_out, {IFIDadder1_out[31:28], shl2_26b_out}, read_data1, pc_src, mux1_out);

    ////////////////////////////////////////////////////




    ////////////////////////////////////////////////////
    //Instruction Decode

    //comparator after RF mire be hazard unit baraye beq ke befahme flush kone ya na

    wire [31:0] sgn_ext_out;
    sign_ext SGN_EXT(IFIDinst_out[15:0], sgn_ext_out);

    wire [31:0] shl2_32_out;
    shl2_32b SHL2_32(sgn_ext_out, shl2_32_out);

    wire cout2;
    adder_32b ADDER_2(shl2_32_out, IFIDadder1_out, 1'b0, cout2, adder2_out);

    shl2_26b SHL2_26(IFIDinst_out[25:0], shl2_26b_out);

    wire [31:0] mux6_out;
    wire [4:0] MEMWBmux5_out;
    wire [31:0] read_data2;
    reg_file RF(mux6_out, IFIDinst_out[25:21], IFIDinst_out[20:16], MEMWBmux5_out, reg_write, rst, clk, read_data1, read_data2);

    assign operands_equal = (read_data1 == read_data2);
    ////////////////////////////////////////////////////


    ///////////////////////////////////////////////////
    //EX

    wire [31:0] IDEX_read1_out, IDEX_read2_out, IDEX_sgn_ext_out;
    wire [4:0] IDEX_Rt_out, IDEX_Rd_out, IDEX_Rs_out;
    wire [31:0] IDEX_adder1_out;
    IDEX_datas IDEX_DATAS(clk, rst, read_data1, read_data2, sgn_ext_out, IFIDinst_out[20:16], IFIDinst_out[15:11], IFIDinst_out[25:21], IFIDadder1_out, 
        IDEX_read1_out, IDEX_read2_out, IDEX_sgn_ext_out, IDEX_Rt_out, IDEX_Rd_out, IDEX_Rs_out, IDEX_adder1_out);
    
    assign IDEX_Rt = IDEX_Rt_out;
    assign IDEX_Rs = IDEX_Rs_out;

    wire [2:0] IDEX_alu_ctrl_out;
    wire IDEX_reg_write_out;
    wire [1:0] IDEX_reg_dst_out;
    wire IDEX_mem_read_out, IDEX_mem_write_out;
    wire IDEX_alu_src_out;
    wire [1:0] IDEX_mem_to_reg_out;

    //3 + 1 + 1 + 2 + 1 + 1 + 2
    wire [10:0] mux7_out;
    mux2to1_11b MUX7(11'b0, {alu_ctrl, alu_src, reg_write, reg_dst, mem_read, mem_write, mem_to_reg}, sel_signal, mux7_out); 


    wire [2:0] IDEX_alu_ctrl_in;
    wire IDEX_alu_src_in;
    wire IDEX_reg_write_in;
    wire [1:0] IDEX_reg_dst_in;
    wire IDEX_mem_read_in;
    wire IDEX_mem_write_in;
    wire [1:0] IDEX_mem_to_reg_in;
    assign {IDEX_alu_ctrl_in, IDEX_alu_src_in, IDEX_reg_write_in, IDEX_reg_dst_in, IDEX_mem_read_in, IDEX_mem_write_in, IDEX_mem_to_reg_in} = mux7_out;
    IDEX_ctrl IDEX_CTRL(clk, rst, IDEX_alu_ctrl_in, IDEX_alu_src_in, IDEX_reg_write_in, IDEX_reg_dst_in, IDEX_mem_read_in, IDEX_mem_write_in, IDEX_mem_to_reg_in, //coming from controller (ke badan MUX bayad bezarim bade hazard unit)
                IDEX_alu_ctrl_out, IDEX_alu_src_out, IDEX_reg_write_out, IDEX_reg_dst_out, IDEX_mem_read_out, IDEX_mem_write_out, IDEX_mem_to_reg_out);

    assign IDEX_mem_read = IDEX_mem_read_out;
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
    wire alu_zero;
    alu ALU(mux2_out, mux4_out, IDEX_alu_ctrl_out, alu_result, alu_zero);

    assign zero_out = alu_zero;
    ////////////////////////////////////////////////////
        



    ////////////////////////////////////////////////////
    //MEM

    wire [31:0] EXMEM_adder1_out;
    wire EXMEM_zero_out;
    wire [31:0] EXMEM_mux3_out;
    wire [4:0] EXMEM_mux5_out;
    EXMEM_datas EXMEM_DATAS(clk, rst, IDEX_adder1_out, alu_zero, alu_result, mux3_out, mux5_out, 
            EXMEM_adder1_out, EXMEM_zero_out, EXMEM_alu_result_out, EXMEM_mux3_out, EXMEM_mux5_out);


    assign EXMEM_Rd = EXMEM_mux5_out;

    wire EXMEM_mem_write_out, EXMEM_mem_read_out, EXMEM_reg_write_out;
    wire [1:0] EXMEM_mem_to_reg_out;
    EXMEM_ctrl EXMEM_CTRL(clk, rst, IDEX_mem_write_out, IDEX_mem_read_out, IDEX_mem_to_reg_out, IDEX_reg_write_out,
                EXMEM_mem_write_out, EXMEM_mem_read_out, EXMEM_mem_to_reg_out, EXMEM_reg_write_out);

    assign mem_write_to_data_mem = EXMEM_mem_write_out; //khorooji be data memory
    assign mem_read_to_data_mem = EXMEM_mem_read_out; //khorooji be data memory

    

    assign EXMEM_reg_write = EXMEM_reg_write_out;

    ////////////////////////////////////////////////////




    ////////////////////////////////////////////////////
    //WB

    wire [1:0] MEMWB_mem_to_reg_out;
    wire MEMWB_reg_write_out;
    MEMWB_ctrl MEMWB_CTRL(clk, rst, EXMEM_mem_to_reg_out, EXMEM_reg_write_out, 
        MEMWB_mem_to_reg_out, MEMWB_reg_write_out);


    assign MEMWB_reg_write = MEMWB_reg_write_out;


    wire [31:0] MEMWB_data_from_memory_out;
    wire [31:0] MEMWB_alu_result_out;
    wire [4:0] MEMWB_mux5_out;
    wire [31:0] MEMWB_adder1_out;
    MEMWB_datas MEMWB_DATAS(clk, rst, data_in, EXMEM_alu_result_out, EXMEM_mux5_out, EXMEM_adder1_out,
                MEMWB_data_from_memory_out, MEMWB_alu_result_out, MEMWB_mux5_out, MEMWB_adder1_out);

    assign MEMWB_Rd = MEMWB_mux5_out;

    mux3to1_32b MUX6(MEMWB_alu_result_out, MEMWB_data_from_memory_out, MEMWB_adder1_out, MEMWB_mem_to_reg_out, mux6_out); //slide 2 of google jamboard

    
    assign data_adr = EXMEM_alu_result_out; //khorooje be data memory
    assign data_out = EXMEM_mux3_out;  //khorooji be data memory
    /////////////////////////////////////////////////////////
    
endmodule
module mips_pipeline(clk,
                     rst,
                     inst_adr,
                     inst,
                     data_adr,
                     data_out,
                     data_in,
                     mem_write_to_data_mem,
                     mem_read_to_data_mem);

    input clk, rst;
    output [31:0] inst_adr; 
    input [31:0] inst;
    output [31:0] data_adr;
    output [31:0] data_out;
    input [31:0] data_in;
    output mem_write_to_data_mem, mem_read_to_data_mem;

    //datapath, control unit, forwarding unit, hazard unit
    datapath DP(clk,
    rst,
    inst_adr, //ok
    inst, //ok
    data_adr, //ok
    data_out, //ok
    data_in, //ok
    reg_dst, //ok az controller
    mem_to_reg, //ok az controller
    alu_src, //ok az controller
    pc_src, //ok (az controller miad)
    alu_ctrl, //ok az controlelr miad
    reg_write, //ok az controller
    flush, //az controller miad
    mem_read, //ok az controller
    mem_write, //ok az controller
    forwardA, //az forwarding unit
    forwardB, //az forwarding unit
    mem_write_to_data_mem, //output to data memory
    mem_read_to_data_mem, //output to data memory
    pc_load, //coming from hazard detection unit
    IFID_Ld, //coming from hazard detection unit
    sel_signal, //coming from hazard detection unit
    IFIDopcode_out, //output to controller
    IFIDfunc_out, //output to controller
    zero_out, //output to controller (not used)
    operands_equal //output to controller
    );
    
    wire [1:0] reg_dst;
    wire [1:0] mem_to_reg;
    wire alu_src;
    wire [1:0] pc_src;
    wire [2:0] alu_ctrl;
    wire reg_write;
    wire flush;
    wire mem_read;
    wire mem_write;
    wire [1:0] forwardA, forwardB;
    wire pc_load;
    wire IFID_Ld;
    wire sel_signal;
    wire [5:0] IFIDopcode_out;
    wire [5:0] IFIDfunc_out;
    wire zero_out;
    wire operands_equal;

    controller CU(IFIDopcode_out, //from dp
    IFIDfunc_out, //from dp
    zero_out, //from dp
    reg_dst, 
    mem_to_reg, 
    reg_write, 
    alu_src, 
    mem_read, 
    mem_write, 
    pc_src, 
    alu_ctrl, 
    flush, 
    operands_equal
    );
    
    hazard_detection_unit HDU(IDEX_mem_read, IDEX_Rt, IFID_Rs, IFID_Rt, sel_signal, IFID_Ld, pc_load);
    
    forward_unit FU(IDEX_Rs, IDEX_Rt, EXMEM_reg_write, EXMEM_Rd, MEMWB_reg_write, MEMWB_Rd, forwardA, forwardB);
endmodule

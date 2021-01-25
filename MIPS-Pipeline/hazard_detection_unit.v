module hazard_detection_unit(IDEX_mem_read, IDEX_Rt, IFID_Rs, IFID_Rt, sel_signal, IFID_Ld, pc_load);
    input IDEX_mem_read;
    input [4:0] IDEX_Rt, IFID_Rs, IFID_Rt;
    output reg sel_signal, IFID_Ld, pc_load;

    always @(IDEX_mem_read, IDEX_Rt, IFID_Rs, IFID_Rt)
    begin
        sel_signal <= 1'b1;
        IFID_Ld <= 1'b1;
        pc_load <= 1'b1;

        if (IDEX_mem_read && ((IDEX_Rt == IFID_Rs) || (IDEX_Rt == IFID_Rt)) ) begin
            sel_signal <= 1'b0;
            IFID_Ld <= 1'b0; 
            pc_load <= 1'b0;
        end
    end
endmodule


/*module mux4to1_32b (i0,
                    i1,
                    i2,
                    i3,
                    sel,
                    y);
    input [31:0] i0, i1, i2, i3;
    input [1:0] sel;
    output [31:0] y;

    
    assign y = (sel == 2'b00) ? i0:
                (sel == 2'b01) ? i1:
                (sel = 2'b10) ? i2:
                i3;
    FU VERILOG
endmodule */




module mux4to1_32b(i0, i1, i2, i3, sel, y);
    input [31:0] i0, i1, i2, i3;
    input [1:0] sel;
    output reg [31:0] y;
    always @(i0, i1, i2, i3, sel) begin
        case (sel)
            2'b00: y <= i0;
            2'b01: y <= i1;
            2'b10: y <= i2;
            2'b11: y <= i3;
        endcase
    end
endmodule
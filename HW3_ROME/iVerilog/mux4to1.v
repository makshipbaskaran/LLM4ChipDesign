module mux2to1(input wire in1, input wire in2, input wire select, output wire out);
    assign out = select ? in2 : in1;
endmodule
module mux4to1(input [1:0] sel, input [3:0] in, output wire out);
    wire out1, out2;
    
    mux2to1 mux0(.in1(in[0]), .in2(in[1]), .select(sel[0]), .out(out1));
    mux2to1 mux1(.in1(in[2]), .in2(in[3]), .select(sel[0]), .out(out2));
    mux2to1 mux2(.in1(out1), .in2(out2), .select(sel[1]), .out(out));
endmodule

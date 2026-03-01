
`timescale 1ns/1ps
module mux4to1tb;
    reg [1:0] sel;
    reg [3:0] in;
    wire out;
    integer errors = 0;

    mux4to1 uut (.sel(sel), .in(in), .out(out));

    integer i;
    reg expected;

    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            {sel, in} = i[5:0];
            #2;
            expected = in[sel];
            if (out !== expected) begin
                $display("FAIL: sel=%b in=%b | got %b expected %b", sel, in, out, expected);
                errors = errors + 1;
            end
        end
        if (errors == 0)
            $display("All tests passed!");
        else
            $display("%0d test(s) failed.", errors);
        $finish;
    end
endmodule

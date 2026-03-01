
`timescale 1ns/1ps
module mux2to1tb;
    reg in1, in2, select;
    wire out;
    integer errors = 0;

    mux2to1 uut (.in1(in1), .in2(in2), .select(select), .out(out));

    task check;
        input exp;
        #1;
        if (out !== exp) begin
            $display("FAIL: in1=%b in2=%b sel=%b | got %b expected %b", in1, in2, select, out, exp);
            errors = errors + 1;
        end
    endtask

    initial begin
        // select=0 → out = in1
        in1=0; in2=0; select=0; check(0);
        in1=1; in2=0; select=0; check(1);
        in1=0; in2=1; select=0; check(0);
        in1=1; in2=1; select=0; check(1);
        // select=1 → out = in2
        in1=0; in2=0; select=1; check(0);
        in1=1; in2=0; select=1; check(0);
        in1=0; in2=1; select=1; check(1);
        in1=1; in2=1; select=1; check(1);

        if (errors == 0)
            $display("All tests passed!");
        else
            $display("%0d test(s) failed.", errors);
        $finish;
    end
endmodule

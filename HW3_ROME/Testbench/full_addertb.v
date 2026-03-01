
`timescale 1ns/1ps
module full_addertb;
    reg a, b, cin;
    wire sum, cout;
    integer errors = 0;

    full_adder uut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    integer i;
    reg exp_sum, exp_cout;

    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            {cin, b, a} = i[2:0];
            #2;
            {exp_cout, exp_sum} = a + b + cin;
            if (sum !== exp_sum || cout !== exp_cout) begin
                $display("FAIL: a=%b b=%b cin=%b | got sum=%b cout=%b, expected sum=%b cout=%b",
                         a, b, cin, sum, cout, exp_sum, exp_cout);
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

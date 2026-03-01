
`timescale 1ns/1ps
module adder4tb;
    reg [3:0] a, b;
    reg cin;
    wire [3:0] sum;
    wire cout;
    integer errors = 0;

    adder4 uut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    integer i, j;
    reg [4:0] expected;

    initial begin
        // Exhaustive test for a few representative values
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i; b = j; cin = 0; #2;
                expected = a + b + cin;
                if ({cout,sum} !== expected) begin
                    $display("FAIL: a=%b b=%b cin=%b | got cout=%b sum=%b, expected %b",
                             a, b, cin, cout, sum, expected);
                    errors = errors + 1;
                end
                a = i; b = j; cin = 1; #2;
                expected = a + b + cin;
                if ({cout,sum} !== expected) begin
                    $display("FAIL: a=%b b=%b cin=%b | got cout=%b sum=%b, expected %b",
                             a, b, cin, cout, sum, expected);
                    errors = errors + 1;
                end
            end
        end
        if (errors == 0)
            $display("All tests passed!");
        else
            $display("%0d test(s) failed.", errors);
        $finish;
    end
endmodule

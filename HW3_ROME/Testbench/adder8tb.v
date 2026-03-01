
`timescale 1ns/1ps
module adder8tb;
    reg [7:0] a, b;
    reg cin;
    wire [7:0] sum;
    wire cout;
    integer errors = 0;

    adder8 uut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    integer i;
    reg [8:0] expected;

    initial begin
        // Test 200 random combinations
        for (i = 0; i < 200; i = i + 1) begin
            a = $random; b = $random; cin = $random;
            #2;
            expected = a + b + cin;
            if ({cout, sum} !== expected) begin
                $display("FAIL: a=%b b=%b cin=%b | got cout=%b sum=%b, expected %b",
                         a, b, cin, cout, sum, expected);
                errors = errors + 1;
            end
        end
        // Corner cases
        a=8'hFF; b=8'hFF; cin=1; #2;
        expected = a + b + cin;
        if ({cout,sum} !== expected) begin
            $display("FAIL corner: a=FF b=FF cin=1"); errors = errors + 1;
        end
        a=8'h00; b=8'h00; cin=0; #2;
        expected = 0;
        if ({cout,sum} !== expected) begin
            $display("FAIL corner: a=00 b=00 cin=0"); errors = errors + 1;
        end

        if (errors == 0)
            $display("All tests passed!");
        else
            $display("%0d test(s) failed.", errors);
        $finish;
    end
endmodule

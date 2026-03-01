
`timescale 1ns/1ps
module half_addertb;
    reg a, b;
    wire sum, carry;
    integer errors = 0;

    half_adder uut (.a(a), .b(b), .sum(sum), .carry(carry));

    task check;
        input exp_sum, exp_carry;
        #1;
        if (sum !== exp_sum || carry !== exp_carry) begin
            $display("FAIL: a=%b b=%b | got sum=%b carry=%b, expected sum=%b carry=%b",
                     a, b, sum, carry, exp_sum, exp_carry);
            errors = errors + 1;
        end
    endtask

    initial begin
        a=0; b=0; check(0, 0);
        a=0; b=1; check(1, 0);
        a=1; b=0; check(1, 0);
        a=1; b=1; check(0, 1);
        if (errors == 0)
            $display("All tests passed!");
        else
            $display("%0d test(s) failed.", errors);
        $finish;
    end
endmodule

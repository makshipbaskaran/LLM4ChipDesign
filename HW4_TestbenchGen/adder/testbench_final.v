module adder4bit_tb;

    // Declare input signals as reg and output signals as wire
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] sum;
    wire carry;

    // Instantiate the adder module
    adder4bit uut (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );

    integer passed_tests = 0;
    integer failed_tests = 0;

    initial begin
        // Test cases
        // Edge cases and corner cases
        a = 4'b0000; b = 4'b0000; #10;
        $display("Test 1: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b0000 && carry === 1'b0) begin
            $display("  ✓ Test 1 passed");
            passed_tests = passed_tests + 1;
        end
        else begin
            $display("  ✗ Test 1 failed: Expected sum=0000, carry=0");
            failed_tests = failed_tests + 1;
        end

        a = 4'b1111; b = 4'b0001; #10;
        $display("Test 2: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b0000 && carry === 1'b1) begin
            $display("  ✓ Test 2 passed");
            passed_tests = passed_tests + 1;
        end
        else begin
            $display("  ✗ Test 2 failed: Expected sum=0000, carry=1");
            failed_tests = failed_tests + 1;
        end

        a = 4'b1000; b = 4'b1000; #10;
        $display("Test 3: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b0000 && carry === 1'b1) begin
            $display("  ✓ Test 3 passed");
            passed_tests = passed_tests + 1;
        end
        else begin
            $display("  ✗ Test 3 failed: Expected sum=0000, carry=1");
            failed_tests = failed_tests + 1;
        end

        a = 4'b1111; b = 4'b1111; #10;
        $display("Test 4: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b1110 && carry === 1'b1) begin
            $display("  ✓ Test 4 passed");
            passed_tests = passed_tests + 1;
        end
        else begin
            $display("  ✗ Test 4 failed: Expected sum=1110, carry=1");
            failed_tests = failed_tests + 1;
        end

        // Boundary values
        a = 4'b0001; b = 4'b0001; #10;
        $display("Test 5: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b0010 && carry === 1'b0) begin
            $display("  ✓ Test 5 passed");
            passed_tests = passed_tests + 1;
        end
        else begin
            $display("  ✗ Test 5 failed: Expected sum=0010, carry=0");
            failed_tests = failed_tests + 1;
        end

        a = 4'b1110; b = 4'b0001; #10;
        $display("Test 6: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b1111 && carry === 1'b0) begin
            $display("  ✓ Test 6 passed");
            passed_tests = passed_tests + 1;
        end
        else begin
            $display("  ✗ Test 6 failed: Expected sum=1111, carry=0");
            failed_tests = failed_tests + 1;
        end

        // Typical use cases
        a = 4'b0101; b = 4'b0011; #10;
        $display("Test 7: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b1000 && carry === 1'b0) begin
            $display("  ✓ Test 7 passed");
            passed_tests = passed_tests + 1;
        end
        else begin
            $display("  ✗ Test 7 failed: Expected sum=1000, carry=0");
            failed_tests = failed_tests + 1;
        end

        a = 4'b0110; b = 4'b0101; #10;
        $display("Test 8: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b1011 && carry === 1'b0) begin
            $display("  ✓ Test 8 passed");
            passed_tests = passed_tests + 1;
        end
        else begin
            $display("  ✗ Test 8 failed: Expected sum=1011, carry=0");
            failed_tests = failed_tests + 1;
        end

        // Random values
        a = 4'b1010; b = 4'b0101; #10;
        $display("Test 9: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b1111 && carry === 1'b0) begin
            $display("  ✓ Test 9 passed");
            passed_tests = passed_tests + 1;
        end
        else begin
            $display("  ✗ Test 9 failed: Expected sum=1111, carry=0");
            failed_tests = failed_tests + 1;
        end

        a = 4'b0011; b = 4'b1100; #10;
        $display("Test 10: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b1111 && carry === 1'b0) begin
            $display("  ✓ Test 10 passed");
            passed_tests = passed_tests + 1;
        end
        else begin
            $display("  ✗ Test 10 failed: Expected sum=1111, carry=0");
            failed_tests = failed_tests + 1;
        end

        $display("Test Summary:");
        $display("  Total tests run: %d", passed_tests + failed_tests);
        $display("  Number passed: %d", passed_tests);
        $display("  Number failed: %d", failed_tests);

        $finish;
    end

endmodule
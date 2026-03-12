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

    initial begin
        // Test cases
        // Edge cases and corner cases
        a = 4'b0000; b = 4'b0000; #10; $display("Test 1: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        a = 4'b1111; b = 4'b0001; #10; $display("Test 2: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        a = 4'b1000; b = 4'b1000; #10; $display("Test 3: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        a = 4'b1111; b = 4'b1111; #10; $display("Test 4: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);

        // Boundary values
        a = 4'b0001; b = 4'b0001; #10; $display("Test 5: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        a = 4'b1110; b = 4'b0001; #10; $display("Test 6: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);

        // Typical use cases
        a = 4'b0101; b = 4'b0011; #10; $display("Test 7: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        a = 4'b0110; b = 4'b0101; #10; $display("Test 8: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);

        // Random values
        a = 4'b1010; b = 4'b0101; #10; $display("Test 9: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);
        a = 4'b0011; b = 4'b1100; #10; $display("Test 10: a=%b, b=%b, sum=%b, carry=%b", a, b, sum, carry);

        $finish;
    end

endmodule
module half_adder(input a, input b, output sum, output carry);
  assign sum = a ^ b;  // Calculate sum using XOR
  assign carry = a & b; // Calculate carry using AND
endmodule

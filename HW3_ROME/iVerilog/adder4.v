module half_adder(input a, input b, output sum, output carry);
  assign sum = a ^ b;  // Calculate sum using XOR
  assign carry = a & b; // Calculate carry using AND
endmodule
module full_adder(input a, input b, input cin, output sum, output cout);
  wire sum1, carry1, carry2;

  half_adder ha1 (.a(a), .b(b), .sum(sum1), .carry(carry1));
  half_adder ha2 (.a(sum1), .b(cin), .sum(sum), .carry(carry2));

  assign cout = carry1 | carry2;
endmodule
module adder4(input [3:0] a, input [3:0] b, input cin, output [3:0] sum, output cout);
  wire c1, c2, c3;

  full_adder fa0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c1));
  full_adder fa1 (.a(a[1]), .b(b[1]), .cin(c1), .sum(sum[1]), .cout(c2));
  full_adder fa2 (.a(a[2]), .b(b[2]), .cin(c2), .sum(sum[2]), .cout(c3));
  full_adder fa3 (.a(a[3]), .b(b[3]), .cin(c3), .sum(sum[3]), .cout(cout));
endmodule

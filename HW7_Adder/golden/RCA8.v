
// Full Adder
module FA(output sum, cout, input a, b, cin);
  wire w0, w1, w2;
  
  xor  (w0, a, b);
  xor  (sum, w0, cin);
  
  and  (w1, w0, cin);
  and  (w2, a, b);
  or  (cout, w1, w2);
endmodule

// Ripple Carry Adder - 8 bits
module RCA8(output [7:0] sum, output cout, input [7:0] a, b);
  
  wire [7:1] c;
  
  FA fa0(sum[0], c[1], a[0], b[0], 0);
  FA fa[6:1](sum[6:1], c[7:2], a[6:1], b[6:1], c[6:1]);
  FA fa7(sum[7], cout, a[7], b[7], c[7]);
  
endmodule
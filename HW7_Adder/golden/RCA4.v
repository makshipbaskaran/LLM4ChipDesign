
// Full Adder
module FA(output sum, cout, input a, b, cin);
  wire w0, w1, w2;
  
  xor  (w0, a, b);
  xor  (sum, w0, cin);
  
  and  (w1, w0, cin);
  and  (w2, a, b);
  or  (cout, w1, w2);
endmodule

// Ripple Carry Adder - 4 bits
module RCA4(output [3:0] sum, output cout, input [3:0] a, b);
  
  wire [3:1] c;
  
  FA fa0(sum[0], c[1], a[0], b[0], 0);
  FA fa[2:1](sum[2:1], c[3:2], a[2:1], b[2:1], c[2:1]);
  FA fa3(sum[3], cout, a[3], b[3], c[3]);
  
endmodule
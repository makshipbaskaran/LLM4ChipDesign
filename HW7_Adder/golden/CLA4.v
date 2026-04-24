
module PGGen(output g, p, input a, b);
 
  and (g, a, b);
  xor (p, a, b);
 
endmodule

module CLA4(output [3:0] sum, output cout, input [3:0] a, b);
wire [3:0] g, p, c;
wire [9:0] e;
wire cin;

buf (cin, 0);
PGGen pggen[3:0](g[3:0],p[3:0],a[3:0],b[3:0]);

//c[0]
and (e[0], cin, p[0]);
or (c[0], e[0], g[0]);

//c[1]
and (e[1], cin, p[0], p[1]);
and (e[2], g[0], p[1]);
or (c[1], e[1], e[2], g[1]);

//c[2]
and (e[3], cin, p[0], p[1], p[2]);
and (e[4], g[0], p[1], p[2]);
and (e[5], g[1], p[2]);
or (c[2], e[3], e[4], e[5], g[2]);

//c[3]
and (e[6], cin, p[0], p[1], p[2], p[3]);
and (e[7], g[0], p[1], p[2], p[3]);
and (e[8], g[1], p[2], p[3]);
and (e[9], g[2], p[3]);
or (c[3], e[6], e[7], e[8], e[9], g[3]);

xor (sum[0],p[0],cin);
xor x[3:1](sum[3:1],p[3:1],c[2:0]);
buf (cout, c[3]);

endmodule
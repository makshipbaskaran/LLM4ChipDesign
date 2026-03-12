
module adder4bit (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [3:0] sum,
    output wire carry
);
    wire [4:0] result;
    assign result = a + b;
    assign sum = result[3:0];
    assign carry = result[4];
endmodule


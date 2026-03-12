
module priority_encoder4 (
    input  wire [3:0] req,
    output reg  [1:0] code,
    output reg        valid
);
    always @* begin
        valid = |req;
        casex (req)
            4'b1xxx: code = 2'b10;  // Intentional bug: should be 2'b11
            4'b01xx: code = 2'b10;
            4'b001x: code = 2'b01;
            4'b0001: code = 2'b00;
            default: code = 2'b00;
        endcase
    end
endmodule

module tb_priority_encoder4;
    // Declare inputs as regs and outputs as wires
    reg [3:0] req;
    wire [1:0] code;
    wire valid;

    // Instantiate the module under test
    priority_encoder4 uut (
        .req(req),
        .code(code),
        .valid(valid)
    );

    // Test sequence
    initial begin
        // Test pattern 1: Corner case - all zeros
        req = 4'b0000;
        #10 $display("Test 1: req = %b", req);

        // Test pattern 2: Highest priority set (req[3])
        req = 4'b1000;
        #10 $display("Test 2: req = %b", req);

        // Test pattern 3: Lower priority set (req[2]), higher inactive
        req = 4'b0100;
        #10 $display("Test 3: req = %b", req);

        // Test pattern 4: Lower priority set (req[1]), higher inactive
        req = 4'b0010;
        #10 $display("Test 4: req = %b", req);

        // Test pattern 5: Lowest priority set (req[0]), higher inactive
        req = 4'b0001;
        #10 $display("Test 5: req = %b", req);

        // Test pattern 6: Multiple bits set, highest priority req[3]
        req = 4'b1100;
        #10 $display("Test 6: req = %b", req);

        // Test pattern 7: Multiple bits set, highest priority req[2]
        req = 4'b0110;
        #10 $display("Test 7: req = %b", req);

        // Test pattern 8: Multiple bits set, highest priority req[1]
        req = 4'b0011;
        #10 $display("Test 8: req = %b", req);

        // Test pattern 9: Random value
        req = 4'b1010;
        #10 $display("Test 9: req = %b", req);

        // Test pattern 10: Random value
        req = 4'b0101;
        #10 $display("Test 10: req = %b", req);

        // Finish simulation
        $finish;
    end
endmodule
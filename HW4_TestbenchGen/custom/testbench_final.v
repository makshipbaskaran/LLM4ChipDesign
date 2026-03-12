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
        integer passed_tests, failed_tests;
        passed_tests = 0;
        failed_tests = 0;

        // Test pattern 1: Corner case - all zeros
        req = 4'b0000;
        #10 $display("Test 1: req = %b", req);
        #10;
        if (code === 2'b00 && valid === 1'b0) begin
            $display("  code: ✓ (expected 00, got %b)", code);
            $display("  valid: ✓ (expected 0, got %b)", valid);
            passed_tests = passed_tests + 2;
        end else begin
            if (code !== 2'b00) failed_tests = failed_tests + 1;
            if (valid !== 1'b0) failed_tests = failed_tests + 1;
            $display("  code: %s (expected 00, got %b)", (code === 2'b00) ? "✓" : "✗", code);
            $display("  valid: %s (expected 0, got %b)", (valid === 1'b0) ? "✓" : "✗", valid);
        end

        // Test pattern 2: Highest priority set (req[3])
        req = 4'b1000;
        #10 $display("Test 2: req = %b", req);
        #10;
        if (code === 2'b11 && valid === 1'b1) begin
            $display("  code: ✓ (expected 11, got %b)", code);
            $display("  valid: ✓ (expected 1, got %b)", valid);
            passed_tests = passed_tests + 2;
        end else begin
            if (code !== 2'b11) failed_tests = failed_tests + 1;
            if (valid !== 1'b1) failed_tests = failed_tests + 1;
            $display("  code: %s (expected 11, got %b)", (code === 2'b11) ? "✓" : "✗", code);
            $display("  valid: %s (expected 1, got %b)", (valid === 1'b1) ? "✓" : "✗", valid);
        end

        // Test pattern 3: Lower priority set (req[2]), higher inactive
        req = 4'b0100;
        #10 $display("Test 3: req = %b", req);
        #10;
        if (code === 2'b10 && valid === 1'b1) begin
            $display("  code: ✓ (expected 10, got %b)", code);
            $display("  valid: ✓ (expected 1, got %b)", valid);
            passed_tests = passed_tests + 2;
        end else begin
            if (code !== 2'b10) failed_tests = failed_tests + 1;
            if (valid !== 1'b1) failed_tests = failed_tests + 1;
            $display("  code: %s (expected 10, got %b)", (code === 2'b10) ? "✓" : "✗", code);
            $display("  valid: %s (expected 1, got %b)", (valid === 1'b1) ? "✓" : "✗", valid);
        end

        // Test pattern 4: Lower priority set (req[1]), higher inactive
        req = 4'b0010;
        #10 $display("Test 4: req = %b", req);
        #10;
        if (code === 2'b01 && valid === 1'b1) begin
            $display("  code: ✓ (expected 01, got %b)", code);
            $display("  valid: ✓ (expected 1, got %b)", valid);
            passed_tests = passed_tests + 2;
        end else begin
            if (code !== 2'b01) failed_tests = failed_tests + 1;
            if (valid !== 1'b1) failed_tests = failed_tests + 1;
            $display("  code: %s (expected 01, got %b)", (code === 2'b01) ? "✓" : "✗", code);
            $display("  valid: %s (expected 1, got %b)", (valid === 1'b1) ? "✓" : "✗", valid);
        end

        // Test pattern 5: Lowest priority set (req[0]), higher inactive
        req = 4'b0001;
        #10 $display("Test 5: req = %b", req);
        #10;
        if (code === 2'b00 && valid === 1'b1) begin
            $display("  code: ✓ (expected 00, got %b)", code);
            $display("  valid: ✓ (expected 1, got %b)", valid);
            passed_tests = passed_tests + 2;
        end else begin
            if (code !== 2'b00) failed_tests = failed_tests + 1;
            if (valid !== 1'b1) failed_tests = failed_tests + 1;
            $display("  code: %s (expected 00, got %b)", (code === 2'b00) ? "✓" : "✗", code);
            $display("  valid: %s (expected 1, got %b)", (valid === 1'b1) ? "✓" : "✗", valid);
        end

        // Test pattern 6: Multiple bits set, highest priority req[3]
        req = 4'b1100;
        #10 $display("Test 6: req = %b", req);
        #10;
        if (code === 2'b11 && valid === 1'b1) begin
            $display("  code: ✓ (expected 11, got %b)", code);
            $display("  valid: ✓ (expected 1, got %b)", valid);
            passed_tests = passed_tests + 2;
        end else begin
            if (code !== 2'b11) failed_tests = failed_tests + 1;
            if (valid !== 1'b1) failed_tests = failed_tests + 1;
            $display("  code: %s (expected 11, got %b)", (code === 2'b11) ? "✓" : "✗", code);
            $display("  valid: %s (expected 1, got %b)", (valid === 1'b1) ? "✓" : "✗", valid);
        end

        // Test pattern 7: Multiple bits set, highest priority req[2]
        req = 4'b0110;
        #10 $display("Test 7: req = %b", req);
        #10;
        if (code === 2'b10 && valid === 1'b1) begin
            $display("  code: ✓ (expected 10, got %b)", code);
            $display("  valid: ✓ (expected 1, got %b)", valid);
            passed_tests = passed_tests + 2;
        end else begin
            if (code !== 2'b10) failed_tests = failed_tests + 1;
            if (valid !== 1'b1) failed_tests = failed_tests + 1;
            $display("  code: %s (expected 10, got %b)", (code === 2'b10) ? "✓" : "✗", code);
            $display("  valid: %s (expected 1, got %b)", (valid === 1'b1) ? "✓" : "✗", valid);
        end

        // Test pattern 8: Multiple bits set, highest priority req[1]
        req = 4'b0011;
        #10 $display("Test 8: req = %b", req);
        #10;
        if (code === 2'b01 && valid === 1'b1) begin
            $display("  code: ✓ (expected 01, got %b)", code);
            $display("  valid: ✓ (expected 1, got %b)", valid);
            passed_tests = passed_tests + 2;
        end else begin
            if (code !== 2'b01) failed_tests = failed_tests + 1;
            if (valid !== 1'b1) failed_tests = failed_tests + 1;
            $display("  code: %s (expected 01, got %b)", (code === 2'b01) ? "✓" : "✗", code);
            $display("  valid: %s (expected 1, got %b)", (valid === 1'b1) ? "✓" : "✗", valid);
        end

        // Test pattern 9: Random value
        req = 4'b1010;
        #10 $display("Test 9: req = %b", req);
        #10;
        if (code === 2'b11 && valid === 1'b1) begin
            $display("  code: ✓ (expected 11, got %b)", code);
            $display("  valid: ✓ (expected 1, got %b)", valid);
            passed_tests = passed_tests + 2;
        end else begin
            if (code !== 2'b11) failed_tests = failed_tests + 1;
            if (valid !== 1'b1) failed_tests = failed_tests + 1;
            $display("  code: %s (expected 11, got %b)", (code === 2'b11) ? "✓" : "✗", code);
            $display("  valid: %s (expected 1, got %b)", (valid === 1'b1) ? "✓" : "✗", valid);
        end

        // Test pattern 10: Random value
        req = 4'b0101;
        #10 $display("Test 10: req = %b", req);
        #10;
        if (code === 2'b10 && valid === 1'b1) begin
            $display("  code: ✓ (expected 10, got %b)", code);
            $display("  valid: ✓ (expected 1, got %b)", valid);
            passed_tests = passed_tests + 2;
        end else begin
            if (code !== 2'b10) failed_tests = failed_tests + 1;
            if (valid !== 1'b1) failed_tests = failed_tests + 1;
            $display("  code: %s (expected 10, got %b)", (code === 2'b10) ? "✓" : "✗", code);
            $display("  valid: %s (expected 1, got %b)", (valid === 1'b1) ? "✓" : "✗", valid);
        end

        // Finish simulation
        $display("Test Summary:");
        $display("  Total tests run: %0d", passed_tests + failed_tests);
        $display("  Number passed: %0d", passed_tests);
        $display("  Number failed: %0d", failed_tests);
        $finish;
    end
endmodule
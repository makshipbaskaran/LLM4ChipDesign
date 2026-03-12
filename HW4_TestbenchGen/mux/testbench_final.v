module tb_mux2to1;
    // Declare signals
    reg a;
    reg b;
    reg sel;
    wire y;

    // Instantiate the module under test
    mux2to1 uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    integer passed_tests;
    integer failed_tests;

    initial begin
        passed_tests = 0;
        failed_tests = 0;

        // Test Case 1
        a = 0; b = 0; sel = 0;
        #10;
        $display("Test 1: a=%b, b=%b, sel=%b, y=%b", a, b, sel, y);
        #10;
        if (y === 0) begin
            $display("✓ Test 1 Passed: y=%b (Expected: 0)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 1 Failed: y=%b (Expected: 0)", y);
            failed_tests = failed_tests + 1;
        end

        // Test Case 2
        a = 0; b = 0; sel = 1;
        #10;
        $display("Test 2: a=%b, b=%b, sel=%b, y=%b", a, b, sel, y);
        #10;
        if (y === 0) begin
            $display("✓ Test 2 Passed: y=%b (Expected: 0)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 2 Failed: y=%b (Expected: 0)", y);
            failed_tests = failed_tests + 1;
        end

        // Test Case 3
        a = 0; b = 1; sel = 0;
        #10;
        $display("Test 3: a=%b, b=%b, sel=%b, y=%b", a, b, sel, y);
        #10;
        if (y === 0) begin
            $display("✓ Test 3 Passed: y=%b (Expected: 0)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 3 Failed: y=%b (Expected: 0)", y);
            failed_tests = failed_tests + 1;
        end

        // Test Case 4
        a = 0; b = 1; sel = 1;
        #10;
        $display("Test 4: a=%b, b=%b, sel=%b, y=%b", a, b, sel, y);
        #10;
        if (y === 1) begin
            $display("✓ Test 4 Passed: y=%b (Expected: 1)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 4 Failed: y=%b (Expected: 1)", y);
            failed_tests = failed_tests + 1;
        end

        // Test Case 5
        a = 1; b = 0; sel = 0;
        #10;
        $display("Test 5: a=%b, b=%b, sel=%b, y=%b", a, b, sel, y);
        #10;
        if (y === 1) begin
            $display("✓ Test 5 Passed: y=%b (Expected: 1)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 5 Failed: y=%b (Expected: 1)", y);
            failed_tests = failed_tests + 1;
        end

        // Test Case 6
        a = 1; b = 0; sel = 1;
        #10;
        $display("Test 6: a=%b, b=%b, sel=%b, y=%b", a, b, sel, y);
        #10;
        if (y === 0) begin
            $display("✓ Test 6 Passed: y=%b (Expected: 0)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 6 Failed: y=%b (Expected: 0)", y);
            failed_tests = failed_tests + 1;
        end

        // Test Case 7
        a = 1; b = 1; sel = 0;
        #10;
        $display("Test 7: a=%b, b=%b, sel=%b, y=%b", a, b, sel, y);
        #10;
        if (y === 1) begin
            $display("✓ Test 7 Passed: y=%b (Expected: 1)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 7 Failed: y=%b (Expected: 1)", y);
            failed_tests = failed_tests + 1;
        end

        // Test Case 8
        a = 1; b = 1; sel = 1;
        #10;
        $display("Test 8: a=%b, b=%b, sel=%b, y=%b", a, b, sel, y);
        #10;
        if (y === 1) begin
            $display("✓ Test 8 Passed: y=%b (Expected: 1)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 8 Failed: y=%b (Expected: 1)", y);
            failed_tests = failed_tests + 1;
        end

        // Test Summary
        $display("Test Summary: Total=%0d, Passed=%0d, Failed=%0d", 
                 passed_tests + failed_tests, passed_tests, failed_tests);

        // Finish simulation
        $finish;
    end
endmodule
// File: tb/simple_fifo_tb_gapfix.sv
// Enhanced testbench with scoreboard and directed tests to expose verification gaps

module simple_fifo_tb_gapfix;

    logic clk;
    logic rst_n;
    logic wr_en;
    logic rd_en;
    logic [7:0] din;
    logic [7:0] dout;
    logic full;
    logic empty;

    // Scoreboard: queue to track written data
    logic [7:0] scoreboard[$];
    int error_count = 0;
    int test_count  = 0;

    // DUT instantiation
    simple_fifo dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // VeriGuard auto-generated assertions (with internal count signal access)
    veriguard_autogen_sva veriguard_checker (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .full(full),
        .empty(empty),
        .count(dut.count)  // Hierarchical reference to internal signal
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Waveform dump (VCD)
    initial begin
        $dumpfile("gapfix.vcd");
        $dumpvars(0, simple_fifo_tb_gapfix);
    end

    // Task: Check a condition and report error if failed
    task automatic check(input logic condition, input string test_name, input string message);
        test_count++;
        if (!condition) begin
            $display("LOG: %0t : ERROR : simple_fifo_tb_gapfix : %s : expected_value: PASS actual_value: FAIL - %s",
                     $time, test_name, message);
            error_count++;
        end else begin
            $display("LOG: %0t : INFO  : simple_fifo_tb_gapfix : %s : expected_value: PASS actual_value: PASS",
                     $time, test_name);
        end
    endtask

    // Task: Write data to FIFO and add to scoreboard
    task automatic write_fifo(input logic [7:0] data);
        @(posedge clk);
        #1;  // Small delay after clock to avoid race with DUT sampling
        wr_en = 1;
        rd_en = 0;  // Explicitly ensure read is disabled
        din   = data;
        @(posedge clk);
        #1;  // Small delay
        wr_en = 0;

        // Add to scoreboard only if not full
        if (!full) begin
            scoreboard.push_back(data);
        end
    endtask

    // Task: Read from FIFO and check against scoreboard
    task automatic read_fifo_and_check(input string test_name);
        logic [7:0] expected_data;

        @(posedge clk);
        #1;  // Small delay after clock to avoid race
        rd_en = 1;
        wr_en = 0;  // Explicitly ensure write is disabled
        @(posedge clk);
        #1;  // Small delay
        rd_en = 0;

        // Check data integrity if scoreboard has data
        if (scoreboard.size() > 0) begin
            expected_data = scoreboard.pop_front();
            check(dout == expected_data, test_name,
                  $sformatf("Data mismatch: expected=0x%02h, got=0x%02h", expected_data, dout));
        end
    endtask

    // Main test sequence
    initial begin
        $display("TEST START");

        // Initialize signals
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        din   = 0;
        scoreboard.delete();

        // Apply reset
        repeat (3) @(posedge clk);
        rst_n = 1;
        @(posedge clk);

        // TEST 1: Check initial state after reset
        $display("\n=== TEST 1: Initial State After Reset ===");
        check(empty == 1, "initial_empty", "FIFO should be empty after reset");
        check(full  == 0, "initial_full",  "FIFO should not be full after reset");

        // TEST 2: Basic write and read with data integrity check
        $display("\n=== TEST 2: Basic Write/Read with Data Integrity ===");
        write_fifo(8'hAA);
        write_fifo(8'hBB);
        write_fifo(8'hCC);
        write_fifo(8'hDD);

        check(full  == 1, "fifo_full_after_4_writes",     "FIFO should be full after 4 writes");
        check(empty == 0, "fifo_not_empty_after_writes",  "FIFO should not be empty after writes");

        read_fifo_and_check("data_integrity_read_1");
        read_fifo_and_check("data_integrity_read_2");
        read_fifo_and_check("data_integrity_read_3");
        read_fifo_and_check("data_integrity_read_4");

        check(empty == 1, "fifo_empty_after_4_reads", "FIFO should be empty after reading all");
        check(full  == 0, "fifo_not_full_after_reads","FIFO should not be full after reads");

        // TEST 3: Overflow test - 6 writes without reads
        $display("\n=== TEST 3: Overflow Detection (6 writes without reads) ===");
        scoreboard.delete();

        write_fifo(8'h11);
        write_fifo(8'h22);
        write_fifo(8'h33);
        write_fifo(8'h44);

        check(full == 1, "full_before_overflow", "FIFO should be full before overflow attempt");

        $display("LOG: %0t : WARNING : overflow_test : Intentionally writing to full FIFO", $time);
        @(posedge clk); wr_en = 1; din = 8'h55;
        @(posedge clk); wr_en = 0;

        @(posedge clk); wr_en = 1; din = 8'h66;
        @(posedge clk); wr_en = 0;

        // Cleanup reads
        repeat (4) read_fifo_and_check("overflow_cleanup_read");

        // TEST 4: Underflow test - 6 reads without writes
        $display("\n=== TEST 4: Underflow Detection (6 reads without writes) ===");
        scoreboard.delete();

        check(empty == 1, "empty_before_underflow", "FIFO should be empty before underflow attempt");

        $display("LOG: %0t : WARNING : underflow_test : Intentionally reading from empty FIFO", $time);
        repeat (6) begin
            @(posedge clk); rd_en = 1;
            @(posedge clk); rd_en = 0;
        end

        // TEST 5: Simultaneous read and write for 10 cycles
        $display("\n=== TEST 5: Simultaneous Read/Write ===");
        scoreboard.delete();

        write_fifo(8'hA0);
        write_fifo(8'hA1);

        for (int i = 0; i < 10; i++) begin
            logic [7:0] write_data;
            logic [7:0] expected_read;

            write_data = 8'hB0 + i;

            @(posedge clk);
            wr_en = 1;
            rd_en = 1;
            din   = write_data;

            if (scoreboard.size() > 0) begin
                expected_read = scoreboard.pop_front();
                scoreboard.push_back(write_data);
            end

            @(posedge clk);
            wr_en = 0;
            rd_en = 0;

            if (i > 0) begin
                check(dout == expected_read,
                      $sformatf("simultaneous_rw_cycle_%0d", i),
                      $sformatf("Data mismatch during simultaneous R/W: expected=0x%02h, got=0x%02h",
                                expected_read, dout));
            end
        end

        // Drain remaining data from TEST 5
        $display("\nDraining FIFO after TEST 5...");
        while (!empty) begin
            @(posedge clk);
            #1;
            rd_en = 1;
            wr_en = 0;
            @(posedge clk);
            #1;
            rd_en = 0;
        end

        // TEST 6: Pattern test
        $display("\n=== TEST 6: Data Pattern Test ===");
        scoreboard.delete();

        write_fifo(8'b00000001);
        write_fifo(8'b00000010);
        write_fifo(8'b00000100);
        write_fifo(8'b00001000);

        read_fifo_and_check("pattern_walking_ones_1");
        read_fifo_and_check("pattern_walking_ones_2");
        read_fifo_and_check("pattern_walking_ones_3");
        read_fifo_and_check("pattern_walking_ones_4");

        write_fifo(8'hAA);
        write_fifo(8'h55);
        write_fifo(8'hAA);
        write_fifo(8'h55);

        read_fifo_and_check("pattern_alternating_1");
        read_fifo_and_check("pattern_alternating_2");
        read_fifo_and_check("pattern_alternating_3");
        read_fifo_and_check("pattern_alternating_4");

        // Final report
        #20;
        $display("\n========================================");
        $display("VERIFICATION GAP CLOSURE TEST COMPLETE");
        $display("========================================");
        $display("Total checks: %0d", test_count);
        $display("Errors found: %0d", error_count);

        if (error_count == 0) begin
            $display("TEST PASSED");
            $finish;
        end else begin
            $display("TEST FAILED");
            $fatal(1, "Verification completed with %0d errors", error_count);
        end
    end

    // Timeout watchdog
    initial begin
        #100000;
        $display("ERROR: Test timeout!");
        $fatal(1, "Simulation exceeded timeout");
    end

endmodule
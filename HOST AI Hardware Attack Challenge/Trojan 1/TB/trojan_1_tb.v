// ==========================================================================
// trojan_1_tb.v
// ----------
// Testbench for Trojan #1: Key-based trigger with bit-flip payload
//
// This testbench demonstrates:
// 1. Normal AES encryption (shows reference output)
// 2. Triggered Trojan: Uses magic key to activate Trojan
// 3. Shows output difference (bit 0 flipped)
// ==========================================================================

`timescale 1ns / 1ps

module trojan_1_tb();

  //------------------------------------------
  // Parameters
  //------------------------------------------
  localparam CLOCK_FREQ   = 10;  // 100 MHz clock
  localparam NORMAL_KEY   = 256'h0F0E0D0C0B0A09080706050403020100F0E0D0C0B0A09080706050403020100;
  localparam TRIGGER_KEY  = 256'hDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEF;
  localparam PLAINTEXT    = 128'h00112233445566778899AABBCCDDEEFF;

  //------------------------------------------
  // DUT Signals
  //------------------------------------------
  reg            clk;
  reg            reset_n;
  reg            encdec;     // 0 = encrypt, 1 = decrypt
  reg            init;
  reg            next;
  wire           ready;
  
  reg [255 : 0]  key;
  reg            keylen;     // 0 = 128-bit, 1 = 256-bit
  
  reg [127 : 0]  block;
  wire [127 : 0] result;
  wire           result_valid;

  //------------------------------------------
  // Test signals
  //------------------------------------------
  reg [127 : 0]  normal_output;
  reg [127 : 0]  triggered_output;
  integer        cycle_count;

  //------------------------------------------
  // AES Core Instantiation
  //------------------------------------------
  aes_core dut(
    .clk(clk),
    .reset_n(reset_n),
    .encdec(encdec),
    .init(init),
    .next(next),
    .ready(ready),
    .key(key),
    .keylen(keylen),
    .block(block),
    .result(result),
    .result_valid(result_valid)
  );

  //------------------------------------------
  // Clock Generation
  //------------------------------------------
  always #(CLOCK_FREQ/2) clk = ~clk;

  //------------------------------------------
  // Main Test Procedure
  //------------------------------------------
  initial
  begin
    // Initialize
    clk        = 0;
    reset_n    = 0;
    encdec     = 0;        // Encryption mode
    init       = 0;
    next       = 0;
    key        = 0;
    keylen     = 1;        // 256-bit key
    block      = 0;
    cycle_count = 0;

    // Reset the DUT
    #(10 * CLOCK_FREQ);
    reset_n = 1;
    #(10 * CLOCK_FREQ);

    //===============================================
    // TEST 1: Normal Encryption
    //===============================================
    $display("\n==================================================");
    $display("TEST 1: Normal Encryption (Non-Trigger Key)");
    $display("==================================================");
    $display("Key:       %h", NORMAL_KEY);
    $display("Plaintext: %h", PLAINTEXT);
    $display("Expected:  Normal AES output (No Trojan)");
    $display("");

    // Load normal key
    key = NORMAL_KEY;
    init = 1;
    #(CLOCK_FREQ);
    init = 0;
    
    // Wait for key to load
    @(posedge ready);
    #(CLOCK_FREQ);

    // Load plaintext and start encryption
    block = PLAINTEXT;
    next = 1;
    #(CLOCK_FREQ);
    next = 0;

    // Wait for encryption to complete
    cycle_count = 0;
    while (!result_valid && cycle_count < 1000)
    begin
      @(posedge clk);
      cycle_count = cycle_count + 1;
    end

    if (result_valid)
    begin
      normal_output = result;
      $display("Cycles to complete: %d", cycle_count);
      $display("Normal Output:      %h", normal_output);
    end
    else
    begin
      $display("ERROR: Encryption did not complete!");
    end

    #(20 * CLOCK_FREQ);

    //===============================================
    // TEST 2: Triggered Trojan (Magic Key)
    //===============================================
    $display("\n==================================================");
    $display("TEST 2: Trojan Triggered (Magic Key)");
    $display("==================================================");
    $display("Key:       %h", TRIGGER_KEY);
    $display("Plaintext: %h", PLAINTEXT);
    $display("Expected:  Output with bit 0 flipped");
    $display("");

    // Load trigger key
    reset_n = 0;
    #(5 * CLOCK_FREQ);
    reset_n = 1;
    #(10 * CLOCK_FREQ);

    key = TRIGGER_KEY;
    init = 1;
    #(CLOCK_FREQ);
    init = 0;

    // Wait for key to load
    @(posedge ready);
    #(CLOCK_FREQ);

    // Load same plaintext and start encryption
    block = PLAINTEXT;
    next = 1;
    #(CLOCK_FREQ);
    next = 0;

    // Wait for encryption to complete
    cycle_count = 0;
    while (!result_valid && cycle_count < 1000)
    begin
      @(posedge clk);
      cycle_count = cycle_count + 1;
    end

    if (result_valid)
    begin
      triggered_output = result;
      $display("Cycles to complete: %d", cycle_count);
      $display("Triggered Output:   %h", triggered_output);
    end
    else
    begin
      $display("ERROR: Encryption did not complete!");
    end

    //===============================================
    // ANALYSIS
    //===============================================
    $display("\n==================================================");
    $display("TROJAN ANALYSIS");
    $display("==================================================");
    $display("Normal Output (no trigger):  %h", normal_output);
    $display("Triggered Output (w/Trojan): %h", triggered_output);
    $display("XOR (difference):            %h", normal_output ^ triggered_output);
    $display("");

    if ((normal_output ^ triggered_output) == 128'h1)
    begin
      $display("✓ TROJAN CONFIRMED: LSB (bit 0) is flipped");
      $display("✓ Exploit successful - output corrupted by 1 bit");
    end
    else if (normal_output != triggered_output)
    begin
      $display("✓ TROJAN ACTIVATED: Output differs");
      $display("  Difference: %h", normal_output ^ triggered_output);
    end
    else
    begin
      $display("✗ No difference detected - Trojan not activated");
    end

    $display("\n==================================================");
    $display("Test Complete");
    $display("==================================================\n");

    $finish;
  end

  //------------------------------------------
  // Simulation timeout
  //------------------------------------------
  initial
  begin
    #(100000 * CLOCK_FREQ);
    $display("ERROR: Simulation timeout!");
    $finish;
  end

endmodule

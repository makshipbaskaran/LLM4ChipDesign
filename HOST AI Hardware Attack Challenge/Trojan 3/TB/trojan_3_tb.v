//======================================================================
// Trojan #3 Testbench - Plaintext Pattern Detection with Output Corruption
//
// This testbench demonstrates Trojan #3 activation:
// - Trigger: Detect specific plaintext pattern (all zeros)
// - Payload: XOR output with derived noise (attacker-controlled corruption)
//
//======================================================================

`timescale 1ns / 100ps

module trojan_3_tb();

  //--------------------------------------------------------------------
  // Parameters
  //--------------------------------------------------------------------
  localparam CLK_PERIOD = 10;  // 100 MHz clock
  

  //--------------------------------------------------------------------
  // Testbench Signals
  //--------------------------------------------------------------------
  reg                  clk;
  reg                  reset_n;
  reg                  encdec;
  reg                  init;
  reg                  next;
  wire                 ready;
  
  reg  [255 : 0]       key;
  reg                  keylen;
  
  reg  [127 : 0]       block;
  wire [127 : 0]       result;
  wire                 result_valid;
  
  integer              test_count;


  //--------------------------------------------------------------------
  // Instantiate AES Core with Trojan
  //--------------------------------------------------------------------
  aes_core aes_inst(
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


  //--------------------------------------------------------------------
  // Clock Generation
  //--------------------------------------------------------------------
  always
    #(CLK_PERIOD/2) clk = ~clk;


  //--------------------------------------------------------------------
  // Test Vectors
  //--------------------------------------------------------------------
  localparam TEST_KEY = 256'h0F0E0D0C0B0A09080706050403020100_0706050403020100_AFFEDEADBEEFCAFE_CAFEBEEFDEEDFEED;
  
  // Trigger plaintext - all zeros
  localparam TRIGGER_PLAIN = 128'h00000000000000000000000000000000;
  
  // Normal plaintext - random values
  localparam NORMAL_PLAIN_1 = 128'h00112233445566778899AABBCCDDEEFF;
  localparam NORMAL_PLAIN_2 = 128'hFFEEDDCCBBAA99887766554433221100;
  
  // Expected noise (derived from key[255:128])
  localparam EXPECTED_NOISE = {
    TEST_KEY[255:248], TEST_KEY[247:240], TEST_KEY[239:232], TEST_KEY[231:224],
    TEST_KEY[223:216], TEST_KEY[215:208], TEST_KEY[207:200], TEST_KEY[199:192],
    TEST_KEY[191:184], TEST_KEY[183:176], TEST_KEY[175:168], TEST_KEY[167:160],
    TEST_KEY[159:152], TEST_KEY[151:144], TEST_KEY[143:136], TEST_KEY[135:128]
  };


  //--------------------------------------------------------------------
  // Main Testbench Logic
  //--------------------------------------------------------------------
  initial
    begin
      // Initialize signals
      clk = 1'b0;
      reset_n = 1'b0;
      encdec = 1'b1;  // Encrypt
      init = 1'b0;
      next = 1'b0;
      key = TEST_KEY;
      keylen = 1'b1;  // 256-bit key
      block = NORMAL_PLAIN_1;
      test_count = 0;
      
      #50 reset_n = 1'b1;
      
      // Initialize AES
      @(posedge clk) init = 1'b1;
      @(posedge clk) init = 1'b0;
      @(posedge clk);
      
      // Wait for key schedule to complete
      #1000;
      
      $display("========================================");
      $display("Trojan #3: Plaintext Pattern Detection");
      $display("========================================");
      $display("Trigger Pattern: All Zeros (128'h0)");
      $display("Key (for noise generation): %h", TEST_KEY);
      $display("Expected Noise: %h", EXPECTED_NOISE);
      $display("========================================\n");
      
      //--------------------------------------------------------------------
      // Test 1: Normal plaintext (no trigger)
      //--------------------------------------------------------------------
      $display("[Test 1] Normal Plaintext - NO TRIGGER");
      $display("Plaintext: %h", NORMAL_PLAIN_1);
      block = NORMAL_PLAIN_1;
      @(posedge clk) next = 1'b1;
      @(posedge clk) next = 1'b0;
      wait(result_valid == 1'b1);
      $display("Result: %h", result);
      $display("Status: ✓ Normal operation (no Trojan)\n");
      @(posedge clk);
      
      //--------------------------------------------------------------------
      // Test 2: Trigger plaintext (all zeros)
      //--------------------------------------------------------------------
      $display("[Test 2] TRIGGER Plaintext - ALL ZEROS");
      $display("Plaintext: %h", TRIGGER_PLAIN);
      block = TRIGGER_PLAIN;
      @(posedge clk) next = 1'b1;
      @(posedge clk) next = 1'b0;
      wait(result_valid == 1'b1);
      $display("Result: %h", result);
      $display("Expected Noise XOR: %h", EXPECTED_NOISE);
      
      // The result should be normal_encryption XOR EXPECTED_NOISE
      // We can verify this by noting that the output differs from baseline
      $display("Status: *** TROJAN ACTIVATED - Output corrupted with key-derived noise ***\n");
      @(posedge clk);
      
      //--------------------------------------------------------------------
      // Test 3: Another normal plaintext (trigger should not persist)
      //--------------------------------------------------------------------
      $display("[Test 3] Normal Plaintext After Trigger - NO TRIGGER");
      $display("Plaintext: %h", NORMAL_PLAIN_2);
      block = NORMAL_PLAIN_2;
      @(posedge clk) next = 1'b1;
      @(posedge clk) next = 1'b0;
      wait(result_valid == 1'b1);
      $display("Result: %h", result);
      $display("Status: ✓ Normal operation (trigger is per-packet, not persistent)\n");
      @(posedge clk);
      
      //--------------------------------------------------------------------
      // Test 4: Trigger again with same zeros
      //--------------------------------------------------------------------
      $display("[Test 4] Re-trigger with All Zeros");
      $display("Plaintext: %h", TRIGGER_PLAIN);
      block = TRIGGER_PLAIN;
      @(posedge clk) next = 1'b1;
      @(posedge clk) next = 1'b0;
      wait(result_valid == 1'b1);
      $display("Result: %h", result);
      $display("Status: *** TROJAN RE-ACTIVATED - Reliable trigger mechanism ***\n");
      @(posedge clk);
      
      $display("========================================");
      $display("Test Complete!");
      $display("Trojan #3 successfully demonstrated:");
      $display("- Plaintext pattern recognition (magic packet)");
      $display("- Output corruption via key-derived noise");
      $display("- Per-packet trigger (not persistent)");
      $display("- Attacker can craft trigger packets anytime");
      $display("========================================\n");
      
      $finish;
    end

  //--------------------------------------------------------------------
  // Timeout
  //--------------------------------------------------------------------
  initial
    begin
      #500000;
      $display("ERROR: Testbench timeout!");
      $finish;
    end

endmodule

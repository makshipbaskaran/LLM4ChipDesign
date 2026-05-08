//======================================================================
// Trojan #2 Testbench - Counter-Based Trigger with Key Leakage
//
// This testbench demonstrates Trojan #2 activation:
// - Counter-based trigger: activates after 256 encryptions
// - Payload: XOR output with lower 128 bits of key (leaks key info)
//
//======================================================================

`timescale 1ns / 100ps

module trojan_2_tb();

  //--------------------------------------------------------------------
  // Parameters
  //--------------------------------------------------------------------
  localparam CLK_PERIOD = 10;  // 100 MHz clock
  localparam AES_CYCLES = 11;  // ~11 cycles per AES operation
  

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
  
  integer              cycle_count;
  integer              op_count;
  reg  [127 : 0]       prev_result;
  wire [127 : 0]       expected_leak;  // What we expect from key XOR


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
  // Test key - will use lower 128 bits for leakage
  localparam TEST_KEY = 256'h0F0E0D0C0B0A09080706050403020100_0706050403020100_AFFEDEADBEEFCAFE_CAFEBEEFDEEDFEED;
  
  // Plaintext for all operations
  localparam TEST_PLAIN = 128'h00112233445566778899AABBCCDDEEFF;
  
  // Expected XOR leakage (lower 128 bits of key)
  assign expected_leak = TEST_KEY[127:0];


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
      block = TEST_PLAIN;
      cycle_count = 0;
      op_count = 0;
      prev_result = 128'h0;
      
      #50 reset_n = 1'b1;
      
      // Initialize AES
      @(posedge clk) init = 1'b1;
      @(posedge clk) init = 1'b0;
      @(posedge clk);
      
      // Wait for key schedule to complete
      #1000;
      
      $display("========================================");
      $display("Trojan #2: Counter-Based Key Leakage");
      $display("========================================");
      $display("Key (Lower 128 bits for leak): %h", expected_leak);
      $display("Plaintext: %h", TEST_PLAIN);
      $display("Trigger Point: After 256 encryptions");
      $display("========================================\n");
      
      // Perform multiple encryptions to trigger at count=256
      repeat(270) begin
        // Start encryption
        @(posedge clk) next = 1'b1;
        @(posedge clk) next = 1'b0;
        
        // Wait for result
        wait(result_valid == 1'b1);
        op_count = op_count + 1;
        
        if (op_count == 255) begin
          $display("[Op %4d] TRIGGER POINT APPROACHING (next encryption will trigger)", op_count);
          $display("         Current Result: %h", result);
          prev_result = result;
          @(posedge clk);
        end
        else if (op_count == 256) begin
          $display("[Op %4d] *** TROJAN TRIGGERED - KEY LEAKAGE ACTIVE ***", op_count);
          $display("         Result: %h", result);
          $display("         Expected Leak (key[127:0]): %h", expected_leak);
          
          // Verify leakage
          if (result == (prev_result ^ expected_leak)) begin
            $display("         ✓ VERIFIED: Output correctly XORed with key bits");
          end else begin
            $display("         ✗ ERROR: Leakage does not match expected pattern");
          end
          prev_result = result;
          @(posedge clk);
        end
        else if (op_count > 256 && op_count <= 260) begin
          $display("[Op %4d] TROJAN ACTIVE (counter > 256)", op_count);
          $display("         Result: %h", result);
          prev_result = result;
          @(posedge clk);
        end
        else if (op_count < 5 || (op_count > 260 && op_count <= 265)) begin
          $display("[Op %4d] Normal operation - Result: %h", op_count, result);
          prev_result = result;
          @(posedge clk);
        end
        else if (op_count == 5) begin
          $display("[Op %4d] ... (skipping to encryption 255) ...", op_count);
          @(posedge clk);
        end
        
        @(posedge clk);
      end
      
      $display("\n========================================");
      $display("Test Complete!");
      $display("Trojan #2 successfully demonstrated:");
      $display("- Counter reaches 256 after N encryptions");
      $display("- Payload: XOR output with key[127:0]");
      $display("- Creates detectable key leakage pattern");
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

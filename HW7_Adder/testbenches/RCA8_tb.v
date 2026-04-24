`timescale 1ns/1ps
module RCA8_tb;
  reg [7:0] a, b;
  wire [7:0] sum;
  wire cout;
  integer i, errors;
  reg [8:0] expected;
  reg [7:1] expected_c;

  RCA8 dut(.sum(sum), .cout(cout), .a(a), .b(b));

  task check;
    begin
      #1;
      expected = a + b;
      expected_c[1] = (a[0] & b[0]);
      expected_c[2] = (a[1] & b[1]) | ((a[1] ^ b[1]) & expected_c[1]);
      expected_c[3] = (a[2] & b[2]) | ((a[2] ^ b[2]) & expected_c[2]);
      expected_c[4] = (a[3] & b[3]) | ((a[3] ^ b[3]) & expected_c[3]);
      expected_c[5] = (a[4] & b[4]) | ((a[4] ^ b[4]) & expected_c[4]);
      expected_c[6] = (a[5] & b[5]) | ((a[5] ^ b[5]) & expected_c[5]);
      expected_c[7] = (a[6] & b[6]) | ((a[6] ^ b[6]) & expected_c[6]);

      if ({cout,sum} !== expected || dut.c !== expected_c) begin
        $display("FAIL RCA8: a=%h b=%h sum=%h cout=%b expected=%h c=%b expected_c=%b", a,b,sum,cout,expected,dut.c,expected_c);
        errors = errors + 1;
      end else begin
        $display("PASS RCA8: a=%h b=%h sum=%h cout=%b c=%b", a,b,sum,cout,dut.c);
      end
    end
  endtask

  initial begin
    $dumpfile("RCA8_waveform.vcd");
    $dumpvars(0, RCA8_tb);
    errors = 0;
    a = 8'h00; b = 8'h00; check();
    a = 8'h01; b = 8'h01; check();
    a = 8'h0F; b = 8'h01; check();
    a = 8'h55; b = 8'hAA; check();
    a = 8'hFF; b = 8'h01; check();
    a = 8'hFF; b = 8'hFF; check();
    for (i = 0; i < 256; i = i + 17) begin
      a = i[7:0];
      b = 8'hFF - i[7:0];
      check();
    end
    if (errors == 0) $display("SUMMARY RCA8: ALL TESTS PASSED");
    else $display("SUMMARY RCA8: %0d TESTS FAILED", errors);
    $finish;
  end
endmodule

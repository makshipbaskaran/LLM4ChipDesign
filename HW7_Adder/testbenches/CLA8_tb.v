`timescale 1ns/1ps
module CLA8_tb;
  reg [7:0] a, b;
  wire [7:0] sum;
  wire cout;
  integer i, errors;
  reg [8:0] expected;
  reg [7:0] expected_g, expected_p, expected_c;

  CLA8 dut(.sum(sum), .cout(cout), .a(a), .b(b));

  task compute_expected_internal;
    begin
      expected_g = a & b;
      expected_p = a ^ b;
      expected_c[0] = expected_g[0];
      expected_c[1] = expected_g[1] | (expected_p[1] & expected_g[0]);
      expected_c[2] = expected_g[2] | (expected_p[2] & expected_g[1]) | (expected_p[2] & expected_p[1] & expected_g[0]);
      expected_c[3] = expected_g[3] | (expected_p[3] & expected_g[2]) | (expected_p[3] & expected_p[2] & expected_g[1]) | (expected_p[3] & expected_p[2] & expected_p[1] & expected_g[0]);
      expected_c[4] = expected_g[4] | (expected_p[4] & expected_g[3]) | (expected_p[4] & expected_p[3] & expected_g[2]) | (expected_p[4] & expected_p[3] & expected_p[2] & expected_g[1]) | (expected_p[4] & expected_p[3] & expected_p[2] & expected_p[1] & expected_g[0]);
      expected_c[5] = expected_g[5] | (expected_p[5] & expected_g[4]) | (expected_p[5] & expected_p[4] & expected_g[3]) | (expected_p[5] & expected_p[4] & expected_p[3] & expected_g[2]) | (expected_p[5] & expected_p[4] & expected_p[3] & expected_p[2] & expected_g[1]) | (expected_p[5] & expected_p[4] & expected_p[3] & expected_p[2] & expected_p[1] & expected_g[0]);
      expected_c[6] = expected_g[6] | (expected_p[6] & expected_g[5]) | (expected_p[6] & expected_p[5] & expected_g[4]) | (expected_p[6] & expected_p[5] & expected_p[4] & expected_g[3]) | (expected_p[6] & expected_p[5] & expected_p[4] & expected_p[3] & expected_g[2]) | (expected_p[6] & expected_p[5] & expected_p[4] & expected_p[3] & expected_p[2] & expected_g[1]) | (expected_p[6] & expected_p[5] & expected_p[4] & expected_p[3] & expected_p[2] & expected_p[1] & expected_g[0]);
      expected_c[7] = expected_g[7] | (expected_p[7] & expected_g[6]) | (expected_p[7] & expected_p[6] & expected_g[5]) | (expected_p[7] & expected_p[6] & expected_p[5] & expected_g[4]) | (expected_p[7] & expected_p[6] & expected_p[5] & expected_p[4] & expected_g[3]) | (expected_p[7] & expected_p[6] & expected_p[5] & expected_p[4] & expected_p[3] & expected_g[2]) | (expected_p[7] & expected_p[6] & expected_p[5] & expected_p[4] & expected_p[3] & expected_p[2] & expected_g[1]) | (expected_p[7] & expected_p[6] & expected_p[5] & expected_p[4] & expected_p[3] & expected_p[2] & expected_p[1] & expected_g[0]);
    end
  endtask

  task check;
    begin
      #1;
      expected = a + b;
      compute_expected_internal();
      if ({cout,sum} !== expected || dut.g !== expected_g || dut.p !== expected_p || dut.c !== expected_c) begin
        $display("FAIL CLA8: a=%h b=%h sum=%h cout=%b expected=%h", a,b,sum,cout,expected);
        $display("          g=%b expected_g=%b p=%b expected_p=%b c=%b expected_c=%b", dut.g, expected_g, dut.p, expected_p, dut.c, expected_c);
        errors = errors + 1;
      end else begin
        $display("PASS CLA8: a=%h b=%h sum=%h cout=%b g=%b p=%b c=%b", a,b,sum,cout,dut.g,dut.p,dut.c);
      end
    end
  endtask

  initial begin
    $dumpfile("CLA8_waveform.vcd");
    $dumpvars(0, CLA8_tb);
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
    if (errors == 0) $display("SUMMARY CLA8: ALL TESTS PASSED");
    else $display("SUMMARY CLA8: %0d TESTS FAILED", errors);
    $finish;
  end
endmodule

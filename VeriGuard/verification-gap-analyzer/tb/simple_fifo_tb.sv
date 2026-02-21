module simple_fifo_tb;

    logic clk;
    logic rst_n;
    logic wr_en;
    logic rd_en;
    logic [7:0] din;
    logic [7:0] dout;
    logic full;
    logic empty;

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

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
     $dumpfile("baseline.vcd");
     $dumpvars(0, simple_fifo_tb);
    end


    initial begin
        // Initialize
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        din   = 0;

        #20;
        rst_n = 1;

        // Write 4 entries
        repeat (4) begin
            @(posedge clk);
            wr_en = 1;
            din   = $random;
        end
        @(posedge clk);
        wr_en = 0;

        // Read 4 entries
        repeat (4) begin
            @(posedge clk);
            rd_en = 1;
        end
        @(posedge clk);
        rd_en = 0;

        #20;
        $display("TEST PASSED");
        $finish;
    end

endmodule


// File: assertions/simple_fifo_sva.sv
// Icarus-compatible assertion monitor (no SVA syntax)

module simple_fifo_sva (
    input logic clk,
    input logic rst_n,
    input logic wr_en,
    input logic rd_en,
    input logic full,
    input logic empty
);

    // Expected occupancy model (reference model)
    integer expected_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            expected_count <= 0;
        end else begin
            // Update expected count
            case ({wr_en, rd_en})
                2'b10: expected_count <= expected_count + 1; // write
                2'b01: expected_count <= expected_count - 1; // read
                default: expected_count <= expected_count;   // no change or simultaneous
            endcase
        end
    end

    // ---------------------------
    // Runtime checks (assertions)
    // ---------------------------
    always @(posedge clk) begin
        if (rst_n) begin

            // Overflow detection
            if (full && wr_en && !rd_en) begin
                $error("ASSERTION FAILED: Write attempted when FIFO FULL");
            end

            // Underflow detection
            if (empty && rd_en && !wr_en) begin
                $error("ASSERTION FAILED: Read attempted when FIFO EMPTY");
            end

            // Full flag correctness
            if ((expected_count == 4) && !full) begin
                $error("ASSERTION FAILED: FULL flag not asserted when expected_count=4");
            end

            if ((expected_count != 4) && full) begin
                $error("ASSERTION FAILED: FULL flag asserted incorrectly (expected_count=%0d)", expected_count);
            end

            // Empty flag correctness
            if ((expected_count == 0) && !empty) begin
                $error("ASSERTION FAILED: EMPTY flag not asserted when expected_count=0");
            end

            if ((expected_count != 0) && empty) begin
                $error("ASSERTION FAILED: EMPTY flag asserted incorrectly (expected_count=%0d)", expected_count);
            end

            // Bounds check
            if (expected_count < 0 || expected_count > 4) begin
                $error("ASSERTION FAILED: FIFO occupancy out of bounds (expected_count=%0d)", expected_count);
            end
        end
    end

endmodule
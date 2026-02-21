//==============================================================================
// VeriGuard Auto-Generated SVA Monitor Module
// Target DUT: simple_fifo
// Generated for: Verification gap coverage
//==============================================================================

module veriguard_autogen_sva (
    input logic clk,
    input logic rst_n,
    input logic wr_en,
    input logic rd_en,
    input logic full,
    input logic empty,
    input logic [2:0] count
);

    //--------------------------------------------------------------------------
    // Parameters
    //--------------------------------------------------------------------------
    localparam DEPTH = 4;

    //--------------------------------------------------------------------------
    // ASSERTION 1: No write when full (GAP-2 detector)
    //--------------------------------------------------------------------------
    property p_no_write_when_full;
        @(posedge clk) disable iff (!rst_n)
        (full && wr_en) |=> 0;  // Should never happen
    endproperty

    a_no_write_when_full: assert property (p_no_write_when_full)
    else begin
        $display("[VERIGUARD-VIOLATION] Write-when-full detected at time %0t: full=%0b, wr_en=%0b, count=%0d", 
                 $time, full, wr_en, count);
    end

    //--------------------------------------------------------------------------
    // ASSERTION 2: No read when empty (GAP-3 detector)
    //--------------------------------------------------------------------------
    property p_no_read_when_empty;
        @(posedge clk) disable iff (!rst_n)
        (empty && rd_en) |=> 0;  // Should never happen
    endproperty

    a_no_read_when_empty: assert property (p_no_read_when_empty)
    else begin
        $display("[VERIGUARD-VIOLATION] Read-when-empty detected at time %0t: empty=%0b, rd_en=%0b, count=%0d", 
               $time, empty, rd_en, count);
    end

    //--------------------------------------------------------------------------
    // ASSERTION 3: Count must stay within legal bounds [0..DEPTH] (GAP-4 detector)
    //--------------------------------------------------------------------------
    property p_count_bounds;
        @(posedge clk) disable iff (!rst_n)
        (count <= DEPTH);
    endproperty

    a_count_bounds: assert property (p_count_bounds)
    else begin
        $display("[VERIGUARD-VIOLATION] Count out of bounds at time %0t: count=%0d, legal range=[0..%0d]", 
               $time, count, DEPTH);
    end

    //--------------------------------------------------------------------------
    // ASSERTION 4: Simultaneous read+write must preserve count (GAP-1 detector)
    //--------------------------------------------------------------------------
    property p_simultaneous_rdwr_count_stable;
        @(posedge clk) disable iff (!rst_n)
        (wr_en && rd_en && !full && !empty) |=> (count == $past(count));
    endproperty

    a_simultaneous_rdwr_count_stable: assert property (p_simultaneous_rdwr_count_stable)
    else begin
        $display("[VERIGUARD-VIOLATION] Simultaneous read+write corruption at time %0t: prev_count=%0d, curr_count=%0d (expected stable)", 
               $time, $past(count), count);
    end

    //--------------------------------------------------------------------------
    // ASSERTION 5: Count consistency with full flag
    //--------------------------------------------------------------------------
    property p_full_flag_consistency;
        @(posedge clk) disable iff (!rst_n)
        (full == (count == DEPTH));
    endproperty

    a_full_flag_consistency: assert property (p_full_flag_consistency)
    else begin
        $display("[VERIGUARD-VIOLATION] Full flag inconsistency at time %0t: full=%0b, count=%0d, expected_full=%0b", 
               $time, full, count, (count == DEPTH));
    end

    //--------------------------------------------------------------------------
    // ASSERTION 6: Count consistency with empty flag
    //--------------------------------------------------------------------------
    property p_empty_flag_consistency;
        @(posedge clk) disable iff (!rst_n)
        (empty == (count == 0));
    endproperty

    a_empty_flag_consistency: assert property (p_empty_flag_consistency)
    else begin
        $display("[VERIGUARD-VIOLATION] Empty flag inconsistency at time %0t: empty=%0b, count=%0d, expected_empty=%0b", 
               $time, empty, count, (count == 0));
    end

    //--------------------------------------------------------------------------
    // ASSERTION 7: Write-only increments count by 1
    //--------------------------------------------------------------------------
    property p_write_only_increments;
        @(posedge clk) disable iff (!rst_n)
        (wr_en && !rd_en && !$past(full)) |=> (count == ($past(count) + 1));
    endproperty

    a_write_only_increments: assert property (p_write_only_increments)
    else begin
        $display("[VERIGUARD-VIOLATION] Write-only increment failed at time %0t: prev_count=%0d, curr_count=%0d, expected=%0d", 
               $time, $past(count), count, $past(count) + 1);
    end

    //--------------------------------------------------------------------------
    // ASSERTION 8: Read-only decrements count by 1
    //--------------------------------------------------------------------------
    property p_read_only_decrements;
        @(posedge clk) disable iff (!rst_n)
        (rd_en && !wr_en && !$past(empty)) |=> (count == ($past(count) - 1));
    endproperty

    a_read_only_decrements: assert property (p_read_only_decrements)
    else begin
        $display("[VERIGUARD-VIOLATION] Read-only decrement failed at time %0t: prev_count=%0d, curr_count=%0d, expected=%0d", 
               $time, $past(count), count, $past(count) - 1);
    end

endmodule
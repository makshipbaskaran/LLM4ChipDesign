module simple_fifo (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        wr_en,
    input  logic        rd_en,
    input  logic [7:0]  din,
    output logic [7:0]  dout,
    output logic        full,
    output logic        empty
);

    logic [7:0] mem [0:3];
    logic [2:0] wr_ptr;
    logic [2:0] rd_ptr;
    logic [2:0] count;

    // Combinational flags based on count
    assign full  = (count == 3'd4);
    assign empty = (count == 3'd0);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 3'd0;
            rd_ptr <= 3'd0;
            count  <= 3'd0;
            dout   <= 8'd0;
        end else begin
            // Handle read and write operations with proper guards
            // Simultaneous read and write
            if (wr_en && rd_en) begin
                if ((count > 3'd0) && (count < 3'd4)) begin
                    // Valid simultaneous operation (not empty and not full)
                    mem[wr_ptr[1:0]] <= din;
                    dout <= mem[rd_ptr[1:0]];
                    wr_ptr <= wr_ptr + 3'd1;
                    rd_ptr <= rd_ptr + 3'd1;
                    // count remains unchanged (one in, one out)
                end
            end
            // Write only
            else if (wr_en) begin
                if (count < 3'd4) begin
                    // Valid write (not full)
                    mem[wr_ptr[1:0]] <= din;
                    wr_ptr <= wr_ptr + 3'd1;
                    count  <= count + 3'd1;
                end
            end
            // Read only
            else if (rd_en) begin
                if (count > 3'd0) begin
                    // Valid read (not empty)
                    dout <= mem[rd_ptr[1:0]];
                    rd_ptr <= rd_ptr + 3'd1;
                    count  <= count - 3'd1;
                end
            end
        end
    end

endmodule

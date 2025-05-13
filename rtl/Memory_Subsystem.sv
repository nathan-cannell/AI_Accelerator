// File: rtl/Memory_Subsystem.sv
module Memory_Subsystem #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 16,
    parameter NUM_BANKS = 4,
    parameter REQ_QUEUE_DEPTH = 4
)(
    // Interface to processing cores
    // Memory controller signals
);
    // Separate weight/data memory banks
    // Arbitration logic
    
    localparam CTRL_REG = 16'hFF00; // Control register address
    logic [3:0] bank_request; // Bank request signals
    logic [3:0] bank_grant; // Bank grant signals

    // Request queue structure
    typedef struct packed {
        logic [ADDR_WIDTH-1:0] addr;
        logic [DATA_WIDTH-1:0] data;
        logic write;
        logic [1:0] priority; // 0=low, 3=high
    } mem_request_t;

    // Request queues and arbitration
    mem_request_t req_queues[NUM_BANKS][REQ_QUEUE_DEPTH];
    logic [NUM_BANKS-1:0][$clog2(REQ_QUEUE_DEPTH+1):0] queue_counts;
    logic [NUM_BANKS-1:0] bank_arb_grant;
    logic [1:0] priority_selector;

    // Basic DMA contorol
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset logic (needs implementation)
            
        end else begin
            // Memory access logic
            if (write_enable && addr == CTRL_REG) begin
                dma_control <= data_in; // Control register write
            end
        end
    end

    // Bank Arbitration
    // Enhanced arbitration logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            req_queues <= '{default:'0};
            bank_arb_grant <= '0;
            wr_addr <= '0;
            wr_data <= '0;
            wr_en <= 0;
            priority_selector <= 0;
            queue_counts <= '{default:0};
        end else begin
            // Update queue counts
            for (int i=0; i<NUM_BANKS; i++) begin
                queue_counts[i] <= queue_counts[i] + 
                                (bank_request[i] ? 1 : 0) - 
                                (bank_arb_grant[i] ? 1 : 0);
            end

            // Rotating priority arbitration
            priority_selector <= (priority_selector == 3) ? 0 : priority_selector + 1;
        end
    end

    always_comb begin
        bank_arb_grant = '0;
        for (int p=3; p>=0; p--) begin // Highest priority first
            for (int i=0; i<NUM_BANKS; i++) begin
                int bank_idx = (i + priority_selector) % NUM_BANKS;
                if (!(|bank_arb_grant) && req_queues[bank_idx][0].priority == p && queue_counts[bank_idx] > 0) begin
                    bank_arb_grant[bank_idx] = 1'b1;
                    break;
                end
            end
            if (|bank_arb_grant) break;
        end
    end

    // Connect to memory interface
    always_ff @(posedge clk) begin
        for (int i=0; i<NUM_BANKS; i++) begin
            if (bank_arb_grant[i]) begin
                // Process request from front of queue
                wr_addr <= req_queues[i][0].addr;
                wr_data <= req_queues[i][0].data;
                wr_en <= req_queues[i][0].write;
                // Shift queue
                for (int j=0; j<REQ_QUEUE_DEPTH-1; j++)
                    req_queues[i][j] <= req_queues[i][j+1];
                req_queues[i][REQ_QUEUE_DEPTH-1] <= '0;
            end
        end
    end
    behav_dual_port_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) weight_mem (
        .clk_a(clk),
        .clk_b(clk),
        .en_a(wr_en | rd_en),
        .en_b(1'b1),  // Always enable read port
        .we_a(wr_en),
        .we_b(1'b0),  // Port B read-only
        .addr_a(wr_addr),
        .addr_b(rd_addr),
        .din_a(wr_data),
        .din_b(32'h0),
        .dout_a(),    // Not used for write port
        .dout_b(rd_data)
    );



endmodule
// File: rtl/Memory_Subsystem.sv
/*
    Remaining TODOs:
    1. Add rd_en control logic for reading
    2. Connect rd_addr to your address logic
    3. Implement actual DMA engine (currently just a control register)
*/
module Memory_Subsystem #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 16
)(
    input  logic clk,
    input  logic reset,
    input  logic [ADDR_WIDTH-1:0] addr,
    input  logic [DATA_WIDTH-1:0] data_in,
    input  logic write_enable,
    output logic [DATA_WIDTH-1:0] rd_data
);
    // Separate weight/data memory banks
    // Arbitration logic
    logic wr_en, rd_en;
    logic [ADDR_WIDTH-1:0] wr_addr, rd_addr;
    logic [DATA_WIDTH-1:0] wr_data;
    logic [DATA_WIDTH-1:0] dma_control;
    localparam CTRL_REG = 16'hFF00; // Control register address
    logic [3:0] bank_request; // Bank request signals
    logic [3:0] bank_grant; // Bank grant signals


    // Basic DMA contorol
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset logic (needs implementation)
            dma_control <= '0;
            wr_en <= 0;
            rd_en <= 0;
            wr_addr <= '0;
            wr_data <= '0;
        end else begin
            // Memory access logic
            if (write_enable && addr == CTRL_REG) begin
                dma_control <= data_in; // Control register write
            end
        end
    end

    // Bank Arbitration
    always_comb begin
        bank_grant = 4'b0000;  // Default grant state

        // Round-robin arbitration using disable
        begin : arbitration_loop
            for (int i = 0; i < 4; i++) begin
                if (bank_request[i]) begin
                    bank_grant[i] = 1'b1;
                    disable arbitration_loop;  // Exit loop after first grant
                end
            end
        end
    end

        // In Memory_Subsystem.sv
    behav_dual_port_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) weight_mem (
        .clk_a(clk),
        .clk_b(clk),
        .en_a(wr_en),
        .en_b(rd_en),  // Always enable read port
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
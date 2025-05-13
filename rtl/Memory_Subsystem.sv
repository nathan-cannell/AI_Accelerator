// File: rtl/Memory_Subsystem.sv
module Memory_Subsystem #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 16
)(
    // Interface to processing cores
    // Memory controller signals
);
    // Separate weight/data memory banks
    // Arbitration logic
    
    localparam CTRL_REG = 16'hFF00; // Control register address
    logic [3:0] bank_request; // Bank request signals
    logic [3:0] bank_grant; // Bank grant signals


    // Basic DMA contorol
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset logic (needs implementation)
        end else begin
            // Memory access logic
            if (write_enable && addr == CTRL_REG) begin
                dma_control <= data_in; // Control register write
            end

    
    always_comb begin
        // robin-robin arbitration
        bank_grants = 4'b0000;
        for (int i = 0; i < 4; i++) begin
            if (bank_request[i]) begin
                bank_grants[i] = 1'b1;
                break;
            end
        end
    end
endmodule
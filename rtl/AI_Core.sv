// File: rtl/AI_Core.sv
module AI_Core #(
    parameter DATA_WIDTH = 32
) (
    input  logic                  clk,
    input  logic                  reset,
    input  logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic                  ready
);

    // Example processing logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= '0;
            ready    <= 1'b0;
        end else begin
            data_out <= data_in + 1; // Example operation
            ready    <= 1'b1;
        end
    end

endmodule
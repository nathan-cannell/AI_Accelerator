// File: rtl/ram/behav_dual_port_ram.sv
module behav_dual_port_ram #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10
)(
    input  wire clk_a,
    input  wire clk_b,
    input  wire en_a,
    input  wire en_b,
    input  wire we_a,
    input  wire we_b,
    input  wire [ADDR_WIDTH-1:0] addr_a,
    input  wire [ADDR_WIDTH-1:0] addr_b,
    input  wire [DATA_WIDTH-1:0] din_a,
    input  wire [DATA_WIDTH-1:0] din_b,
    output reg [DATA_WIDTH-1:0] dout_a,
    output reg [DATA_WIDTH-1:0] dout_b
);
    // Memory array declaration
    reg [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    // Port A operation
    always_ff @(posedge clk_a) begin
        if (en_a) begin
            if (we_a) begin
                mem[addr_a] <= din_a;
                dout_a <= din_a;  // Write-through behavior
            end else begin
                dout_a <= mem[addr_a];
            end
        end
    end

    // Port B operation
    always_ff @(posedge clk_b) begin
        if (en_b) begin
            if (we_b) begin
                mem[addr_b] <= din_b;
                dout_b <= din_b;  // Write-through behavior
            end else begin
                dout_b <= mem[addr_b];
            end
        end
    end
endmodule

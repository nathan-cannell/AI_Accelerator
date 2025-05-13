// weight_mem.sv
// uses multiple clocks, I should maybe only use one
module weight_mem #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10
)(
    input  wire                   clk_a,
    input  wire                   clk_b,
    input  wire                   en_a,
    input  wire                   en_b,
    input  wire                   we_a,
    input  wire                   we_b,
    input  wire [ADDR_WIDTH-1:0]  addr_a,
    input  wire [ADDR_WIDTH-1:0]  addr_b,
    input  wire [DATA_WIDTH-1:0]  din_a,
    input  wire [DATA_WIDTH-1:0]  din_b,
    output logic  [DATA_WIDTH-1:0]  dout_a,
    output logic  [DATA_WIDTH-1:0]  dout_b
);

    // Memory array
    reg [DATA_WIDTH-1:0] ram [0:(1<<ADDR_WIDTH)-1];

    // Port A
    always @(posedge clk_a) begin
        if (en_a) begin
            if (we_a) begin
                ram[addr_a] <= din_a;
                dout_a <= din_a; // Write-through
            end else begin
                dout_a <= ram[addr_a];
            end
        end
    end

    // Port B
    always @(posedge clk_b) begin
        if (en_b) begin
            if (we_b) begin
                ram[addr_b] <= din_b;
                dout_b <= din_b; // Write-through
            end else begin
                dout_b <= ram[addr_b];
            end
        end
    end

endmodule

// Generic behavioral dual-port RAM model (for simulation but never for synthesis

module behav_dual_port_ram #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10
)(
    input  logic clk_a, clk_b,
    input  logic en_a, en_b,
    input  logic we_a, we_b,
    input  logic [ADDR_WIDTH-1:0] addr_a, addr_b,
    input  logic [DATA_WIDTH-1:0] din_a, din_b,
    output logic [DATA_WIDTH-1:0] dout_a, dout_b
);
    
    logic [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];
    
    // Port A
    always_ff @(posedge clk_a) begin
        if (en_a) begin
            if (we_a) 
                mem[addr_a] <= din_a;
            dout_a <= mem[addr_a];
        end
    end
    
    // Port B
    always_ff @(posedge clk_b) begin
        if (en_b) begin
            if (we_b)
                mem[addr_b] <= din_b;
            dout_b <= mem[addr_b];
        end
    end
endmodule

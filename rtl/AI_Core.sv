module AI_Core #(
    parameter DATA_WIDTH = 32,
    parameter WEIGHT_ADDR = 16'h0000,  // Unique weight base address per core
    parameter BIAS_ADDR = 16'h1000     // Unique bias base address per core
) (
    input  logic                  clk,
    input  logic                  reset,
    input  logic [DATA_WIDTH-1:0] data_in,
    input  logic                  input_valid,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic                  ready
);

    // Core registers and pipeline stages
    logic [DATA_WIDTH-1:0] weight_reg;
    logic [DATA_WIDTH-1:0] bias_reg;
    logic [DATA_WIDTH-1:0] activation;
    logic [1:0] state;

    // MAC Pipeline registers
    logic [DATA_WIDTH-1:0] mult_result;
    logic [DATA_WIDTH-1:0] acc_result;

    // FSM states
    enum logic [1:0] {
        IDLE,
        LOAD_WEIGHTS,
        PROCESSING
    } fsm_state;

    // Quantization (optional - for fixed-point)
    localparam FRACT_BITS = 16;
    function logic [DATA_WIDTH-1:0] quantize(input real val);
        return val * (2 ** FRACT_BITS);
    endfunction

    // ReLU activation function
    function logic [DATA_WIDTH-1:0] relu(input logic [DATA_WIDTH-1:0] val);
        return val[DATA_WIDTH-1] ? 0 : val;  // Check sign bit
    endfunction

    // Weight/Bias initialization (could load from memory)
    initial begin
        weight_reg = quantize(0.5);  // Example weight
        bias_reg = quantize(0.1);    // Example bias
    end

    // Main processing pipeline
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= '0;
            ready <= 1'b0;
            fsm_state <= IDLE;
        end else begin
            case (fsm_state)
                IDLE: begin
                    ready <= 1'b0;
                    if (input_valid) begin
                        mult_result <= data_in * weight_reg;
                        fsm_state <= PROCESSING;
                    end
                end
                
                PROCESSING: begin
                    // Accumulate result and apply bias
                    acc_result <= mult_result + acc_result;
                    activation <= acc_result + bias_reg;
                    
                    // Apply ReLU
                    data_out <= relu(activation);
                    ready <= 1'b1;
                    fsm_state <= IDLE;
                end
            endcase
        end
    end

endmodule

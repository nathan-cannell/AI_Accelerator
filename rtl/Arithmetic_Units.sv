// File: rtl/Arithmetic_Units.sv
module MAC_Unit #(parameter WIDTH=32) (
    input logic clk,
    input logic reset,
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH*2-1:0] result
);
    
    logic [WIDTH-1:0] a_reg, b_reg;
    logic [WIDTH*2-1:0] mult_result; // maybe include add_result

    always_ff@(posedge clk or posedge reset) begin
        if (reset) begin
            a_reg <= '0;
            b_reg <= '0;
            result <= '0;
        end else begin
            a_reg <= a;
            b_reg <= b;
            mult_result <= a_reg * b_reg; // Multiplication
            result <= mult_result + result; // Accumulate
        end 
    end


endmodule
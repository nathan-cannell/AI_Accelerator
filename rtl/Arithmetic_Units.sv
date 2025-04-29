// File: rtl/Arithmetic_Units.sv
module MAC_Unit #(parameter WIDTH=32) (
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    output logic [WIDTH*2-1:0] result
);
    assign result = a * b;  // Replace with pipelined version
endmodule
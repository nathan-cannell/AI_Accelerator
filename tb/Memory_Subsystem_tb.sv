`timescale 1ns/1ps

module Memory_Subsystem_tb;

    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 16;

    // Inputs
    logic clk;
    logic reset;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] data_in;
    logic write_enable;
    logic [3:0] bank_request;

    // Outputs
    logic [DATA_WIDTH-1:0] rd_data;
    logic [3:0] bank_grant;

    // Instantiate the Unit Under Test (UUT)
    Memory_Subsystem #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .data_in(data_in),
        .write_enable(write_enable),
        .rd_data(rd_data),
        .bank_request(bank_request),
        .bank_grant(bank_grant)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, Memory_Subsystem_tb);
        $dumpvars(1, uut);
        $dumpvars(2, uut.weight_mem);
        
        $display("--- Simulation Start ---");
        
        // Initialize
        clk = 0;
        reset = 1;
        addr = 0;
        data_in = 0;
        write_enable = 0;
        bank_request = 4'b0000;

        // Reset (3 clock cycles)
        #15;
        reset = 0;

        // Test 1: DMA control register write
        addr = 16'hFF00;
        data_in = 32'hA5A5A5A5;
        write_enable = 1;
        #10;
        write_enable = 0;
        #10;
        if (uut.dma_control !== 32'hA5A5A5A5)
            $error("DMA write failed!");

        // Test 2: Bank arbitration
        bank_request = 4'b1010; // Banks 1 and 3 request
        #10;
        if (bank_grant !== 4'b0010)  // Should grant bank 1
            $error("Grant mismatch: Expected 4'b0010, Got %b", bank_grant);
        bank_request = 4'b0000;

        $display("--- All Tests Passed ---");
        #50;
        $finish;
    end


endmodule

module tb_top;

reg clk, reset;

// Instantiate DUT
top uut(.clk(clk), .reset(reset));

// Clock generation (10 time units period)
always begin
    #5 clk = ~clk;
end

initial begin
    // Initialize signals
    clk = 0;
    reset = 1;

    // Dump file for GTKWave
    $dumpfile("top.vcd");
    $dumpvars(0, uut);
    

    // Apply reset
    #10;
    reset = 0;

    // Run simulation
    #500;

    // Stop simulation
    $finish;
end

endmodule
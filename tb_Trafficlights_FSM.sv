`timescale 1ns/1ps

module tb_Trafficlights_FSM();

    // Inputs
    logic clk;
    logic reset;
    logic TAORB;

    // Outputs
    logic [1:0] LA;
    logic [1:0] LB;

    // Instantiate the Unit Under Test (UUT)
    Trafficlights_FSM uut (
        .clk(clk),
        .reset(reset),
        .TAORB(TAORB),
        .LA(LA),
        .LB(LB)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        TAORB = 1; // Start with traffic on Street A 

        // Wait 20ns for global reset
        #20;
        reset = 0;

        // Test Scenario 1: Transition from S0 to S1
        #20;
        TAORB = 0; // No more traffic at A, transition to S1
        
        // Stay in S1 (Yellow) for 5 clock cycles 
        repeat (6) @(posedge clk); 

        // Test Scenario 2: Transition from S2 to S3
        TAORB = 1; // Traffic returns to A, transition to S3 
        
        // Stay in S3 (Yellow) for 5 clock cycles
        repeat (6) @(posedge clk);

        #50;
        $stop; // Pause simulation
    end

    // Monitor changes in the console
    initial begin
        $monitor("Time=%0t | Reset=%b | TAORB=%b | LA=%b | LB=%b", 
                 $time, reset, TAORB, LA, LB);
    end

endmodule


module Trafficlights_FSM (
    input  logic clk,
    input  logic reset,
    input  logic TAORB,  // Traffic at A or Traffic at B sensor 
    output logic [1:0] LA, // Light A: 00=Red, 01=Yellow, 10=Green 
    output logic [1:0] LB  // Light B: 00=Red, 01=Yellow, 10=Green 
);

    // State Encoding for the 4-state FSM 
    typedef enum logic [1:0] {
        S0 = 2'b00, // LA Green, LB Red 
        S1 = 2'b01, // LA Yellow, LB Red 
        S2 = 2'b10, // LA Red, LB Green 
        S3 = 2'b11  // LA Red, LB Yellow 
    } state_t;

    state_t state, next_state;
    logic [2:0] timer; // Internal counter for 5-unit delay 
	 
    // State Register & Timer Logic 
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0; 
            timer <= 3'd0;
        end else begin
            state <= next_state;
            // Increments during S1/S3, resets when leaving 
            if (state == S1 || state == S3) begin
                if (next_state != state) 
                    timer <= 3'd0; 
                else 
                    timer <= timer + 1;
            end else begin
                timer <= 3'd0;
            end
        end
    end

    // Next state logic  
    always_comb begin
        case (state)
            S0: begin 
                if (!TAORB) next_state = S1; // Transition if ~TAORB 
                else        next_state = S0; // Stay if TAORB
            end
            
            S1: begin 
                // Loop while ~TAORB and TIMER < 5 
                if (timer < 3'd5) next_state = S1;
                else              next_state = S2; // Transition when TIMER = 5 
            end
            
            S2: begin 
                if (TAORB) next_state = S3; // Transition if TAORB 
                else       next_state = S2; // Stay while ~TAORB 
            end
            
            S3: begin 
                // Loop while TAORB and TIMER < 5
                if (timer < 3'd5) next_state = S3;
                else              next_state = S0; // Transition when TIMER = 5 
            end
            
            default: next_state = S0;
        endcase
    end

    // Output logic 
    // Red=2'b00, Yellow=2'b01, Green=2'b10
    always_comb begin
        case (state)
            S0: {LA, LB} = {2'b10, 2'b00}; // S0: LA Green, LB Red 
            S1: {LA, LB} = {2'b01, 2'b00}; // S1: LA Yellow, LB Red 
            S2: {LA, LB} = {2'b00, 2'b10}; // S2: LA Red, LB Green 
            S3: {LA, LB} = {2'b00, 2'b01}; // S3: LA Red, LB Yellow
            default: {LA, LB} = {2'b00, 2'b00};
        endcase
    end

endmodule
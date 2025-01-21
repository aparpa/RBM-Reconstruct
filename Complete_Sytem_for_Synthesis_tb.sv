`timescale 1ns/1ps

module complete_system_tb;
    // Parameters
    parameter NV = 16;  // Number of neurons
    parameter NH = 16;  // Number of inputs per neuron
    parameter N  = 8;   // Bit width of each weight
    parameter real CLK_PERIOD = 1.25; // Clock period in ns for 800 MHz

    // Test bench signals
    reg clk;
    reg reset_n;
    reg start;
    wire system_done;
    wire [NV-1:0] comparator_outputs_out;
    wire [2:0] state_display;

    // Instantiate DUT
    complete_system #(
        .NV(NV),
        .NH(NH),
        .N(N)
    ) dut (
        .clk(clk),
        .reset_n(reset_n),
        .start(start),
        .system_done(system_done),
        .comparator_outputs_out(comparator_outputs_out),
        .state_display(state_display)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test stimulus
    initial begin
        // Initialize control signals
        reset_n = 0;
        start = 0;

        // Apply reset
        #20;
        reset_n = 1;
        #40; // Wait additional time to allow H Buffer and W Memory initialization

        // Start processing
        $display("\n[%0t] Starting system processing...", $time);
        start = 1;
        @(posedge clk); // Synchronize with clock edge
        start = 0;

        // Wait for completion
        wait(system_done);
        #20;

        // Display final results
        $display("\nFinal System Results:");
        $display("------------------------------------------------");
        $display("Neuron | Comparator Output");
        $display("------------------------------------------------");
        for (integer i = 0; i < NV; i = i + 1) begin
            $display("  %2d   |         %1b", 
                    i,
                    comparator_outputs_out[i]
            );
        end
        $display("------------------------------------------------\n");

        // Display final binary pattern
        $display("Final Binary Pattern: %b\n", comparator_outputs_out);

        #100;
        $finish;
    end

    // State monitoring
    initial begin
        $monitor("[%0t] reset_n=%0b | start=%0b | state=%3b | done=%0b", 
                 $time, reset_n, start, state_display, system_done);
    end

    // Print state transitions
    always @(posedge clk) begin
        case(state_display)
            3'b000: $display("[%0t] State: IDLE", $time);
            3'b001: $display("[%0t] State: MAC_PROC", $time);
            3'b010: $display("[%0t] State: BIAS_SETUP", $time);
            3'b011: $display("[%0t] State: BIAS_PROC", $time);
            3'b100: $display("[%0t] State: SIGMOID", $time);
            3'b101: $display("[%0t] State: COMPARE", $time);
            3'b110: $display("[%0t] State: DONE", $time);
            default: $display("[%0t] State: UNKNOWN", $time);
        endcase
    end

endmodule

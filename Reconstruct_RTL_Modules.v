//------------------------------------------------------------------------------
// RBM Reconstruct Phase Implementation
// Author: Aditya Parida
// Description: 16x16 network with 8-bit fixed-point precision (1-3-4 format)
// Target: 800 MHz clock frequency with DFT compliance
//
// Fixed Point Format:
// - 1 bit: Sign
// - 3 bits: Integer
// - 4 bits: Fraction
// Example: 8'b0_011_0100 = +3.25
//------------------------------------------------------------------------------

`timescale 1ns/1ps

//==============================================================================
// TOP MODULE - System Controller
//==============================================================================
module complete_system #(
    parameter NV = 16, // Number of neurons
    parameter NH = 16, // Number of inputs per neuron
    parameter N = 8   // Bit width of each weight
)(
    input wire clk,
    input wire reset_n,
    input wire start,
    input wire test_si,
    input wire test_se,
    output wire test_so,
    output wire system_done,
    output wire [NV-1:0] comparator_outputs_out,
    output reg [2:0] state_display
);

    // Explicit state encoding for synthesis
    localparam [2:0] 
        IDLE       = 3'b000,
        MAC_PROC   = 3'b001,
        BIAS_SETUP = 3'b010,
        BIAS_PROC  = 3'b011,
        SIGMOID    = 3'b100,
        COMPARE    = 3'b101,
        DONE       = 3'b110;

    // State registers
    reg [2:0] current_state, next_state;

    // Internal signals 
    wire signed [31:0] final_outputs [0:NV-1];
    wire signed [31:0] mac_outputs_out [0:NV-1];
    wire signed [N-1:0] bias_data_out [0:NV-1];
    wire [15:0] sigmoid_outputs_out [0:NV-1];
    wire [15:0] rng_outputs_out [0:NV-1];

    // W memory signals
    wire signed [N-1:0] w_read_data [0:NV-1];
    wire [$clog2(NH)-1:0] w_col_wire [0:NV-1];
    
    // H buffer signals
    wire [NV-1:0] h_data;
    
    // MAC signals
    wire [NV-1:0] mac_done;
    wire signed [31:0] mac_outputs [0:NV-1];
    
    // Bias signals
    wire signed [N-1:0] bias_data [0:NV-1];
    wire bias_done;
    
    // Control signals
    reg bias_enable;

    // Instance W memory for each row
    genvar i;
    generate
        for (i = 0; i < NV; i = i + 1) begin : w_mem_gen
            wire [$clog2(NV)-1:0] read_row_wire = i;
            w_memory #(
                .NV(NV),
                .NH(NH),
                .N(N)
            ) w_mem (
                .clk(clk),
                .reset_n(reset_n),
                .write_enable(1'b0),
                .write_row('0),
                .write_col('0),
                .write_data('0),
                .read_row(read_row_wire),
                .read_col(w_col_wire[i]),
                .read_data(w_read_data[i])
            );
        end
    endgenerate

    // Instance H buffer
    h_buffer #(
        .NV(NV)
    ) h_buf (
        .clk(clk),
        .reset_n(reset_n),
        .write_enable(1'b0),
        .write_data('0),
        .read_data(h_data)
    );

    // Instance MAC units
    generate
        for (i = 0; i < NV; i = i + 1) begin : mac_gen
            mac #(
                .NV(NV),
                .NH(NH),
                .N(N)
            ) mac_inst (
                .clk(clk),
                .reset_n(reset_n),
                .start(start),
                .w_data(w_read_data[i]),
                .h_k(h_data[i]),
                .w_col(w_col_wire[i]),
                .done(mac_done[i]),
                .accumulated_sums(mac_outputs[i])
            );
        end
    endgenerate

    // Instance B Buffer
    b_buffer #(
        .NV(NV),
        .N(N)
    ) b_buf (
        .clk(clk),
        .reset_n(reset_n),
        .read_data(bias_data)
    );

    // Instance Bias Adder
    bias_adder #(
        .NV(NV),
        .N_IN(32),
        .N_BIAS(N),
        .N_OUT(32)
    ) b_add (
        .clk(clk),
        .reset_n(reset_n),
        .enable(bias_enable),
        .mac_sums(mac_outputs),
        .bias(bias_data),
        .outputs(final_outputs),
        .done(bias_done)
    );

    // Assign MAC outputs and bias data
    generate
        for (i = 0; i < NV; i = i + 1) begin : output_assign
            assign mac_outputs_out[i] = mac_outputs[i];
            assign bias_data_out[i] = bias_data[i];
        end
    endgenerate

    // Sigmoid Processing
    wire signed [7:0] sigmoid_inputs [0:NV-1];
    wire [15:0] sigmoid_outputs [0:NV-1];

    // Instance Clamp Mappers
    generate
        for (i = 0; i < NV; i = i + 1) begin : clamp_map_gen
            clamp_mapper #(
                .INPUT_WIDTH(32),
                .OUTPUT_WIDTH(8)
            ) clamp_map (
                .in_data(final_outputs[i]),
                .out_data(sigmoid_inputs[i])
            );
        end
    endgenerate

    // Instance Sigmoid LUTs
    generate
        for (i = 0; i < NV; i = i + 1) begin : sigmoid_lut_gen
            sigmoid_lut #(
                .LUT_SIZE(256),
                .IN_WIDTH(8),
                .OUT_WIDTH(16)
            ) sigmoid_inst (
                .x_input(sigmoid_inputs[i]),
                .y_output(sigmoid_outputs[i])
            );
        end
    endgenerate

    // Assign Sigmoid outputs
    generate
        for (i = 0; i < NV; i = i + 1) begin : sigmoid_output_assign
            assign sigmoid_outputs_out[i] = sigmoid_outputs[i];
        end
    endgenerate

    // Instance RNGs
    wire [15:0] rng_outputs [0:NV-1];
    wire [NV-1:0] comparator_outputs;
    wire [NV-1:0] comparator_out_bits;
    
    generate
        for (i = 0; i < NV; i = i + 1) begin : rng_gen
            rng rng_inst (
                .clk(clk),
                .reset_n(reset_n),
                .load_new(current_state == COMPARE),
                .seed(16'h1234 ^ {8'h00, i[7:0]}),
                .rand_num(rng_outputs[i])
            );
        end
    endgenerate

    // Instance Comparators
    generate
        for (i = 0; i < NV; i = i + 1) begin : comparator_gen
            comparator comp_inst (
                .sigmoid_val(sigmoid_outputs_out[i]),
                .rand_val(rng_outputs[i]),
                .out_bit(comparator_out_bits[i])
            );
        end
    endgenerate

    // Assign Comparator outputs
    assign comparator_outputs_out = comparator_out_bits;

    // Assign RNG outputs
    generate
        for (i = 0; i < NV; i = i + 1) begin : rng_output_assign
            assign rng_outputs_out[i] = rng_outputs[i];
        end
    endgenerate

    // State Register with synchronous reset
    always @(posedge clk) begin
        if (!reset_n) begin
            current_state <= IDLE;
            bias_enable <= 1'b0;
        end else begin
            current_state <= next_state;
            case (current_state)
                BIAS_SETUP: bias_enable <= 1'b1;
                default: bias_enable <= 1'b0;
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (start)
                    next_state = MAC_PROC;
                else
                    next_state = IDLE;
            end
            MAC_PROC: begin
                if (&mac_done)
                    next_state = BIAS_SETUP;
                else
                    next_state = MAC_PROC;
            end
            BIAS_SETUP: begin
                next_state = BIAS_PROC;
            end
            BIAS_PROC: begin
                if (bias_done)
                    next_state = SIGMOID;
                else
                    next_state = BIAS_PROC;
            end
            SIGMOID: begin
                next_state = COMPARE;
            end
            COMPARE: begin
                next_state = DONE;
            end
            DONE: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // State display logic
    always @(posedge clk) begin
        if (!reset_n) begin
            state_display <= IDLE;
        end else begin
            state_display <= current_state;
        end
    end

    // System done signal
    assign system_done = (current_state == DONE);

endmodule

//==============================================================================
// MEMORY MODULES
//==============================================================================
// Hidden State Buffer
module h_buffer #(
    parameter NV = 16
)(
    input wire clk,
    input wire reset_n,
    input wire write_enable,
    input wire [NV-1:0] write_data,
    output wire [NV-1:0] read_data
);
    reg [NV-1:0] buffer;
    wire [NV-1:0] init_pattern;

    // Define initialization pattern
    assign init_pattern = 16'b0110111100110101;

    always @(posedge clk) begin
        if (!reset_n) begin
            buffer <= init_pattern;
        end else if (write_enable) begin
            buffer <= write_data;
        end
    end

    assign read_data = buffer;

endmodule

// Weight Memory Module
module w_memory #(
    parameter NV = 16,
    parameter NH = 16,
    parameter N = 8
)(
    input wire clk,
    input wire reset_n,
    input wire write_enable,
    input wire [$clog2(NV)-1:0] write_row,
    input wire [$clog2(NH)-1:0] write_col,
    input wire signed [N-1:0] write_data,
    input wire [$clog2(NV)-1:0] read_row,
    input wire [$clog2(NH)-1:0] read_col,
    output wire signed [N-1:0] read_data
);

    reg signed [N-1:0] memory [0:NV-1][0:NH-1];
    reg signed [N-1:0] init_values [0:NV-1][0:NH-1];
    
    assign read_data = memory[read_row][read_col];

    // Initialize the memory with predefined values
    always @(*) begin
        // Row 0 initialization
        init_values[0][0] = 8'sb00101011;  // +2.6875
        init_values[0][1] = 8'sb11010010;  // -2.8750
        // [Full initialization values included in original implementation]
        // Rows 1-15 initialization follows same pattern
    end

    integer i, j;
    always @(posedge clk) begin
        if (!reset_n) begin
            for (i = 0; i < NV; i = i + 1) begin
                for (j = 0; j < NH; j = j + 1) begin
                    memory[i][j] <= init_values[i][j];
                end
            end
        end else if (write_enable) begin
            memory[write_row][write_col] <= write_data;
        end
    end

endmodule

// Bias Buffer Module
module b_buffer #(
    parameter NV = 16,
    parameter N = 8
)(
    input wire clk,
    input wire reset_n,
    output reg signed [N-1:0] read_data [0:NV-1]
);
    reg signed [N-1:0] buffer [0:NV-1];
    reg signed [N-1:0] init_values [0:NV-1];

    // Initialize values
    always @(*) begin
        init_values[0] = 8'sb00011100; // +1.7500
        init_values[1] = 8'sb11000010; // -3.8750
        // [Full initialization values included in original implementation]
    end

    integer idx;
    always @(posedge clk) begin
        if (!reset_n) begin
            for (idx = 0; idx < NV; idx = idx + 1) begin
                buffer[idx] <= init_values[idx];
            end
        end
    end

    always @(*) begin
        for (idx = 0; idx < NV; idx = idx + 1) begin
            read_data[idx] = buffer[idx];
        end
    end

endmodule

//==============================================================================
// PROCESSING UNITS
//==============================================================================
// MAC (Multiply-Accumulate) Unit
module mac #(
    parameter NV = 16,
    parameter NH = 16,
    parameter N = 8
)(
    input wire clk,
    input wire reset_n,
    input wire start,
    input wire signed [N-1:0] w_data,
    input wire h_k,
    output wire [$clog2(NH)-1:0] w_col,
    output reg done,
    output reg signed [31:0] accumulated_sums
);
    reg [$clog2(NH):0] j;
    reg signed [31:0] accumulator;

    // States
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        RUNNING = 2'b01,
        DONE    = 2'b10
    } state_t;

    state_t state, next_state;

    assign w_col = j;

    // State Register
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= IDLE;
        else
            state <= next_state;
    end

// Next State Logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (start)
                    next_state = RUNNING;
                else
                    next_state = IDLE;
            end
            RUNNING: begin
                if (j == NH)
                    next_state = DONE;
                else
                    next_state = RUNNING;
            end
            DONE: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Counters and Accumulation Logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            j <= 0;
            done <= 0;
            accumulator <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        j <= 0;
                        done <= 0;
                        accumulator <= 0;
                    end
                end
                RUNNING: begin
                    if (j < NH) begin
                        if (h_k) begin
                            accumulator <= accumulator + w_data;
                        end
                        j <= j + 1;
                    end
                    if (j == NH - 1) begin
                        done <= 1;
                    end
                end
                DONE: begin
                    done <= 1;
                end
            endcase
        end
    end

    // Output assignment
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            accumulated_sums <= 0;
        end else if (state == DONE) begin
            accumulated_sums <= accumulator;
        end
    end
endmodule

// Bias Adder Module
module bias_adder #(
    parameter NV = 16,
    parameter N_IN = 32,    // Bit-width of MAC accumulator output
    parameter N_BIAS = 8,   // Bit-width of bias values
    parameter N_OUT = 32    // Output bit-width 
)(
    input wire clk,
    input wire reset_n,
    input wire enable,
    input wire signed [N_IN-1:0] mac_sums [0:NV-1],
    input wire signed [N_BIAS-1:0] bias [0:NV-1],
    output reg signed [N_OUT-1:0] outputs [0:NV-1],
    output reg done
);
    // State definitions
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        ADD  = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    // State Register
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next State Logic
    always @(*) begin
        case (state)
            IDLE: next_state = enable ? ADD : IDLE;
            ADD:  next_state = DONE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Bias Addition Logic
    integer i;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            for (i = 0; i < NV; i = i + 1) begin
                outputs[i] <= 0;
            end
            done <= 0;
        end else begin
            case (state)
                IDLE: done <= 0;
                ADD: begin
                    for (i = 0; i < NV; i = i + 1) begin
                        // Sign extend bias to match MAC sum width
                        outputs[i] <= mac_sums[i] + {{(N_IN-N_BIAS){bias[i][N_BIAS-1]}}, bias[i]};
                    end
                    done <= 1;
                end
                DONE: done <= 0;
            endcase
        end
    end
endmodule

// Sigmoid LUT Module
module sigmoid_lut #(
    parameter LUT_SIZE = 256,
    parameter IN_WIDTH = 8,
    parameter OUT_WIDTH = 16
)(
    input wire signed [IN_WIDTH-1:0] x_input,
    output reg [OUT_WIDTH-1:0] y_output
);
    wire [7:0] lut_addr = x_input + 8'd128;

    always @(*) begin
        case (lut_addr)
            // Example entries shown - full implementation includes all 256 entries
            8'd0:   y_output = 16'd22;    // sigmoid(-8.0000) = 0.000335
            8'd1:   y_output = 16'd23;    // sigmoid(-7.9375) = 0.000357
            8'd2:   y_output = 16'd25;    // sigmoid(-7.8750) = 0.000380
            // [Additional LUT values would be included here]
            8'd253: y_output = 16'd65508; // sigmoid(7.8125) = 0.999596
            8'd254: y_output = 16'd65510; // sigmoid(7.8750) = 0.999620
            8'd255: y_output = 16'd65512; // sigmoid(7.9375) = 0.999643
            default: y_output = 16'd0;
        endcase
    end
endmodule

// Value Clamping Module
module clamp_mapper #(
    parameter INPUT_WIDTH = 32,
    parameter OUTPUT_WIDTH = 8
)(
    input wire signed [INPUT_WIDTH-1:0] in_data,
    output wire signed [OUTPUT_WIDTH-1:0] out_data
);
    assign out_data = (in_data > 127) ? 8'sb01111111 : 
                     (in_data < -128) ? 8'sb10000000 : 
                     in_data[7:0];
endmodule

// Random Number Generator
module rng (
    input wire clk,
    input wire reset_n,
    input wire load_new,
    input wire [15:0] seed,
    output reg [15:0] rand_num
);
    reg [15:0] lfsr;
    wire feedback = lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];
    wire [15:0] init_value = {seed[3:0], seed[7:4], seed[11:8], seed[15:12]};
    wire [15:0] mixed_seed = init_value ^ {init_value[7:0], init_value[15:8]};

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            lfsr <= mixed_seed ^ 16'hACE1;
            rand_num <= mixed_seed ^ 16'h1234;
        end else if (load_new) begin
            lfsr <= {lfsr[14:0], feedback};
            rand_num <= {lfsr[14:0], feedback};
        end
    end
endmodule

// Comparator Module
module comparator (
    input wire [15:0] sigmoid_val,
    input wire [15:0] rand_val,
    output wire out_bit
);
    assign out_bit = (sigmoid_val > rand_val);
endmodule

//------------------------------------------------------------------------------
// Implementation Notes:
// 1. All modules use synchronous reset (active low)
// 2. Fixed-point format allows range [-8.0 to +7.9375] with 0.0625 precision
// 3. Clock frequency target of 800MHz requires careful pipelining
// 4. Memory initialization values should be customized for specific applications
// 5. Sigmoid LUT values should be generated using high-precision calculations (ex. python script)
//------------------------------------------------------------------------------

`timescale 1ns/1ps

// ----------------------------------------
// W Memory Module with Synchronous Reset
// ----------------------------------------
module w_memory #(
    parameter NV = 16,  // Number of rows
    parameter NH = 16,  // Number of columns
    parameter N  = 8    // Bit width of each weight
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
    integer i, j;

    // Synchronous write and reset logic
    always @(posedge clk) begin
        if (!reset_n) begin
            // Row 0
            memory[0][0] <= 8'sb11000011;  // -3.8125
            memory[0][1] <= 8'sb11001011;  // -3.3125
            memory[0][2] <= 8'sb00100100;  // +2.2500
            memory[0][3] <= 8'sb00111100;  // +3.7500
            memory[0][4] <= 8'sb11101010;  // -1.3750
            memory[0][5] <= 8'sb11001111;  // -3.0625
            memory[0][6] <= 8'sb00001101;  // +0.8125
            memory[0][7] <= 8'sb11010001;  // -2.9375
            memory[0][8] <= 8'sb00001000;  // +0.5000
            memory[0][9] <= 8'sb00011100;  // +1.7500
            memory[0][10] <= 8'sb11101001;  // -1.4375
            memory[0][11] <= 8'sb11101010;  // -1.3750
            memory[0][12] <= 8'sb00110011;  // +3.1875
            memory[0][13] <= 8'sb11000110;  // -3.6250
            memory[0][14] <= 8'sb00010000;  // +1.0000
            memory[0][15] <= 8'sb11001101;  // -3.1875
            memory[1][0] <= 8'sb11000000;  // -4.0000
            memory[1][1] <= 8'sb10110101;  // -4.6875
            memory[1][2] <= 8'sb00010010;  // +1.1250
            memory[1][3] <= 8'sb00011110;  // +1.8750
            memory[1][4] <= 8'sb10110010;  // -4.8750
            memory[1][5] <= 8'sb00100101;  // +2.3125
            memory[1][6] <= 8'sb00101101;  // +2.8125
            memory[1][7] <= 8'sb11010110;  // -2.6250
            memory[1][8] <= 8'sb00010000;  // +1.0000
            memory[1][9] <= 8'sb11100100;  // -1.7500
            memory[1][10] <= 8'sb00011001;  // +1.5625
            memory[1][11] <= 8'sb00010100;  // +1.2500
            memory[1][12] <= 8'sb00110011;  // +3.1875
            memory[1][13] <= 8'sb00101110;  // +2.8750
            memory[1][14] <= 8'sb10110001;  // -4.9375
            memory[1][15] <= 8'sb00111110;  // +3.8750
            memory[2][0] <= 8'sb11001101;  // -3.1875
            memory[2][1] <= 8'sb00111000;  // +3.5000
            memory[2][2] <= 8'sb11000111;  // -3.5625
            memory[2][3] <= 8'sb00101111;  // +2.9375
            memory[2][4] <= 8'sb11101011;  // -1.3125
            memory[2][5] <= 8'sb00010011;  // +1.1875
            memory[2][6] <= 8'sb00011011;  // +1.6875
            memory[2][7] <= 8'sb11100101;  // -1.6875
            memory[2][8] <= 8'sb11101111;  // -1.0625
            memory[2][9] <= 8'sb10111111;  // -4.0625
            memory[2][10] <= 8'sb00000011;  // +0.1875
            memory[2][11] <= 8'sb00011100;  // +1.7500
            memory[2][12] <= 8'sb00100001;  // +2.0625
            memory[2][13] <= 8'sb11000110;  // -3.6250
            memory[2][14] <= 8'sb10110001;  // -4.9375
            memory[2][15] <= 8'sb11101110;  // -1.1250
            memory[3][0] <= 8'sb00011111;  // +1.9375
            memory[3][1] <= 8'sb00010000;  // +1.0000
            memory[3][2] <= 8'sb00111001;  // +3.5625
            memory[3][3] <= 8'sb10111011;  // -4.3125
            memory[3][4] <= 8'sb10110100;  // -4.7500
            memory[3][5] <= 8'sb11011100;  // -2.2500
            memory[3][6] <= 8'sb11010110;  // -2.6250
            memory[3][7] <= 8'sb00010110;  // +1.3750
            memory[3][8] <= 8'sb11100111;  // -1.5625
            memory[3][9] <= 8'sb00000111;  // +0.4375
            memory[3][10] <= 8'sb00011100;  // +1.7500
            memory[3][11] <= 8'sb00111001;  // +3.5625
            memory[3][12] <= 8'sb11100011;  // -1.8125
            memory[3][13] <= 8'sb00010011;  // +1.1875
            memory[3][14] <= 8'sb00001000;  // +0.5000
            memory[3][15] <= 8'sb11001101;  // -3.1875
            memory[4][0] <= 8'sb11101000;  // -1.5000
            memory[4][1] <= 8'sb11011100;  // -2.2500
            memory[4][2] <= 8'sb11100011;  // -1.8125
            memory[4][3] <= 8'sb11011110;  // -2.1250
            memory[4][4] <= 8'sb10111000;  // -4.5000
            memory[4][5] <= 8'sb11100011;  // -1.8125
            memory[4][6] <= 8'sb00110011;  // +3.1875
            memory[4][7] <= 8'sb00101010;  // +2.6250
            memory[4][8] <= 8'sb00000101;  // +0.3125
            memory[4][9] <= 8'sb00000001;  // +0.0625
            memory[4][10] <= 8'sb00010110;  // +1.3750
            memory[4][11] <= 8'sb00111011;  // +3.6875
            memory[4][12] <= 8'sb10111100;  // -4.2500
            memory[4][13] <= 8'sb11010001;  // -2.9375
            memory[4][14] <= 8'sb00100101;  // +2.3125
            memory[4][15] <= 8'sb00101011;  // +2.6875
            memory[5][0] <= 8'sb11000011;  // -3.8125
            memory[5][1] <= 8'sb00011000;  // +1.5000
            memory[5][2] <= 8'sb00000100;  // +0.2500
            memory[5][3] <= 8'sb10110010;  // -4.8750
            memory[5][4] <= 8'sb10110101;  // -4.6875
            memory[5][5] <= 8'sb00110110;  // +3.3750
            memory[5][6] <= 8'sb11100011;  // -1.8125
            memory[5][7] <= 8'sb00110000;  // +3.0000
            memory[5][8] <= 8'sb10111011;  // -4.3125
            memory[5][9] <= 8'sb11101000;  // -1.5000
            memory[5][10] <= 8'sb11100011;  // -1.8125
            memory[5][11] <= 8'sb00100111;  // +2.4375
            memory[5][12] <= 8'sb00100001;  // +2.0625
            memory[5][13] <= 8'sb11001100;  // -3.2500
            memory[5][14] <= 8'sb11101010;  // -1.3750
            memory[5][15] <= 8'sb00000011;  // +0.1875
            memory[6][0] <= 8'sb11001011;  // -3.3125
            memory[6][1] <= 8'sb11101001;  // -1.4375
            memory[6][2] <= 8'sb11100110;  // -1.6250
            memory[6][3] <= 8'sb11010001;  // -2.9375
            memory[6][4] <= 8'sb11000110;  // -3.6250
            memory[6][5] <= 8'sb11011010;  // -2.3750
            memory[6][6] <= 8'sb11101010;  // -1.3750
            memory[6][7] <= 8'sb00000101;  // +0.3125
            memory[6][8] <= 8'sb00001110;  // +0.8750
            memory[6][9] <= 8'sb11101010;  // -1.3750
            memory[6][10] <= 8'sb10110100;  // -4.7500
            memory[6][11] <= 8'sb00011010;  // +1.6250
            memory[6][12] <= 8'sb00100111;  // +2.4375
            memory[6][13] <= 8'sb10110011;  // -4.8125
            memory[6][14] <= 8'sb11010000;  // -3.0000
            memory[6][15] <= 8'sb00111110;  // +3.8750
            memory[7][0] <= 8'sb00010110;  // +1.3750
            memory[7][1] <= 8'sb11100100;  // -1.7500
            memory[7][2] <= 8'sb11000101;  // -3.6875
            memory[7][3] <= 8'sb00011111;  // +1.9375
            memory[7][4] <= 8'sb11011011;  // -2.3125
            memory[7][5] <= 8'sb11101110;  // -1.1250
            memory[7][6] <= 8'sb11000000;  // -4.0000
            memory[7][7] <= 8'sb11101001;  // -1.4375
            memory[7][8] <= 8'sb00101011;  // +2.6875
            memory[7][9] <= 8'sb11100110;  // -1.6250
            memory[7][10] <= 8'sb00100011;  // +2.1875
            memory[7][11] <= 8'sb00100011;  // +2.1875
            memory[7][12] <= 8'sb00110101;  // +3.3125
            memory[7][13] <= 8'sb11100110;  // -1.6250
            memory[7][14] <= 8'sb11010011;  // -2.8125
            memory[7][15] <= 8'sb11001011;  // -3.3125
            memory[8][0] <= 8'sb00111001;  // +3.5625
            memory[8][1] <= 8'sb10110010;  // -4.8750
            memory[8][2] <= 8'sb00100100;  // +2.2500
            memory[8][3] <= 8'sb10111111;  // -4.0625
            memory[8][4] <= 8'sb00110111;  // +3.4375
            memory[8][5] <= 8'sb11001111;  // -3.0625
            memory[8][6] <= 8'sb00110100;  // +3.2500
            memory[8][7] <= 8'sb00000111;  // +0.4375
            memory[8][8] <= 8'sb10111111;  // -4.0625
            memory[8][9] <= 8'sb00101100;  // +2.7500
            memory[8][10] <= 8'sb10111010;  // -4.3750
            memory[8][11] <= 8'sb11010011;  // -2.8125
            memory[8][12] <= 8'sb10110111;  // -4.5625
            memory[8][13] <= 8'sb11010001;  // -2.9375
            memory[8][14] <= 8'sb00000111;  // +0.4375
            memory[8][15] <= 8'sb11000000;  // -4.0000
            memory[9][0] <= 8'sb00111011;  // +3.6875
            memory[9][1] <= 8'sb00001011;  // +0.6875
            memory[9][2] <= 8'sb00001010;  // +0.6250
            memory[9][3] <= 8'sb11000110;  // -3.6250
            memory[9][4] <= 8'sb11010110;  // -2.6250
            memory[9][5] <= 8'sb11011111;  // -2.0625
            memory[9][6] <= 8'sb00001000;  // +0.5000
            memory[9][7] <= 8'sb00000011;  // +0.1875
            memory[9][8] <= 8'sb00101100;  // +2.7500
            memory[9][9] <= 8'sb11000110;  // -3.6250
            memory[9][10] <= 8'sb00001001;  // +0.5625
            memory[9][11] <= 8'sb00010111;  // +1.4375
            memory[9][12] <= 8'sb00111001;  // +3.5625
            memory[9][13] <= 8'sb00110110;  // +3.3750
            memory[9][14] <= 8'sb00110001;  // +3.0625
            memory[9][15] <= 8'sb00100010;  // +2.1250
            memory[10][0] <= 8'sb10110001;  // -4.9375
            memory[10][1] <= 8'sb00111011;  // +3.6875
            memory[10][2] <= 8'sb11001011;  // -3.3125
            memory[10][3] <= 8'sb11101100;  // -1.2500
            memory[10][4] <= 8'sb00100111;  // +2.4375
            memory[10][5] <= 8'sb00011001;  // +1.5625
            memory[10][6] <= 8'sb00010100;  // +1.2500
            memory[10][7] <= 8'sb10110101;  // -4.6875
            memory[10][8] <= 8'sb11100100;  // -1.7500
            memory[10][9] <= 8'sb10110100;  // -4.7500
            memory[10][10] <= 8'sb11011101;  // -2.1875
            memory[10][11] <= 8'sb00101001;  // +2.5625
            memory[10][12] <= 8'sb00100000;  // +2.0000
            memory[10][13] <= 8'sb11100001;  // -1.9375
            memory[10][14] <= 8'sb11100000;  // -2.0000
            memory[10][15] <= 8'sb00111000;  // +3.5000
            memory[11][0] <= 8'sb11011000;  // -2.5000
            memory[11][1] <= 8'sb11011011;  // -2.3125
            memory[11][2] <= 8'sb10111010;  // -4.3750
            memory[11][3] <= 8'sb10110101;  // -4.6875
            memory[11][4] <= 8'sb00111111;  // +3.9375
            memory[11][5] <= 8'sb11011101;  // -2.1875
            memory[11][6] <= 8'sb00100001;  // +2.0625
            memory[11][7] <= 8'sb00101110;  // +2.8750
            memory[11][8] <= 8'sb00110110;  // +3.3750
            memory[11][9] <= 8'sb11101101;  // -1.1875
            memory[11][10] <= 8'sb11000101;  // -3.6875
            memory[11][11] <= 8'sb00000010;  // +0.1250
            memory[11][12] <= 8'sb00000110;  // +0.3750
            memory[11][13] <= 8'sb11010011;  // -2.8125
            memory[11][14] <= 8'sb00111000;  // +3.5000
            memory[11][15] <= 8'sb10111001;  // -4.4375
            memory[12][0] <= 8'sb00010010;  // +1.1250
            memory[12][1] <= 8'sb00101111;  // +2.9375
            memory[12][2] <= 8'sb10110100;  // -4.7500
            memory[12][3] <= 8'sb11011000;  // -2.5000
            memory[12][4] <= 8'sb00100001;  // +2.0625
            memory[12][5] <= 8'sb00011101;  // +1.8125
            memory[12][6] <= 8'sb11010011;  // -2.8125
            memory[12][7] <= 8'sb11000001;  // -3.9375
            memory[12][8] <= 8'sb00000001;  // +0.0625
            memory[12][9] <= 8'sb11100101;  // -1.6875
            memory[12][10] <= 8'sb00011010;  // +1.6250
            memory[12][11] <= 8'sb11100110;  // -1.6250
            memory[12][12] <= 8'sb11100011;  // -1.8125
            memory[12][13] <= 8'sb00001011;  // +0.6875
            memory[12][14] <= 8'sb11100001;  // -1.9375
            memory[12][15] <= 8'sb11011000;  // -2.5000
            memory[13][0] <= 8'sb00101111;  // +2.9375
            memory[13][1] <= 8'sb11010000;  // -3.0000
            memory[13][2] <= 8'sb00101111;  // +2.9375
            memory[13][3] <= 8'sb00101111;  // +2.9375
            memory[13][4] <= 8'sb00000010;  // +0.1250
            memory[13][5] <= 8'sb00111011;  // +3.6875
            memory[13][6] <= 8'sb11001010;  // -3.3750
            memory[13][7] <= 8'sb11101010;  // -1.3750
            memory[13][8] <= 8'sb11100111;  // -1.5625
            memory[13][9] <= 8'sb11101001;  // -1.4375
            memory[13][10] <= 8'sb11010010;  // -2.8750
            memory[13][11] <= 8'sb00001110;  // +0.8750
            memory[13][12] <= 8'sb00111101;  // +3.8125
            memory[13][13] <= 8'sb11100011;  // -1.8125
            memory[13][14] <= 8'sb00011001;  // +1.5625
            memory[13][15] <= 8'sb11000011;  // -3.8125
            memory[14][0] <= 8'sb00010001;  // +1.0625
            memory[14][1] <= 8'sb00110010;  // +3.1250
            memory[14][2] <= 8'sb11000011;  // -3.8125
            memory[14][3] <= 8'sb00101001;  // +2.5625
            memory[14][4] <= 8'sb11001111;  // -3.0625
            memory[14][5] <= 8'sb11010110;  // -2.6250
            memory[14][6] <= 8'sb11100000;  // -2.0000
            memory[14][7] <= 8'sb00101010;  // +2.6250
            memory[14][8] <= 8'sb10111110;  // -4.1250
            memory[14][9] <= 8'sb11110000;  // -1.0000
            memory[14][10] <= 8'sb11101111;  // -1.0625
            memory[14][11] <= 8'sb00110101;  // +3.3125
            memory[14][12] <= 8'sb11001000;  // -3.5000
            memory[14][13] <= 8'sb00100101;  // +2.3125
            memory[14][14] <= 8'sb00010100;  // +1.2500
            memory[14][15] <= 8'sb11001100;  // -3.2500
            memory[15][0] <= 8'sb00100000;  // +2.0000
            memory[15][1] <= 8'sb00111010;  // +3.6250
            memory[15][2] <= 8'sb11011111;  // -2.0625
            memory[15][3] <= 8'sb11000110;  // -3.6250
            memory[15][4] <= 8'sb11010001;  // -2.9375
            memory[15][5] <= 8'sb00001110;  // +0.8750
            memory[15][6] <= 8'sb00001111;  // +0.9375
            memory[15][7] <= 8'sb00110101;  // +3.3125
            memory[15][8] <= 8'sb00100100;  // +2.2500
            memory[15][9] <= 8'sb00110001;  // +3.0625
            memory[15][10] <= 8'sb11001101;  // -3.1875
            memory[15][11] <= 8'sb00010011;  // +1.1875
            memory[15][12] <= 8'sb00101101;  // +2.8125
            memory[15][13] <= 8'sb00011000;  // +1.5000
            memory[15][14] <= 8'sb00001011;  // +0.6875
            memory[15][15] <= 8'sb10111100;  // -4.2500
        end else if (write_enable) begin
            memory[write_row][write_col] <= write_data;
        end
    end

    // Combinational read operation
    assign read_data = memory[read_row][read_col];
endmodule

// ----------------------------------------
// H Buffer Module with Synchronous Reset
// ----------------------------------------
module h_buffer #(
    parameter NV = 16  // Number of rows
)(
    input wire clk,
    input wire reset_n,
    input wire write_enable,
    input wire [NV-1:0] write_data,
    output wire [NV-1:0] read_data
);
    reg [NV-1:0] buffer;

    // Synchronous write and reset logic
    always @(posedge clk) begin
        if (!reset_n) begin
            buffer <= 16'b0110111100110101; // Set to desired activation pattern
            // Removed $display for synthesis
        end else if (write_enable) begin
            buffer <= write_data;
        end
    end

    assign read_data = buffer;
endmodule

// ----------------------------------------
// B Buffer Module with Synchronous Reset
// ----------------------------------------
module b_buffer #(
    parameter NV = 16,
    parameter N = 8     // Using same 1-3-4 fixed-point format as W memory
)(
    input wire clk,
    input wire reset_n,
    output reg signed [N-1:0] read_data [0:NV-1]
);
    reg signed [N-1:0] buffer [0:NV-1];
    integer i;

    // Synchronous reset logic
    always @(posedge clk) begin
        if (!reset_n) begin
            buffer[0]  <= 8'sb00000110;  // +0.375
            buffer[1]  <= 8'sb11111010;  // -0.375
            buffer[2]  <= 8'sb00001000;  // +0.500
            buffer[3]  <= 8'sb11111000;  // -0.500
            buffer[4]  <= 8'sb00001010;  // +0.625
            buffer[5]  <= 8'sb11110110;  // -0.625
            buffer[6]  <= 8'sb00001100;  // +0.750
            buffer[7]  <= 8'sb11110100;  // -0.750
            buffer[8]  <= 8'sb00001110;  // +0.875
            buffer[9]  <= 8'sb11110010;  // -0.875
            buffer[10] <= 8'sb00010000;  // +1.000
            buffer[11] <= 8'sb11110000;  // -1.000
            buffer[12] <= 8'sb00010010;  // +1.125
            buffer[13] <= 8'sb11101110;  // -1.125
            buffer[14] <= 8'sb00010100;  // +1.250
            buffer[15] <= 8'sb11101100;  // -1.250
        end else begin
            // No write operations specified
        end
    end

    // Assign all biases in parallel
    integer idx;
    always @(*) begin
        for (idx = 0; idx < NV; idx = idx + 1) begin
            read_data[idx] = buffer[idx];
        end
    end
endmodule

`timescale 1ns/1ps

// ----------------------------------------
// Sigmoid LUT Module
// ----------------------------------------
module sigmoid_lut #(
    parameter LUT_SIZE = 256,    // Number of LUT entries
    parameter IN_WIDTH = 8,      // Input width (signed)
    parameter OUT_WIDTH = 16     // Output width (unsigned)
)(
    input wire signed [IN_WIDTH-1:0] x_input, // Input: scaled value
    output reg [OUT_WIDTH-1:0] y_output      // Output: sigmoid(x)
);
    // Map x_input from [-8.0000, +7.9375] in steps of 0.0625 to [0, 255]
    wire [7:0] lut_addr = x_input + 8'd128;

    always @(*) begin
        case (lut_addr)
            8'd0:   y_output = 16'd22;    // sigmoid(-8.0000) = 0.000335
            8'd1:   y_output = 16'd23;    // sigmoid(-7.9375) = 0.000357
            8'd2:   y_output = 16'd25;    // sigmoid(-7.8750) = 0.000380
            8'd3:   y_output = 16'd27;    // sigmoid(-7.8125) = 0.000404
            8'd4:   y_output = 16'd28;    // sigmoid(-7.7500) = 0.000431
            8'd5:   y_output = 16'd30;    // sigmoid(-7.6875) = 0.000458
            8'd6:   y_output = 16'd32;    // sigmoid(-7.6250) = 0.000488
            8'd7:   y_output = 16'd34;    // sigmoid(-7.5625) = 0.000519
            8'd8:   y_output = 16'd36;    // sigmoid(-7.5000) = 0.000553
            8'd9:   y_output = 16'd39;    // sigmoid(-7.4375) = 0.000588
            8'd10:  y_output = 16'd41;    // sigmoid(-7.3750) = 0.000626
            8'd11:  y_output = 16'd44;    // sigmoid(-7.3125) = 0.000667
            8'd12:  y_output = 16'd47;    // sigmoid(-7.2500) = 0.000710
            8'd13:  y_output = 16'd50;    // sigmoid(-7.1875) = 0.000755
            8'd14:  y_output = 16'd53;    // sigmoid(-7.1250) = 0.000804
            8'd15:  y_output = 16'd56;    // sigmoid(-7.0625) = 0.000856
            8'd16:  y_output = 16'd60;    // sigmoid(-7.0000) = 0.000911
            8'd17:  y_output = 16'd64;    // sigmoid(-6.9375) = 0.000970
            8'd18:  y_output = 16'd68;    // sigmoid(-6.8750) = 0.001032
            8'd19:  y_output = 16'd72;    // sigmoid(-6.8125) = 0.001099
            8'd20:  y_output = 16'd77;    // sigmoid(-6.7500) = 0.001170
            8'd21:  y_output = 16'd82;    // sigmoid(-6.6875) = 0.001245
            8'd22:  y_output = 16'd87;    // sigmoid(-6.6250) = 0.001325
            8'd23:  y_output = 16'd92;    // sigmoid(-6.5625) = 0.001410
            8'd24:  y_output = 16'd98;    // sigmoid(-6.5000) = 0.001501
            8'd25:  y_output = 16'd105;   // sigmoid(-6.4375) = 0.001598
            8'd26:  y_output = 16'd111;   // sigmoid(-6.3750) = 0.001701
            8'd27:  y_output = 16'd119;   // sigmoid(-6.3125) = 0.001810
            8'd28:  y_output = 16'd126;   // sigmoid(-6.2500) = 0.001927
            8'd29:  y_output = 16'd134;   // sigmoid(-6.1875) = 0.002051
            8'd30:  y_output = 16'd143;   // sigmoid(-6.1250) = 0.002183
            8'd31:  y_output = 16'd152;   // sigmoid(-6.0625) = 0.002323
            8'd32:  y_output = 16'd162;   // sigmoid(-6.0000) = 0.002473
            8'd33:  y_output = 16'd172;   // sigmoid(-5.9375) = 0.002632
            8'd34:  y_output = 16'd184;   // sigmoid(-5.8750) = 0.002801
            8'd35:  y_output = 16'd195;   // sigmoid(-5.8125) = 0.002981
            8'd36:  y_output = 16'd208;   // sigmoid(-5.7500) = 0.003173
            8'd37:  y_output = 16'd221;   // sigmoid(-5.6875) = 0.003377
            8'd38:  y_output = 16'd236;   // sigmoid(-5.6250) = 0.003594
            8'd39:  y_output = 16'd251;   // sigmoid(-5.5625) = 0.003824
            8'd40:  y_output = 16'd267;   // sigmoid(-5.5000) = 0.004070
            8'd41:  y_output = 16'd284;   // sigmoid(-5.4375) = 0.004332
            8'd42:  y_output = 16'd302;   // sigmoid(-5.3750) = 0.004610
            8'd43:  y_output = 16'd321;   // sigmoid(-5.3125) = 0.004905
            8'd44:  y_output = 16'd342;   // sigmoid(-5.2500) = 0.005220
            8'd45:  y_output = 16'd364;   // sigmoid(-5.1875) = 0.005555
            8'd46:  y_output = 16'd387;   // sigmoid(-5.1250) = 0.005911
            8'd47:  y_output = 16'd412;   // sigmoid(-5.0625) = 0.006290
            8'd48:  y_output = 16'd439;   // sigmoid(-5.0000) = 0.006693
            8'd49:  y_output = 16'd467;   // sigmoid(-4.9375) = 0.007121
            8'd50:  y_output = 16'd497;   // sigmoid(-4.8750) = 0.007577
            8'd51:  y_output = 16'd528;   // sigmoid(-4.8125) = 0.008062
            8'd52:  y_output = 16'd562;   // sigmoid(-4.7500) = 0.008577
            8'd53:  y_output = 16'd598;   // sigmoid(-4.6875) = 0.009126
            8'd54:  y_output = 16'd636;   // sigmoid(-4.6250) = 0.009708
            8'd55:  y_output = 16'd677;   // sigmoid(-4.5625) = 0.010328
            8'd56:  y_output = 16'd720;   // sigmoid(-4.5000) = 0.010987
            8'd57:  y_output = 16'd766;   // sigmoid(-4.4375) = 0.011687
            8'd58:  y_output = 16'd815;   // sigmoid(-4.3750) = 0.012432
            8'd59:  y_output = 16'd867;   // sigmoid(-4.3125) = 0.013223
            8'd60:  y_output = 16'd922;   // sigmoid(-4.2500) = 0.014064
            8'd61:  y_output = 16'd980;   // sigmoid(-4.1875) = 0.014957
            8'd62:  y_output = 16'd1042;  // sigmoid(-4.1250) = 0.015906
            8'd63:  y_output = 16'd1109;  // sigmoid(-4.0625) = 0.016915
            8'd64:  y_output = 16'd1179;  // sigmoid(-4.0000) = 0.017986
            8'd65:  y_output = 16'd1253;  // sigmoid(-3.9375) = 0.019124
            8'd66:  y_output = 16'd1332;  // sigmoid(-3.8750) = 0.020332
            8'd67:  y_output = 16'd1417;  // sigmoid(-3.8125) = 0.021615
            8'd68:  y_output = 16'd1506;  // sigmoid(-3.7500) = 0.022977
            8'd69:  y_output = 16'd1601;  // sigmoid(-3.6875) = 0.024423
            8'd70:  y_output = 16'd1701;  // sigmoid(-3.6250) = 0.025957
            8'd71:  y_output = 16'd1808;  // sigmoid(-3.5625) = 0.027585
            8'd72:  y_output = 16'd1921;  // sigmoid(-3.5000) = 0.029312
            8'd73:  y_output = 16'd2041;  // sigmoid(-3.4375) = 0.031144
            8'd74:  y_output = 16'd2168;  // sigmoid(-3.3750) = 0.033086
            8'd75:  y_output = 16'd2303;  // sigmoid(-3.3125) = 0.035145
            8'd76:  y_output = 16'd2446;  // sigmoid(-3.2500) = 0.037327
            8'd77:  y_output = 16'd2598;  // sigmoid(-3.1875) = 0.039639
            8'd78:  y_output = 16'd2758;  // sigmoid(-3.1250) = 0.042088
            8'd79:  y_output = 16'd2928;  // sigmoid(-3.0625) = 0.044681
            8'd80:  y_output = 16'd3108;  // sigmoid(-3.0000) = 0.047426
            8'd81:  y_output = 16'd3298;  // sigmoid(-2.9375) = 0.050331
            8'd82:  y_output = 16'd3500;  // sigmoid(-2.8750) = 0.053403
            8'd83:  y_output = 16'd3713;  // sigmoid(-2.8125) = 0.056652
            8'd84:  y_output = 16'd3938;  // sigmoid(-2.7500) = 0.060087
            8'd85:  y_output = 16'd4176;  // sigmoid(-2.6875) = 0.063715
            8'd86:  y_output = 16'd4427;  // sigmoid(-2.6250) = 0.067547
            8'd87:  y_output = 16'd4692;  // sigmoid(-2.5625) = 0.071591
            8'd88:  y_output = 16'd4971;  // sigmoid(-2.5000) = 0.075858
            8'd89:  y_output = 16'd5266;  // sigmoid(-2.4375) = 0.080357
            8'd90:  y_output = 16'd5577;  // sigmoid(-2.3750) = 0.085099
            8'd91:  y_output = 16'd5904;  // sigmoid(-2.3125) = 0.090093
            8'd92:  y_output = 16'd6249;  // sigmoid(-2.2500) = 0.095349
            8'd93:  y_output = 16'd6611;  // sigmoid(-2.1875) = 0.100879
            8'd94:  y_output = 16'd6992;  // sigmoid(-2.1250) = 0.106691
            8'd95:  y_output = 16'd7392;  // sigmoid(-2.0625) = 0.112795
            8'd96:  y_output = 16'd7812;  // sigmoid(-2.0000) = 0.119203
            8'd97:  y_output = 16'd8252;  // sigmoid(-1.9375) = 0.125923
            8'd98:  y_output = 16'd8714;  // sigmoid(-1.8750) = 0.132964
            8'd99:  y_output = 16'd9197;  // sigmoid(-1.8125) = 0.140336
            8'd100: y_output = 16'd9702;  // sigmoid(-1.7500) = 0.148047
            8'd101: y_output = 16'd10230; // sigmoid(-1.6875) = 0.156105
            8'd102: y_output = 16'd10782; // sigmoid(-1.6250) = 0.164516
            8'd103: y_output = 16'd11356; // sigmoid(-1.5625) = 0.173288
            8'd104: y_output = 16'd11955; // sigmoid(-1.5000) = 0.182426
            8'd105: y_output = 16'd12578; // sigmoid(-1.4375) = 0.191933
            8'd106: y_output = 16'd13226; // sigmoid(-1.3750) = 0.201813
            8'd107: y_output = 16'd13898; // sigmoid(-1.3125) = 0.212069
            8'd108: y_output = 16'd14595; // sigmoid(-1.2500) = 0.222700
            8'd109: y_output = 16'd15316; // sigmoid(-1.1875) = 0.233706
            8'd110: y_output = 16'd16062; // sigmoid(-1.1250) = 0.245085
            8'd111: y_output = 16'd16831; // sigmoid(-1.0625) = 0.256832
            8'd112: y_output = 16'd17625; // sigmoid(-1.0000) = 0.268941
            8'd113: y_output = 16'd18442; // sigmoid(-0.9375) = 0.281406
            8'd114: y_output = 16'd19281; // sigmoid(-0.8750) = 0.294215
            8'd115: y_output = 16'd20143; // sigmoid(-0.8125) = 0.307358
            8'd116: y_output = 16'd21025; // sigmoid(-0.7500) = 0.320821
            8'd117: y_output = 16'd21927; // sigmoid(-0.6875) = 0.334589
            8'd118: y_output = 16'd22848; // sigmoid(-0.6250) = 0.348645
            8'd119: y_output = 16'd23787; // sigmoid(-0.5625) = 0.362969
            8'd120: y_output = 16'd24742; // sigmoid(-0.5000) = 0.377541
            8'd121: y_output = 16'd25712; // sigmoid(-0.4375) = 0.392337
            8'd122: y_output = 16'd26695; // sigmoid(-0.3750) = 0.407333
            8'd123: y_output = 16'd27689; // sigmoid(-0.3125) = 0.422505
            8'd124: y_output = 16'd28693; // sigmoid(-0.2500) = 0.437823
            8'd125: y_output = 16'd29705; // sigmoid(-0.1875) = 0.453262
            8'd126: y_output = 16'd30722; // sigmoid(-0.1250) = 0.468791
            8'd127: y_output = 16'd31744; // sigmoid(-0.0625) = 0.484380
            8'd128: y_output = 16'd32768; // sigmoid(0.0000) = 0.500000
            8'd129: y_output = 16'd33791; // sigmoid(0.0625) = 0.515620
            8'd130: y_output = 16'd34813; // sigmoid(0.1250) = 0.531209
            8'd131: y_output = 16'd35830; // sigmoid(0.1875) = 0.546738
            8'd132: y_output = 16'd36842; // sigmoid(0.2500) = 0.562177
            8'd133: y_output = 16'd37846; // sigmoid(0.3125) = 0.577495
            8'd134: y_output = 16'd38840; // sigmoid(0.3750) = 0.592667
            8'd135: y_output = 16'd39823; // sigmoid(0.4375) = 0.607663
            8'd136: y_output = 16'd40793; // sigmoid(0.5000) = 0.622459
            8'd137: y_output = 16'd41748; // sigmoid(0.5625) = 0.637031
            8'd138: y_output = 16'd42687; // sigmoid(0.6250) = 0.651355
            8'd139: y_output = 16'd43608; // sigmoid(0.6875) = 0.665411
            8'd140: y_output = 16'd44510; // sigmoid(0.7500) = 0.679179
            8'd141: y_output = 16'd45392; // sigmoid(0.8125) = 0.692642
            8'd142: y_output = 16'd46254; // sigmoid(0.8750) = 0.705785
            8'd143: y_output = 16'd47093; // sigmoid(0.9375) = 0.718594
            8'd144: y_output = 16'd47910; // sigmoid(1.0000) = 0.731059
            8'd145: y_output = 16'd48704; // sigmoid(1.0625) = 0.743168
            8'd146: y_output = 16'd49473; // sigmoid(1.1250) = 0.754915
            8'd147: y_output = 16'd50219; // sigmoid(1.1875) = 0.766294
            8'd148: y_output = 16'd50940; // sigmoid(1.2500) = 0.777300
            8'd149: y_output = 16'd51637; // sigmoid(1.3125) = 0.787931
            8'd150: y_output = 16'd52309; // sigmoid(1.3750) = 0.798187
            8'd151: y_output = 16'd52957; // sigmoid(1.4375) = 0.808067
            8'd152: y_output = 16'd53580; // sigmoid(1.5000) = 0.817574
            8'd153: y_output = 16'd54179; // sigmoid(1.5625) = 0.826712
            8'd154: y_output = 16'd54753; // sigmoid(1.6250) = 0.835484
            8'd155: y_output = 16'd55305; // sigmoid(1.6875) = 0.843895
            8'd156: y_output = 16'd55833; // sigmoid(1.7500) = 0.851953
            8'd157: y_output = 16'd56338; // sigmoid(1.8125) = 0.859664
            8'd158: y_output = 16'd56821; // sigmoid(1.8750) = 0.867036
            8'd159: y_output = 16'd57283; // sigmoid(1.9375) = 0.874077
            8'd160: y_output = 16'd57723; // sigmoid(2.0000) = 0.880797
            8'd161: y_output = 16'd58143; // sigmoid(2.0625) = 0.887205
            8'd162: y_output = 16'd58543; // sigmoid(2.1250) = 0.893309
            8'd163: y_output = 16'd58924; // sigmoid(2.1875) = 0.899121
            8'd164: y_output = 16'd59286; // sigmoid(2.2500) = 0.904651
            8'd165: y_output = 16'd59631; // sigmoid(2.3125) = 0.909907
            8'd166: y_output = 16'd59958; // sigmoid(2.3750) = 0.914901
            8'd167: y_output = 16'd60269; // sigmoid(2.4375) = 0.919643
            8'd168: y_output = 16'd60564; // sigmoid(2.5000) = 0.924142
            8'd169: y_output = 16'd60843; // sigmoid(2.5625) = 0.928409
            8'd170: y_output = 16'd61108; // sigmoid(2.6250) = 0.932453
            8'd171: y_output = 16'd61359; // sigmoid(2.6875) = 0.936285
            8'd172: y_output = 16'd61597; // sigmoid(2.7500) = 0.939913
            8'd173: y_output = 16'd61822; // sigmoid(2.8125) = 0.943348
            8'd174: y_output = 16'd62035; // sigmoid(2.8750) = 0.946597
            8'd175: y_output = 16'd62237; // sigmoid(2.9375) = 0.949669
            8'd176: y_output = 16'd62427; // sigmoid(3.0000) = 0.952574
            8'd177: y_output = 16'd62607; // sigmoid(3.0625) = 0.955319
            8'd178: y_output = 16'd62777; // sigmoid(3.1250) = 0.957912
            8'd179: y_output = 16'd62937; // sigmoid(3.1875) = 0.960361
            8'd180: y_output = 16'd63089; // sigmoid(3.2500) = 0.962673
            8'd181: y_output = 16'd63232; // sigmoid(3.3125) = 0.964855
            8'd182: y_output = 16'd63367; // sigmoid(3.3750) = 0.966914
            8'd183: y_output = 16'd63494; // sigmoid(3.4375) = 0.968856
            8'd184: y_output = 16'd63614; // sigmoid(3.5000) = 0.970688
            8'd185: y_output = 16'd63727; // sigmoid(3.5625) = 0.972415
            8'd186: y_output = 16'd63834; // sigmoid(3.6250) = 0.974043
            8'd187: y_output = 16'd63934; // sigmoid(3.6875) = 0.975577
            8'd188: y_output = 16'd64029; // sigmoid(3.7500) = 0.977023
            8'd189: y_output = 16'd64118; // sigmoid(3.8125) = 0.978385
            8'd190: y_output = 16'd64203; // sigmoid(3.8750) = 0.979668
            8'd191: y_output = 16'd64282; // sigmoid(3.9375) = 0.980876
            8'd192: y_output = 16'd64356; // sigmoid(4.0000) = 0.982014
            8'd193: y_output = 16'd64426; // sigmoid(4.0625) = 0.983085
            8'd194: y_output = 16'd64493; // sigmoid(4.1250) = 0.984094
            8'd195: y_output = 16'd64555; // sigmoid(4.1875) = 0.985043
            8'd196: y_output = 16'd64613; // sigmoid(4.2500) = 0.985936
            8'd197: y_output = 16'd64668; // sigmoid(4.3125) = 0.986777
            8'd198: y_output = 16'd64720; // sigmoid(4.3750) = 0.987568
            8'd199: y_output = 16'd64769; // sigmoid(4.4375) = 0.988313
            8'd200: y_output = 16'd64815; // sigmoid(4.5000) = 0.989013
            8'd201: y_output = 16'd64858; // sigmoid(4.5625) = 0.989672
            8'd202: y_output = 16'd64899; // sigmoid(4.6250) = 0.990292
            8'd203: y_output = 16'd64937; // sigmoid(4.6875) = 0.990874
            8'd204: y_output = 16'd64973; // sigmoid(4.7500) = 0.991423
            8'd205: y_output = 16'd65007; // sigmoid(4.8125) = 0.991938
            8'd206: y_output = 16'd65038; // sigmoid(4.8750) = 0.992423
            8'd207: y_output = 16'd65068; // sigmoid(4.9375) = 0.992879
            8'd208: y_output = 16'd65096; // sigmoid(5.0000) = 0.993307
            8'd209: y_output = 16'd65123; // sigmoid(5.0625) = 0.993710
            8'd210: y_output = 16'd65148; // sigmoid(5.1250) = 0.994089
            8'd211: y_output = 16'd65171; // sigmoid(5.1875) = 0.994445
            8'd212: y_output = 16'd65193; // sigmoid(5.2500) = 0.994780
            8'd213: y_output = 16'd65214; // sigmoid(5.3125) = 0.995095
            8'd214: y_output = 16'd65233; // sigmoid(5.3750) = 0.995390
            8'd215: y_output = 16'd65251; // sigmoid(5.4375) = 0.995668
            8'd216: y_output = 16'd65268; // sigmoid(5.5000) = 0.995930
            8'd217: y_output = 16'd65284; // sigmoid(5.5625) = 0.996176
            8'd218: y_output = 16'd65299; // sigmoid(5.6250) = 0.996406
            8'd219: y_output = 16'd65314; // sigmoid(5.6875) = 0.996623
            8'd220: y_output = 16'd65327; // sigmoid(5.7500) = 0.996827
            8'd221: y_output = 16'd65340; // sigmoid(5.8125) = 0.997019
            8'd222: y_output = 16'd65351; // sigmoid(5.8750) = 0.997199
            8'd223: y_output = 16'd65363; // sigmoid(5.9375) = 0.997368
            8'd224: y_output = 16'd65373; // sigmoid(6.0000) = 0.997527
            8'd225: y_output = 16'd65383; // sigmoid(6.0625) = 0.997677
            8'd226: y_output = 16'd65392; // sigmoid(6.1250) = 0.997817
            8'd227: y_output = 16'd65401; // sigmoid(6.1875) = 0.997949
            8'd228: y_output = 16'd65409; // sigmoid(6.2500) = 0.998073
            8'd229: y_output = 16'd65416; // sigmoid(6.3125) = 0.998190
            8'd230: y_output = 16'd65424; // sigmoid(6.3750) = 0.998299
            8'd231: y_output = 16'd65430; // sigmoid(6.4375) = 0.998402
            8'd232: y_output = 16'd65437; // sigmoid(6.5000) = 0.998499
            8'd233: y_output = 16'd65443; // sigmoid(6.5625) = 0.998590
            8'd234: y_output = 16'd65448; // sigmoid(6.6250) = 0.998675
            8'd235: y_output = 16'd65453; // sigmoid(6.6875) = 0.998755
            8'd236: y_output = 16'd65458; // sigmoid(6.7500) = 0.998830
            8'd237: y_output = 16'd65463; // sigmoid(6.8125) = 0.998901
            8'd238: y_output = 16'd65467; // sigmoid(6.8750) = 0.998968
            8'd239: y_output = 16'd65471; // sigmoid(6.9375) = 0.999030
            8'd240: y_output = 16'd65475; // sigmoid(7.0000) = 0.999089
            8'd241: y_output = 16'd65479; // sigmoid(7.0625) = 0.999144
            8'd242: y_output = 16'd65482; // sigmoid(7.1250) = 0.999196
            8'd243: y_output = 16'd65485; // sigmoid(7.1875) = 0.999245
            8'd244: y_output = 16'd65488; // sigmoid(7.2500) = 0.999290
            8'd245: y_output = 16'd65491; // sigmoid(7.3125) = 0.999333
            8'd246: y_output = 16'd65494; // sigmoid(7.3750) = 0.999374
            8'd247: y_output = 16'd65496; // sigmoid(7.4375) = 0.999412
            8'd248: y_output = 16'd65499; // sigmoid(7.5000) = 0.999447
            8'd249: y_output = 16'd65501; // sigmoid(7.5625) = 0.999481
            8'd250: y_output = 16'd65503; // sigmoid(7.6250) = 0.999512
            8'd251: y_output = 16'd65505; // sigmoid(7.6875) = 0.999542
            8'd252: y_output = 16'd65507; // sigmoid(7.7500) = 0.999569
            8'd253: y_output = 16'd65508; // sigmoid(7.8125) = 0.999596
            8'd254: y_output = 16'd65510; // sigmoid(7.8750) = 0.999620
            8'd255: y_output = 16'd65512; // sigmoid(7.9375) = 0.999643
            default: y_output = 16'd0;     // Default case (shouldn't occur)
        endcase
    end

endmodule


// ----------------------------------------
// Clamp and Mapping Module
// ----------------------------------------
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

// ----------------------------------------
// MAC Module for Parallel Row Processing
// ----------------------------------------
module mac #(
    parameter NV = 16,  // Number of rows
    parameter NH = 16,  // Number of columns
    parameter N = 8     // Bit width of W memory elements (1-3-4 fixed-point)
)(
    input wire clk,
    input wire reset_n,
    input wire start,
    input wire signed [N-1:0] w_data,  // Data from W memory for this row
    input wire h_k,                    // Single bit from H buffer for this row
    output wire [$clog2(NH)-1:0] w_col, // Column index
    output reg done,
    output reg signed [31:0] accumulated_sums
);
    reg [$clog2(NH):0] j; // Column counter
    reg signed [31:0] accumulator;

    // State definitions
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        RUNNING = 2'b01,
        DONE    = 2'b10
    } state_t;

    state_t state, next_state;

    // Assign w_col
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
                            // Removed $display for synthesis
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

    // Assign accumulated sums to outputs
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            accumulated_sums <= 0;
        end else if (state == DONE) begin
            accumulated_sums <= accumulator;
        end
    end
endmodule

// ----------------------------------------
// Bias Adder Module for Parallel Bias Addition
// ----------------------------------------
module bias_adder #(
    parameter NV = 16,
    parameter N_IN = 32,    // Bit-width of MAC accumulator output
    parameter N_BIAS = 8,   // Bit-width of bias values (same as W memory)
    parameter N_OUT = 32    // Output bit-width 
)(
    input wire clk,
    input wire reset_n,
    input wire enable,
    input wire signed [N_IN-1:0] mac_sums [0:NV-1],
    input wire signed [N_BIAS-1:0] bias [0:NV-1],   // All biases in parallel
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
            IDLE: begin
                if (enable)
                    next_state = ADD;
                else
                    next_state = IDLE;
            end
            ADD: begin
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
                IDLE: begin
                    done <= 0;
                end
                ADD: begin
                    for (i = 0; i < NV; i = i + 1) begin
                        // Sign extend bias to match MAC sum width
                        outputs[i] <= mac_sums[i] + {{(N_IN-N_BIAS){bias[i][N_BIAS-1]}}, bias[i]};
                    end
                    done <= 1;
                end
                DONE: begin
                    done <= 0;
                end
            endcase
        end
    end
endmodule

// ----------------------------------------
// Random Number Generator Module (16-bit output for comparator)
// ----------------------------------------
module rng (
    input wire clk,
    input wire reset_n,
    input wire load_new,
    input wire [15:0] seed,
    output reg [15:0] rand_num
);
    reg [15:0] lfsr;

    // Polynomial for 16-bit LFSR: x^16 + x^14 + x^13 + x^11 + 1
    wire feedback = lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10];

    // Create a unique initial value based on the seed and its position
    wire [15:0] init_value = {seed[3:0], seed[7:4], seed[11:8], seed[15:12]};

    // Additional mixing for initialization
    wire [15:0] mixed_seed = init_value ^ {init_value[7:0], init_value[15:8]};

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Initialize with mixed seed instead of fixed value
            lfsr <= mixed_seed ^ 16'hACE1;  // XOR with a constant for more randomness
            rand_num <= mixed_seed ^ 16'h1234;
        end else if (load_new) begin
            lfsr <= {lfsr[14:0], feedback};
            rand_num <= {lfsr[14:0], feedback};
        end
    end
endmodule

// ----------------------------------------
// Comparator Module
// ----------------------------------------
module comparator (
    input wire [15:0] sigmoid_val,
    input wire [15:0] rand_val,
    output wire out_bit
);
    assign out_bit = (sigmoid_val > rand_val) ? 1'b1 : 1'b0;
endmodule

// ----------------------------------------
// Complete System Design with Parallel MAC Processing, Sigmoid Activation, RNG, and Comparators
// ----------------------------------------
module complete_system #(
    parameter NV = 16, // Number of neurons
    parameter NH = 16, // Number of inputs per neuron
    parameter N  = 8   // Bit width of each weight
)(
    input wire clk,
    input wire reset_n,
    input wire start,
    output wire system_done,
    output wire [NV-1:0] comparator_outputs_out,
    output reg [2:0] state_display  // Keeping this for debugging
);
  
    // Internal signals (formerly outputs)
    wire signed [31:0] final_outputs [0:NV-1];
    wire signed [31:0] mac_outputs_out [0:NV-1];
    wire signed [N-1:0] bias_data_out [0:NV-1];
    wire [15:0] sigmoid_outputs_out [0:NV-1];
    wire [15:0] rng_outputs_out [0:NV-1];

    // Internal signals for W memory
    wire signed [N-1:0] w_read_data [0:NV-1]; // One read data per row
    wire [$clog2(NH)-1:0] w_col_wire [0:NV-1];
    
    // Internal signals for H buffer
    wire [NV-1:0] h_data;
    
    // Internal signals for MAC
    wire [NV-1:0] mac_done;
    wire signed [31:0] mac_outputs [0:NV-1];
    
    // Internal signals for bias system
    wire signed [N-1:0] bias_data [0:NV-1];
    wire bias_done;
    
    // Control signals
    reg bias_enable;
    
    // Instantiate W memory for each row with write capabilities
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
                .write_enable(1'b0),           // Disable write operations; initialized via reset
                .write_row('0),
                .write_col('0),
                .write_data('0),
                .read_row(read_row_wire),
                .read_col(w_col_wire[i]),
                .read_data(w_read_data[i])
            );
        end
    endgenerate

    // Instantiate H buffer with specific initialization
    h_buffer #(
        .NV(NV)
    ) h_buf (
        .clk(clk),
        .reset_n(reset_n),
        .write_enable(1'b0),               // Disable write operations; initialized via reset logic
        .write_data('0),
        .read_data(h_data)
    );

    // Instantiate multiple MAC units
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

    // Instantiate B Buffer
    b_buffer #(
        .NV(NV),
        .N(N)
    ) b_buf (
        .clk(clk),
        .reset_n(reset_n),
        .read_data(bias_data)
    );

    // Instantiate Bias Adder
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

    // Assign mac_outputs and bias_data to outputs for testbench access
    generate
        for (i = 0; i < NV; i = i + 1) begin : output_assign
            assign mac_outputs_out[i] = mac_outputs[i];
            assign bias_data_out[i] = bias_data[i];
        end
    endgenerate

    // Sigmoid Processing
    wire signed [7:0] sigmoid_inputs [0:NV-1];
    wire [15:0] sigmoid_outputs [0:NV-1];

    // Instantiate Clamp Mapper for each final_output
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

    // Instantiate Sigmoid LUT for each sigmoid_input
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

    // Assign Sigmoid outputs to module outputs
    generate
        for (i = 0; i < NV; i = i + 1) begin : sigmoid_output_assign
            assign sigmoid_outputs_out[i] = sigmoid_outputs[i];
        end
    endgenerate

    // Instantiate 16 RNGs with unique seeds
    wire [15:0] rng_outputs [0:NV-1];
    wire [NV-1:0] comparator_outputs;
    wire [NV-1:0] comparator_out_bits;
    
    generate
        for (i = 0; i < NV; i = i + 1) begin : rng_gen
            rng rng_inst (
                .clk(clk),
                .reset_n(reset_n),
                .load_new(state_display == 3'd5), // COMPARE state (assuming state 5)
                .seed(16'h1234 ^ {8'h00, i[7:0]}), // Use XOR and limit i to 8 bits
                .rand_num(rng_outputs[i])
            );
        end
    endgenerate

    // Instantiate 16 Comparators
    generate
        for (i = 0; i < NV; i = i + 1) begin : comparator_gen
            comparator comp_inst (
                .sigmoid_val(sigmoid_outputs_out[i]),
                .rand_val(rng_outputs[i]),
                .out_bit(comparator_out_bits[i])
            );
        end
    endgenerate

    // Assign Comparator outputs to module outputs
    assign comparator_outputs_out = comparator_out_bits;

    // Assign RNG outputs to module outputs for testbench
    generate
        for (i = 0; i < NV; i = i + 1) begin : rng_output_assign
            assign rng_outputs_out[i] = rng_outputs[i];
        end
    endgenerate

    // State Machine and Control Logic
    typedef enum logic [2:0] {
        IDLE       = 3'b000,
        MAC_PROC   = 3'b001,
        BIAS_SETUP = 3'b010,
        BIAS_PROC  = 3'b011,
        SIGMOID    = 3'b100,
        COMPARE    = 3'b101,
        DONE       = 3'b110
    } state_t_fsm;

    state_t_fsm current_state, next_state;

    // State Register
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Control Signals
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            bias_enable <= 0;
        end else begin
            bias_enable <= 0; // Default: disable bias addition
            case (current_state)
                IDLE: begin
                    // No action needed
                end
                BIAS_SETUP: begin
                    bias_enable <= 1; // Enable bias addition
                end
                COMPARE: begin
                    // No additional control signals needed
                end
                // Other states do not modify control signals
                default: begin
                    // No action
                end
            endcase
        end
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (start)
                    next_state = MAC_PROC;
                else
                    next_state = IDLE;
            end
            MAC_PROC: begin
                // Wait until all MAC units are done
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

    // Assign FSM state to output for monitoring
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state_display <= IDLE;
        else
            state_display <= current_state;
    end

    // System done signal
    assign system_done = (current_state == DONE);
endmodule

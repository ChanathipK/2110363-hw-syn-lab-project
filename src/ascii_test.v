`timescale 1ns / 1ps
// Reference book: "FPGA Prototyping by Verilog Examples"
//                    "Xilinx Spartan-3 Version"
// Authored by: Pong P. Chu
// Published by: Wiley, 2008
// Adapted for use on Basys 3 FPGA with Xilinx Artix-7
// by: David J. Marion aka FPGA Dude

module ascii_test(
    input clk,
    input video_on,
    input [9:0] x, y,
    output reg [11:0] rgb,
    input wire [7:0] data,
    input wire newdata,
    input wire baud,
    input wire reset
    );
    
    reg [6:0] showdata;
    
    // signal declarations
    wire [10:0] rom_addr;           // 11-bit text ROM address
    wire [6:0] ascii_char;          // 7-bit ASCII character code
    wire [3:0] char_row;            // 4-bit row of ASCII character
    wire [2:0] bit_addr;            // column number of ROM data
    wire [7:0] rom_data;            // 8-bit row data from text ROM
    wire ascii_bit, ascii_bit_on;     // ROM bit and status signal
    
    // instantiate ASCII ROM
    ascii_rom rom(.clk(clk), .addr(rom_addr), .data(rom_data));
      
    // ASCII ROM interface
    assign rom_addr = {ascii_char, char_row};   // ROM address is ascii code + row
    assign ascii_bit = rom_data[~bit_addr];     // reverse bit order

    assign ascii_char = showdata;   // 7-bit ascii code
    assign char_row = y[3:0];               // row number of ascii character rom
    assign bit_addr = x[2:0];               // column number of ascii character rom
    // "on" region in center of screen
    assign ascii_bit_on = ((x >= 192 && x < 448) && (y >= 208 && y < 272)) ? ascii_bit : 1'b0;
    
    // rgb multiplexing circuit
    always @*
        if(~video_on)
            rgb = 12'h000;      // blank
        else
            if(ascii_bit_on)
                rgb = 12'h99F;  // blue letters
            else
                rgb = 12'h888;  // white background
   //##################################### additional logic #################################################//
   reg [4:0] x_letter;
   reg [1:0] y_letter;
   reg [4:0] x_pointer;
   reg [1:0] y_pointer;
   
   reg [6:0] memory [3:0][31:0];
    
   integer i, j;
   
   initial begin
    x_letter = 0;
    y_letter = 0;
    x_pointer = 0;
    y_pointer = 0;
    for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 32; j = j + 1) begin
                memory[i][j] <= 47; // Fill with sequential ASCII characters
            end
        end    
    end
   
//   // Memory write logic (baud clock)
always @(posedge reset or posedge newdata ) begin
    if (reset) begin
        x_pointer <= 0;
        y_pointer <= 0;
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 32; j = j + 1) begin
                memory[i][j] <= 47; // Fill with sequential ASCII characters
            end
        end    
    end else if (newdata) begin
        if (data[6:0] == 13) begin
            x_pointer <= 0;
            y_pointer <= (y_pointer + 1) % 4;
        end else if (data[6:0] == 45) begin /////////
            if(x_pointer == 0) begin
                  x_pointer = 31;
                  y_pointer = y_pointer-1;
                  memory[y_pointer][x_pointer] = 47; //////////////
            end else begin
                x_pointer = x_pointer - 1;
                memory[y_pointer][x_pointer] = 47; //////////////
            end
        end else begin
            memory[y_pointer][x_pointer] <= data[6:0];
            if (x_pointer == 31) begin
                x_pointer <= 0;
                y_pointer <= (y_pointer == 3) ? 0 : y_pointer + 1;
            end else begin
                x_pointer <= x_pointer + 1;
            end
        end
    end
end


    integer count;
    // Memory read logic (clk clock)    
    always @(posedge clk) begin
    // Memory read logic
    showdata <= memory[((y[5:4] + 3) & 2'b11)][((x[7:3] + 8) & 5'b11111)];  // Non-blocking assignment for showdata
    
    if (count == 32) begin
        count <= 0;  // Reset count after reaching 7

        if (x_letter == 31) begin
            x_letter <= 0;  // Reset x_letter to 0 when it reaches 31
            y_letter <= (y_letter == 3) ? 0 : y_letter + 1;  // Update y_letter, reset if 3
        end else begin
            x_letter <= x_letter + 1;  // Increment x_letter
        end
    end else begin
        count <= count + 1;  // Increment count if not yet 7
    end
    end
 
endmodule

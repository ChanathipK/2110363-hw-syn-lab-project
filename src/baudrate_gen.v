`timescale 1ns / 1ps

module baudrate_gen(
    input clk,
    output reg baud
    );
    
    integer counter;
    initial baud = 0;
    always @(posedge clk) begin
        counter = counter + 1;
        if (counter == 325) begin counter = 0; baud = ~baud; end 
        // Clock = 10ns
        // ClockFreq = 1/10ns = 100 MHz
        // Baudrate = 9600
        // counter = ClockFreq/Baudrate/16/2
        // sampling every 16 ticks
    end
    
endmodule
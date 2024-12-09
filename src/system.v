`timescale 1ns / 1ps

module system(
    output wire RsTx,
    input wire RsRx,
    input clk,
    input wire JB0,
    output wire JC0,
    input wire btnC,
    output hsync,
    output vsync,
    output [11:0] rgb,
    input [7:0] sw,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    input wire btnU,
    input PS2Data,
    input PS2Clk
    );

// ######################### global var ######################### //

// data_out is the data received from UART (receiver - uart_rx.v)
wire [7:0] data_out;

// received is 1 for 1 baud when data is received
wire received;

wire baud;
baudrate_gen baudrate_gen(clk, baud);

// make btnC one baud width (single pulser)
wire singleBaudBtnC;
singlePulser singleReset(singleBaudBtnC, btnC, baud);

// ######################### get data from switch ######################### //

reg [7:0] data_to_send;
initial begin
    data_to_send <= 0;
end 
reg en;

wire singleBaudBtnU;
singlePulser singleClick(singleBaudBtnU, btnU, baud);

// ######################## get data from keyboard ######################## //

reg CLK50MHZ=0;
wire [15:0] keycode;
wire flag;

always @(posedge clk) begin
    CLK50MHZ<=~CLK50MHZ;
end

PS2Receiver uut (
    .clk(CLK50MHZ),
    .kclk(PS2Clk),
    .kdata(PS2Data),
    .keycode(keycode),
    .oflag(flag)
);

// flag is 1 when new data (keycode) is ready
// when press and release a button, flag is 1 three times
// for example, A
// flag1: 001C
// flag2: 1CF0
// flag3: F01C
// see how the data is inserted from lower bit

// key_out is mapped 8-bit data that can be sent
wire [7:0] key_out;

// flag is too fast, when used in a sensitivity list, things could go wrong
// so long_flag is created
reg [15:0] timer;
reg long_flag;
always @(posedge clk) begin
    if (flag == 1) begin
       timer <= 325;
       long_flag <= 1;
    end else if (timer > 0) begin
        timer <= timer - 1;
    end else begin
        long_flag = 0;
    end

end

// handle shift, cap lock, change language

reg leftShift;
reg rightShift;

initial begin
    leftShift <= 0;
    rightShift <= 0;
end

wire shift;
assign shift = leftShift | rightShift;

reg capPressed;
reg capLock;

reg langPressed;
reg changeToThai;

initial begin
    capLock <= 0;
    changeToThai <= 0;
end

keyboardToUnicode(keycode[7:0], key_out, clk, long_flag, shift, capLock, changeToThai);

always @(posedge long_flag) begin
    if (keycode[7:0] == 8'h58 && keycode[15:8] != 8'hF0) begin
        capPressed <= 1;
    end else if (keycode == 16'hF058) begin
        capPressed <= 0;
    end else if (keycode[7:0] == 8'h12 && keycode[15:8] != 8'hF0) begin
        leftShift <= 1;
    end else if (keycode == 16'hF012) begin
        leftShift <= 0;
    end else if (keycode[7:0] == 8'h59 && keycode[15:8] != 8'hF0) begin
        rightShift <= 1;
    end else if (keycode == 16'hF059) begin
        rightShift <= 0;
    end else if (keycode[7:0] == 8'h0E && keycode[15:8] != 8'hF0) begin
        langPressed <= 1;
    end else if (keycode == 16'hF00E) begin
        langPressed <= 0;
    end
end

always @(posedge capPressed) begin
    capLock <= ~capLock;
end

always @(posedge langPressed) begin
    changeToThai <= ~changeToThai;
end

// ######################### use 7-segment to show values ############### //

wire [3:0] num3, num2, num1, num0;
assign num3 = {1'b0, 1'b0, 1'b0, changeToThai};
assign num2 = {1'b0, 1'b0, 1'b0, langPressed};
assign num1 = data_to_send[7:4];
assign num0 = data_to_send[3:0];
wire an0, an1, an2, an3;
assign an = {an3, an2, an1, an0};
 
wire targetClk;
wire [18:0] tclk;
assign tclk[0]=clk;
genvar c;
generate for(c=0;c<18;c=c+1) begin
    clockDiv fDiv(tclk[c+1],tclk[c]);
end endgenerate

clockDiv fdivTarget(targetClk,tclk[18]);

quadSevenSeg q7seg(seg,dp,an0,an1,an2,an3,num0,num1,num2,num3,targetClk);

// ######################### vga ########################################## //
// signals
wire [9:0] w_x, w_y;
wire w_video_on, w_p_tick;
reg [11:0] rgb_reg;
wire [11:0] rgb_next;
    
// VGA Controller
vga_controller vga(.clk_100MHz(clk), .reset(btnC), .hsync(hsync), .vsync(vsync),
                   .video_on(w_video_on), .p_tick(w_p_tick), .x(w_x), .y(w_y));
// Text Generation Circuit
ascii_test at(.clk(clk), .video_on(w_video_on), .x(w_x), .y(w_y), .rgb(rgb_next), .data(data_out), .newdata(received), .baud(baud), .reset(singleBaudBtnC));
    
// rgb buffer
always @(posedge clk)
    if(w_p_tick)
        rgb_reg <= rgb_next;
        
// output
assign rgb = rgb_reg;

// ######################### uart ########################################### //

wire sent;

// change bit_in to RsRx to receive from microUSB
uart_rx receiver(
    .clk(baud),
    .bit_in(JB0),
    .received(received),
    .data_out(data_out)
);

// en is not controlled by uart_rx's received anymore because we are not doing echo
// change bit_out to RsTx to send data through microUSB
// data_transmit is set to data_to_send because we might assign its value depending on the situation
uart_tx transimitter(
    .clk(baud),
    .data_transmit(data_to_send),
    .ena(en),
    .sent(sent),
    .bit_out(JC0)
);

always @(posedge baud or posedge singleBaudBtnU or posedge long_flag) begin
    if (long_flag == 1) begin
        // check if which key can be sent
        // just to make it cooler
        if ((key_out >= 65 && key_out <= 90) ||
            (key_out >= 97 && key_out <= 122) ||
            (key_out >= 48 && key_out <= 57) ||
            (key_out >= 0 && key_out <= 47) || 
            (key_out >= 0 && key_out <= 127)) begin
            // if not releasing key, send it
            // otherwise, don't send it
            // if the above condition is too fast, things could go wrong.
            if (keycode[15:8] != 8'hf0 && keycode[7:0] != 8'hf0) begin
                data_to_send <= key_out;
                en <= 1;
            end
        end
    end else if (singleBaudBtnU == 1) begin
        en <= 1;
        data_to_send <= sw[7:0];
    end else if (baud && en == 1) begin
        en <= 0;
        data_to_send <= key_out;
    end
end

endmodule
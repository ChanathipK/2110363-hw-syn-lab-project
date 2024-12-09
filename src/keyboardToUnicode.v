`timescale 1ns / 1ps

module keyboardToUnicode(
    input [7:0] key_in,
    output reg [7:0] key_out,
    input clk,
    input flag,
    input shift,
    input capLock,
    input changeToThai
    );

always @(*) begin
    if ((shift ^ capLock) & ~changeToThai) begin
        case (key_in)
            8'h1C: key_out <= 8'd65; // A
            8'h32: key_out <= 8'd66; // B
            8'h21: key_out <= 8'd67; // C
            8'h23: key_out <= 8'd68; // D
            8'h24: key_out <= 8'd69; // E
            8'h2B: key_out <= 8'd70; // F
            8'h34: key_out <= 8'd71; // G
            8'h33: key_out <= 8'd72; // H
            8'h43: key_out <= 8'd73; // I
            8'h3B: key_out <= 8'd74; // J
            8'h42: key_out <= 8'd75; // K
            8'h4B: key_out <= 8'd76; // L
            8'h3A: key_out <= 8'd77; // M
            8'h31: key_out <= 8'd78; // N
            8'h44: key_out <= 8'd79; // O
            8'h4D: key_out <= 8'd80; // P
            8'h15: key_out <= 8'd81; // Q
            8'h2D: key_out <= 8'd82; // R
            8'h1B: key_out <= 8'd83; // S
            8'h2C: key_out <= 8'd84; // T
            8'h3C: key_out <= 8'd85; // U
            8'h2A: key_out <= 8'd86; // V
            8'h1D: key_out <= 8'd87; // W
            8'h22: key_out <= 8'd88; // X
            8'h35: key_out <= 8'd89; // Y
            8'h1A: key_out <= 8'd90; // Z
            8'h5A: key_out <= 8'd13; // CR Carriage Return
            8'h12: key_out <= 8'd254; // left shift
            8'h58: key_out <= 8'd254; // cap lock
            8'h59: key_out <= 8'd254; // right shift
            8'h0E: key_out <= 8'd254; // back tick for lang change
            8'h70: key_out <= 8'd48; // 0 (numpad)
            8'h69: key_out <= 8'd49; // 1 (numpad)
            8'h72: key_out <= 8'd50; // 2 (numpad)
            8'h7A: key_out <= 8'd51; // 3 (numpad)
            8'h6B: key_out <= 8'd52; // 4 (numpad)
            8'h73: key_out <= 8'd53; // 5 (numpad)
            8'h74: key_out <= 8'd54; // 6 (numpad)
            8'h6C: key_out <= 8'd55; // 7 (numpad)
            8'h75: key_out <= 8'd56; // 8 (numpad)
            8'h7D: key_out <= 8'd57; // 9 (numpad)
            8'h29: key_out <= 8'd47; // space
            8'h66: key_out <= 8'd45; // backspace
            8'h4C: key_out <= 8'd58; // colon (already have in rom)
            8'h5D: key_out <= 8'd124; // vertical bar (already have in rom)
            8'h41: key_out <= 8'd60; // <
            8'h49: key_out <= 8'd62; // >
            8'h16: key_out <= 8'd64; // !
            8'h46: key_out <= 8'd92; // (
            8'h45: key_out <= 8'd93; // )
            8'h55: key_out <= 8'd91; // +
            8'h4A: key_out <= 8'd63; // ?
            8'h4E: key_out <= 8'd125; // _
            8'h1E: key_out <= 8'd126; // @
            default: key_out <= 8'd254; // -
        endcase
    end else if (~changeToThai) begin
        case (key_in)
            8'h1C: key_out <= 8'd97; // a
            8'h32: key_out <= 8'd98; // b
            8'h21: key_out <= 8'd99; // c
            8'h23: key_out <= 8'd100; // d
            8'h24: key_out <= 8'd101; // e
            8'h2B: key_out <= 8'd102; // f
            8'h34: key_out <= 8'd103; // g
            8'h33: key_out <= 8'd104; // h
            8'h43: key_out <= 8'd105; // i
            8'h3B: key_out <= 8'd106; // j
            8'h42: key_out <= 8'd107; // k
            8'h4B: key_out <= 8'd108; // l
            8'h3A: key_out <= 8'd109; // m
            8'h31: key_out <= 8'd110; // n
            8'h44: key_out <= 8'd111; // o
            8'h4D: key_out <= 8'd112; // p
            8'h15: key_out <= 8'd113; // q
            8'h2D: key_out <= 8'd114; // r
            8'h1B: key_out <= 8'd115; // s
            8'h2C: key_out <= 8'd116; // t
            8'h3C: key_out <= 8'd117; // u
            8'h2A: key_out <= 8'd118; // v
            8'h1D: key_out <= 8'd119; // w
            8'h22: key_out <= 8'd120; // x
            8'h35: key_out <= 8'd121; // y
            8'h1A: key_out <= 8'd122; // z
            8'h45: key_out <= 8'd48; // 0
            8'h16: key_out <= 8'd49; // 1
            8'h1E: key_out <= 8'd50; // 2
            8'h26: key_out <= 8'd51; // 3
            8'h25: key_out <= 8'd52; // 4
            8'h2E: key_out <= 8'd53; // 5
            8'h36: key_out <= 8'd54; // 6
            8'h3D: key_out <= 8'd55; // 7
            8'h3E: key_out <= 8'd56; // 8
            8'h46: key_out <= 8'd57; // 9
            8'h5A: key_out <= 8'd13; // CR Carriage Return
            8'h12: key_out <= 8'd254; // left shift
            8'h58: key_out <= 8'd254; // cap lock
            8'h59: key_out <= 8'd254; // right shift
            8'h0E: key_out <= 8'd254; // back tick for lang change
            8'h70: key_out <= 8'd48; // 0 (numpad)
            8'h69: key_out <= 8'd49; // 1 (numpad)
            8'h72: key_out <= 8'd50; // 2 (numpad)
            8'h7A: key_out <= 8'd51; // 3 (numpad)
            8'h6B: key_out <= 8'd52; // 4 (numpad)
            8'h73: key_out <= 8'd53; // 5 (numpad)
            8'h74: key_out <= 8'd54; // 6 (numpad)
            8'h6C: key_out <= 8'd55; // 7 (numpad)
            8'h75: key_out <= 8'd56; // 8 (numpad)
            8'h7D: key_out <= 8'd57; // 9 (numpad)
            8'h29: key_out <= 8'd47; // space
            8'h66: key_out <= 8'd45; // backspace
            8'h4E: key_out <= 8'd46; // - (hyphen)
            8'h55: key_out <= 8'd61; // equal (=)
            8'h4C: key_out <= 8'd59; // ;
            8'h4A: key_out <= 8'd123; // /
            8'h5D: key_out <= 8'd96; // \
            8'h49: key_out <= 8'd95; // .
            8'h41: key_out <= 8'd94; // ,
            
            default: key_out <= 8'd254; // -
        endcase
    end else if ((shift ^ capLock) & changeToThai) begin
        // press shift and thai lang
        case (key_in)
            8'h1B: key_out <= 8'd3; // rakang
            8'h5D: key_out <= 8'd4; // khon
            8'h21: key_out <= 8'd7; // ching
            8'h4C: key_out <= 8'd9; // so
            8'h34: key_out <= 8'd10; // cher
            8'h4D: key_out <= 8'd11; // ying
            8'h24: key_out <= 8'd12; // door chada
            8'h23: key_out <= 8'd14; // tor patak
            8'h54: key_out <= 8'd15; // than
            8'h2D: key_out <= 8'd16; // monto
            8'h41: key_out <= 8'd17; // put thao
            8'h43: key_out <= 8'd18; // nen
            8'h2C: key_out <= 8'd23; // thor thong
            8'h4B: key_out <= 8'd37; // sala
            8'h42: key_out <= 8'd38; // rusee
            8'h49: key_out <= 8'd41; // chula
            8'h2A: key_out <= 8'd43; // hook
            8'h5A: key_out <= 8'd13; // CR Carriage Return
            8'h12: key_out <= 8'd254; // left shift
            8'h58: key_out <= 8'd254; // cap lock
            8'h59: key_out <= 8'd254; // right shift
            8'h0E: key_out <= 8'd254; // back tick for lang change
            8'h70: key_out <= 8'd48; // 0 (numpad)
            8'h69: key_out <= 8'd49; // 1 (numpad)
            8'h72: key_out <= 8'd50; // 2 (numpad)
            8'h7A: key_out <= 8'd51; // 3 (numpad)
            8'h6B: key_out <= 8'd52; // 4 (numpad)
            8'h73: key_out <= 8'd53; // 5 (numpad)
            8'h74: key_out <= 8'd54; // 6 (numpad)
            8'h6C: key_out <= 8'd55; // 7 (numpad)
            8'h75: key_out <= 8'd56; // 8 (numpad)
            8'h7D: key_out <= 8'd57; // 9 (numpad)
            8'h29: key_out <= 8'd47; // space
            8'h66: key_out <= 8'd45; // backspace
            default: key_out <= 8'd254; // -
        endcase
    end else begin
        case (key_in)
            8'h23: key_out <= 8'd0; // kor kai
            8'h4E: key_out <= 8'd1; // khor khai
            8'h3E: key_out <= 8'd2; // kwai
            8'h52: key_out <= 8'd5; // snake
            8'h45: key_out <= 8'd6; // chan
            8'h55: key_out <= 8'd8; // chang
            8'h23: key_out <= 8'd19; // dek
            8'h46: key_out <= 8'd20; // tao
            8'h2E: key_out <= 8'd21; // toong
            8'h3A: key_out <= 8'd22; // soldier
            8'h44: key_out <= 8'd24; // noo
            8'h54: key_out <= 8'd25; // bai mai
            8'h22: key_out <= 8'd26; // pla
            8'h1A: key_out <= 8'd27; // bee
            8'h4A: key_out <= 8'd28; // faa
            8'h2D: key_out <= 8'd29; // phan
            8'h1C: key_out <= 8'd30; // fan
            8'h25: key_out <= 8'd31; // phor phan
            8'h41: key_out <= 8'd32; // mhar
            8'h4D: key_out <= 8'd33; // yak
            8'h43: key_out <= 8'd34; // rua
            8'h5B: key_out <= 8'd35; // ling
            8'h4C: key_out <= 8'd36; // wan
            8'h4B: key_out <= 8'd39; // sua
            8'h1B: key_out <= 8'd40; // heep
            8'h2A: key_out <= 8'd42; // ang
            8'h5D: key_out <= 8'd44; // khuad
            8'h5A: key_out <= 8'd13; // CR Carriage Return
            8'h12: key_out <= 8'd254; // left shift
            8'h58: key_out <= 8'd254; // cap lock
            8'h59: key_out <= 8'd254; // right shift
            8'h0E: key_out <= 8'd254; // back tick for lang change
            8'h70: key_out <= 8'd48; // 0 (numpad)
            8'h69: key_out <= 8'd49; // 1 (numpad)
            8'h72: key_out <= 8'd50; // 2 (numpad)
            8'h7A: key_out <= 8'd51; // 3 (numpad)
            8'h6B: key_out <= 8'd52; // 4 (numpad)
            8'h73: key_out <= 8'd53; // 5 (numpad)
            8'h74: key_out <= 8'd54; // 6 (numpad)
            8'h6C: key_out <= 8'd55; // 7 (numpad)
            8'h75: key_out <= 8'd56; // 8 (numpad)
            8'h7D: key_out <= 8'd57; // 9 (numpad)
            8'h29: key_out <= 8'd47; // space
            8'h66: key_out <= 8'd45; // backspace
            default: key_out <= 8'd254; // -
        endcase
    end
end
    
endmodule

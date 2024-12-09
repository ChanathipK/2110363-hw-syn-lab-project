# Hardware Synthesis Lab I Project

## Group: Hardware Shanetesis

### Member

1. 6330080621 Chanathip Kulsirilak

2. 6530007021 Korawit Bhatanaprabhabhan

## Project Workflow

### Basic Design

(Thai) ระบบของพวกเราจะประกอบไปด้วย FPGA board 2 ชิ้น โดยเราใช้ Basys 3 ณ ที่นี้ ระบบของเราเป็น Teletype ที่รองรับการส่งข้อมูลทั้งภาษาอังกฤษ (พิมพ์เล็กและพิมพ์ใหญ่) และพยัญชนะภาษาไทยทั้ง 44 ตัว ซึ่งหลังจากแต่ละบอร์ดรับข้อมูลแล้ว ข้อมูลดังกล่าวก็จะขึ้นมาแสดงบนหน้าจอมอนิเตอร์ โดยข้อมูลสามารถส่งได้ทั้งจาก Switch และ Keyboard

### Communication

การสื่อสารระหว่างบอร์ดใช้รูปแบบการสื่อสาร (protocol) แบบ UART โดยเราจะใช้ Pmod port `JB[0]` เป็น UART's RX (เพื่อรับข้อมูล) และ `JC[0]` UART's TX (เพื่อส่งข้อมูล)

การทำงานของระบบหลาย ๆ ส่วนจะมีความเกี่ยวข้อง หรือมีความถี่ของส่วนต่าง ๆ ปรับให้ใกล้เคียงกับความถี่ของ Baud ที่ถูกใช้ใน UART

### Keyboard

เราได้ใช้โค้ดบางส่วนจาก Keyboard Demo ที่จัดทำขึ้นโดยทีมงานของ Digilent ผู้จัดจำหน่ายบอร์ดของเรา โดยเราได้ทำการรับข้อมูล Scan Code เข้ามาในตัวแปรที่ชื่อ `keycode` และแปลงข้อมูลดังกล่าวก็จะถูกแปลงให้เป็น `key_out` ที่จะถูกนำไปใส่ `data_to_send` เพื่อที่จะนำไปส่งผ่าน `Transmitter` ต่อไป

ระบบการรับข้อมูลของ Keyboard จะมีรายละเอียดเกี่ยวกับ `flag` และ `long_flag` ที่ค่อนข้างซับซ้อน กรุณาติดต่อเจ้าของ Repository เพื่อสอบถามรายละเอียด หรืออ่านคอมเม้นต์เพื่อทำความเข้าใจ

### 7-Segment Displays

เราแค่ใช้ 7-Segment Displays เพื่อการแสดงผลข้อมูลบางส่วนเท่านั้น

### Mapping Keyboard Codes to ASCII and Other Codes

เรานำ `keycode` ไปใส่เป็น input สำหรับโมดูลที่ชื่อว่า `keyboardToUnicode` เพื่อแปลงค่า Scan Code เป็นข้อมูลขนาด 8 bits ที่ใช้ได้จริง

### Switch and Synchronization

เราใช้ Switch ร่วมกับ Single Pulser ที่ทำให้ Switch มีความกว้าง (ระยะเวลา) การกดไม่เกิน 1 Baud เพื่อที่เราจะสามารถนำไปใช้กับระบบส่วนอื่นได้อย่างง่ายดาย

### Data Sending

เราจะใช้ Clock ที่มีขนาดเล็กในการเปลี่ยนค่า `en` ให้เป็น 1 เพื่อที่ค่า `en` นั้นจะได้ไปสั่งให้ Transmitter ส่งข้อมูลไป โดยหากดูจากโค้ดด้านล่างจะพบว่า หลักการทำงานดังกล่าวจะไม่ขัดแย้งกันเอง (`en` สามารถเป็น 1 เมื่อเข้า Transmitter และเข้า block ที่เปลี่ยน `en` ให้เป็น 0 ได้พร้อมกัน)

```v
always @(posedge baud or posedge singleBaudBtnU or posedge long_flag) begin
    if (long_flag == 1) begin
        // check if which key can be sent
        // just to make it cooler
        if ((key_out >= 65 && key_out <= 90) ||
            (key_out >= 97 && key_out <= 122) ||
            (key_out >= 48 && key_out <= 57) ||
            (key_out == 13)) begin
            // if not releasing key, send it
            // otherwise, don't send it
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
```
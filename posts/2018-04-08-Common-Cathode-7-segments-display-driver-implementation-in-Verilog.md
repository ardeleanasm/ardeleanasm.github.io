---
layout: post
title: "Common-Cathode 7-segments display driver implementation in Verilog"
description: "Common-Cathode 7-segments display driver implementation in Verilog"
category: hdl
tags: verilog,7-segments driver
---


### Description

7-segment LED type displays provide a convenient way to display data, like numbers, letters, and typically consist of seven individual LEDs within one single display package. In order to produce the required data ( HEX characters from 0 to 9 and A to F), on the display the correct combination of LED segments need to be illuminated. However, to display BCD information on 7-segments we need to use a BCD to 7 segments decoder like 74LS47 or HC4511.

A 7-segment LED display usually have 8 connections for each LED segment and one that acts as a GND or VCC. There are some displays that have an additional input pin used to display a decimal point. Anyway, in electronics there are 2 types of 7-segment displays:

1. **Common Cathode Display** - all the cathode connections of the LED segments are joined together to **Gnd**. This means that a segment is illuminated by applying a logic '1' signal to the *Anode* terminal. (Img 1a)
2. **Common Anode Display** - all the anode connections of the LED segments are joined together to **Vcc** which means that to illuminate a segment a logic '0' needs to be applied to the *Cathode* terminal. (Img 1b)


{% include img.html img="resources/common_cathode_anode_leds.png"
            title="Img 1:LED display types"
            caption="Img 1:LED display types" %}



{% include img.html img="resources/led_scheme.png"
            title="Img 2:7-segment display format"
            caption="Img 2: 7-segment display format" %}


Considering Img 2 we can create the truth table below. Because we use a common cathode 7 segment display we will have 1 for each illuminated segment and 0 for not illuminated. Since we will design a BCD to 7-segments the values from 10 to 15 are invalid. For there values we will mark the corresponding segment with X, meaning don't care. 


| $$X_{3}$$ | $$X_{2}$$ | $$X_{1}$$ | $$X_{0}$$ | a | b | c | d | e | f | g | Display |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|  0  |  0  |  0  |  0  |  1  |  1  |  1  | 1   |  1  |  1  |  0  |  0  |
|  0  |  0  |  0  |  1  |  0  |  1  |  1  | 0   |  0  |  0  |  0  |  1  |
|  0  |  0  |  1  |  0  |  1  |  1  |  0  | 1   |  1  |  0  |  1  |  2  |
|  0  |  0  |  1  |  1  |  1  |  1  |  1  | 1   |  0  |  0  |  1  |  3  |
|  0  |  1  |  0  |  0  |  0  |  1  |  1  | 0   |  0  |  1  |  1  |  4  |
|  0  |  1  |  0  |  1  |  1  |  0  |  1  | 1   |  0  |  1  |  1  |  5  |
|  0  |  1  |  1  |  0  |  1  |  0  |  1  | 1   |  1  |  1  |  1  |  6  |
|  0  |  1  |  1  |  1  |  1  |  1  |  1  | 0   |  0  |  0  |  0  |  7  |
|  1  |  0  |  0  |  0  |  1  |  1  |  1  | 1   |  1  |  1  |  1  |  8  |
|  1  |  0  |  0  |  1  |  1  |  1  |  1  | 1   |  0  |  1  |  1  |  9  |
|  1  |  0  |  1  |  0  |  x  |  x  |  x  | 0   |  x  |  x  |  x  |  -  |
|  1  |  0  |  1  |  1  |  0  |  0  |  x  | x   |  x  |  x  |  x  |  -  |
|  1  |  1  |  0  |  0  |  x  |  0  |  0  | x   |  x  |  x  |  0  |  -  |
|  1  |  1  |  0  |  1  |  0  |  x  |  x  | x   |  x  |  0  |  x  |  -  |
|  1  |  1  |  1  |  0  |  x  |  0  |  0  | x   |  x  |  x  |  x  |  -  |
|  1  |  1  |  1  |  1  |  x  |  0  |  0  | 0   |  x  |  x  |  x  |  -  |


Based on the above table we can express output as minterm expansions:

$$a = F_{1} (A, B, C, D) = \sum m(0, 2, 3, 5, 7, 8, 9)$$

$$b = F_{2} (A, B, C, D) = \sum m(0, 1, 2, 3, 4, 7, 8, 9)$$

$$c = F_{3} (A, B, C, D) = \sum m(0, 1, 3, 4, 5, 6, 7, 8, 9)$$

$$d = F_{4} (A, B, C, D) = \sum m(0, 2, 3, 5, 6, 8)$$

$$e = F_{5} (A, B, C, D) = \sum m(0, 2, 6, 8)$$

$$f = F_{6} (A, B, C, D) = \sum m(0, 4, 5, 6, 8, 9)$$

$$g = F_{7} (A, B, C, D) = \sum m(2, 3, 4, 5, 6, 8, 9)$$


Now we can construct the Karnaugh's Map for each output term and then simplify it to obtain a logic combination of inputs for each output.

$$a=A\overline{B}\overline{C}+\overline{A}(C+\overline{B}\overline{D}+BD)$$

$$b=\overline{AC}\overline{B}+\overline{A}(CD+\overline{C}\overline{D})$$

$$c=\overline{B}\overline{C}+\overline{A}(B+D)$$

$$d=\overline{A}\overline{B}(C+\overline{D})+\overline{A}(C\overline{D}+BD\overline{C})+A\overline{B}\overline{C}$$

$$e=\overline{D}(\overline{B}\overline{C}+\overline{A}C)$$

$$f=\overline{A}(B\overline{CD}+\overline{C}\overline{D})+A\overline{B}\overline{C}$$

$$g=\overline{A}(C\overline{BD}+B\overline{C})+A\overline{B}\overline{C}$$

### Implementation

{% include img.html img="resources/hc4511_block_scheme.png"
            title="Img 3:TI HC4511 block scheme"
            caption="Img 3: TI HC4511 block scheme" %}

In Img 3 is the block scheme of the TI HC4511 BCD-to-7 segment latch/decoder/driver.

#### Decoder Implementation

The **decoder** will have 2 input ports ( *BL* signal, *D[0:3]*) and one output port, *D[0:7]*and will contain the implementation of the above equations. Moreover, the output of decoder will be blank ( 0 ) if **BL** signal is 0.

```verilog
module dec_7seg(
    datain,bl,dataout
    );

    input   [3:0]   datain; 
    input           bl;
    output  [7:0]   dataout;
    
    assign dataout[7]=(bl==1'b0)?8'b00000000:(datain[3]&(~datain[2])&(~datain[1]))|
                ((~datain[3])&(datain[1]|(((~datain[2])&(~datain[0]))|(datain[2]&datain[0]))));

    assign dataout[6]=(bl==1'b0)?8'b00000000:((~(datain[3]&datain[1]))&(~datain[2]))|
                        ((~datain[3])&((datain[1]&datain[0])|((~datain[1])&(~datain[0]))));

    assign dataout[5]=(bl==1'b0)?8'b00000000:((~datain[2])&(~datain[1]))|
                        ((~datain[3])&(datain[2]|datain[0]));

	assign dataout[4]=(bl==1'b0)?8'b00000000:
                ((~datain[3])&(~datain[2])&(datain[1]|(~datain[0])))|
                ((~datain[3])&((datain[1]&(~datain[0]))|(datain[2]&datain[0]&(~datain[1]))))|
                (datain[3]&(~datain[2])&(~datain[1]));

    assign dataout[3]=(bl==1'b0)?8'b00000000:
                (~datain[0])&(((~datain[2])&(~datain[1]))|((~datain[3])&datain[1]));

    assign dataout[2]=(bl==1'b0)?8'b00000000:
        ((~datain[3])&((datain[2]&(~(datain[1]&datain[0])))|((~datain[1])&(~datain[0]))))|
        (datain[3]&(~datain[2])&(~datain[1]));

    assign dataout[1]=(bl==1'b0)?8'b00000000:
            ((~datain[3])&((datain[1]&(~(datain[2]&datain[0])))|(datain[2]&(~datain[1]))))|
            (datain[3]&(~datain[2])&(~datain[1]));

    assign dataout[0]=1'b0;//dot
endmodule // decoder

```

#### Latch Implementation

We can easily implement a D-type latch using an **always** block. We will need 5 ports,
3 for input signals ( data in, enable, $\overline{enable}$ ) and 2 for output signals ( q and $\overline{q}$).


```verilog
module dlatch(
    d,q,nq,ena,nena
    );
    
    input       d;
    input       ena;
    input       nena;
    output  reg q;
    output  reg nq;

    always @(d,ena,nena) begin: d_latch_procedure
        if(ena) begin
            q<=d;
            nq<=~d;
        end // if( le='1')
        else begin
        end

    end // d_latch_procedure

endmodule // dlatch

```

#### Driver Implementation

The driver will have to set output to 1 if *LT* (Lamp Test) signal is low, otherwise the output will be transparent to input. In other words, in can be implemented as a latch.

```verilog
module drv_7seg(
    lt,inbus,outbus
    );

    input               lt;
    input       [7:0]   inbus;
    output  reg [7:0]   outbus;

    always @(lt,inbus) begin : drv_7seg
        if(lt) begin
            outbus<=inbus;
        end else begin
            outbus<=8'b11111111; 
        end
    end

endmodule // drv_7seg

```


#### Modules Instantiation and testbench

Now that we have all the modules defined we can create a new module **driver_7_segments** and instantiate them.

```verilog
module driver_7_segments(
    inbus,le,lt,bl,outbus,
    );
    
    input       [3:0]   inbus;      //input data
    input               le;             //latch-enable
    input               lt;             //lamp-test->displays 8
    input               bl;             //blanking-> blank
    output reg  [7:0]   outbus;


    wire [3:0]  latch_output;
    wire [7:0]  decoder_output;

    dlatch latch0(.d  (inbus[0]),.ena (~le),.nena(le),.q  (latch_output[0]),.nq ());
    
    dlatch latch1(.d  (inbus[1]),.ena (~le),.nena(le),.q  (latch_output[1]),.nq ());
    
    dlatch latch2(.d  (inbus[2]),.ena (~le),.nena(le),.q  (latch_output[2]),.nq ());

    dlatch latch3(.d  (inbus[3]),.ena (~le),.nena(le),.q  (latch_output[3]),.nq ());
    
    dec_7seg decoder_7_segments(.datain (latch_output),.bl     (bl),.dataout(decoder_output));
    
    drv_7seg driver_7_segments(.inbus (decoder_output),.lt    (lt),.outbus(outbus));
   
endmodule // segments_driver

```


```verilog

`include "testbench/test_inc.v"
module driver_7_segments_tb;

	reg       [3:0]   inbus;      //input data
    reg               le;             //latch-enable
    reg               lt;             //lamp-test->displays 8
    reg               bl;             //blanking-> blank
    wire reg  [7:0]   outbus;

    driver_7_segments driver(.inbus (inbus),.le (le),.lt (lt),.bl (bl),.outbus(outbus));

    initial begin
        $dumpfile("segments_driver_tb.vcd");
        $dumpvars;

        //Lamp Test
        le<=1'b0;//latch is transparent
        bl<=1'b1;//blanking is disabled
        inbus<=4'b0000;//0 on inbus
        lt<=1'b0;//lamp test enabled
        #25 `assert(outbus,8'b11111111);

        #50 
        //Blanking Test
        le<=1'b0;//latch is transparent
        bl<=1'b0;//blanking is enabled
		inbus<=4'b0000;//0 on inbus
        lt<=1'b1;//lamp test disabled
        #25 `assert(outbus,8'b00000000);        

        #50
        //test all values
        le<=1'b0;//latch is transparent
        bl<=1'b1;//blanking is disabled
        lt<=1'b1; //lamp test is disabled
        
        #25 inbus<=4'b0000;
        #25 `assert(outbus,8'b11111100);
		
		#25 inbus<=4'b0001;
        #25 `assert(outbus,8'b01100000);

		#25 inbus<=4'b0010;
        #25 `assert(outbus,8'b11011010);

        #25 inbus<=4'b0011;
        #25 `assert(outbus,8'b11110010);

        #25 inbus<=4'b0100;
        #25 `assert(outbus,8'b01100110);

        #25 inbus<=4'b0101;
        #25 `assert(outbus,8'b10110110);

        #25 inbus<=4'b0110;
        #25 `assert(outbus,8'b10111110);

        #25 inbus<=4'b0111;
        #25 `assert(outbus,8'b11100000);

        #25 inbus<=4'b1000;
        #25 `assert(outbus,8'b11111110);

        #25 inbus<=4'b1001;
        #25 `assert(outbus,8'b11110110);
    end // initial

    initial begin :dump_proc
            $display("\t\tTime\tINBUS\t/LE\t/LT\t/BL\tOUTBUS");
            $monitor("%d\t%b\t%b\t%b\t%b\t%b",$time,inbus,le,lt,bl,outbus);
    end // dump_proc
endmodule // segments_driver_tb
```

---
### Bibliography

1. [TI HC4511 Datasheet](http://www.ti.com/lit/ds/symlink/cd74hc4511.pdf)
2. [Electronics Hub](https://www.electronicshub.org/bcd-7-segment-led-display-decoder-circuit/)
3. [Electronics Tutorials](https://www.electronics-tutorials.ws/combination/comb_6.html)
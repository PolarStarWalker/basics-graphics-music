`include "config.svh"

module lab_top
# (
    parameter  clk_mhz       = 50,
               w_key         = 4,
               w_sw          = 8,
               w_led         = 8,
               w_digit       = 8,
               w_gpio        = 100,

               screen_width  = 640,
               screen_height = 480,

               w_red         = 4,
               w_green       = 4,
               w_blue        = 4,

               w_x           = $clog2 ( screen_width  ),
               w_y           = $clog2 ( screen_height )
)
(
    input                        clk,
    input                        slow_clk,
    input                        rst,

    // Keys, switches, LEDs

    input        [w_key   - 1:0] key,
    input        [w_sw    - 1:0] sw,
    output logic [w_led   - 1:0] led,

    // A dynamic seven-segment display

    output logic [          7:0] abcdefgh,
    output logic [w_digit - 1:0] digit,

    // Graphics

    input        [w_x     - 1:0] x,
    input        [w_y     - 1:0] y,

    output logic [w_red   - 1:0] red,
    output logic [w_green - 1:0] green,
    output logic [w_blue  - 1:0] blue,

    // Microphone, sound output and UART

    input        [         23:0] mic,
    output       [         15:0] sound,

    input                        uart_rx,
    output                       uart_tx,

    // General-purpose Input/Output

    inout        [w_gpio  - 1:0] gpio
);

    //------------------------------------------------------------------------

    // assign led        = '0;
       assign abcdefgh   = '0;
       assign digit      = '0;
       assign red        = '0;
       assign green      = '0;
       assign blue       = '0;
       assign sound      = '0;
       assign uart_tx    = '1;

    //------------------------------------------------------------------------

    // Exercise 1: Free running counter.
    // How do you change the speed of LED blinking?
    // Try different bit slices to display.

    /*
    localparam w_cnt = $clog2 (clk_mhz * 1000 * 1000);

    logic [w_cnt - 1:0] cnt;

    always_ff @ (posedge clk or posedge rst) begin
        if (rst)
            cnt <= '0;
        else
             cnt <= cnt + 1'd1;
     end

    assign led = cnt [$left (cnt) - 3 -: w_led];
    */
    // Exercise 2: Key-controlled counter.
    // Comment out the code above.
    // Uncomment and synthesize the code below.
    // Press the key to see the counter incrementing.
    //
    // Change the design, for example:
    //
    // 1. One key is used to increment, another to decrement.
    //
    // 2. Two counters controlled by different keys
    // displayed in different groups of LEDs.

    /*
    wire one_key = key[0];
    wire two_key = key[1];

    logic one_key_r;
    logic two_key_r;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            one_key_r <= '0;
        else
            one_key_r <= one_key;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            two_key_r <= '0;
        else
            two_key_r <= two_key;

    wire one_key_pressed = ~one_key & one_key_r;
    wire two_key_pressed = ~two_key & two_key_r;

    logic [w_led - 1:0] cnt;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            cnt <= '0;
        else if (one_key_pressed)
            cnt <= cnt + 1'd1;
        else if (two_key_pressed)
            cnt <= cnt - 1'd1;

    assign led = w_led' (cnt);
    */

    wire one_key = key[0];
    wire two_key = key[1];

    logic one_key_r;
    logic two_key_r;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            one_key_r <= '0;
        else
            one_key_r <= one_key;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            two_key_r <= '0;
        else
            two_key_r <= two_key;

    wire one_key_pressed = ~one_key & one_key_r;
    wire two_key_pressed = ~two_key & two_key_r;

    logic [w_led / 2 - 1:0] cnt1;
    logic [w_led / 2 - 1:0] cnt2;


    always_ff @ (posedge clk or posedge rst)
        if (rst)
            cnt1 <= '0;
        else if (one_key_pressed)
            cnt1 <= cnt1 + 1'd1;

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            cnt2 <= '0;
        else if (two_key_pressed)
            cnt2 <= cnt2 + 1'd1;

    assign led = w_led' ({cnt2, cnt1});


endmodule

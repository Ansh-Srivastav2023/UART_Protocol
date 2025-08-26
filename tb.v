`include "Top_Module.v"

// Set Parameter CLKS_PER_BIT as follows:
// clk_div = (Frequency of i_Clock)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (10000000)/(115200) = 87
module tb;

    reg clk, clk_rx, rst, Tx_Drive;
    reg [3:0] tick_div_tx;
    reg [3:0] tick_div_rx;
    reg [7:0] data_in;

    Top_Module Top_Module(.clk(clk), .rst(rst), .tick_div_tx(tick_div_tx), .tick_div_rx(tick_div_rx), .Tx_Drive(Tx_Drive), .data_in(data_in));

    always #5 clk = ~clk;
    always #5 clk_rx = ~clk_rx;

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        tick_div_tx = 4'd12;

        #5
        data_in  = 8'b11001011;
        Tx_Drive = 1'b0;

        
        #2 rst = ~rst;
        #2 rst = ~rst;
        #10 Tx_Drive = 1'b1;

        #20000;

        #(tick_div_tx * 10) Tx_Drive = 1'b1;

        #(150000 * tick_div_tx) 
        
        data_in = 8'b01101111;
        #(150000 * tick_div_tx) 


        for (integer i = 0; i <= 7; i = i+1) begin
            $display("%b", Top_Module.uart_rx.mem[i]);
        end
        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);
    end

endmodule


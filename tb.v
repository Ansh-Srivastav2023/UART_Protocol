`include "Top_Module.v"

// Set Parameter CLKS_PER_BIT as follows:
// clk_div = (Frequency of i_Clock)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (10000000)/(115200) = 87
module tb;

    reg clk_tx, clk_rx, rst, Tx_Drive;
    reg [3:0] clk_div_tx;
    reg [3:0] clk_div_rx;

    Top_Module Top_Module(.clk_tx(clk_tx), .clk_rx(clk_rx), .rst(rst), .clk_div_tx(clk_div_tx), .clk_div_rx(clk_div_rx), .Tx_Drive(Tx_Drive));

    always #5 clk_tx = ~clk_tx;
    always #5 clk_rx = ~clk_rx;

    initial begin
        clk_tx = 1'b0;
        clk_rx = 1'b0;
        rst = 1'b1;
        Tx_Drive = 1'b0;
        clk_div_tx = 4'd2;
        clk_div_rx = 4'd2;

        #2 rst = ~rst;
        #2 rst = ~rst;

        #(clk_div_tx * 10) Tx_Drive = 1'b1;

        #(200 * clk_div_tx) 
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


// module tb;
//     reg clk, Tx_Drive;
//     reg rst;
//     reg [3:0] dvsr;
    
//     wire Tx_Serial, Tx_Active;

//     uart_tx uut (clk, Tx_Drive, dvsr, rst, Tx_Serial, Tx_Active);

//     initial begin
//         clk     = 1;        
//         Tx_Drive = 0;
//         rst     = 1;
//         dvsr    = 10;
//         #2 rst  = ~rst;
//         #2 rst  = ~rst;

//         #100 Tx_Drive = 1'b1;

//         #(dvsr * 100) 
//         // for (integer i = 0; i<= 7; i = i+1) begin
//         //     $display("%b", uut.mem[i]);
//         // end
//         $finish;
//     end

//     always #5 clk = !clk;

//     initial begin
//         $monitor(Tx_Serial);
//     end

    // initial begin
    //     $dumpfile("dump.vcd");
    //     $dumpvars(0, tb);
    // end
    
// endmodule // uart_tx_tb
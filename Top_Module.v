`include "uart_tx.v"
`include "uart_rx.v"

module Top_Module (clk_tx, clk_rx, rst, clk_div_tx, clk_div_rx, Tx_Drive);

    input clk_tx, clk_rx, rst, Tx_Drive;
    input [3:0] clk_div_tx, clk_div_rx;

    wire Rx_Data, Tx_Serial, Tx_Active;
 
    uart_tx uart_tx (.clk(clk_tx), .Tx_Drive(Tx_Drive), .clk_div(clk_div_tx), .rst(rst), .Tx_Serial(Tx_Serial), .Tx_Active(Tx_Active));

    uart_rx uart_rx(.clk(clk_rx), .rst(rst), .Rx_Serial(Tx_Serial), .clk_div(clk_div_rx), .Rx_Data(Rx_Data));

endmodule
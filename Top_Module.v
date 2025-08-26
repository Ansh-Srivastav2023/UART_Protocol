`include "uart_tx.v"
`include "uart_rx.v"
`include "baud_rate_gen.v"

module Top_Module (clk, rst, tick_div_tx, tick_div_rx, Tx_Drive, data_in);

    input clk, rst, Tx_Drive;
    input [7:0] data_in;
    input [3:0] tick_div_tx, tick_div_rx;

    wire tick;
    wire [15:0] dvsr = 15'd650;
    wire Rx_Data, Tx_Serial, Tx_Active;
    wire [7:0] data_out;
 
    uart_tx uart_tx (.tick(tick), .Tx_Drive(Tx_Drive), .tick_div(tick_div_tx), .rst(rst), .Tx_Serial(Tx_Serial), .Tx_Active(Tx_Active), .data_in(data_in));

    uart_rx uart_rx (.clk(clk), .tick(tick), .rst(rst), .Rx_Serial(Tx_Serial), .clk_div(tick_div_tx), .Rx_Data(Rx_Data), .data_out(data_out));

    baud_gen baud_gen (.clk(clk), .reset(rst), .dvsr(dvsr), .tick(tick));

endmodule
`timescale 100ns/1ps

//FPGA time period = 10ns, baud rate of BT = 9600, no. of tickes per symbol = 16, dvsr = 650

module baud_gen(
    input wire clk, reset,
    input wire [15:0] dvsr,
    output reg tick
);

    reg [15:0] count;

    always @(posedge clk or negedge reset) begin
        if(~reset) begin 
            count   <= 0;
            tick    <= 1;
        end
        else 
            if (count == dvsr) 
            begin
                tick    <= ~tick;
                count   <= 0;                
            end
            else count = count + 1;
    end        

endmodule

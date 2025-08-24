module uart_rx (
    input clk, rst, Rx_Serial,
    input [3:0] clk_div,
    output reg Rx_Data    
);

    parameter s_Idle = 2'b00, s_Start = 2'b01, s_Read = 2'b10, s_Stop = 2'b11;
    reg [2:0] state = 'b0;
    reg [2:0] bit_indx;
    reg [3:0] count;

    reg mem [0:7];

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            state <= s_Idle;
            bit_indx <= 'b0;
            count <= 'b0;
            Rx_Data <= 1'b1;
        end

        else begin
            case (state)
                s_Idle:
                begin
                    bit_indx  <= 'b0;
                    count <= 'b0;
                    if(Rx_Serial == 1'b0) begin                    
                        state <= s_Start;
                    end 
                    else begin
                        state <= s_Idle;
                    end              
                end

                s_Start:
                begin
                    count <= count + 1'b1;
                    if(count == (clk_div/2 - 1'b1)) begin
                        if (Rx_Serial == 1'b0)
                            state <= s_Read;
                        else
                            state <= s_Idle;
                    end
                    else 
                        state <= s_Start;
                end

                s_Read: begin
                    count <= count + 1'b1;
                    mem [bit_indx] <= Rx_Serial;
                    if (count == clk_div - 1'b1) begin
                        count <= 'b0;
                        if (bit_indx < 3'b111) begin
                            Rx_Data <= Rx_Serial;
                            bit_indx <= bit_indx + 1'b1;
                            state <= s_Read;
                        end
                        else begin
                            state <= s_Stop;
                        end
                    end
                    else
                        state <= s_Read;

                end

                s_Stop: state <= s_Idle;
            endcase
        end      
    end
endmodule //uart_rx

// module tb;

//     reg clk, rx_Serial;
//     wire [7:0] Rx_Data;

//     reg [7:0] data;
//     reg[3:0] count;

//     reg rst;
//     reg [10:0] dvsr;
//     wire tick;
    
//     baud_gen bdclk(clk, rst, dvsr, tick);
//     uart_rx uut(tick, rx_Serial, Rx_Data);

//     initial begin
//         clk         = 1'b1;
//         data        = 8'b11010111;
//         count       = 'b0;
//         dvsr        = 10;
//         rx_Serial   = 1'b1;
//         rst         = 1'b1;
//         #2 rst      = ~rst;

//         #(100*dvsr)  @(negedge tick) rx_Serial = 1'b0;

//         while(count <= 8) @(negedge tick)begin
//             rx_Serial   = data[count];
//             count       = count + 1;
//         end

//         rx_Serial <= 1'b1;
//         #(100*dvsr); 
//         $display("Rx_data = %b", Rx_Data);
         
//         $finish;
//     end

//     always #5 clk = ~clk;

//     initial begin
//         $dumpfile("reciever.vcd");
//         $dumpvars(0, tb);
//     end
// endmodule //uart_rx_tb
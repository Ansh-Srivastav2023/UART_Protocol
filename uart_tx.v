module uart_tx (
    input clk, Tx_Drive,
    input [3:0] clk_div,
    input rst,
    output reg Tx_Serial, Tx_Active    
);

    reg [3:0] count;
    reg [2:0] bit_indx;

    reg mem [0:7];
    initial $readmemb("data_memory.bin", mem);

    parameter s_IDLE = 3'b000, s_START = 3'b001, s_DATA = 3'b010, s_STOP = 3'b011;
    reg [2:0] state = 3'b000;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            state <= s_IDLE;
            count <= 'b0;
            Tx_Serial <= 1'b1;
            Tx_Active <= 1'b0;
            bit_indx <= 'b0;
        end
        else begin 
            case (state)
            s_IDLE: begin
                count <= 'b0;
                Tx_Serial <= 1'b1;
                Tx_Active <= 1'b0;
                
                if(!Tx_Drive | (Tx_Drive & bit_indx == 'b1)) 
                    state <= s_IDLE;
                else 
                    state <= s_START;
                
            end

            s_START: begin
                count <= count + 1'b1;
                Tx_Serial <= 1'b0;
                if (count == clk_div - 1'b1) begin
                    state <= s_DATA;
                    count <= 'b0;
                    bit_indx <= 3'b000;
                    Tx_Active <= 1'b1;
                end
                else 
                    state <= s_START;
            end

            s_DATA: begin
                count <= count + 1'b1;
                Tx_Serial <= mem[bit_indx];
                
                if (count == clk_div - 1'b1) begin
                    count <= 'b0;
                    if (bit_indx < 3'b111) begin
                        bit_indx <= bit_indx + 1'b1;
                        state <= s_DATA;
                    end else begin
                        state <= s_STOP;
                    end
                end
            end


            s_STOP: begin
                if (count == clk_div - 'b1) begin
                    Tx_Serial <= 1'b1;
                    Tx_Active <= 1'b0;
                    state <= s_IDLE;
                end
            end

            default: begin
                state <= s_IDLE;
            end
            endcase
        end
    end
endmodule //uart_tx

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

//     initial begin
//         $dumpfile("dump.vcd");
//         $dumpvars(0, tb);
//     end
    
// endmodule // uart_tx_tb
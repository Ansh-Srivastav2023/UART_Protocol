module uart_rx (
    input clk, tick, rst, Rx_Serial,
    input [3:0] clk_div,
    output reg Rx_Data,
    output reg Rx_Done,
    output reg [7:0] data_out
);

    parameter s_Idle = 2'b00, s_Start = 2'b01, s_Read = 2'b10, s_Stop = 2'b11;
    reg [2:0] state = 'b0;
    reg [2:0] bit_indx;
    reg [3:0] count;

    reg mem [0:7];

    always @(posedge clk) begin
        data_out <= {mem[7], mem[6], mem[5], mem[4], mem[3], mem[2], mem[1], mem[0]};        
    end

    always @(posedge tick or negedge rst) begin
        if (~rst) begin
            mem[0] = 1'b0;
            mem[1] = 1'b0;
            mem[2] = 1'b0;
            mem[3] = 1'b0;
            mem[4] = 1'b0;
            mem[5] = 1'b0;
            mem[6] = 1'b0;
            mem[7] = 1'b0;
            state <= s_Idle;
            bit_indx <= 'b0;
            count <= 'b0;
            Rx_Data <= 1'b1;
            Rx_Done <= 1'b0;
        end

        else begin
            case (state)
                s_Idle:
                begin
                    bit_indx  <= 'b0;
                    count <= 'b0;
                    Rx_Done <= 1'b0;
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
                        if (Rx_Serial == 1'b0) begin
                            state <= s_Read;
                            count <= 'b0;
                        end
                        else
                            state <= s_Idle;
                    end
                    else 
                        state <= s_Start;
                end

                s_Read: begin
                if (count == clk_div - 1'b1) begin
                    count <= 'b0;

                    mem[bit_indx] <= Rx_Serial;

                    if (bit_indx == 3'd7) begin
                    state <= s_Stop;         // all 8 data bits captured
                    end else begin
                    bit_indx <= bit_indx + 1'b1;
                    state    <= s_Read;
                    end

                end else begin
                    count <= count + 1'b1;     // keep counting toward the next baud edge
                    state <= s_Read;
                end
                end


                s_Stop: begin 
                    state <= s_Idle;
                    Rx_Done <= 1'b1;
                end
                default : state <= s_Idle;
                    
            endcase
        end      
    end
endmodule //uart_rx

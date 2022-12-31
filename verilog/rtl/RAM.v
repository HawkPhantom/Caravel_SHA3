`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2022 12:40:02 AM
// Design Name: 
// Module Name: RAM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RAM#(
    parameter BITS = 32
)(
    input clk,
    input rst,
    input read_e,
    input write_e,
    input [31:0] data_in,
    input [31:0] addr_in,
    output reg ready,
    output reg [575:0] ram_data_o
    );
    
    reg [575:0] enc_data;
    reg [5:0] counter = 0;  
    
    always @(posedge clk)
        begin
            if(rst)
                begin
                    ram_data_o <= 32'b0;
                    enc_data <= 32'b0;
                    counter <= 6'b0;
                    ready <= 0;
                    
                end
            else
                begin 
                    if (read_e & !write_e & ready)
                        begin
                            if (addr_in == 32'h55)
                                begin
                                    ram_data_o <= enc_data;
                                end
                        end
                end
        end

    always @(posedge clk)
        begin
            if (!read_e & write_e & !ready & !rst)
                begin 
                    if (addr_in == 32'h55)
                        begin
                            if (counter<18)
                                begin
                                   if (counter == 0)
                                       enc_data[31:0] <= data_in[31:0];
                                   else if (counter == 1)
                                       enc_data[63:32] <= data_in[31:0]; 
                                    else if (counter == 2)
                                       enc_data[95:64] <= data_in[31:0]; 
                                    else if (counter == 3)
                                       enc_data[127:96] <= data_in[31:0]; 
                                    else if (counter == 4)
                                       enc_data[159:128] <= data_in[31:0]; 
                                    else if (counter == 5)
                                       enc_data[191:160] <= data_in[31:0]; 
                                    else if (counter == 6)
                                       enc_data[223:192] <= data_in[31:0]; 
                                    else if (counter == 7)
                                       enc_data[255:224] <= data_in[31:0]; 
                                    else if (counter == 8)
                                       enc_data[287:256] <= data_in[31:0]; 
                                    else if (counter == 9)
                                       enc_data[319:288] <= data_in[31:0]; 
                                    else if (counter == 10)
                                       enc_data[351:320] <= data_in[31:0]; 
                                    else if (counter == 11)
                                       enc_data[383:352] <= data_in[31:0]; 
                                    else if (counter == 12)
                                       enc_data[415:384] <= data_in[31:0]; 
                                    else if (counter == 13)
                                       enc_data[447:416] <= data_in[31:0]; 
                                    else if (counter == 14)
                                       enc_data[479:448] <= data_in[31:0]; 
                                    else if (counter == 15)
                                       enc_data[511:480] <= data_in[31:0]; 
                                    else if (counter == 16)
                                       enc_data[543:512] <= data_in[31:0]; 
                                    else if (counter == 17)
                                        begin
                                            enc_data[575:544] <= data_in[31:0];
                                            ready <= 1;
                                        end 
                                    counter = counter + 1;
                                end
                            else
                                ready <= 1;
                        end
                    
                end       
        end
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2022 10:47:56 PM
// Design Name: 
// Module Name: absorb
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


module x_o(
    input clk,
    input rst,
    input [575:0] data_in,
    input [575:0] r_in,
    output reg [575:0] x_data_o
    );
    
    always @ (posedge clk)
        begin
            if (rst)
                x_data_o <= 0;
            else if (!rst)
                x_data_o <= (r_in ^ data_in);
        end
        
endmodule

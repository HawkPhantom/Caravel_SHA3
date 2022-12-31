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


module absorb(
    input clk,
    input rst,
    input [575:0] data_in,
    input [575:0] r_in,
    input [1023:0] c_in,
    output [575:0] abs_data_o,
    output ready
    );
    
    wire [575:0] x_out;
    

    x_o xno (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .r_in(r_in),
        .x_data_o(x_out)
    );
    
    
    keccak_f keccak(
        .clk(clk),
        .rst(rst),
        .x_data_i(x_out),
        .c(c_in),
        .kecc_out(abs_data_o),
        .ready(ready)
    );
  
        
endmodule

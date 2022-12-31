`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2022 11:39:50 PM
// Design Name: 
// Module Name: keccak_f
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


module keccak_f(
    input clk,
    input rst,
    input [575:0] x_data_i,
    input [1023:0] c,
    output [575:0] kecc_out,
    output ready
    );
    
    
    theta_rho_pi_chi_iota keccak (
        .clk(clk),
        .rst(rst),
        .c_in(c),
        .x_data_in(x_data_i),
        .r_o(kecc_out),
        .ready(ready)
    );
    
    
endmodule

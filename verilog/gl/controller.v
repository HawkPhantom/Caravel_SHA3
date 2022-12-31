`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2022 12:33:04 AM
// Design Name: 
// Module Name: padding
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


module controller#(
    parameter BITS = 32
)(
    input clk,
    input reset,
    input valid,
    input [3:0] wstrb,
    input [BITS-1:0] wdata,
    input [BITS-1:0] la_write,
    input [BITS-1:0] la_input,
    output reg ready,
    output reg [BITS-1:0] rdata,
    output reg [BITS-1:0] hash_o
);
    
    reg ram_rst, ram_write_e, ram_read_e = 0;
    wire ram_ready;
    reg [31:0] ram_addr = 0;
    wire [575:0] ram_o, abs_o;
    reg [31:0] ram_data_i = 0;
    reg [575:0] r_abs_init = 0; 
    reg [1023:0] c_abs_init = 0;
    reg [4:0] counter;
    wire k_ready;

    always @(posedge clk) begin
        if (reset) begin
            hash_o <= 0;
            ready <= 0;
            ram_rst <= 1;
            ram_read_e <= 0;
            ram_write_e <= 0;
            rdata <= 0;
            counter <= 0;
        end else begin
            ready <= 1'b0;
            ram_rst <= 0;
            
            
            if (valid && !ready) begin //This goes to RAM
                if(!ram_ready)
                    begin
                        ready <= 1'b1;
                        rdata <= hash_o;
                        if (wstrb[0]) ram_data_i[7:0] <= wdata[7:0];
                        if (wstrb[1]) ram_data_i[15:8] <= wdata[15:8];
                        if (wstrb[2]) ram_data_i[23:16] <= wdata[23:16];
                        if (wstrb[3]) ram_data_i[31:24] <= wdata[31:24];
                        ram_write_e <= 1;
                        ram_read_e <= 0;
                        ram_addr <= 32'h55;
                    end
                else if (ram_ready)
                    begin
                        ram_write_e <= 0;
                        ram_read_e <= 1;
                        ram_addr <= 32'h55;
                        
                        if (k_ready)
                            begin
                                ready <= 1;
                                if(counter==0)
                                   begin
                                       hash_o <= abs_o[63:32]; 
                                       rdata <= abs_o[63:32]; 
                                   end
                                else if(counter==1)
                                   begin
                                       hash_o <= abs_o[95:64]; 
                                       rdata <= abs_o[95:64]; 
                                   end
                                else if(counter==2)
                                   begin
                                       hash_o <= abs_o[127:96]; 
                                       rdata <= abs_o[127:96]; 
                                   end
                                else if(counter==3)
                                   begin
                                       hash_o <= abs_o[159:128]; 
                                       rdata <= abs_o[159:128]; 
                                   end
                                else if(counter==4)
                                   begin
                                       hash_o <= abs_o[191:160]; 
                                       rdata <= abs_o[191:160]; 
                                   end
                                else if(counter==5)
                                   begin
                                       hash_o <= abs_o[223:192]; 
                                       rdata <= abs_o[223:192]; 
                                   end
                                else if(counter==6)
                                   begin
                                       hash_o <= abs_o[255:224]; 
                                       rdata <= abs_o[255:224]; 
                                   end
                                else if(counter==7)
                                   begin
                                       hash_o <= abs_o[287:256]; 
                                       rdata <= abs_o[287:256]; 
                                   end
                                else if(counter==8)
                                   begin
                                       hash_o <= abs_o[319:288]; 
                                       rdata <= abs_o[319:288]; 
                                   end
                                else if(counter==9)
                                   begin
                                       hash_o <= abs_o[351:320]; 
                                       rdata <= abs_o[351:320]; 
                                   end
                                else if(counter==10)
                                   begin
                                       hash_o <= abs_o[383:352]; 
                                       rdata <= abs_o[383:352]; 
                                   end
                                else if(counter==11)
                                   begin
                                       hash_o <= abs_o[415:384]; 
                                       rdata <= abs_o[415:384]; 
                                   end
                                else if(counter==12)
                                   begin
                                       hash_o <= abs_o[447:416]; 
                                       rdata <= abs_o[447:416]; 
                                   end
                                else if(counter==13)
                                   begin
                                       hash_o <= abs_o[479:448]; 
                                       rdata <= abs_o[479:448]; 
                                   end
                                else if(counter==14)
                                   begin
                                       hash_o <= abs_o[511:480]; 
                                       rdata <= abs_o[511:480]; 
                                   end
                                else if(counter==15)
                                   begin
                                       hash_o <= abs_o[543:512]; 
                                       rdata <= abs_o[543:512]; 
                                   end
                                else if(counter==16)
                                   begin
                                       hash_o <= abs_o[575:544]; 
                                       rdata <= abs_o[575:544]; 
                                   end
                                if(counter <=16)
                                    begin
                                        counter <= counter + 1;
                                    end
                                else
                                    begin
                                        counter <= 0;
                                    end
                                
                            end
                        
                        
                        
                    end
                
            end else if (|la_write) begin //if logic analyser is working print out what is given
                hash_o <= la_write & la_input;
            end
        end
    end
    
    
    RAM #(
        .BITS(BITS)
    ) ram(
        .clk(clk),
        .rst(ram_rst),
        .read_e(ram_read_e),
        .write_e(ram_write_e),
        .data_in(ram_data_i),
        .addr_in(ram_addr),
        .ready(ram_ready),
        .ram_data_o(ram_o)
    );
    
    
    absorb abs (
        .clk(clk),
        .rst(ram_rst),
        .data_in(ram_o),
        .r_in(r_abs_init),
        .c_in(c_abs_init),
        .abs_data_o(abs_o),
        .ready(k_ready)
    );

endmodule

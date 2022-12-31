`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Furkan Ciylan
// 
// Create Date: 12/29/2022 10:59:21 PM
// Design Name: SHA 3 ver. 1.0
// Module Name: theta_rho_pi_chi_iota
// Project Name: SHA 3
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


module theta_rho_pi_chi_iota(
    input clk,
    input rst,
    input [1023:0] c_in,
    input [575:0] x_data_in,
    output reg [575:0] r_o,
    output reg ready
    );
    
    reg [63:0] cube [4:0][4:0];
    reg [2:0] step = 0;
    
    reg [4:0] round;
    
    reg [2:0] rst_counter = 0;
    reg [2:0] rst_counter_1 = 0;
    reg [2:0] rst_counter_2 = 0;
    reg [2:0] rst_counter_3 = 0;
    reg [2:0] rst_counter_4 = 0;
    
    reg [63:0] B [4:0][4:0]; 
    
    reg [63:0] C [4:0];
    reg [63:0] D [4:0];
    
    reg [2:0] c_counter = 0;
    reg [2:0] d_counter = 0;
    reg [2:0] a_counter = 0;

    always @ (posedge clk)
        begin
            if(rst)
                begin
                    r_o <= 0;
                    step <= 0;
                    round <= 0;
                    ready <= 0;
                    
                    for(rst_counter_4=0; rst_counter_4<=4; rst_counter_4=rst_counter_4+1)
                        begin
                            C[rst_counter_4] <= 0;
                            D[rst_counter_4] <= 0;
                        end
                    
                    for(rst_counter=0; rst_counter<=4; rst_counter=rst_counter+1)
                        begin
                            for(rst_counter_3=0; rst_counter_3<=4; rst_counter_3=rst_counter_3+1)
                                begin
                                    B[rst_counter][rst_counter_3] <= 0;
                                end
                        end
                    
                    for(rst_counter_1=0; rst_counter_1<=4; rst_counter_1=rst_counter_1+1)
                        begin
                            for(rst_counter_2=0; rst_counter_2<=4; rst_counter_2=rst_counter_2+1)
                                begin
                                    cube[rst_counter_1][rst_counter_2] <= 0;
                                end
                        end
                end
        end
        
    always @(posedge clk)
        begin
            if(!rst)
                begin
                    if(step==0)
                        begin
                            ready <= 0;
                            cube[0][0] <= x_data_in[63:0];
                            cube[0][1] <= x_data_in[127:64]; 
                            cube[0][2] <= x_data_in[191:128]; 
                            cube[0][3] <= x_data_in[255:192]; 
                            cube[0][4] <= x_data_in[319:256]; 
                            cube[1][0] <= x_data_in[383:320]; 
                            cube[1][1] <= x_data_in[447:384]; 
                            cube[1][2] <= x_data_in[511:448];
                            cube[1][3] <= x_data_in[575:512]; 
                            
                            cube[1][4] <= c_in[63:0]; 
                            cube[2][0] <= c_in[127:64]; 
                            cube[2][1] <= c_in[191:128]; 
                            cube[2][2] <= c_in[255:192]; 
                            cube[2][3] <= c_in[319:256]; 
                            cube[2][4] <= c_in[383:320]; 
                            cube[3][0] <= c_in[447:384]; 
                            cube[3][1] <= c_in[511:448]; 
                            cube[3][2] <= c_in[575:512]; 
                            cube[3][3] <= c_in[639:576]; 
                            cube[3][4] <= c_in[703:640]; 
                            cube[4][0] <= c_in[767:704];
                            cube[4][1] <= c_in[831:768];
                            cube[4][2] <= c_in[895:832]; 
                            cube[4][3] <= c_in[959:896]; 
                            cube[4][4] <= c_in[1023:960];
                           
                            step <= 1;
                        end
                end
        end
        
    //Theta
    always @(posedge clk)
        begin
            if(!rst)
                begin
                    if(step == 1) 
                        begin
                            for(c_counter=0; c_counter<=4; c_counter=c_counter+1)
                                begin
                                    C[c_counter] <= cube[c_counter][0] ^ cube[c_counter][1] ^ cube[c_counter][2] ^ cube[c_counter][3];
                                end
                                step <= 2;
                        end
                    
                end
        end
        
    always @(posedge clk)
        begin
            if(!rst)
                begin
                    if(step == 2)
                        begin 
                        
                            D[0] <= ({C[1][0],C[1][63:1]}) ^ C[4];
                            D[1] <= ({C[2][0],C[2][63:1]}) ^ C[0];
                            D[2] <= ({C[3][0],C[3][63:1]}) ^ C[1];
                            D[3] <= ({C[4][0],C[4][63:1]}) ^ C[2];
                            D[4] <= ({C[0][0],C[0][63:1]}) ^ C[3];
                        
                            step <= 3;
                        end
                end
        end
        
    always @(posedge clk)
        begin
            if(!rst)
                begin
                    if(step == 3)
                        begin
                            for(a_counter=0; a_counter<=4; a_counter=a_counter+1)
                                begin
                                    for(d_counter=0; d_counter<=4; d_counter=d_counter+1)
                                        begin
                                            cube[a_counter][d_counter] <= cube[a_counter][d_counter] ^ D[a_counter];
                                        end  
                                end
                                step <= 4;
                        end
                end
        end
    
    //rho and pi
    always @(posedge clk)
        begin
            if(!rst)
                begin
                    if(step==4)
                        begin
                        
                            B[0][0] <= cube[0][0];
                            B[0][1] <= {cube[3][0][27:0],cube[3][0][63:28]};
                            B[0][2] <= {cube[1][0][0],cube[1][0][63:1]};
                            B[0][3] <= {cube[4][0][26:0],cube[4][0][63:27]};
                            B[0][4] <= {cube[2][0][61:0],cube[2][0][63:62]};
                            
                            B[1][0] <= {cube[1][1][43:0],cube[1][1][63:44]};
                            B[1][1] <= {cube[4][1][19:0],cube[4][1][63:20]};
                            B[1][2] <= {cube[2][1][5:0],cube[2][1][63:6]};
                            B[1][3] <= {cube[0][1][35:0],cube[0][1][63:36]};
                            B[1][4] <= {cube[3][1][54:0],cube[3][1][63:55]};
                             
                            B[2][0] <= {cube[2][2][42:0],cube[2][2][63:43]}; 
                            B[2][1] <= {cube[0][2][2:0],cube[0][2][63:3]};
                            B[2][2] <= {cube[3][2][24:0],cube[3][2][63:25]};
                            B[2][3] <= {cube[1][2][9:0],cube[1][2][63:10]};
                            B[2][4] <= {cube[4][2][38:0],cube[4][2][63:39]};

                            B[3][0] <= {cube[3][3][20:0],cube[3][3][63:21]};
                            B[3][1] <= {cube[1][3][44:0],cube[1][3][63:45]};
                            B[3][2] <= {cube[4][3][7:0],cube[4][3][63:8]};
                            B[3][3] <= {cube[2][3][14:0],cube[2][3][63:14]};
                            B[3][4] <= {cube[0][3][40:0],cube[0][3][63:41]}; 
                            
                            B[4][0] <= {cube[4][4][13:0],cube[4][4][63:14]};
                            B[4][1] <= {cube[2][4][60:0],cube[2][4][63:61]};
                            B[4][2] <= {cube[0][4][17:0],cube[0][1][63:18]}; 
                            B[4][3] <= {cube[3][4][55:0],cube[3][4][63:56]};
                            B[4][4] <= {cube[1][4][1:0],cube[1][4][63:2]};
                            step <= 5;
                        end
                end
        end
    
    
     //chi
     always @(posedge clk)
            begin
                if(!rst)
                    begin
                        if(step == 5)
                            begin
                                    cube[0][0] <= B[0][0] ^ (~B[1][0] & B[2][0]);
                                    cube[0][1] <= B[0][1] ^ (~B[1][1] & B[2][1]);
                                    cube[0][2] <= B[0][2] ^ (~B[1][2] & B[2][2]);
                                    cube[0][3] <= B[0][3] ^ (~B[1][3] & B[2][3]);
                                    cube[0][4] <= B[0][4] ^ (~B[1][4] & B[2][4]);
                                    
                                    cube[1][0] <= B[1][0] ^ (~B[2][0] & B[3][0]);
                                    cube[1][1] <= B[1][1] ^ (~B[2][1] & B[3][1]);
                                    cube[1][2] <= B[1][2] ^ (~B[2][2] & B[3][2]);
                                    cube[1][3] <= B[1][3] ^ (~B[2][3] & B[3][3]);
                                    cube[1][4] <= B[1][4] ^ (~B[2][4] & B[3][4]);
                                    
                                    cube[2][0] <= B[2][0] ^ (~B[3][0] & B[4][0]);
                                    cube[2][1] <= B[2][1] ^ (~B[3][1] & B[4][1]);
                                    cube[2][2] <= B[2][2] ^ (~B[3][2] & B[4][2]);
                                    cube[2][3] <= B[2][3] ^ (~B[3][3] & B[4][3]);
                                    cube[2][4] <= B[2][4] ^ (~B[3][4] & B[4][4]);
                                    
                                    cube[3][0] <= B[3][0] ^ (~B[4][0] & B[0][0]);
                                    cube[3][1] <= B[3][1] ^ (~B[4][1] & B[0][1]);
                                    cube[3][2] <= B[3][2] ^ (~B[4][2] & B[0][2]);
                                    cube[3][3] <= B[3][3] ^ (~B[4][3] & B[0][3]);
                                    cube[3][4] <= B[3][4] ^ (~B[4][4] & B[0][4]);
                                    
                                    cube[4][0] <= B[4][0] ^ (~B[0][0] & B[1][0]);
                                    cube[4][1] <= B[4][1] ^ (~B[0][1] & B[1][1]);
                                    cube[4][2] <= B[4][2] ^ (~B[0][2] & B[1][2]);
                                    cube[4][3] <= B[4][3] ^ (~B[0][3] & B[1][3]);
                                    cube[4][4] <= B[4][4] ^ (~B[0][4] & B[1][4]);
                                    
                                    step <= 6;
                            end
                    end
            end
            
            
      // iota      
      always @(posedge clk)
        begin
            if(!rst)
                begin
                    if(step == 6)
                        begin
                                if (round == 0)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h0000000000000001;
                                    end
                                    
                                else if(round==1)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h0000000000008082;
                                    end
                                    
                                else if(round==2)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h800000000000808A;
                                    end
                                    
                                else if(round==3)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h8000000080008000;
                                    end
                                    
                                else if(round==4)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h000000000000808B;
                                    end
                                    
                                else if(round==5)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h0000000080000001;
                                    end
                                    
                               else if(round==6)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h8000000080008081;
                                    end
                                    
                               else if(round==7)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h8000000000008009;
                                    end
                               
                               else if(round==8)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h000000000000008A;
                                    end
                                    
                               else if(round==9)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h0000000000000088;
                                    end  
                                    
                               else if(round==10)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h0000000080008009;
                                    end   
                                    
                               else if(round==11)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h000000008000000A;
                                    end 
                                    
                               else if(round==12)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h000000008000808B;
                                    end 
                                    
                               else if(round==13)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h800000000000008B;
                                    end 
                                    
                               else if(round==14)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h8000000000008089;
                                    end 
                                    
                               else if(round==15)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h8000000000008003;
                                    end
                                    
                               else if(round==16)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h8000000000008002;
                                    end
                                    
                               else if(round==17)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h8000000000000080;
                                    end
                                    
                               else if(round==18)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h000000000000800A;
                                    end
                               
                               else if(round==19)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h800000008000000A;
                                    end
                                    
                               else if(round==20)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h8000000080008081;
                                    end
                                    
                               else if(round==21)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h8000000000008080;
                                    end
                                    
                               else if(round==22)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h0000000080000001;
                                    end
                                    
                               else if(round==23)
                                    begin
                                        cube[0][0] <= cube[0][0] ^ 64'h8000000080008008;
                                    end
                               else
                                    begin
                                        cube[0][0] <= 0;
                                    end
                               
                               
                                step <= 7;
                        end
                end
        end      
        
        always @(posedge clk)
        begin
            if(!rst)
                begin
                    if(step == 7)
                        begin
                                if (round < 23) 
                                    begin
                                        step <= 1;
                                        round <= round + 1;
                                    end
                                else
                                    begin
                                        r_o[63:0] <= cube[0][0]; 
                                        r_o[127:64] <= cube[0][1]; 
                                        r_o[191:128] <= cube[0][2]; 
                                        r_o[255:192] <= cube[0][3]; 
                                        r_o[319:256] <= cube[0][4]; 
                                        r_o[383:320] <= cube[1][0]; 
                                        r_o[447:384] <= cube[1][1]; 
                                        r_o[511:448] <= cube[1][2]; 
                                        r_o[575:512] <= cube[1][3]; 
                                        ready <= 1;
                                    end
                                
                        end
                end
        end
        
            
endmodule

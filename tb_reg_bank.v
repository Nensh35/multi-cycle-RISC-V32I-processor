`include "REG_bank.v"
`timescale 1ns/100ps 

module tb() ;

reg clk             ;            
reg reset           ;
reg RegWrite        ;      
reg [4:0] rs1_addr  ;
reg [4:0] rs2_addr  ; 
reg [4:0] rd_addr   ;
reg [31:0] write_data ;

integer i ;

wire  [31:0] rs1_data ;
wire  [31:0] rs2_data ;

    registers R (clk, reset , RegWrite , rs1_addr , rs2_addr , rd_addr , write_data , rs1_data , rs2_data ) ;

always #5 clk = ~ clk ;

initial begin

    $dumpfile("reg.vcd") ;
    $dumpvars (0,tb) ;
    
    $monitor($time , " rs1_data %d  and rs2_data %d " , rs1_data , rs2_data );
    clk = 0 ; reset = 1 ; RegWrite = 0 ;

    #30 
        reset = 0 ; RegWrite = 1 ;
        write_data = 32'd10 ;  rd_addr = 5'd1 ;

    #10 write_data = 32'd10 ;  rd_addr = 5'd2 ;

    #10 write_data = 32'd10 ;  rd_addr = 5'd3 ;

    #10 write_data = 32'd11 ;  rd_addr = 5'd4 ;

    #10 write_data = 32'd12 ;  rd_addr = 5'd5 ;

    #10 write_data = 32'd13 ;  rd_addr = 5'd10 ;

    #10 write_data = 32'd14 ;  rd_addr = 5'd15 ;

    #10 write_data = 32'd15 ;  rd_addr = 5'd31 ;

    #10 write_data = 32'd16 ;  rd_addr = 5'd20 ;

    #10 write_data = 32'd17 ;  rd_addr = 5'd0 ;

    #10 write_data = 32'd18 ;  rd_addr = 5'd2 ;

    #10 RegWrite = 0 ;
        rs1_addr = 5'd1 ;

    #10 rs1_addr = 5'd2 ;
    #10 rs2_addr = 5'd3 ;
    #10 rs1_addr = 5'd4 ;
    #10 rs1_addr = 5'd5 ;
    #10 rs2_addr = 5'd10 ;
    #10 rs2_addr = 5'd15 ;
    #10 rs2_addr = 5'd31 ;
    #10 rs2_addr = 5'd20 ;
    #10 rs1_addr = 5'd0 ;
    #10 rs2_addr = 5'd2 ;

    

    for(i = 0  ; i< 32 ; i = i+1)
        $display("value in the reg no . %d is %d " , i , R.R[i]) ;
    #50 $finish() ;
    end

endmodule

// working fine !#!


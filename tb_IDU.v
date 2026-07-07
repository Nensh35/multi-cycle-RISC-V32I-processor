`include "IDU.v"
`timescale 1ns/100ps

module tb();

    reg clk, En_IDU , reset ;
    reg [31:0] IR ;

    wire [2:0] Funct3   ;
    wire [6:0] OpCode   ;
    wire [4:0] Rd       ; 
    wire [4:0] Rs1      ;
    wire [4:0] Rs2      ;
    wire [6:0] Funct7   ;
    wire [11:0] imm_I   ;
    wire [19:0] imm_U   ;

    idu d1 (clk , En_IDU , reset , IR , Funct3 , OpCode , Rd , Rs1 , Rs2 , Funct7 , imm_I , imm_U ) ;

    always #5 clk = ~clk ;

    initial begin

    clk = 0 ; En_IDU = 0 ; reset = 0;
    IR = 0 ;
    
    $dumpfile("IDU.vcd") ;
    $dumpvars(0,tb) ;

    $monitor($time , "  clk %d, En_IDU %d, reset %d, IR %d, Funct3 %d, OpCode %d, Rd %d, Rs1 %d,Rs2 %d, Funct7 %d, imm_I %d, imm_U %d " , clk , En_IDU , reset , IR , Funct3 , 
                        OpCode , Rd , Rs1 , Rs2 , Funct7 , imm_I , imm_U);

    #2 reset = 1 ;
    #30 reset = 0 ;
    #20 En_IDU = 1 ;

    //IR = {7'h0 , 5'h02 , 5'h03 ,3'b0 , 5'h05 , 7'b0110011};        // R type
    
 
   //  IR = {12'h005 , 5'h04 ,3'd2 , 5'h08 , 7'b0010011 } ;          // I type addi



   //   IR = {7'd5 , 5'h04 , 5'h06 , 3'd2 , 5'd8 , 7'b0100011 } ;    //  s Type

      //  IR = {7'h1 , 5'd2 , 3'd0 ,5'd5 , 7'b0000011};                //  I type  LW 8bits

      //IR = {7'h1 ,5'd5 ,5'd2 , 3'd0 ,5'd5 , 7'b0100011};                //  S type

      //IR = {7'h1 , 5'd8 , 5'd5 , 3'd0 ,5'd5 , 7'b1100011};                //  B type

      // IR = {20'd80 ,5'd4 , 7'b1101111};                           // JAL type

      //  IR = {7'd10 , 5'd2 , 3'd1 ,5'd5 , 7'b1100111};              //  J-I type ;

      //  IR = {20'd500 ,5'd20 , 7'b0110111};                           //Load upper imm 

      //  IR = {20'd60 ,5'd13 , 7'b0010111};                           //AddUpperImmtoPC 
      #10 $finish() ;
 
    end
endmodule

    
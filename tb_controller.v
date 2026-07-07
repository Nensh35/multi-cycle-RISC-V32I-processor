`include "Controller.v"
`timescale 1ns/100ps

module tb() ;

    reg  clk , reset    ; 
    reg  [9:0] PC       ;
    reg  [31:0]ALU_out  ; 
    reg  Branch_Taken   ; 
    reg  [31:0] IR      ; 
    reg  [31:0] MDR     ; 
    reg  [31:0] Rs2     ;      /// mainly  bcz of the store instruction
    reg   [11:0] imm_I  ;     
    reg   [19:0] imm_U  ;         
    
    wire [9:0] New_PC   ;                
    wire En_IFU , En_IDU , En_IEX , En_write  ;  // En_write for the data mem
    wire [9:0] Row_DM       ;
    wire [1:0] type_DM      ;
    wire [31:0] data_DM     ;
    wire RegWrite           ;

    controller c1(clk , reset , PC , ALU_out , Branch_Taken , IR , MDR , Rs2 , imm_I , imm_U ,
                   New_PC , En_IFU , En_IDU , En_IEX , En_write , Row_DM , type_DM , data_DM , RegWrite) ;

    always #5 clk = ~ clk ;

    initial begin

        clk = 0 ;  reset = 0 ;

        $dumpfile("controller.vcd");
        $dumpvars(0,tb);
        
        $monitor($time , "reset %d  PC %d New_PC %d En_IFU %d En_IDU %d En_IEX %d En_write %d Row_DM %d type_DM %d data_DM %d RegWrite %d " ,
                        reset , PC , New_PC , En_IFU , En_IDU , En_IEX , En_write , Row_DM , type_DM , data_DM , RegWrite );


        #2 reset = 1 ; ALU_out = 10 ;  PC = 10 ; 
      //IR = {7'h0 , 5'd1 , 5'd2 , 3'd0 ,5'd5 , 7'b0110011};   //  R type  add
      //IR = {7'h1 , 5'd2 , 3'd0 ,5'd5 , 7'b0010011};          //  I type addi
      //IR = {7'h1 , 5'd2 , 3'd0 ,5'd5 , 7'b0000011};          //  I type  LW 8bits
      //IR = {7'h1 , 5'b0, 5'd2 , 3'd0 ,5'd5 , 7'b0100011};          //  S type

      //IR = {7'h1 , 5'd5 , 3'd0 ,5'd5 , 7'b1100011}; Branch_Taken = 1 ; imm_I = 2 ;  ///  B type
      //  IR = {20'b0 ,5'd5 , 7'b1101111}; Branch_Taken = 1 ; imm_U = 2 ;  // JAL type
        
      //  IR = {7'd1 , 5'd2 , 3'd0 ,5'd5 , 7'b1100111};     ///  J-I type ;

      //  IR = {20'b0 ,5'd5 , 7'b0110111};  Load upper imm 
      //  IR = {20'b0 ,5'd5 , 7'b0010111};  AddUpperImmtoPC


        #50 reset = 0 ;

        #60 $finish() ;

    end

endmodule

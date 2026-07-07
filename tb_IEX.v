`include "IEX.v"

`timescale 1ns/100ps

module tb();

    reg   clk, En_IEX  , reset  ;
    reg   [2:0] Funct3          ;
    reg   [6:0] OpCode          ; 
    reg   [31:0] Rs1            ;
    reg   [31:0] Rs2            ;
    reg   [6:0] Funct7          ;
    reg   [11:0] imm_I          ;
    reg   [19:0] imm_U          ;


    wire  [31:0] ALU_out        ;
    wire  Branch_Taken          ;

    iex EX (clk , En_IEX , reset , Funct3 , OpCode , Rs1 , Rs2 , Funct7 , imm_I , imm_U , ALU_out , Branch_Taken) ;

    always #5 clk = ~ clk ;

    initial begin

    clk = 0; En_IEX = 0 ; reset = 0  ; Funct3 = 0 ; OpCode = 7'bx; 

    $dumpfile("iex.vcd");
    $dumpvars(0,tb);

    $monitor($time ," reset %d , En_IEX %d, ALU_out %d , Branch_Taken %d ", reset  , En_IEX , ALU_out , Branch_Taken );

    #2 reset = 1 ;  Funct3 = 3'd0 ; Funct7 = 7'h0 ; Rs1 = 32'd1 ; Rs2 = 32'd10 ; imm_I = 12'd20 ; imm_U = 20'd2 ;

    #20 reset = 0 ; En_IEX = 1 ; OpCode = 7'b0010111;

    #50 $finish();

    end

endmodule
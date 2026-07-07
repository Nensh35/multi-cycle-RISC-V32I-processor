`timescale 1ns/100ps 
`include "IM.v"
`include "REG_bank.v"

module tb_IM ();

    reg reset , write , read ;
    reg  [4:0]  idx          ;
    reg  [31:0] data_in      ;
    wire [31:0] data_out     ;
    reg  [9:0]  PC           ;
    wire [31:0] IR           ;

    instruction_memory m1 (reset , PC  , IR);
    
    initial begin

    $dumpfile("IM.vcd");
    $dumpvars(0,tb_IM_REG) ;


    reset = 0 ; write = 0 ; read =0 ; idx = 0 ; data_in = 0 ;

   
/*
    $monitor($time  , " im 0 %d 1 %d  2 %d  10 %d 20 %d 30 %d and data_out %d",
             r1.R[0] , r1.R[1] , r1.R[2] , r1.R[10] , r1.R[20] , r1.R[30] , data_out);

    #2 reset = 1 ;
    #30 reset = 0 ;   write =  1 ;
    idx = 1 ; data_in = 1 ;
    #10
    write = 0 ;
    data_in = 10 ;
    #10 write= 1 ; idx = 10 ;

    #10 write = 1 ; data_in = 20; idx= 20 ;

    #10 read = 1 ; write = 0 ; idx = 0 ;
    #10 idx = 1 ;
    #10 idx = 2 ;
    #10 idx = 10 ;
    #10 idx = 20 ;
    #10 idx = 30 ;

*/


  //  **** to verify the instruction_memory only by this :

   $monitor($time  , "and the IR is %d at %d PC  im 0 %d 1 %d  2 %d  10 %d 20 %d 30 %d ",IR,PC ,
             m1.imem[0] , m1.imem[1] , m1.imem[2] , m1.imem[10] , m1.imem[20] , m1.imem[30]);

    reset = 0 ; write = 0 ; read =0 ; idx = 0 ; data_in = 0 ; PC= 0; 
    #2 reset = 1 ;
    #30 reset = 0 ;
    m1.imem[0] = 0 ; m1.imem[1] = 1 ; m1.imem[2] = 2 ; m1.imem[10] = 3 ; m1.imem[20] = 4; m1.imem[30] = 5 ;

    #5 PC = 1 ;
    #5 PC = 2 ;
    #5 PC = 30;
    #5 PC = 10;



    #50 reset = 1 ;
    #20  reset = 0 ;
    m1.imem[0] = 0 ; m1.imem[1] = 1 ; m1.imem[2] = 2 ; m1.imem[10] = 10 ; m1.imem[20] = 40; m1.imem[30] = 50 ;

    #5 PC = 1 ;
    #5 PC = 2 ;
    #5 PC = 30;
    #5 PC = 10;

    #50 $finish();
end

endmodule
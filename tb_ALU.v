`include "ALU.v"
`timescale 1ns/100ps 

module tb() ;

    reg [31:0] A,B ;
    reg [3:0] sel  ;
    wire [31:0] ALU_out ;
    wire flag ; 

    alu a(A , B , sel , ALU_out , flag ) ;

    integer i ;

initial begin 

    $dumpfile("ALU.vcd");
    $dumpvars(0,tb) ;

    $monitor($time  , "  A is %d  and B is %d sel is %d   ALU_out %d flag %d " , A , B , sel , ALU_out , flag );
    #2 A = 32'd12 ; B=32'd12 ; sel = 4'bx ;

    for(i = 0 ; i<15 ; i = i+1) 
        #5 sel  = i ;

    #5 A = 32'd10 ; B=32'd12 ; sel = 4'bx ;

    for(i = 0 ; i<15 ; i = i+1) 
        #5 sel  = i ;
    
    #5 A = 32'd10 ; B=32'd5 ; sel = 4'bx ;

    for(i = 0 ; i<15 ; i = i+1) 
        #5 sel  = i ;

    end

endmodule
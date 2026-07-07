`include "IFU.v"

`timescale 1ns/100ps

module tb_IFU();

    reg clk, En_IFU , reset ;
    wire [9:0] PC    ;

    ifu  IF(clk, En_IFU ,reset ,PC) ;


    always #5 clk = ~ clk ; 
    initial begin 
        
        $dumpfile("IFU.vcd");
        $dumpvars(0,tb_IFU);

        $monitor($time , "  PC is %d" , PC);

        clk=0 ; En_IFU = 0  ;reset = 0 ;
        #2 reset = 1 ; 
        #30 reset = 0 ; En_IFU = 1 ;
        #300 reset = 1 ; En_IFU = 0 ;

        #50 $finish();

    end

endmodule



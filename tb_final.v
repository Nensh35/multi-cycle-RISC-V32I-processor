`include "RISC_V.v"
`timescale 1ns/100ps

module tb();

reg clk, reset ;
integer i ;
    RISC_V p (clk , reset) ;

always #5 clk = ~clk ;

initial begin

    clk  = 0 ; reset = 0 ;

    $dumpfile("RISC_V.vcd");
    $dumpvars(0,tb);

    
    #2 reset = 1 ;

    #20 reset = 0;

        
        
        for(i = 1 ; i < 32 ; i= i+1)
            p.R.R[i] = i ;


        // input is taken in the reg 1 :  
        
        //p.im.imem[0] = {12'd20 , 5'd1 , 3'b0 , 5'd7 , 7'b0010011  } ;
        //p.im.imem[0] = {7'h0   , 5'd1  , 5'd0 , 3'b0  , 5'd0 , 7'b0110011  } ; 

        p.R.R[1] = 10 ;
        p.DM.mem[30] = 8'hFC;  // this is -5 ;
        p.R.R[21]= 32'd31;
        p.R.R[22] = 32'd2;

        //  Shift left exteam test ::  load the data -1 and sll by 31 : 
        
        
        //p.im.imem[0] = {12'd30 , 5'd0 , 3'd2 , 5'd1 , 7'b0000011  } ;
        //p.im.imem[1] = {7'h20   , 5'd21  , 5'd1 , 3'd5  , 5'd2 , 7'b0110011  } ; 


        //loading a negative no of 8bit and see is it sign extended or not :

        p.im.imem[0] = {12'd30 , 5'd0 , 3'd0 , 5'd1 , 7'b0000011  } ;




    #170
            $display("the final output in the reg no  %d is %d " , 1 ,p.R.R[1]); 
            $display("the final output in the reg no  %d is %d " , 2 ,p.R.R[2]); 
            $display("the final output in the reg no  %d is %d " , 3 ,p.R.R[21]);
            $display("the final output in the reg no  %d is %d " , 4 , p.DM.mem[30]);
            $display("the final output in the reg no  %d is %d " , 4 ,p.R.R[25]);

        //for(i = 0 ; i < 32 ; i= i+1)
        //    $display("the final output in the reg no  %d is %d " , i ,p.R.R[i]);


    #20 $finish();

    end
    endmodule
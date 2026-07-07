`timescale 1ns/100ps 
`include "Data_Memory.v"

module tb() ;

 reg clk , reset        ;  
 reg [9:0] Row          ;
 reg [1:0] type         ;
 reg [31:0] data_in     ;
 reg En_write           ;
    integer i ;
 wire [31:0] data_out ;

    data_mem dm(clk ,reset , Row , type , data_in  , En_write , data_out ) ;

 always #5 clk = ~ clk ;

initial begin
    
    clk = 0 ; reset = 0 ; En_write = 0;

    $dumpfile("DM.vcd") ;
    $dumpvars(0,tb)     ;

    $monitor($time ," reset %d, En_write %d ,Row no %d , data_out %d " , reset , En_write , Row , data_out );

    #2 reset = 1 ; En_write = 0 ;
    #20 reset = 0 ; En_write = 1 ;
    data_in = 32'd2 ; Row = 10'd0 ; type = 2'b10 ;

    #10 data_in = 32'd2 ; Row = 10'd0 ; type = 2'b10 ;

        #10 data_in = 32'd0 ; Row = 10'd0 ; type = 2'b10 ;
        #10 data_in = 32'd1 ; Row = 10'd1 ; type = 2'b10 ;
        #10 data_in = 32'd2 ; Row = 10'd2 ; type = 2'b10 ;
        #10 data_in = 32'd3 ; Row = 10'd3 ; type = 2'b10 ;
        #10 data_in = 32'd4 ; Row = 10'd4 ; type = 2'b10 ;
        #10 data_in = 32'd5 ; Row = 10'd5 ; type = 2'b10 ;
        #10 data_in = 32'd6 ; Row = 10'd6 ; type = 2'b10 ;
        #10 data_in = 32'd7 ; Row = 10'd7 ; type = 2'b10 ;

    #10 En_write = 0 ;

    // reading

        #10 Row = 10'd0 ; type = 2'b10 ;
        #10 Row = 10'd1 ; type = 2'b10 ;
        #10 Row = 10'd2 ; type = 2'b10 ;
        #10 Row = 10'd3 ; type = 2'b10 ;
        #10 Row = 10'd4 ; type = 2'b10 ;
        #10 Row = 10'd5 ; type = 2'b10 ;
        #10 Row = 10'd6 ; type = 2'b10 ;
        #10 Row = 10'd7 ; type = 2'b10 ;


        for(i = 0 ; i<8 ; i= i+1 )
            $display("mem address %d  data is %d " , i ,dm.mem[i]);

    #50 $finish() ; 

end
endmodule



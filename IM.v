module instruction_memory(
    input clk,reset,En_IM ,Branch_Taken ,
    input [9:0] PC,New_PC ,
    output reg [31:0] IR
) ;

reg [31:0] imem [1023:0];
integer i ;

always @(negedge clk) begin
    if(reset) begin

        for (i = 0 ; i<= 1023 ; i= i + 1) 
           imem[i]= 0 ;

    end
    else if(En_IM)
        if(Branch_Taken)
            IR <= imem[New_PC] ;

        else IR <= imem[PC] ;
        

end

endmodule 

/*
why that the IR is output of this not the IFU ?? 
bcz that if we definne the IR in the IFU i need a IM over there to fetch for that i need to 
new module inside that and that is not good so to ease our code IFU is just providing the PC that we will give to the
IM module it give an IR !!

*/
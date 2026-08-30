module instruction_memory(
    input clk,reset,En_IM ,Branch_Taken ,
    input [9:0] PC,New_PC ,
    output reg [31:0] IR ,
    input load_imem
) ;

reg [31:0] imem [1023:0];
integer i ;

always @(negedge clk) begin
    if(reset) begin
            for (i = 0; i < 1024; i = i + 1) begin
            
            imem[i] <= 32'b0;
            
            end
        end

    else if(load_imem) begin

        imem[0] <= {12'd5 , 5'd0 , 3'b0 , 5'd1 , 7'b0010011  } ;  // addi 
        
        imem[1] <= {12'd1 , 5'd0 , 3'b0 , 5'd21 , 7'b0010011  } ;
        
        imem[2] <= {12'd2 , 5'd0 , 3'b0 , 5'd22 , 7'b0010011  } ;
        
        imem[3] <= {7'h0   , 5'd1  , 5'd0 , 3'b0  , 5'd2 , 7'b0110011  } ;   //   copy to reg2         
        imem[4] <= {7'h0   , 5'd1  , 5'd0 , 3'b0  , 5'd3 , 7'b0110011  } ;   //   copy to reg3
        imem[5] <= {7'h0   , 5'd1  , 5'd0 , 3'b0  , 5'd4 , 7'b0110011  } ;   //   copy to reg4
        imem[6] <= {7'h20  , 5'd21  , 5'd2  , 3'b0  , 5'd2  , 7'b0110011 };  //   reg2  - 1
        imem[7] <= {7'h20  , 5'd22  , 5'd3  , 3'b0  , 5'd3  , 7'b0110011 };  //   reg3  - 2
        //p 2 is multipication of reg 1 and 2 :      
        imem[8] <= {7'h0   , 5'd1  , 5'd4 , 3'b0  , 5'd1 , 7'b0110011  }  ;  //     add reg1  + reg4  
        imem[9] <= {7'h20  , 5'd21  , 5'd2  , 3'b0  , 5'd2  , 7'b0110011 };  //     sub reg2  - 1
        imem[10] <= {7'h0   , 5'd2  , 5'd21  , 3'd4  , 5'd8  , 7'b1100011 };  //   branch if reg2 > 1 to the im[5];
//      p 3 copy that reg 3 to 2 ;     
        imem[11] <= {7'h0   , 5'd3  , 5'd0 , 3'b0  , 5'd2 , 7'b0110011  } ;   //  copy reg3 in the reg2
        imem[12] <= {7'h20  , 5'd21  , 5'd3  , 3'b0  , 5'd3  , 7'b0110011 };  //  sub  reg3  - 1 ; 
        imem[13] <= {7'h0   , 5'd1  , 5'd0 , 3'b0  , 5'd4 , 7'b0110011  } ;  //  copy reg1 in the reg 4
        imem[14] <= {7'h0   , 5'd3  , 5'd0  , 3'd4  , 5'd8  , 7'b1100011 };  //  branch if reg3 > 0 to the imem[5];
        imem[15] <=  {25'd0,7'h7F} ;
        
            end

    else if(En_IM) begin
        if(Branch_Taken)
            IR <= imem[New_PC] ;

        else IR <= imem[PC] ;
        
    end
end

endmodule


module ifu(
    input clk, En_IFU , reset , Branch_Taken ,
    input [9:0] New_PC ,
    output reg [9:0] PC    
);

always @(negedge clk) begin

    if(reset) begin

        PC <= 0 ;

    end

    
    else if(En_IFU) begin

        if(Branch_Taken)
            PC <= New_PC + 1'b1 ;

        else
            PC <= PC + 10'd1  ;

    end

end

endmodule
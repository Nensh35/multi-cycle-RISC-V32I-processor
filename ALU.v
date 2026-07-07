module alu(
    input [31:0] A,B ,
    input [3:0] sel  ,
    output reg [31:0] ALU_out ,
    output reg flag
);

always @(*) begin   

    flag = 0 ;
    case(sel) 

        4'd0 : ALU_out = A +  B      ;
        4'd1 : ALU_out = A -  B      ;
        4'd2 : ALU_out = A ^  B      ;
        4'd3 : ALU_out = A |  B      ;
        4'd4 : ALU_out = A &  B      ;
        4'd5 : ALU_out = A << B      ;
        4'd6 : ALU_out = A >> B      ;
        4'd7 : ALU_out = A << B[4:0] ;
        4'd8 : ALU_out = A >> B[4:0] ;
        4'd9 : flag    = (A == B) ? 1:0 ;
        4'd10: flag    = (A != B) ? 1:0 ;
        4'd11: ALU_out = (A < B ) ? 1:0 ;
        4'd12: flag    = (A >= B) ? 1:0 ;
        4'd13: flag    = (A < B ) ? 1:0 ;
        4'd14: ALU_out = $signed(A) >>> B ;  //SR but arithmatic not logical nagative will be -ve only ;;

        default : begin ALU_out = 32'bx ; flag = 1'bx ; end

    endcase

end 
endmodule


module idu(
    input clk, En_IDU , reset,
    input [31:0] IR ,
    output reg [2:0] Funct3 ,
    output reg [6:0] OpCode ,
    output reg [4:0] Rd     , 
    output reg [4:0] Rs1    ,
    output reg [4:0] Rs2    ,
    output reg [6:0] Funct7 ,
    output reg [11:0] imm_I ,
    output reg [19:0] imm_U  
);

always @(negedge clk) begin

    if(En_IDU & (~reset)) begin 

    case(IR[6:0])

        7'b0110011 : begin ///  this is R type 

                OpCode   <= 7'b0110011  ;
                Rd       <= IR[11:7] ;
                Funct3   <= IR[14:12];
                Rs1      <= IR[19:15];
                Rs2      <= IR[24:20];
                Funct7   <= IR[31:25];

                end

        7'b0010011 : begin
                                                /// I type  1
                OpCode   <= 7'b0010011  ;
                Rd       <= IR[11:7] ;
                Funct3   <= IR[14:12];
                Rs1      <= IR[19:15];
                imm_I    <= IR[31:20];
                
                end

        7'b0000011 : begin

                OpCode   <= 7'b0000011  ;
                Rd       <= IR[11:7] ;
                Funct3   <= IR[14:12];
                Rs1      <= IR[19:15];
                imm_I    <= IR[31:20];

            end

        7'b1100111 : begin

                OpCode   <= 7'b1100111  ;
                Rd       <= IR[11:7] ;
                Funct3   <= IR[14:12];
                Rs1      <= IR[19:15];
                imm_I    <= IR[31:20];     

            end

        7'b0100011  : begin
                                ////  S type 
                OpCode   <= 7'b0100011                 ;           
                Funct3   <= IR[14:12]               ;       
                Rs1      <= IR[19:15]               ;           
                imm_I    <= {IR[31:25] , IR[11:7]}  ;
                Rs2      <= IR[24:20]               ;       

            end

        7'b1100011  : begin    /// B type

                OpCode   <= 7'b1100011                ;                                                            
                Funct3   <= IR[14:12]              ;             
                Rs1      <= IR[19:15]              ;                         
                imm_I    <= {IR[31:25] , IR[11:7]} ;  
                Rs2      <= IR[24:20]              ; 

            end

        7'b0110111 ,7'b0010111    : begin  // U type

                OpCode   <= 7'b0110111  ;
                Rd       <= IR[11:7] ;
                imm_U    <= IR[31:12];

            end

        7'b1101111   : begin   // J type

                OpCode   <= 7'b1101111  ;
                Rd       <= IR[11:7] ;
                imm_U    <= IR[31:12];

            end

        default : begin

                OpCode  <= 7'bx ;

                end
        
        endcase

    end
    end

endmodule 





        


        
        
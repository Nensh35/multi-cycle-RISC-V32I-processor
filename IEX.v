`include "ALU.v"

module iex(
    input   clk, En_IEX  , reset,
    input   [2:0] Funct3 ,
    input   [6:0] OpCode , 
    input   [31:0] Rs1   ,
    input   [31:0] Rs2   ,
    input   [6:0] Funct7 ,
    input   [11:0] imm_I ,
    input   [19:0] imm_U ,
    output  [31:0] ALU_out,
    output  Branch_Taken

);

// sign extends
wire[31:0]  IMM_U = {{12{imm_U[19]}},imm_U } ;
wire[31:0]  IMM_I = {{20{imm_I[11]}} ,imm_I } ;
reg [3:0]   sel ; 
reg [31:0]    A  ;
reg [31:0]    B  ;
wire flag        ; /// it will goes to the ALU for the B type
reg  Branch_Taken_2 ; // it is for the J type as in the j type we do not need to chek any conditon;

assign Branch_Taken = flag ? 1 : Branch_Taken_2 ;




always @(negedge clk) begin

    if(En_IEX & (~reset)) begin

    case(OpCode)

        7'b0110011 : begin  // R type so A is Rs1 and B is Rs2 only
                A       <= Rs1 ;
                B       <= Rs2 ;
                Branch_Taken_2    <= 0   ;
            case(Funct3) 



                3'd0 :  begin    /// ADD

                        if(Funct7 == 0)
                            sel <= 0;
                        
                        //sub
                        else if(Funct7 == 7'h20)  
                        
                            sel <= 1;

                        else sel <= 4'bx;

                        end

                3'd1 : begin
                        if(Funct7 == 0)  //SL
                            sel  <= 5 ;
                        else sel <= 4'bx;
                        end

                3'd2 :  begin    /// A<B opration
                        if(Funct7 == 0) 
                            sel  <= 11;

                        else sel <= 4'bx;
                    end

                3'd4 :  begin   ///  XOR  ^^
                        if(Funct7 == 0)
                            sel<=2;

                        else sel <= 4'bx;
                    end

                3'd5 :  begin  // >> SR opration
                        if(Funct7 == 0)
                            sel  <=6;

                        else if(Funct7 == 7'h20)
                            sel  <=4'd14;

                        else sel <= 4'bx;
                    end

                3'd6 :  begin    /// or |
                        if(Funct7 == 0)
                             sel <=3;
                        else sel <= 4'bx;
                    end

                3'd7 :  begin    // & opration

                        if(Funct7 == 0)
                            sel  <=4;
                        else sel <= 4'bx;

                    end
                
                default : sel <= 4'bx ;

                endcase

                end
                

        7'b0010011 : begin  

                A            <= Rs1   ;
                B            <= IMM_I ;
                Branch_Taken_2 <= 0;

                case(Funct3) 

                3'd0 :  begin    /// ADD

                            sel <= 0;

                        end

                3'd1 : begin  //SL

                            sel <= 7  ;

                        end

                3'd2 :  begin    /// A<B opration
                            sel <= 11;
                    end

                3'd4 :  begin   ///  XOR  ^^

                            sel<=2;

                    end

                3'd5 :  begin  // >> imm[4:0] only SR opration
                            sel<=8;
                    end

                3'd6 :  begin    /// or |
                            sel<=3;
                    end

                3'd7 :  begin    // & opration

                            sel<=4;

                    end

                default : sel <= 4'bx ;

                endcase

            end

        7'b0000011 : begin  // I type but the load  alu out is imm + Rs1

                Branch_Taken_2 <= 0   ;
                A <= Rs1            ;
                B <= IMM_I          ;
            case(Funct3)

                3'd0 : sel <= 0;
                3'd1 : sel <= 0;
                3'd2 : sel <= 0;
                3'd4 : sel <= 0;
                3'd5 : sel <= 0;

            default : sel = 4'dx ;
            endcase

            end

        7'b0100011 : begin   /// S type 
                
                Branch_Taken_2  <= 0   ;
                A     <= Rs1            ;
                B     <= IMM_I          ;

            case(Funct3)

                3'd0 : sel <= 0;
                3'd1 : sel <= 0;
                3'd2 : sel <= 0;

            default : sel <= 4'dx ;

            endcase

            end

        7'b1100011 : begin  // branch type

                
                A    <= Rs1            ;
                B    <= Rs2            ;
                

            case(Funct3)

                3'd0 : sel <= 4'd9  ;
                3'd1 : sel <= 4'd10 ;
                3'd4 : sel <= 4'd13 ;
                3'd5 : sel <= 4'd12 ;

                default : sel <= 4'dx ;
            
            endcase
        
        end

        7'b1101111 :  begin  // Jump;

            Branch_Taken_2 <= 1;
            A    <= 0 ;
            B    <= IMM_U ;
            sel  <= 0 ;

         /// **** note that you have to save the PC also 

        end

        7'b1100111 : begin  // J-I jalr ;

            
            A       <= Rs1;
            B       <= IMM_I ;
            sel     <= 0;
            Branch_Taken_2 <= 1;


            end
        
        7'b0110111 , 7'b0010111 : begin  // U type  

            Branch_Taken_2 <= 0;
            A    <= IMM_U;
            B    <= 32'd12 ;
            sel  <= 5 ;

            end   /// note for that opration 0010111 PC+ alu out 

        
        default : sel <= 4'bx ;

        endcase

        end
    end

    /// ALU initiated
    alu a1 (A , B , sel , ALU_out , flag ) ;

endmodule

/*
Changes are made like addition of HLT AS  instructions to stopping the pc 
And LD as new one time executes after the reset


*/



module controller(

    input  clk , reset                  ,
    input  [9:0] PC                     ,
    input  [31:0]ALU_out                ,
    input  Branch_Taken                 ,
    input  [31:0] IR                    ,
    input  [31:0] MDR                   ,
    input  [31:0] Rs2                   , /// mainly  bcz of the store instruction
    input  [11:0] imm_I                 ,
    input  [19:0] imm_U                 ,
    
    output reg [9:0] New_PC             ,
    output reg En_IFU , En_IDU , En_IEX , En_write ,En_IM ,  // En_write for the data mem
    output reg [9:0]  Row_DM   ,
    output reg [1:0]  type_DM  ,
    output reg [31:0] data_DM  ,
    output reg        RegWrite ,load_imem       
    
);


    reg [2:0] state ;
     
    parameter IDEL  = 0 , LD= 1 , IF= 2 , ID = 3 , IE = 4 ,  ME= 5  , WB = 6;


    always @ (negedge clk) begin

        /// state transition :

        case(state)

            IDEL : state <= reset  ? IDEL : LD ;
            
            LD   : state <= reset  ? IDEL : IF ;

            IF   : state <= reset  ? IDEL : ID  ;

            ID   : state <= reset  ? IDEL : IE  ;

            IE   : state <= reset  ? IDEL : ME ;

            ME   : state <= reset  ? IDEL : WB ;

            WB   : state <= reset  ? IDEL : IF ;

            default : state <= IDEL ;

        endcase


        // New_PC register
        //
        // New_PC changes ONLY when a branch/jump needs a new PC.
        // Otherwise it retains its previous value.
        

        if (reset) begin

            New_PC <= 10'b0;

        end

        else if (state == WB) begin

            case(IR[6:0])

                // Branch
                7'b1100011 : begin

                    if (Branch_Taken)
                        New_PC <= imm_I[9:0];

                end


                // JAL
                7'b1101111 : begin

                    New_PC <= imm_U[9:0];

                end


                // JALR
                7'b1100111 : begin

                    New_PC <= ALU_out[9:0];

                end
                7'h7F : begin

                                    New_PC <= 10'bx  ;

                                end


                // All other instructions:
                // retain previous New_PC

                default : begin

                    New_PC <= New_PC;

                end

            endcase

        end

    end


    always @(*) begin

        // now hear actual signal will be activated crospoding to the current state

        En_IDU = 0 ;
        En_IEX = 0 ;
        En_IFU = 0 ;
        En_write = 0 ;
        RegWrite = 0 ;
        En_IM = 0 ;
        
        // CRITICAL FIX: Adding default values to prevent latches!

        Row_DM = 10'b0 ;
        type_DM = 2'b00 ;
        data_DM = 32'b0 ;
        load_imem = 0 ;


        case(state) 

            IDEL : begin

                En_IDU = 0 ;
                En_IEX = 0 ;
                En_IFU = 0 ;
                En_write = 0 ;
                load_imem = 0 ;
                RegWrite = 0 ;
                En_IM = 0 ;

            end


            LD : load_imem = 1 ;
            

            IF : begin

                En_IFU = 1 ;
                En_IM = 1 ;

            end  
            

            ID : En_IDU = 1 ;


            IE : En_IEX = 1 ;


            ME : begin

                 /// now this is done by the controller only no any new module as DM is for all not for a single module

                 // this state is mainly for the Load and store type instruction ;

                 case(IR[6:0])

                    //Lw type
                    7'b0000011  : begin

                        case(IR[14:12])

                            3'd0 : begin

                                    type_DM = 2'b00 ;
                                    Row_DM  = ALU_out[9:0];

                                    end


                            3'd1 :begin

                                    type_DM = 2'b01 ;
                                    Row_DM  = ALU_out[9:0];

                                    end


                            3'd2 :begin

                                    type_DM = 2'b10 ;
                                    Row_DM  = ALU_out[9:0];

                                    end


                            default : begin

                                type_DM = 2'bx ;
                                Row_DM = 10'bx ;

                            end
                                            
                        endcase

                    end


                    /// SW type

                    7'b0100011 : begin

                            En_write = 1 ;
                            
                            case(IR[14:12])

                                3'd0 : begin

                                        Row_DM       = ALU_out[9:0] ;
                                        data_DM[7:0] = Rs2[7:0]     ;
                                        data_DM[31:8]= 0 ;

                                        end

                                3'd1 :  begin

                                        Row_DM        = ALU_out[9:0] ;
                                        data_DM[15:0] = Rs2[15:0]     ;
                                        data_DM[31:16]= 16'b0 ;

                                        end

                                3'd2 :  begin

                                        Row_DM       = ALU_out[9:0] ;
                                        data_DM      = Rs2;

                                        end
                                
                                default : begin

                                    En_write = 0 ;
                                    Row_DM = 10'bx ;
                                    data_DM = 32'bx ;

                                end

                            endcase

                        end


                    default : begin

                        En_IDU = 0 ;
                        En_IEX = 0 ;
                        En_IFU = 0 ;
                        En_write = 0 ;
                        RegWrite = 0 ;

                    end

                    endcase

                    end


            WB : begin

                    /// write back so for R type give signal and data is alu output only and Rd 

                    case(IR[6:0])

                        // HLT instruction
                        // New_PC is NOT changed here.
                        // It retains its previous value.

                        

                        7'b0110011 : begin

                                    RegWrite = 1 ;
                                    data_DM  = ALU_out ;

                                    end


                    /// I type same as R 

                        7'b0010011  : begin

                                    RegWrite = 1 ;
                                    data_DM  = ALU_out ;

                                    end


                    //Load type  data is in the MDR  

                        7'b0000011  : begin

                                    RegWrite = 1 ;
                                    data_DM  = MDR ;

                                    end 


                        


                        7'b1101111  :  begin  ///JUMP type
                                        
                                        RegWrite = 1 ;
                                        data_DM  = {22'b0,PC};
                                        
                                    end


                        7'b1100111  : begin  /// JUMP but that I type also 

                                        RegWrite = 1 ;
                                        data_DM  = {22'b0,PC}; 
                                        

                                    end 


                        7'b0110111  : begin  // Load upper immediate :

                                    RegWrite = 1 ;
                                    data_DM  = ALU_out ;

                                end
                        

                        7'b0010111  : begin  /// same but added with PC

                                    RegWrite = 1 ;
                                    data_DM  = ALU_out + PC ;

                                end
                        

                        default : begin

                            RegWrite = 0;

                        end

                    endcase

                end


            default : begin

                En_IDU = 0 ;
                En_IEX = 0 ;
                En_IFU = 0 ;
                load_imem = 0 ;
                En_write = 0 ;
                RegWrite = 0 ;

            end

            endcase

    end

endmodule

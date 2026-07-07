//  This is the final Top module ::

`include "IM.v"
`include "IFU.v"
`include "IDU.v"
`include "IEX.v"
`include "Data_Memory.v"
`include "Controller.v"
`include "REG_bank.v"


module RISC_V(
    
    input clk , reset

);

///  now all the signal that are used:


wire    [9:0] PC            ;
wire    [31:0] IR           ;
wire    En_IM               ;

wire    En_IFU              ;
wire    Branch_Taken        ;        
wire    [9:0]New_PC              ;    

wire    En_IDU              ;               
wire    [2:0] Funct3        ;
wire    [6:0] OpCode        ;
wire    [4:0] Rd            ; 
wire    [4:0] Rs1           ;
wire    [4:0] Rs2           ;
wire    [6:0] Funct7        ;
wire    [11:0] imm_I        ;
wire    [19:0] imm_U        ;

wire    En_IEX              ;
wire    [31:0] Rs1_data     ;
wire    [31:0] Rs2_data     ;
wire    [31:0] ALU_out      ;    


wire    [31:0] MDR          ;                               
wire    [9:0]  Row_DM       ;                  
wire    [1:0]  type_DM      ;                  
wire    [31:0] data_DM      ;                  


wire    [4:0] rs1_addr      ;            
           
wire    [4:0] rd_addr       ;            
wire          RegWrite      ;
    

wire          En_write      ;

// now initiate the all the module 

controller CONTRLR(clk , reset , PC , ALU_out , Branch_Taken , IR , MDR , Rs2_data , imm_I , imm_U ,
        New_PC , En_IFU , En_IDU , En_IEX , En_write ,En_IM , Row_DM , type_DM , data_DM , RegWrite) ;

ifu  IF(clk, En_IFU ,reset , Branch_Taken , New_PC ,PC) ;

instruction_memory im (clk , reset ,En_IM, Branch_Taken ,   PC , New_PC  , IR);

idu DU (clk , En_IDU , reset , IR , Funct3 , OpCode , Rd , Rs1 , Rs2 , Funct7 , imm_I , imm_U ) ;

iex EX (clk , En_IEX , reset , Funct3 , OpCode , Rs1_data , Rs2_data , Funct7 , imm_I , imm_U , ALU_out , Branch_Taken) ;

registers R (clk, reset , RegWrite , Rs1 , Rs2 , Rd ,  data_DM , Rs1_data , Rs2_data ) ;

data_mem DM (clk , reset , Row_DM , type_DM , data_DM , En_write , MDR ) ;

endmodule
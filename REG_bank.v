module registers(
    input clk,              
    input reset,
    input RegWrite,         
    
    input [4:0] rs1_addr,   
    input [4:0] rs2_addr,   
    input [4:0] rd_addr ,    
    
    input [31:0] write_data,
    
    output [31:0] rs1_data, 
    output [31:0] rs2_data  
);

   
    reg [31:0] R [31:0];
    integer i;

    // 1. COMBINATIONAL READS (Instantaneous!)
    // If address is 0, always output 0. Otherwise, output the register data.

    assign rs1_data = (rs1_addr == 5'b00000) ? 32'b0 : R[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b00000) ? 32'b0 : R[rs2_addr];

    // 2. SYNCHRONOUS WRITES (Happens strictly on the clock tick)

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                R[i] <= 32'b0;
        end 
        else if (RegWrite && rd_addr != 5'b00000) begin
        
            // Never allow writing to register 0!
            R[rd_addr] <= write_data;
        end
    end
endmodule
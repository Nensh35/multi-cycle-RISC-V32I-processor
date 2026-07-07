module data_mem(
    input clk , reset ,
    input [9:0] Row   ,
    input [1:0] type  ,
    input [31:0] data_in ,
    input En_write,
    output [31:0] data_out

);

reg [31:0] mem [1023:0] ;
integer i ;
assign data_out  = ((type == 00) ? {{24{(mem[Row][7])}},{(mem[Row][7:0])}} : 
                   ((type == 2'b01) ? {{16{(mem[Row][15])}},{(mem[Row][15:0])}}:
                   (type == 2'b10) ?  (mem[Row][31:0]) : 32'bx ) ) ;

always @(negedge clk) begin

        if(reset) begin
        for (i = 0 ; i<= 1023 ; i= i + 1) 
           mem[i]= 0 ;  
        end

        else if(En_write) begin
            mem[Row] <= data_in ;
        end

        end
endmodule          
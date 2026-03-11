module memory_cycle(
clk,rst,RegWriteM,ResultSrcM,MemWriteM,ALUResultM,WriteDataM,RdM,PCplus4M,
RegWriteW,ResultSrcW,ReadDataW,RdW,PCplus4W,ALUResultW,VectorResultM,VectorResultW,
isVectorM,isVectorW,vector_mem_addr,vector_mem_wdata,vector_mem_we,VrdM,VrdW);

input clk,rst,RegWriteM,ResultSrcM,MemWriteM;
input [31:0] ALUResultM,WriteDataM,PCplus4M;
input [4:0]RdM;
input [127:0] VectorResultM;
input isVectorM;
input [31:0] vector_mem_addr;
input [31:0] vector_mem_wdata;
input vector_mem_we;
input [1:0] VrdM;

output [127:0] VectorResultW;
output RegWriteW,ResultSrcW;
output [4:0]RdW;
output [31:0]ALUResultW,ReadDataW,PCplus4W;
output isVectorW;
output [1:0] VrdW;

wire [31:0]ReadDataM;
wire [31:0] mem_addr;

reg [1:0] VrdM_r;
reg isVectorM_r;
reg [127:0] VectorResultM_r;
reg RegWriteM_r,ResultSrcM_r;
reg [4:0]RdM_r;
reg [31:0]ALUResultM_r,ReadDataM_r,PCplus4M_r;


assign mem_addr =          //address mux
        (isVectorM) ? vector_mem_addr :
                      ALUResultM;

wire [31:0] mem_wdata; //write data mux

assign mem_wdata =
        (isVectorM) ? vector_mem_wdata :
                      WriteDataM;
                      
wire mem_we;
                       //mux enable
assign mem_we =
        (isVectorM) ? vector_mem_we :
                      MemWriteM;
data_memory DM(
               .A(mem_addr),
               .WD(mem_wdata),
               .RD(ReadDataM),
               .WE(mem_we),
               .rst(rst),
               .clk(clk));
               
always@(posedge clk or negedge rst)
begin
     if(!rst)
       begin
         RegWriteM_r<=1'b0;
         ResultSrcM_r<=1'b0;
         RdM_r<=5'b0;
         ALUResultM_r<=32'h00000000;
         ReadDataM_r<=32'h00000000;
         PCplus4M_r<=32'h00000000;
         VectorResultM_r <= 128'd0;
         isVectorM_r <= 1'b0;
         VrdM_r <= 2'b00;
       end
       else
         begin
         RegWriteM_r<=RegWriteM;
         ResultSrcM_r<=ResultSrcM;
         RdM_r<=RdM;
         ALUResultM_r<=ALUResultM;
         ReadDataM_r<=ReadDataM;
         PCplus4M_r<=PCplus4M;
         VectorResultM_r <= VectorResultM;
         isVectorM_r <= isVectorM;
         VrdM_r <= VrdM;
         end

end

assign RegWriteW=RegWriteM_r;
assign ResultSrcW=ResultSrcM_r;
assign RdW=RdM_r;
assign ALUResultW=ALUResultM_r;
assign ReadDataW=ReadDataM_r;
assign PCplus4W=PCplus4M_r;
assign VectorResultW = VectorResultM_r;
assign isVectorW = isVectorM_r;
assign VrdW = VrdM_r;
endmodule

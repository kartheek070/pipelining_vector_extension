`include "fetch_cycle.v"
`include "decode_cycle.v"
`include "execute_cycle.v"
`include "memory_cycle.v"
`include "write_back_cycle.v"  
module pipeline_top(rst,clk);
input clk,rst;

wire RegWriteW,RegWriteE,ResultSrcE,ALUSrcE,MemWriteE,BranchE,PCSrcE,RegWriteM;
wire MemWriteM,ResultSrcM,ResultSrcW,isVectorM,vector_done,vector_mem_we,vector_busy,stall;
wire [31:0] PCTargetE,InstrD,PCD,PCplus4D,ResultW,RD1E,RD2E,ImmextE,PCE,PCplus4E;
wire [31:0] ALUResultM,ReadDataM,WriteDataM,PCplus4M,ALUResultW,ReadDataW,PCplus4W,vector_mem_addr,vector_mem_wdata;
wire [4:0]RdW,Rs1E,Rs2E,RdE,RdM;
wire [2:0]ALUControlE;
wire [1:0]ForwardA_E,ForwardB_E;
wire [127:0]VectorWriteDataM,VectorReadDataM;
wire [127:0] VectorSrc1E;
wire [127:0] VectorSrc2E;
wire [127:0] VectorResultW,VectorResultM;
wire isVectorE,isVectorW;
wire [1:0] Vrs1E, Vrs2E;
wire [1:0] VrdM, VrdW;
wire [127:0] VectorWritebackM;
assign VectorWritebackM =
       (ResultSrcM) ? VectorReadDataM : VectorResultM;


assign VectorWriteDataM = VectorResultM;
vector_load_store VLS(
    .clk(clk),
    .rst(rst),
    .start(isVectorM & ~vector_busy),
    .isLoad(ResultSrcM),
    .base_addr(ALUResultM),
    .write_vector(VectorWriteDataM),
    .read_vector(VectorReadDataM),
    .done(vector_done),

    .mem_addr(vector_mem_addr),
    .mem_wdata(vector_mem_wdata),
    .mem_rdata(ReadDataM),
    .mem_we(vector_mem_we),
    .vector_busy(vector_busy)
);

fetch_cycle FC(.clk(clk),
               .rst(rst),
               .PCtargetE(PCTargetE),
               .PCsrcE(PCsrcE),
               .InstrD(InstrD),
               .PCD(PCD),
               .PCplus4D(PCplus4D),
               .stall(stall));
               
decode_cycle DC(.clk(clk),
                .rst(rst),
                .RegWriteW(RegWriteW),
                .InstrD(InstrD),
                .PCD(PCD),
                .PCplus4D(PCplus4D),
                .RdW(RdW),
                .ResultW(ResultW),
                .RegWriteE(RegWriteE),
                .ResultSrcE(ResultSrcE),
                .MemWriteE(MemWriteE),
                .BranchE(BranchE),
                .ALUControlE(ALUControlE),
                .ALUSrcE(ALUSrcE),
                .RD1E(RD1E),
                .RD2E(RD2E),
                .PCE(PCE),
                .ImmextE(ImmextE),
                .PCplus4E(PCplus4E),
                .Rs1E(Rs1E),
                .Rs2E(Rs2E),
                .RdE(RdE),
                .stall(stall),
                .Vrs1E(Vrs1E),
                .Vrs2E(Vrs2E),
                .VectorSrc1E(VectorSrc1E),
                .VectorSrc2E(VectorSrc2E),
                .VectorResultW(VectorResultW),
                .isVectorE(isVectorE),
                .isVectorW(isVectorW));
                
execute_cycle EC(.clk(clk),
                 .rst(rst),
                 .RegWriteE(RegWriteE),
                 .ResultSrcE(ResultSrcE),
                 .MemWriteE(MemWriteE),
                 .BranchE(BranchE),
                 .ALUControlE(ALUControlE),
                 .ALUSrcE(ALUSrcE),
                 .RD1E(RD1E),
                 .RD2E(RD2E),
                 .PCE(PCE),
                 .RdE(RdE),
                 .ImmextE(ImmextE),
                 .PCplus4E(PCplus4E),
                 .PCsrcE(PCsrcE),
                 .PCTargetE(PCTargetE),
                 .RegWriteM(RegWriteM),
                 .MemWriteM(MemWriteM),
                 .ResultSrcM(ResultSrcM),
                 .ALUResultM(ALUResultM),
                 .WriteDataM(WriteDataM),
                 .RdM(RdM),
                 .PCplus4M(PCplus4M),
                 .ForwardA_E(ForwardA_E),
                 .ForwardB_E(ForwardB_E),
                 .ResultW(ResultW),
                 .isVectorE(isVectorE),
                 .VectorSrc1E(VectorSrc1E),
                 .VectorSrc2E(VectorSrc2E),
                 .VectorResultM(VectorResultM),
                 .isVectorM(isVectorM),
                 .VrdM(VrdM),
                 .stall(stall));
                   
memory_cycle MC(
                 .clk(clk),
                 .rst(rst),

                .RegWriteM(RegWriteM),
                .ResultSrcM(ResultSrcM),
                .MemWriteM(MemWriteM),

                .ALUResultM(ALUResultM),
                .WriteDataM(WriteDataM),

                .RdM(RdM),
                .PCplus4M(PCplus4M),

                .VectorResultM(VectorWritebackM),
                .VectorResultW(VectorResultW),

                .VrdM(VrdM),
                .isVectorM(isVectorM),
                .VrdW(VrdW),
                .isVectorW(isVectorW),

                .vector_mem_addr(vector_mem_addr),
                .vector_mem_wdata(vector_mem_wdata),
                .vector_mem_we(vector_mem_we),

                .RegWriteW(RegWriteW),
                .ResultSrcW(ResultSrcW),

                .ReadDataW(ReadDataW),
                .RdW(RdW),

                .PCplus4W(PCplus4W),
                .ALUResultW(ALUResultW));
                
write_back_cycle WC(
                    .clk(clk),
                    .rst(rst),
                    .ResultSrcW(ResultSrcW),
                    .ReadDataW(ReadDataW),
                    .ALUResultW(ALUResultW),
                    //.PCplus4W(PCplus4W),
                    .ResultW(ResultW));
 
hazard_unit HU(.rst(rst),
               .Rs1E(Rs1E),
               .Rs2E(Rs2E),
               .ForwardA_E(ForwardA_E),
               .ForwardB_E(ForwardB_E),
               .RdM(RdM),
               .RdW(RdW),
               .RegWriteM(RegWriteM),
               .RegWriteW(RegWriteW),
               .stall(stall),
               .vector_busy(vector_busy),
               .Vrs1E(Vrs1E),
               .Vrs2E(Vrs2E),
               .VrdM(VrdM),
               .VrdW(VrdW),
               .isVectorE(isVectorE), 
               .isVectorM(isVectorM),
               .isVectorW(isVectorW)
               );


endmodule

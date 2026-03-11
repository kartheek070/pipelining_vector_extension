module decode_cycle(clk,rst,RegWriteW,InstrD,PCD,PCplus4D,RdW,ResultW,RegWriteE,ResultSrcE,
                    MemWriteE,BranchE,ALUControlE,ALUSrcE,RD1E,RD2E,PCE,ImmextE,PCplus4E,
                    Rs1E,Rs2E,RdE,isVectorE,VectorSrc1E,VectorSrc2E,isVectorW,VectorResultW,stall
                    ,Vrs1E, Vrs2E);
                    
   input clk,rst,RegWriteW;
   input [4:0]RdW;
   input [31:0] InstrD,PCD,PCplus4D,ResultW;
   input isVectorW,stall;
   input [127:0] VectorResultW;
   
   output [127:0]VectorSrc1E,VectorSrc2E;
   output isVectorE;
   output RegWriteE,ResultSrcE,ALUSrcE,MemWriteE,BranchE;
   output [2:0]ALUControlE;
   output [31:0] RD1E,RD2E,ImmextE;
   output [4:0]Rs1E,Rs2E,RdE;
   output [31:0]PCE,PCplus4E;
   output [1:0] Vrs1E, Vrs2E;
   
   
   wire RegWriteD,ResultSrcD,ALUSrcD,MemWriteD,BranchD,isVectorD;
   wire [1:0]ImmSrcD;
   wire [2:0]ALUControlD;
   wire [31:0] RD1D,RD2D,ImmextD;
   wire [127:0] Vread1;
   wire [127:0] Vread2;
   wire [4:0] rs1_field;
wire [4:0] rs2_field;

assign rs1_field = InstrD[19:15];
assign rs2_field = InstrD[24:20];
   
   reg [1:0] Vrs1D_r;
   reg [1:0] Vrs2D_r;
   reg [127:0] VectorSrc1D_r, VectorSrc2D_r;
   reg isVectorD_r;
   reg RegWriteD_r,ResultSrcD_r,ALUSrcD_r,MemWriteD_r,BranchD_r;
   reg [2:0]ALUControlD_r;
   reg [31:0] RD1D_r,RD2D_r,ImmextD_r;
   reg [4:0]Rs1D_r,Rs2D_r,RDD_r;
   reg [31:0]PCD_r,PCplus4D_r;
   
 vector_regfile VRF(
    .clk(clk),
    .rst(rst),
    .we(isVectorW),
    .rs1(rs1_field[1:0]),
    .rs2(rs2_field[1:0]),
    .rd(RdW[1:0]),
    .write_data(VectorResultW),
    .read_data1(Vread1),
    .read_data2(Vread2)
);
   control_unit CU(.OP(InstrD[6:0]),
                  .RegWrite(RegWriteD),
                  .ImmSrc(ImmSrcD),
                  .ALUSrc(ALUSrcD),
                  .MemWrite(MemWriteD),
                  .ResultSrc(ResultSrcD),
                  .Branch(BranchD),
                  .fn3(InstrD[14:12]),
                  .fn7(InstrD[31:25]),
                  .ALUControl(ALUControlD),
                  .isVector(isVectorD));
                  
   register_file RF(.rst(rst),
                  .A1(InstrD[19:15]),
                  .A2(InstrD[24:20]),
                  .A3(RdW),
                  .wd3(ResultW),
                  .rd1(RD1D),
                  .we3(RegWriteW),
                  .rd2(RD2D),
                  .clk(clk));
                  
   extender_top EXT(.Instr(InstrD), //31:7
                .Immext(ImmextD),
                .ImmSrc(ImmSrcD));
 
 always @(posedge clk or negedge rst)
begin
    if(!rst)
    begin
        RegWriteD_r <= 1'b0;
        ALUSrcD_r <= 1'b0;
        MemWriteD_r <= 1'b0;
        ResultSrcD_r <= 1'b0;
        BranchD_r <= 1'b0;
        ALUControlD_r <= 3'b000;
        RD1D_r <= 32'h0;
        RD2D_r <= 32'h0;
        ImmextD_r <= 32'h0;
        RDD_r <= 5'h0;
        PCD_r <= 32'h0;
        PCplus4D_r <= 32'h0;
        Rs1D_r <= 5'h0;
        Rs2D_r <= 5'h0;
        isVectorD_r<=1'b0;
        Vrs1D_r <= 2'b00;
        Vrs2D_r <= 2'b00;
        VectorSrc2D_r <= 128'd0;
        VectorSrc1D_r <= 128'd0;
    end
    else if(!stall)
    begin
        isVectorD_r <= isVectorD ? 1'b1 : 1'b0;
        RegWriteD_r <= RegWriteD;
        ALUSrcD_r <= ALUSrcD;
        MemWriteD_r <= MemWriteD;
        ResultSrcD_r <= ResultSrcD;
        BranchD_r <= BranchD;
        ALUControlD_r <= ALUControlD;
        RD1D_r <= RD1D;
        RD2D_r <= RD2D;
        ImmextD_r <= ImmextD;
        RDD_r <= InstrD[11:7];
        PCD_r <= PCD;
        PCplus4D_r <= PCplus4D;
        Rs1D_r <= InstrD[19:15];
        Rs2D_r <= InstrD[24:20];
        Vrs1D_r <= rs1_field[1:0];
        Vrs2D_r <= rs2_field[1:0];
         VectorSrc2D_r <= Vread2;
        VectorSrc1D_r <= Vread1;
    end
end             
  assign RegWriteE=RegWriteD_r;
  assign ResultSrcE=ResultSrcD_r;
  assign ALUSrcE=ALUSrcD_r;
  assign MemWriteE=MemWriteD_r;
  assign BranchE=BranchD_r;
   assign ALUControlE=ALUControlD_r;
   assign RD1E=RD1D_r;
   assign RD2E=RD2D_r;
   assign ImmextE=ImmextD_r;
   assign Rs1E=Rs1D_r;
   assign Rs2E=Rs2D_r;
   assign RdE=RDD_r;
   assign PCE=PCD_r;
   assign PCplus4E=PCplus4D_r;
   assign isVectorE = isVectorD_r;
  assign VectorSrc1E = VectorSrc1D_r;
  assign VectorSrc2E = VectorSrc2D_r;
  assign Vrs1E = Vrs1D_r;
  assign Vrs2E = Vrs2D_r; 
endmodule

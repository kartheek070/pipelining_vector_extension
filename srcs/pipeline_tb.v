`timescale 1ns/1ps

module pipeline_tb;

reg clk;
reg rst;

pipeline_top DUT(
.clk(clk),
.rst(rst)
);

//////////////////////
// Clock generation
//////////////////////

initial begin
clk = 0;
forever #5 clk = ~clk;   // 10ns clock
end

//////////////////////
// Reset
//////////////////////

initial begin
rst = 0;
#20;
rst = 1;
end

//////////////////////
// Stop simulation
//////////////////////

initial begin
#200;
$finish;
end

//////////////////////
// Pipeline monitor
//////////////////////

always @(posedge clk)
begin
$display("------------------------------------------------------");
$display("Time=%0t  PC=%h  stall=%b  vector_busy=%b",
$time,
DUT.FC.PCF,
DUT.stall,
DUT.vector_busy);

$display("InstrD = %h", DUT.InstrD);
$display("ALUControlE = %b", DUT.ALUControlE);

$display("Vrs1E=%d  Vrs2E=%d  VrdM=%d",
          DUT.Vrs1E,
          DUT.Vrs2E,
          DUT.VrdM);

$display("VectorSrc1E = %h", DUT.VectorSrc1E);
$display("VectorSrc2E = %h", DUT.VectorSrc2E);

$display("VectorResultM = %h", DUT.VectorResultM);
$display("VectorResultW = %h", DUT.VectorResultW);

end

//////////////////////
// Final register dump
//////////////////////

initial begin
#200;


$display("=========== VECTOR REGISTER FILE ===========");

$display("v0 = %h", DUT.DC.VRF.vreg[0]);
$display("v1 = %h", DUT.DC.VRF.vreg[1]);
$display("v2 = %h", DUT.DC.VRF.vreg[2]);
$display("v3 = %h", DUT.DC.VRF.vreg[3]);



end

endmodule

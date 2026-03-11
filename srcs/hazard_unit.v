module hazard_unit(rst,Rs1E,Rs2E,ForwardA_E,ForwardB_E,RdM,RdW,RegWriteM,RegWriteW,
vector_busy,stall,
// new signals
Vrs1E,Vrs2E,VrdM,VrdW,
isVectorE,isVectorM,isVectorW);
input rst,RegWriteM,RegWriteW,vector_busy;
input [4:0]Rs1E,Rs2E,RdM,RdW;
input [1:0] Vrs1E,Vrs2E,VrdM,VrdW;
input isVectorE,isVectorM,isVectorW;
output [1:0]ForwardA_E,ForwardB_E;
output stall;

assign ForwardA_E=(rst==1'b0)?2'b00:
                   ((RegWriteM==1'b1) &(RdM!=5'h00)&(RdM==Rs1E))?2'b10:
                   ((RegWriteW==1'b1) &(RdW!=5'h00)&(RdW==Rs1E))?2'b01:2'b00;

assign ForwardB_E=(rst==1'b0)?2'b00:
                   ((RegWriteM==1'b1) &(RdM!=5'h00)&(RdM==Rs2E))?2'b10:
                   ((RegWriteW==1'b1) &(RdW!=5'h00)&(RdW==Rs2E))?2'b01:2'b00;   

wire vector_hazard;

assign vector_hazard =
 (isVectorE && isVectorM && (VrdM != 2'b00) && (Vrs1E == VrdM)) ||
 (isVectorE && isVectorM && (VrdM != 2'b00) && (Vrs2E == VrdM)) ||
 (isVectorE && isVectorW && (VrdW != 2'b00) && (Vrs1E == VrdW)) ||
 (isVectorE && isVectorW && (VrdW != 2'b00) && (Vrs2E == VrdW));
    
assign stall = vector_busy | vector_hazard;  //vector memory running or vector register dependency

                
endmodule

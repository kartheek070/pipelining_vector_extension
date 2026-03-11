module vector_alu #(parameter LANES = 4,
                    parameter WIDTH = 32)
(
    input [LANES*WIDTH-1:0] A,
    input [LANES*WIDTH-1:0] B,
    input [2:0] ALUControl,
    output [LANES*WIDTH-1:0] result
);

genvar i;

generate
for(i=0;i<LANES;i=i+1)
begin : VECTOR_LANE

wire [WIDTH-1:0] a_lane;
wire [WIDTH-1:0] b_lane;
reg  [WIDTH-1:0] r_lane;

assign a_lane = A[i*WIDTH +: WIDTH];
assign b_lane = B[i*WIDTH +: WIDTH];

always @(*)
begin
    case(ALUControl)

        3'b110: r_lane = a_lane + b_lane;   // VADD
        3'b111: r_lane = a_lane - b_lane;   // VSUB
        3'b100: r_lane = a_lane * b_lane;   // VMUL

        default: r_lane = 0;

    endcase
end

assign result[i*WIDTH +: WIDTH] = r_lane;

end
endgenerate

endmodule
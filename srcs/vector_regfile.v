module vector_regfile #(parameter Lanes=4,
                         parameter Width=32)
                         (input clk,we,rst,
                         input [1:0]rs1,rs2,rd,
                         input [Lanes*Width-1:0]write_data,
                         output [Lanes*Width-1:0]read_data1,read_data2
                         );
 reg [Lanes*Width-1:0]vreg[0:3];
 initial begin
    vreg[0] = 128'h00000004_00000003_00000002_00000001;
    vreg[1] = 128'h00000010_0000000C_00000008_00000004;
    vreg[2] = 128'h0;
    vreg[3] = 128'h0;
end
 always @(posedge clk)
begin
    if(we && rd != 0)
        vreg[rd] <= write_data;
end
 assign read_data1= vreg[rs1];
 assign read_data2=vreg[rs2];
endmodule

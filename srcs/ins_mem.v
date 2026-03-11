module ins_mem(A,rst,RD);
input [31:0]A;
input rst;
output  [31:0]RD;
//creation of memory
reg [31:0]mem[1023:0]; //1024 memories of 32bit sized
//the data inside A(A is address here) is read to RD
assign RD = (~rst) ? {32{1'b0}} : mem[A[31:2]];//memory is word(8bits)aligned and each instr is 32bits
                                             //so we jump by (32/8)4 bytes for each instruction 

//always @(posedge clk)
//begin
//if(!rst)
// RD<=32'd0;
// else
// RD<=mem[A[31:2]];
//end

/*initial begin //automates memory reading automatically from file
    $readmemh("memfile.h",mem); //readmemh means read memory in hexadecimal 
                                //reads input from memfile.h into mem
end*/
integer i;

initial begin



mem[0] = 32'h0010008B; // vadd v2, v0, v1
mem[1] = 32'h4011018B; // vsub v3, v2, v1
mem[2] = 32'h0021008B; // vmul v1, v0, v2




for(i=3;i<1024;i=i+1)
    mem[i] = 32'h00000013;

end


endmodule
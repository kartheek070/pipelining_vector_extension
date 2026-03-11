
// wire branch;  
 //truth table for main decoder
//assign Regwrite=((op==7'b0000011)|(op==7'b0110011))?1'b1:1'b0;
//assign ALUsrc=((op==7'b0000011)|(op==7'b0100011))?1'b1:1'b0;
//assign mem_write=(op==7'b0100011)?1'b1:1'b0;
//assign result_src=(op==7'b0000011)?1'b1:1'b0;
//assign branch=(op==7'b1100011)?1'b1:1'b0;
//assign imm_src=(op==7'b0100011)?2'b01:(op==7'b1100011)?2'b10:2'b00;
//assign ALUop=(op==7'b0110011)?2'b10:(op==7'b1100011)?2'b01:2'b00;
//assign Pcsrc=zero&branch;
module main_decoder(
  input zero,
  input[6:0]Op,
  output ResultSrc,MemWrite,ALUSrc,RegWrite,
  output [1:0] ImmSrc,ALUOp,
  output Branch,
  output isVector
 );
//new table for pipeline
assign RegWrite =
(Op == 7'b0000011 ||  // lw
 Op == 7'b0110011 ||  // R-type
 Op == 7'b0010011 ||  // I-type
 Op == 7'b0001011 ||  // vector ALU
 Op == 7'b0000111);   // vector load

assign ImmSrc =
(Op == 7'b0100011) ? 2'b01 :   // store
(Op == 7'b1100011) ? 2'b10 :   // branch
                   2'b00;

assign ALUSrc =
(Op == 7'b0000011 ||
 Op == 7'b0100011 ||
 Op == 7'b0010011 ||
 Op == 7'b0000111 ||   // vload
 Op == 7'b0100111);    // vstore

assign MemWrite =
(Op == 7'b0100011 ||   // sw
 Op == 7'b0100111);    // vstore

assign ResultSrc =
(Op == 7'b0000011 ||   // lw
 Op == 7'b0000111);    // vload

assign Branch =
(Op == 7'b1100011);

assign ALUOp =
(Op == 7'b0110011) ? 2'b10 :
(Op == 7'b1100011) ? 2'b01 :
(Op == 7'b0001011) ? 2'b11 :   // vector ALU
                    2'b00;

assign isVector =
(Op == 7'b0001011 ||
 Op == 7'b0000111 ||
 Op == 7'b0100111);

endmodule
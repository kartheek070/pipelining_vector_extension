module vector_load_store(
    input clk,
    input rst,
    input start,
    input isLoad,
    input [31:0] base_addr,
    input [127:0] write_vector,
    output reg [127:0] read_vector,
    output reg done,
    
    output [31:0] mem_addr,
    output [31:0] mem_wdata,
    input  [31:0] mem_rdata,
    output mem_we,vector_busy
);
reg [1:0] index;
reg busy;

assign vector_busy = busy;
assign mem_we = busy & ~isLoad;
assign mem_addr = base_addr + index*4;
assign mem_wdata = write_vector[index*32 +: 32];

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        index <= 0;
        done <= 0;
        busy <= 0;
    end

    else if(start && !busy)
    begin
        busy <= 1;
        index <= 0;
        done <= 0;
    end

    else if(busy)
    begin
        if(isLoad)
            read_vector[index*32 +: 32] <= mem_rdata;

        if(index == 2'b11)
        begin
            done <= 1;
            busy <= 0;
        end
        else
            index <= index + 1;
    end
end
endmodule

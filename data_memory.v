module data_memory(
    input clk,
    input reset,
    input memwrite,
    input memread,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] memdata_out
);

reg [31:0] D_memory [0:63];
integer k;

// Convert byte address → word index
wire [5:0] word_addr;
assign word_addr = address[7:2];

always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        for (k = 0; k < 64; k = k + 1)
            D_memory[k] <= 32'b0;

        memdata_out <= 32'b0;
    end
    else
    begin
        // WRITE
        if (memwrite)
            D_memory[word_addr] <= write_data;

        // READ (synchronous – safer)
        if (memread)
            memdata_out <= D_memory[word_addr];
        else
            memdata_out <= 32'b0;
    end
end

endmodule
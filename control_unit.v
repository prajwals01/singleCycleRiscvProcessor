module control_unit(
    input [6:0] opcode,
    output reg branch,
    output reg memread,
    output reg memtoreg,
    output reg memwrite,
    output reg alusrc,
    output reg regwrite,
    output reg [1:0] aluop
);

always @(*)
begin
    case(opcode)

    // R-type (add, sub, and, or)
    7'b0110011:
    begin
        alusrc   = 0;
        memtoreg = 0;
        regwrite = 1;
        memread  = 0;
        memwrite = 0;
        branch   = 0;
        aluop    = 2'b10;
    end

    // lw
    7'b0000011:
    begin
        alusrc   = 1;
        memtoreg = 1;
        regwrite = 1;
        memread  = 1;
        memwrite = 0;
        branch   = 0;
        aluop    = 2'b00;
    end

    // sw
    7'b0100011:
    begin
        alusrc   = 1;
        memtoreg = 0;
        regwrite = 0;
        memread  = 0;
        memwrite = 1;
        branch   = 0;
        aluop    = 2'b00;
    end

    // branch
    7'b1100011:
    begin
        alusrc   = 0;
        memtoreg = 0;
        regwrite = 0;
        memread  = 0;
        memwrite = 0;
        branch   = 1;
        aluop    = 2'b01;
    end

    // I-type (addi, ori)
    7'b0010011:
    begin
        alusrc   = 1;
        memtoreg = 0;
        regwrite = 1;
        memread  = 0;
        memwrite = 0;
        branch   = 0;
        aluop    = 2'b00;
    end

    default:
    begin
        alusrc   = 0;
        memtoreg = 0;
        regwrite = 0;
        memread  = 0;
        memwrite = 0;
        branch   = 0;
        aluop    = 2'b00;
    end

    endcase
end

endmodule
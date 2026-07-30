module top(clk,reset);
input clk,reset;
wire [31:0] pc_top,instruction_top,rd1_top,rd2_top,immext_top,mux1_top,sum_out_top,nextopc_top,pcin_top,address_top,memdata_top,writeback_top;
wire regwrite_top,ALUsrc_top,zero_top,branch_top,sel2_top,memtoreg_top,memwrite_top,memread_top;
wire[1:0] ALUop_top;
wire[3:0] control_top;

program_counter pc(.clk(clk),.reset(reset),.pc_in(nextopc_top),.pc_out(pc_top));

pcplus4 pc_adder(.frompc(pc_top),.nextopc(nextopc_top));

instruction_mem  inst_mem(.clk(clk),.reset(reset),.read_address(pc_top),.instruction_out(instruction_top));

reg_file reg_file(.clk(clk),.reset(reset),.rs1(instruction_top[19:15]),.rs2(instruction_top[24:20]),.regwrite(regwrite_top),.rd((instruction_top[11:7])),.write_data(writeback_top),.read_data1(rd1_top),.read_data2(rd2_top));

immgen immgen(.opcode(instruction_top[6:0]),.instruction(instruction_top),.immext(immext_top));

control_unit control_unit(.opcode(instruction_top[6:0]),.branch(branch_top),.memread(memread_top),.memtoreg(memtoreg_top),.aluop(ALUop_top),.memwrite(memwrite_top),.alusrc(ALUsrc_top),.regwrite(regwrite_top));

alu_control alu_control(.ALUop(ALUop_top),.fun7(instruction_top[30]),.fun3(instruction_top[14:12]),.control_out(control_top));

alu_unit alu(.A(rd1_top),.B(mux1_top),.control_in(control_top),.ALU_result(address_top),.zero(zero_top));

mux1 ALU_mux(.sel1(ALUsrc_top),.A1(rd2_top),.B1(immext_top),.mux1_out(mux1_top));

adder adder(.in_1(pc_top),.in_2(immext_top),.sum_out(sum_out_top));

and_logic AND(.branch(branch_top),.zero(zero_top),.and_out(sel2_top));

mux2 adder_mux(.sel2(sel2_top),.A2(nextopc_top),.B2(sum_out_top),.mux2_out(pcin_top));

data_memory data_mem(.clk(clk),.reset(reset),.memwrite(memwrite_top),.memread(memread_top),.address(address_top),.write_data(rd2_top),.memdata_out(memdata_top));

mux3 memory_mux(.sel3(memtoreg_top),.A3(address_top),.B3(memdata_top),.mux3_out(writeback_top));
  
endmodule
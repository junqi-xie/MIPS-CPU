module cpu (clock, reset, inst, mem_out, pc, alu_out, reg_data2, mem_write, overflow);

   input [31:0] inst, mem_out;
   input clock, reset;
   output [31:0] pc, alu_out, reg_data2;
   output mem_write, overflow;

   //////////////////////////////////////////////////
   // Instruction Fetch

   wire [31:0] new_pc, pc;
   dff32 pc_reg (clock, reset, new_pc, pc);
   wire [31:0] next_pc = pc + 32'h4; // next sequential instruction

   //////////////////////////////////////////////////
   // Instruction Decode

   wire [5:0] op = inst[31:26];
   wire [4:0] rs = inst[25:21];
   wire [4:0] rt = inst[20:16];
   wire [4:0] rd = inst[15:11];
   wire [4:0] shamt = inst[10:6];
   wire [5:0] funct = inst[5:0];
   wire [15:0] immediate = inst[15:0];
   wire [25:0] address = inst[25:0];

   // Control Unit and Signals
   wire zero, sign, sign_ext, shift, alu_src, mem_write, reg_src,
        reg_dst, reg_write, branch, jump, jal, jr;
   control cu (op, funct, zero, sign, sign_ext, shift,
               alu_src, mem_write, reg_src, reg_dst, reg_write,
               branch, jump, jal, jr);

   // Register Files
   wire [31:0] reg_data1, write_data;
   wire [4:0] write_reg = reg_dst ? rd : (jal ? 5'h1f : rt);
   registers regs (clock, reset, rs, rt, write_reg, 
                   write_data, reg_write, reg_data1, reg_data2);

   // Immediate Extension
   wire [31:0] immediate_ext;
   extender ext (immediate, sign_ext, immediate_ext);

   //////////////////////////////////////////////////
   // Execute

   wire [31:0] shamt_ext = { 27'b0, shamt };
   wire [31:0] alu_a = shift ? shamt_ext : reg_data1;
   wire [31:0] alu_b = alu_src ? immediate_ext : reg_data2;
   wire [3:0] alu_ctl;
   wire alu_overflow;
   alu_control ac (op, funct, alu_ctl);
   alu a (alu_ctl, alu_a, alu_b, alu_out, zero, alu_overflow);

   //////////////////////////////////////////////////
   // Memory

   // PC Update
   wire [31:0] jump_addr = { next_pc[31:28], address, 2'b0 };
   wire [31:0] branch_addr = next_pc + (immediate_ext << 2);

   // Exception Handling
   assign overflow = sign & alu_overflow;
   assign new_pc = branch ? branch_addr : (jr ? reg_data1 :
                   (jump ? jump_addr : (overflow ? 8'h80 : next_pc)));

   //////////////////////////////////////////////////
   // Write Back

   assign write_data = reg_src ? mem_out : (jal ? next_pc : alu_out);

endmodule
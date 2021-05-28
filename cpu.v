module cpu (clock, reset, if_inst, mem_mem_out, pc,
            mem_alu_out, mem_reg_mem, mem_mem_write, overflow);

   input [31:0] if_inst, mem_mem_out;
   input clock, reset;
   output [31:0] pc, mem_alu_out, mem_reg_mem;
   output mem_mem_write, overflow;

   //////////////////////////////////////////////////
   // Instruction Fetch

   // PC Update
   wire [31:0] branch_addr, reg_a, reg_b, jump_addr, if_next_pc;
   wire id_branch, id_jr, id_jump;
   wire [31:0] new_pc = id_branch ? branch_addr : (id_jr ? reg_a :
                        (id_jump ? jump_addr : (overflow ? 8'h80 : if_next_pc)));

   // PC Register
   wire [31:0] pc;
   wire pc_stall;
   dff32 pc_reg (clock, reset, pc_stall, new_pc, pc);
   assign if_next_pc = pc + 32'h4; // next sequential instruction
   
   // IF/ID Pipeline Register
   wire [31:0] id_next_pc, id_inst;
   wire if_id_stall, if_id_flush;
   if_id if_id_reg (clock, reset, if_id_stall, if_id_flush,
                    if_next_pc, if_inst, id_next_pc, id_inst);

   //////////////////////////////////////////////////
   // Instruction Decode

   wire [5:0] id_op = id_inst[31:26];
   wire [4:0] id_rs = id_inst[25:21];
   wire [4:0] id_rt = id_inst[20:16];
   wire [4:0] id_rd = id_inst[15:11];
   wire [4:0] id_shamt = id_inst[10:6];
   wire [5:0] id_funct = id_inst[5:0];
   wire [15:0] id_immediate = id_inst[15:0];
   wire [25:0] id_address = id_inst[25:0];

   // Control Unit and Signals
   wire zero, id_sign, id_sign_ext, id_shift, id_alu_src, id_mem_write, id_reg_src,
        id_reg_dst, id_reg_write, id_reg_fwd, id_pc_update, id_jal;
   control cu (id_op, id_funct, zero, id_sign, id_sign_ext, id_shift,
               id_alu_src, id_mem_write, id_reg_src, id_reg_dst, id_reg_write,
               id_reg_fwd, id_pc_update, id_branch, id_jump, id_jal, id_jr);

   // Register Files
   wire [31:0] id_reg_data1, id_reg_data2, wb_write_data;
   wire [4:0] wb_write_reg;
   wire wb_reg_write;
   wire reg_clock = ~clock;
   registers regs (reg_clock, reset, id_rs, id_rt, wb_write_reg,
                   wb_write_data, wb_reg_write, id_reg_data1, id_reg_data2);

   // Forwarded Registers (only when `id_reg_fwd`)
   wire ex_reg_a, ex_reg_b;
   assign reg_a = ex_reg_a ? mem_alu_out : id_reg_data1;
   assign reg_b = ex_reg_b ? mem_alu_out : id_reg_data2;
   assign zero = (reg_a == reg_b);

   // Immediate Extension
   wire [31:0] id_shamt_ext = { 27'b0, id_shamt };
   wire [31:0] id_immediate_ext;
   extender ext (id_immediate, id_sign_ext, id_immediate_ext);

   // PC Update
   assign jump_addr = { id_next_pc[31:28], id_address, 2'b0 };
   assign branch_addr = id_next_pc + (id_immediate_ext << 2);

   // ID/EX Pipeline Register
   wire [31:0] ex_next_pc, ex_reg_data1, ex_reg_data2, ex_shamt_ext, ex_immediate_ext;
   wire [5:0]  ex_op, ex_funct;
   wire [4:0]  ex_rs, ex_rt, ex_rd;
   wire ex_sign, ex_shift, ex_alu_src, ex_mem_write, ex_reg_src, ex_reg_dst, ex_reg_write, ex_jal;
   wire id_ex_stall, id_ex_flush;
   id_ex id_ex_reg (clock, reset, id_ex_stall, id_ex_flush,
                    id_op, id_rs, id_rt, id_rd, id_funct, id_shamt_ext, id_immediate_ext,
                    id_next_pc, id_reg_data1, id_reg_data2, id_sign, id_shift,
                    id_alu_src, id_mem_write, id_reg_src, id_reg_dst, id_reg_write, id_jal,
                    ex_op, ex_rs, ex_rt, ex_rd, ex_funct, ex_shamt_ext, ex_immediate_ext,
                    ex_next_pc, ex_reg_data1, ex_reg_data2, ex_sign, ex_shift,
                    ex_alu_src, ex_mem_write, ex_reg_src, ex_reg_dst, ex_reg_write, ex_jal);

   //////////////////////////////////////////////////
   // Execute

   // Forwarded ALU Inputs
   wire ex_alu_a, ex_alu_b, mem_alu_a, mem_alu_b;
   wire [31:0] alu_a = ex_shift ? ex_shamt_ext : (mem_alu_a ? wb_write_data :
                       (ex_alu_a ? mem_alu_out : ex_reg_data1));
   wire [31:0] ex_reg_mem = mem_alu_b ? wb_write_data :
                            (ex_alu_b ? mem_alu_out : ex_reg_data2);
   wire [31:0] alu_b = ex_alu_src ? ex_immediate_ext : ex_reg_mem;

   // ALU and ALU Control
   wire [31:0] ex_alu_out;
   wire [3:0] alu_ctl;
   wire alu_zero, alu_overflow;
   alu_control ac (ex_op, ex_funct, alu_ctl);
   alu a (alu_ctl, alu_a, alu_b, ex_alu_out, alu_zero, alu_overflow);

   // Exception Handling
   assign overflow = ex_sign & alu_overflow;

   // Select Write Register
   wire [4:0] ex_write_reg = ex_reg_dst ? ex_rd : (ex_jal ? 5'h1f : ex_rt);

   // EX/MEM Pipeline Register
   wire [31:0] mem_next_pc;
   wire [4:0]  mem_write_reg;
   wire mem_reg_src, mem_reg_write, mem_jal;
   ex_mem ex_mem_reg (clock, reset,
                      ex_next_pc, ex_alu_out, ex_reg_mem, ex_write_reg,
                      ex_mem_write, ex_reg_src, ex_reg_write, ex_jal,
                      mem_next_pc, mem_alu_out, mem_reg_mem, mem_write_reg,
                      mem_mem_write, mem_reg_src, mem_reg_write, mem_jal);

   //////////////////////////////////////////////////
   // Memory

   // MEM/WB Pipeline Register
   wire [31:0] wb_next_pc, wb_alu_out, wb_mem_out;
   wire wb_reg_src, wb_jal;
   mem_wb mem_wb_reg (clock, reset,
                      mem_next_pc, mem_alu_out, mem_mem_out, mem_write_reg,
                      mem_reg_src, mem_reg_write, mem_jal,
                      wb_next_pc, wb_alu_out, wb_mem_out, wb_write_reg,
                      wb_reg_src, wb_reg_write, wb_jal);

   //////////////////////////////////////////////////
   // Write Back

   // Select Write Back Data
   assign wb_write_data = wb_reg_src ? wb_mem_out : (wb_jal ? wb_next_pc : wb_alu_out);

   //////////////////////////////////////////////////
   // Pipeline Controllers

   // Forwarding Unit
   forwarding f (mem_write_reg, wb_write_reg, mem_reg_write, wb_reg_write,
                 ex_rs, ex_rt, ex_alu_a, ex_alu_b, mem_alu_a, mem_alu_b,
                 id_rs, id_rt, ex_reg_a, ex_reg_b);
   
   // Hazard Detection Unit
   hazard_detection h (ex_reg_src, ex_reg_write, mem_reg_src, ex_write_reg, mem_write_reg,
                       id_rs, id_rt, id_reg_fwd, id_pc_update, overflow,
                       pc_stall, if_id_stall, if_id_flush, id_ex_stall, id_ex_flush);

endmodule
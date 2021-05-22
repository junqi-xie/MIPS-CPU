module id_ex (clock, reset, stall, flush,
              id_op, id_rs, id_rt, id_rd, id_funct, id_shamt_ext, id_immediate_ext,
              id_next_pc, id_reg_data1, id_reg_data2, id_sign, id_shift,
              id_alu_src, id_mem_write, id_reg_src, id_reg_dst, id_reg_write, id_jal,
              ex_op, ex_rs, ex_rt, ex_rd, ex_funct, ex_shamt_ext, ex_immediate_ext,
              ex_next_pc, ex_reg_data1, ex_reg_data2, ex_sign, ex_shift,
              ex_alu_src, ex_mem_write, ex_reg_src, ex_reg_dst, ex_reg_write, ex_jal);

   input [31:0] id_next_pc, id_reg_data1, id_reg_data2, id_shamt_ext, id_immediate_ext;
   input [5:0]  id_op, id_funct;
   input [4:0]  id_rs, id_rt, id_rd;
   input id_sign, id_shift, id_alu_src, id_mem_write, id_reg_src, id_reg_dst, id_reg_write, id_jal;
   input clock, reset, stall, flush;
   output reg [31:0] ex_next_pc, ex_reg_data1, ex_reg_data2, ex_shamt_ext, ex_immediate_ext;
   output reg [5:0]  ex_op, ex_funct;
   output reg [4:0]  ex_rs, ex_rt, ex_rd;
   output reg ex_sign, ex_shift, ex_alu_src, ex_mem_write, ex_reg_src, ex_reg_dst, ex_reg_write, ex_jal;

   always @(posedge clock)
   begin
      if (reset || flush) // reset the registers
      begin
         ex_op <= 0;
         ex_rs <= 0;
         ex_rt <= 0;
         ex_rd <= 0;
         ex_funct <= 0;
         ex_shamt_ext <= 0;
         ex_immediate_ext <= 0;
         ex_next_pc <= 0;
         ex_reg_data1 <= 0;
         ex_reg_data2 <= 0;
         ex_sign <= 0;
         ex_shift <= 0;
         ex_alu_src <= 0;
         ex_mem_write <= 0;
         ex_reg_src <= 0;
         ex_reg_dst <= 0;
         ex_reg_write <= 0;
         ex_jal <= 0;
      end
      else if (!stall)
      begin
         ex_op <= id_op;
         ex_rs <= id_rs;
         ex_rt <= id_rt;
         ex_rd <= id_rd;
         ex_funct <= id_funct;
         ex_shamt_ext <= id_shamt_ext;
         ex_immediate_ext <= id_immediate_ext;
         ex_next_pc <= id_next_pc;
         ex_reg_data1 <= id_reg_data1;
         ex_reg_data2 <= id_reg_data2;
         ex_sign <= id_sign;
         ex_shift <= id_shift;
         ex_alu_src <= id_alu_src;
         ex_mem_write <= id_mem_write;
         ex_reg_src <= id_reg_src;
         ex_reg_dst <= id_reg_dst;
         ex_reg_write <= id_reg_write;
         ex_jal <= id_jal;
      end
   end

endmodule
module forwarding (mem_write_reg, wb_write_reg, mem_reg_write, wb_reg_write,
                   ex_rs, ex_rt, ex_alu_a, ex_alu_b, mem_alu_a, mem_alu_b,
                   id_rs, id_rt, ex_reg_a, ex_reg_b);

   input [4:0] mem_write_reg, wb_write_reg, ex_rs, ex_rt, id_rs, id_rt;
   input mem_reg_write, wb_reg_write;
   output ex_alu_a, ex_alu_b, mem_alu_a, mem_alu_b,
          ex_reg_a, ex_reg_b;

   wire mem_reg = mem_reg_write && (mem_write_reg != 0);
   wire wb_reg = wb_reg_write && (wb_write_reg != 0);

   assign ex_alu_a = mem_reg && (mem_write_reg == ex_rs);
   assign ex_alu_b = mem_reg && (mem_write_reg == ex_rt);
   assign mem_alu_a = wb_reg && (wb_write_reg == ex_rs) && !ex_alu_a;
   assign mem_alu_b = wb_reg && (wb_write_reg == ex_rt) && !ex_alu_b;

   assign ex_reg_a = mem_reg && (mem_write_reg == id_rs);
   assign ex_reg_b = mem_reg && (mem_write_reg == id_rt);

endmodule
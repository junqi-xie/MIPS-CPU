module hazard_detection (ex_mem_read, ex_reg_write, mem_mem_read, ex_write_reg, mem_write_reg,
                         id_rs, id_rt, reg_fwd, pc_update, overflow,
                         pc_stall, if_id_stall, if_id_flush, id_ex_stall, id_ex_flush);

   input [4:0] ex_write_reg, mem_write_reg, id_rs, id_rt;
   input ex_mem_read, ex_reg_write, mem_mem_read, reg_fwd, pc_update, overflow;
   output pc_stall, if_id_stall, if_id_flush, id_ex_stall, id_ex_flush;

   wire load_hazard = ex_mem_read && (ex_write_reg != 0) &&
                      ((ex_write_reg == id_rs) || (ex_write_reg == id_rt));
   wire ex_reg_hazard = reg_fwd && ex_reg_write && (ex_write_reg != 0) &&
                        ((ex_write_reg == id_rs) || (ex_write_reg == id_rt));
   wire mem_reg_hazard = reg_fwd && mem_mem_read && (mem_write_reg != 0) &&
                         ((mem_write_reg == id_rs) || (mem_write_reg == id_rt));

   wire data_hazard = load_hazard || ex_reg_hazard || mem_reg_hazard;
   wire control_hazard = pc_update || overflow;

   assign pc_stall = data_hazard;
   assign if_id_stall = data_hazard;
   assign if_id_flush = control_hazard && !data_hazard;
   assign id_ex_stall = 0;
   assign id_ex_flush = data_hazard;

endmodule
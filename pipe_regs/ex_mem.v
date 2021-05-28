module ex_mem (clock, reset,
               ex_next_pc, ex_alu_out, ex_reg_mem, ex_write_reg,
               ex_mem_write, ex_reg_src, ex_reg_write, ex_jal,
               mem_next_pc, mem_alu_out, mem_reg_mem, mem_write_reg,
               mem_mem_write, mem_reg_src, mem_reg_write, mem_jal);

   input [31:0] ex_next_pc, ex_alu_out, ex_reg_mem;
   input [4:0]  ex_write_reg;
   input ex_mem_write, ex_reg_src, ex_reg_write, ex_jal;
   input clock, reset;
   output reg [31:0] mem_next_pc, mem_alu_out, mem_reg_mem;
   output reg [4:0]  mem_write_reg;
   output reg mem_mem_write, mem_reg_src, mem_reg_write, mem_jal;

   always @(posedge clock)
   begin
      if (reset) // reset the registers
      begin
         mem_next_pc <= 0;
         mem_alu_out <= 0;
         mem_reg_mem <= 0;
         mem_write_reg <= 0;
         mem_mem_write <= 0;
         mem_reg_src <= 0;
         mem_reg_write <= 0;
         mem_jal <= 0;
      end
      else
      begin
         mem_next_pc <= ex_next_pc;
         mem_alu_out <= ex_alu_out;
         mem_reg_mem <= ex_reg_mem;
         mem_write_reg <= ex_write_reg;
         mem_mem_write <= ex_mem_write;
         mem_reg_src <= ex_reg_src;
         mem_reg_write <= ex_reg_write;
         mem_jal <= ex_jal;
      end
   end

endmodule
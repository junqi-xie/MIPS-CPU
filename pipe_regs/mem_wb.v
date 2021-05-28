module mem_wb (clock, reset,
               mem_next_pc, mem_alu_out, mem_mem_out, mem_write_reg,
               mem_reg_src, mem_reg_write, mem_jal,
               wb_next_pc, wb_alu_out, wb_mem_out, wb_write_reg,
               wb_reg_src, wb_reg_write, wb_jal);

   input [31:0] mem_next_pc, mem_alu_out, mem_mem_out;
   input [4:0]  mem_write_reg;
   input mem_reg_src, mem_reg_write, mem_jal;
   input clock, reset;
   output reg [31:0] wb_next_pc, wb_alu_out, wb_mem_out;
   output reg [4:0]  wb_write_reg;
   output reg wb_reg_src, wb_reg_write, wb_jal;

   always @(posedge clock)
   begin
      if (reset) // reset the registers
      begin
         wb_next_pc <= 0;
         wb_alu_out <= 0;
         wb_mem_out <= 0;
         wb_write_reg <= 0;
         wb_reg_src <= 0;
         wb_reg_write <= 0;
         wb_jal <= 0;
      end
      else
      begin
         wb_next_pc <= mem_next_pc;
         wb_alu_out <= mem_alu_out;
         wb_mem_out <= mem_mem_out;
         wb_write_reg <= mem_write_reg;
         wb_reg_src <= mem_reg_src;
         wb_reg_write <= mem_reg_write;
         wb_jal <= mem_jal;
      end
   end

endmodule
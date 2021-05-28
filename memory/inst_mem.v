module inst_mem (clock, mem_clock, addr, inst);

   input [31:0] addr;
   input clock, mem_clock;
   output [31:0] inst;

   wire inst_clock = clock & ~mem_clock;

   rom inst_rom (addr[7:2], inst_clock, inst);

endmodule
module data_mem (clock, mem_clock, addr, data_in, mem_write, data_out);

   input [31:0] addr, data_in;
   input mem_write, clock, mem_clock;
   output [31:0] data_out;

   wire write_enable = mem_write & ~clock;
   wire data_clock = mem_clock & ~clock;

   ram data_ram (addr[7:2], data_clock, data_in, write_enable, data_out);

endmodule
/////////////////////////////////////////////////////////////
//                                                         //
// EI332 Computer Organization                             //
//                                                         //
// A Sequential MIPS Computer Implementation               //
//                                                         //
/////////////////////////////////////////////////////////////

module computer (mem_clock, reset_bar, input1, input2, output1, output2, output3, overflow);

   input mem_clock, reset_bar;
   input [4:0] input1, input2;
   output [13:0] output1, output2, output3;
   output overflow;

   // Clock and reset
   wire clock;
   multiplier m (mem_clock, clock, reset);

   wire reset = ~reset_bar;

   // Connection between CPU, Instruction Memory and Data Memory
   wire [31:0] inst, data_out, pc, addr, mem_in;
   wire output_write;
   cpu c (clock, reset, inst, data_out, pc, addr, mem_in, output_write, overflow);

   // Instruction I/O
   inst_mem im (clock, mem_clock, pc, inst);

   // Data I/O
   wire [31:0] mem_out, input_out;
   wire memory = addr[7:0] < 8'ha0;

   assign data_out = memory ? mem_out : input_out;
   wire mem_write = memory && output_write;
   wire data_write = !memory && output_write;

   data_mem dm (clock, mem_clock, addr, mem_in, mem_write, mem_out);
   input_control ic (addr, input1, input2, input_out);
   output_control oc (clock, addr, mem_in, data_write, output1, output2, output3);

endmodule
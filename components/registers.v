module registers (clock, reset, read1, read2, write_reg,
                 write_data, reg_write, data1, data2);

   input [4:0]  read1, read2, write_reg;
   input [31:0] write_data;
   input reg_write, clock, reset;
   output [31:0] data1, data2;
   reg [31:0] register [31:0]; // 32 registers each 32 bits long

   assign data1 = register[read1];
   assign data2 = register[read2];

   always @(posedge clock or posedge reset)
   begin
      if (reset) // reset the registers
      begin
         integer i;
         for (i = 0; i < 32; i = i + 1)
            register[i] <= 0;
      end
      else
      begin
         if ((write_reg != 0) && reg_write)
            // write the register with new value
            register[write_reg] <= write_data;
      end
   end

endmodule
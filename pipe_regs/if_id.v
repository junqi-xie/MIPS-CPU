module if_id (clock, reset, stall, flush,
              if_next_pc, if_inst, id_next_pc, id_inst);

   input [31:0] if_next_pc, if_inst;
   input clock, reset, stall, flush;
   output reg [31:0] id_next_pc, id_inst;

   always @(posedge clock)
   begin
      if (reset || flush) // reset the registers
      begin
         id_next_pc <= 0;
         id_inst <= 0;
      end
      else if (!stall)
      begin
         id_next_pc <= if_next_pc;
         id_inst <= if_inst;
      end
   end

endmodule
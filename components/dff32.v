module dff32 (clock, reset, stall, in, out);

   input [31:0] in;
   input clock, reset, stall;
   output reg [31:0] out;

   always @(posedge clock or posedge reset)
   begin
      if (reset) // reset the registers
         out <= -4;
      else if (!stall)
         out <= in;
   end

endmodule
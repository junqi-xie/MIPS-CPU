module dff32 (clock, reset, in, out);

   input [31:0] in;
   input clock, reset;
   output reg [31:0] out;

   always @(posedge clock or posedge reset)
   begin
      if (reset) // reset the registers
         out <= -4;
      else
         out <= in;
   end

endmodule
module multiplier (in, out, reset);

   input in, reset;
   output reg out;

   always @(posedge in or posedge reset)
   begin
      if (reset) // reset the clock
         out <= 0;
      else
         out <= ~out;
   end

endmodule
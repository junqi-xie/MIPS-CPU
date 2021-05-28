module extender (in, sign_ext, out);
   
   input [15:0] in;
   input sign_ext;
   output reg [31:0] out;

   wire sign_bit = sign_ext & in[15]; // sign bit at sign_ext signal

   always @(in or sign_bit) // reevaluate if these change
   begin
      out <= { { 16{ sign_bit } }, in }; // extend the immediate
   end

endmodule
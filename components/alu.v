module alu (alu_ctl, a, b, alu_out, zero, overflow);

   input [3:0]  alu_ctl;
   input [31:0] a, b;
   output reg [31:0] alu_out;
   output zero, overflow;

   assign zero = (alu_out == 0); // zero is true if alu_out is 0
   assign overflow = (alu_ctl == 4'b0010) && // overflow bit for add
                        ((~a[31] & ~b[31] & alu_out[31]) |
                        (a[31] & b[31] & ~alu_out[31])) ||
                     (alu_ctl == 4'b0011) && // overflow bit for subtract
                        ((~a[31] & b[31] & alu_out[31]) |
                        (a[31] & ~b[31] & ~alu_out[31]));

   always @(alu_ctl or a or b) // reevaluate if these change
   begin
      case (alu_ctl)
         4'b0000: alu_out <= a & b;                     // 0000: AND
         4'b0001: alu_out <= a | b;                     // 0001: OR
         4'b0010: alu_out <= a + b;                     // 0010: add
         4'b0011: alu_out <= a - b;                     // 0011: subtract
         4'b0110: alu_out <= ($signed(a) < $signed(b)); // 0110: set on less than (signed)
         4'b0111: alu_out <= (a < b);                   // 0111: set on less than

         4'b1000: alu_out <= b << a;                    // 1000: shift left logical
         4'b1001: alu_out <= b >> a;                    // 1001: shift right logical
         4'b1010: alu_out <= $signed(b) >>> a;          // 1010: shift right arithmetic

         4'b1100: alu_out <= a ^ b;                     // 1100: XOR
         4'b1101: alu_out <= ~(a | b);                  // 1101: NOR
         4'b1110: alu_out <= { b[15:0], 16'b0 };        // 1110: load upper

         default: alu_out <= 0;
      endcase
   end

endmodule
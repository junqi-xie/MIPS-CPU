module alu_control (op, funct, alu_ctl);

   input [5:0] op, funct;
   output reg [3:0] alu_ctl;

   always @(op or funct) // reevaluate if these change
   begin
      case (op)
         6'h00: // 0x00: general R-type instructions
         begin
            case (funct)
               6'h20, // 0x20: add
               6'h21: // 0x21: addu
                  alu_ctl <= 4'b0010;
               6'h22, // 0x22: sub
               6'h23: // 0x23: subu
                  alu_ctl <= 4'b0011;

               6'h24: alu_ctl <= 4'b0000; // 0x24: and
               6'h25: alu_ctl <= 4'b0001; // 0x25: or
               6'h26: alu_ctl <= 4'b1100; // 0x26: xor
               6'h27: alu_ctl <= 4'b1101; // 0x27: nor
               6'h2a: alu_ctl <= 4'b0110; // 0x2a: slt
               6'h2b: alu_ctl <= 4'b0111; // 0x2b: sltu

               6'h00: alu_ctl <= 4'b1000; // 0x00: sll
               6'h02: alu_ctl <= 4'b1001; // 0x02: srl
               6'h03: alu_ctl <= 4'b1010; // 0x03: sra

               default: alu_ctl <= 4'b1111;
            endcase
         end

         6'h08, // 0x08: addi
         6'h09, // 0x09: addiu
         6'h23, // 0x23: lw
         6'h2b: // 0x2b: sw
            alu_ctl <= 4'b0010;

         6'h04, // 0x04: beq
         6'h05: // 0x05: bne
            alu_ctl <= 4'b0011;

         6'h0a: alu_ctl <= 4'b0110; // 0x0a: slti
         6'h0b: alu_ctl <= 4'b0111; // 0x0b: sltiu
         6'h0c: alu_ctl <= 4'b0000; // 0x0c: andi
         6'h0d: alu_ctl <= 4'b0001; // 0x0d: ori
         6'h0e: alu_ctl <= 4'b1100; // 0x0e: xori
         6'h0f: alu_ctl <= 4'b1110; // 0x0f: lui

         default: alu_ctl <= 4'b1111;
      endcase
   end

endmodule
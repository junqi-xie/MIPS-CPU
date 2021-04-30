module control (op, funct, zero, sign, sign_ext, shift,
                alu_src, mem_write, reg_src, reg_dst, reg_write,
                branch, jump, jal, jr);

   input [5:0] op, funct;
   input zero;
   output sign, sign_ext, shift, alu_src, mem_write, reg_src,
          reg_dst, reg_write, branch, jump, jal, jr;

   // Parse the instructions

   wire r_type  = (op == 6'h00);
   wire i_add   = r_type && (funct == 6'h20);
   wire i_sub   = r_type && (funct == 6'h22);
   wire i_sll   = r_type && (funct == 6'h00);
   wire i_srl   = r_type && (funct == 6'h02);
   wire i_sra   = r_type && (funct == 6'h03);
   wire i_jr    = r_type && (funct == 6'h08);

   wire i_type  = (op >= 6'h08) && (op <= 6'h0f);
   wire i_addi  = (op == 6'h08);

   wire i_lw    = (op == 6'h23);
   wire i_sw    = (op == 6'h2b);
   wire i_beq   = (op == 6'h04);
   wire i_bne   = (op == 6'h05);

   wire i_j     = (op == 6'h02);
   wire i_jal   = (op == 6'h03);

   // Generate control signals

   assign sign      = i_add  || i_sub  || i_addi;
   assign sign_ext  = i_addi || i_lw   || i_sw   || i_beq  || i_bne;
   assign shift     = i_sll  || i_srl  || i_sra;
   assign alu_src   = i_type || i_lw   || i_sw;

   assign mem_write = i_sw;
   assign reg_src   = i_lw;
   assign reg_dst   = r_type;
   assign reg_write = r_type || i_type || i_lw   || i_jal;

   assign branch    = (i_beq && zero)  || (i_bne && !zero);
   assign jump      = i_j    || i_jal;
   assign jal       = i_jal;
   assign jr        = i_jr;

endmodule
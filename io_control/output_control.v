module output_control (clock, addr, data_in, output_write, output1, output2, output3);

   input [31:0] addr, data_in;
   input clock, output_write;
   output reg [13:0] output1, output2, output3;

   wire write_enable = output_write & ~clock;

   wire [13:0] output_data;

   seven_seg num1 (data_in[3:0], output_data[6:0]);
   seven_seg num2 (data_in[7:4], output_data[13:7]);

   always @(posedge write_enable)
   begin
      case (addr)
         8'hb0: output1 <= output_data;
         8'hb4: output2 <= output_data;
         8'hb8: output3 <= output_data;

         default:
         begin
            output1 <= 14'b11111111111111;
            output2 <= 14'b11111111111111;
            output3 <= 14'b11111111111111;
         end
      endcase
   end

endmodule
module input_control (addr, input1, input2, data_out);

   input [31:0] addr;
   input [4:0]  input1, input2;
   output [31:0] data_out;

   reg [4:0] input_data;
   
   assign data_out = { 27'b0, input_data }; // extend the input data

   always @(addr or input1 or input2) // reevaluate if these change
   begin
      case (addr)
         8'ha0: input_data <= input1;
         8'ha4: input_data <= input2;

         default: input_data <= 5'h0;
      endcase
   end

endmodule
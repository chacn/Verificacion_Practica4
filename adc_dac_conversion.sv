module adc_dac_conversion
(
  input reset,
  input bclk,
  input LRC,
  input adc_dat,
  input [15:0]left_paralel_in,
  input [15:0]right_paralel_in,
  //outputs
  output dac_dat,
  output [15:0]left_paralel_out,
  output [15:0]right_paralel_out
  );

  //----------------------------------Wires-------------------------------------
  bit [15:0] right_sipo_out_wire;
  bit [15:0] left_sipo_out_wire;
  bit [15:0] right_piso_out_wire;
  bit [15:0] left_piso_out_wire;


  //-----------------Serial input parallel output registers---------------------
  Register      RIGHT_SIPO
  #(.Word_Length(16) )
  (
   // Input Ports
   .clk(bclk),
   .reset(reset),
   .Data_Input({right_sipo_out_wire[14:0], adc_dat}),
   .enable(~LRC),
   .sync_reset(1'b0),
   // Output Ports
   .Data_Output(right_sipo_out_wire)
  );
  Register      LEFT_SIPO
  #(.Word_Length(16) )
  (
    // Input Ports
    .clk(bclk),
    .reset(reset),
    .Data_Input({left_sipo_out_wire[14:0], adc_dat}),
    .enable(LRC),
    .sync_reset(1'b0),
    // Output Ports
    .Data_Output(left_sipo_out_wire)
  );

  //-----------------Serial input parallel output registers---------------------
  Shift_Register_left     RIGHT_PISO
  #(.Word_Length(16))
  (
 	  // Input Ports
 	  .clk(bclk),
 	  .reset(reset),
 	  .Data_Input(right_paralel_in),
 	  .load(LRC),
 	  .shift(~LRC),
 	  .sync_rst(1'b0),
 	  // Output Ports
 	  .Data_Output(right_piso_out_wire)
  );
  Shift_Register_left     LEFT_PISO
  #(.Word_Length(16))
  (
 	  // Input Ports
 	  .clk(bclk),
 	  .reset(reset),
 	  .Data_Input(left_paralel_in),
 	  .load(~LRC),
 	  .shift(LRC),
 	  .sync_rst(1'b0),
 	  // Output Ports
 	  .Data_Output(left_piso_out_wire)
  );

  //---------------------------Output assigns-----------------------------------
  assign dac_dat = (LRC & left_piso_out_wire[15] ) | (~LRC & right_piso_out_wire[15])

endmodule

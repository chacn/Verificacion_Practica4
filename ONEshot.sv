module ONEshot(
 input in,
 input clk,
 input reset,
 output out
);

bit outR12R2_wire;
bit outR2_wire;

 Register
#(	.Word_Length(1))		 R1

(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.Data_Input(in),
	.enable(1'b1),
	.sync_reset(1'b0),

	// Output Ports
	.Data_Output(outR12R2_wire)
);

 Register
#(.Word_Length(1))		 R2

(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.Data_Input(outR12R2_wire),
	.enable(1'b1),
	.sync_reset(1'b0),

	// Output Ports
	.Data_Output(outR2_wire)
);

assign out = outR12R2_wire & ~outR2_wire;
endmodule
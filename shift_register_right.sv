 module Shift_Register_right
#(
	parameter Word_Length = 8
)

(
	// Input Ports
	input clk,
	input reset,
	input [Word_Length-1:0] Data_Input,
	input load,
	input shift,
	input sync_rst,

	// Output Ports
	output [Word_Length-1:0]Data_Output
);

logic [Word_Length-1:0]Data_logic;

always_ff@(posedge clk or negedge reset) begin: ThisIsARegister
	if(reset == 1'b0)
		Data_logic <= 0;
	else
		if(shift == 1)
			Data_logic <= Data_logic >> 1;
		else if (load == 1)
			Data_logic <= Data_Input;
		else
			Data_logic <= Data_logic;

end: ThisIsARegister

assign Data_Output = Data_logic;

endmodule

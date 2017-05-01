module Multiplexers 
#(parameter WORD_LENGHT = 8)

(
	// Input Ports
	input Selector,
	input [WORD_LENGHT-1 : 0]Data_0,
	input [WORD_LENGHT-1 : 0]Data_1,
	
	// Output Ports
	output logic [WORD_LENGHT-1 : 0]Mux_Output_log

);

//logic Mux_Output_log;

always_comb begin: ThisIsAMUX

	if (Selector == 1'b1)
		Mux_Output_log = Data_1;
	else 
		Mux_Output_log = Data_0;

end : ThisIsAMUX

//assign Mux_Output = Mux_Output_log;

endmodule
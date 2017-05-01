module Multiplexers_4_to_1
#(parameter WORD_LENGHT = 8)

(
	// Input Ports
	input [1:0]Selector,
	input [WORD_LENGHT-1 : 0]Data_0,
	input [WORD_LENGHT-1 : 0]Data_1,
	input [WORD_LENGHT-1 : 0]Data_2,
	input [WORD_LENGHT-1 : 0]Data_3,

	// Output Ports
	output logic [WORD_LENGHT-1 : 0]Mux_Output_log

);

//logic Mux_Output_log;

always_comb begin: ThisIsAMUX

	if (Selector == 2'b0)
		Mux_Output_log = Data_0;
	else if(Selector == 2'b1)
		Mux_Output_log = Data_1;

	else if(Selector == 2'b10)
		Mux_Output_log = Data_2;
	else
		Mux_Output_log = Data_3;
end : ThisIsAMUX

//assign Mux_Output = Mux_Output_log;

endmodule

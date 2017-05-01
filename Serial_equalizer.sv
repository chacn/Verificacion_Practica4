module Serial_equalizer{
	//Input ports.
	input clk,
	input reset,
	input LRC_signal,
	input [15:0]left_data,
	input [15:0]right_data,
	
	//Output ports.
	output conv_out

}

bit LRCsignal_ONESHOT_2_PUSH_FIFORIGHT_wire;
bit [15:0]MUXout_2_DataIn_FIFORIGHT_wire;
bit [15:0]FIFORIGHT_out_2_MUXandFEEDBACK_wire;

//----------------------FIFO RIGHT BLOCK-------------------------------------
Multiplexers 
#(.WORD_LENGHT (16))
MUX RIGHT

(
	// Input Ports
	.Selector(),
	.Data_0(right_data),
	.Data_1(FIFORIGHT_out_2_MUXandFEEDBACK_wire),
	
	// Output Ports
	.Mux_Output_log(MUXout_2_DataIn_FIFORIGHT_wire)

);
.ONEshot ONESHOT_RIGHT(
 .in(LRC_signal),
 .clk(clk),
 .reset(reset),
 .out(LRCsignal_ONESHOT_2_PUSH_FIFORIGHT_wire)
);


 FIFO
#(.WORDLENGHT(16), .Mem_lenght(32))
FIFO_RIGHT
(

	.data_input(MUXout_2_DataIn_FIFORIGHT_wire),
	.push(LRCsignal_ONESHOT_2_PUSH_FIFORIGHT_wire),
	.pop(),
	.clk(clk),
	.reset(reset),
	.synch_rst(1'b1),

	.data_out(FIFORIGHT_out_2_MUXandFEEDBACK_wire),
	.full_out(),
	.empty_out()

);

//--------------------------------FIFO LEFT BLOCK---------------------------------

endmodule 
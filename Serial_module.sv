module Serial_module(
	//Input ports.
	input clk,
	input reset,
	input audio,
	input sw_in,
	input sync_rst
	//Output ports.
	output signal_out
);
 bit [15:0] ROMout_BYPASS_2_MUX_wire;
 bit [15:0] ROMout_LOWPASS_2_MUX_wire;
 bit [15:0] ROMout_HIGHPASS_2_MUX_wire;
 bit [15:0] ROMout_BANDPASS_2_MUX_wire;
 bit [15:0] MACout_2_REGMAC_wire;
 bit [15:0] REGMACout_2_REGOUT_wire;
 bit [15:0] MUXout_2_MAC_wire;
//------------------------------ COUNTER ----------------------------------------------------
CounterParameter
#(
	// Parameter Declarations
	.Maximum_Value (32),
)

(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(),
	.SyncReset(sync_rst),
	
	// Output Ports
	.Flag(),
	.Counting()
);
//------------------------------- ROMS ------------------------------------------------------
single_port_rom
#(.DATA_WIDTH(16),   .ADDR_WIDTH(16))
ROM_BYPASS
(
	.addr(),
	.clk(clk),
	.q(ROMout_BYPASS_2_MUX_wire)
);

single_port_rom
#(.DATA_WIDTH(16),   .ADDR_WIDTH(16))
ROM_LOWPASS
(
	.addr(),
	.clk(clk),
	.q(ROMout_LOWPASS_2_MUX_wire)
);

single_port_rom
#(.DATA_WIDTH(16),   .ADDR_WIDTH(16))
ROM_HIGHPASS
(
	.addr(),
	.clk(clk),
	.q(ROMout_HIGHPASS_2_MUX_wire)
);

single_port_rom
#(.DATA_WIDTH(16),   .ADDR_WIDTH(16))
ROM_BANDPASS
(
	.addr(),
	.clk(clk),
	.q(ROMout_BANDPASS_2_MUX_wire)
);
//----------------------------- MUX 4 TO 1 --------------------------------------------------
.Multiplexers_4_to_1
#(.WORD_LENGHT(16))

(
	// Input Ports
	.Selector(sw_in),
	.Data_0(ROMout_BYPASS_2_MUX_wire),
	.Data_1(ROMout_LOWPASS_2_MUX_wire),
	.Data_2(ROMout_HIGHPASS_2_MUX_wire),
	.Data_3(ROMout_BANDPASS_2_MUX_wire),

	// Output Ports
	.Mux_Output_log(MUXout_2_MAC_wire)

);
//------------------------------ MAC --------------------------------------------------------
Fixed_Point_MAC
#(
	.Word_Length(16),
	.Integer_Part(16),
)
(
	// Input Ports
	.A(),
	.B(MUXout_2_MAC_wire),
	.C(REGMACout_2_REGOUT_wire),

	// Output Ports
	.D(MACout_2_REGMAC_wire)
);

//----------------------------- REGISTER MAC-------------------------------------------------
Register
#(
	.Word_Length(16)
)
REG_MAC

(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.Data_Input(MACout_2_REGMAC_wire),
	.eable(),
	.sync_reset(sync_rst),

	// Output Ports
	.Data_Output(REGMACout_2_REGOUT_wire)
);
//-------------------------------- REGISTER OUT---------------------------------------------
Register
#(
	.Word_Length(16)
)
REG_MAC

(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.Data_Input(REGMACout_2_REGOUT_wire),
	.eable(sync_rst),
	.sync_reset(1'b0),

	// Output Ports
	.Data_Output(signal_out)
);
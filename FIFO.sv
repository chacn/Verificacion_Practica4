module FIFO
#(parameter WORDLENGHT = 8, Mem_lenght = 8)
(

	input [WORDLENGHT-1:0]data_input /*synthesis keep*/,
	input push,
	input pop,
	input clk,
	input reset,
	input synch_rst,

	output [WORDLENGHT-1:0]data_out,
	output full_out,
	output empty_out

);


bit POP_counter_enable_wire /*synthesis keep*/;
bit PUSH_counter_enable_wire /*synthesis keep*/;

bit [CeilLog2(Mem_lenght)-1:0] POP_counter_out_wire /*synthesis keep*/;
bit [CeilLog2(Mem_lenght)-1:0] PUSH_counter_out_wire /*synthesis keep*/;
bit [CeilLog2(Mem_lenght):0] DATA_counter_wire;

bit POP_SYNC_RST_WIRE;
bit PUSH_SYNC_RST_WIRE;

bit  Flag_full_wire;


//--------------------Pop counter module---------------------
assign POP_counter_enable_wire = (~empty_out) && pop;

CounterParameter
#(	.Maximum_Value(Mem_lenght) )    POP_module

(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(synch_rst | POP_counter_enable_wire),
	.SyncReset(synch_rst||POP_SYNC_RST_WIRE),

	// Output Ports
	.Flag(POP_SYNC_RST_WIRE),
	.Counting(POP_counter_out_wire)
);

//-----------------------Push counter module---------------------

assign PUSH_counter_enable_wire = (~Flag_full_wire) & push;

CounterParameter
#(	.Maximum_Value(Mem_lenght) )       PUSH_module

(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(synch_rst | PUSH_counter_enable_wire),
	.SyncReset(synch_rst || PUSH_SYNC_RST_WIRE),

	// Output Ports
	.Flag(PUSH_SYNC_RST_WIRE),
	.Counting(PUSH_counter_out_wire)
);

//------------------------- Data-----------------------------
CounterParameterUpDown
#(
	// Parameter Declarations
	.Maximum_Value(Mem_lenght+1)
)
DATA_module

(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.up(PUSH_counter_enable_wire),
	.down(POP_counter_enable_wire),
	.SyncReset(synch_rst),

	// Output Ports
	.Flag(Flag_full_wire),
	.Counting(DATA_counter_wire)
);

//----------------------------ROM--------------------------------

simple_dual_port_ram_single_clock
#(
	.DATA_WIDTH(WORDLENGHT),
	.ADDR_WIDTH(CeilLog2(Mem_lenght))
  )
  MEMORY
(
	.data(data_input),
	.read_addr(POP_counter_out_wire),
	.write_addr(PUSH_counter_out_wire),
	.we(PUSH_counter_enable_wire),
	.clk(clk),
	.q(data_out)
);

//------------------------Assign OUTPUTS-------------------------

assign empty_out = ~(|DATA_counter_wire);
assign full_out = Flag_full_wire;


 /*Log Function*/
     function integer CeilLog2;
       input integer data;
       integer i,result;
       begin
          for(i=0; 2**i < data; i=i+1)
             result = i + 1;
          CeilLog2 = result;
       end
    endfunction

endmodule

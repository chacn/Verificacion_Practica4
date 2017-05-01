module CounterParameter
#(
	// Parameter Declarations
	parameter Maximum_Value = 9,
	parameter NBitsForCounter = CeilLog2(Maximum_Value)
)

(
	// Input Ports
	input clk,
	input reset,
	input enable,
	input SyncReset,
	
	// Output Ports
	output Flag,
	output[NBitsForCounter-1:0] Counting 
);

bit MaxValue_Bit;

logic [NBitsForCounter-1 : 0] Counting_logic;

	always_ff@(posedge clk or negedge reset) begin
		if (reset == 1'b0)
			Counting_logic <= {NBitsForCounter{1'b0}};
		else begin
				if(enable == 1'b1) begin
					if(SyncReset == 0)
						Counting_logic <= Counting + 1'b1;
					else
						Counting_logic <= 0;
				end
		end
	end

//--------------------------------------------------------------------------------------------

always_comb
	if(Counting_logic == Maximum_Value-1)
		MaxValue_Bit = 1;
	else
		MaxValue_Bit = 0;

		
//---------------------------------------------------------------------------------------------
assign Flag = MaxValue_Bit;

assign Counting = Counting_logic;
//----------------------------------------------------------------------------------------------

/*--------------------------------------------------------------------*/
 /*--------------------------------------------------------------------*/
 /*--------------------------------------------------------------------*/
   
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

/*--------------------------------------------------------------------*/
 /*--------------------------------------------------------------------*/
 /*--------------------------------------------------------------------*/
endmodule


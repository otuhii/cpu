module mem(
	input clk,
	input we,
	input[15:0] addr, //maybe another format like 8bits 
	input[15:0] valIn,
	output[15:0] valOut
);
	reg[15:0] memory[0:1023];
	assign valOut = memory[addr];
		
	always @ (posedge clk) begin 
		if (we) 
			memory[addr] = valIn;
	end

endmodule




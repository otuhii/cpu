module mem(
	input clk,
	input we,
	input [31:0] addr,
	input [31:0] valIn,
	output reg[31:0] valOut
);

	parameter MEM_WORDS = 262144;
	
	reg[31:0] memory[0:MEM_WORDS-1]; //1 MB - 262144 words

	wire [17:0] word_addr = addr[19:2]; //divided by 4=shifted by 2, just because we work with words


	always @(posedge clk) begin 
		if (we) begin 
			memory[word_addr] <= valIn;
		end
		valOut <= memory[word_addr];
	end

	initial begin
		foreach(memory[i]) memory[i] = 32'h0000_0000;
	end
endmodule

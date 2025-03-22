module proc(
	input clk,
	input rst,
	input reg[15:0] memory[0:1023],
	output reg[15:0] out
);

	initial begin 
		out = 16'b0;
	end

	reg[3:0] count = 4'd0;
	always @(posedge clk or posedge rst) begin
		if (rst) begin 
			count = 4'd0;
			out = memory[count];
		end else begin 
			out = memory[count];
			count = (count == 9) ? 0 : count + 1;
		end
	end

endmodule

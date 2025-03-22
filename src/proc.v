module proc(
	input clk,
	input rst,
	input wire[15:0] memory[0:255],
	output reg[15:0] out
);

	reg [15:0] valueBuffer;

	initial begin 
		out = 16'b0;
	end

	reg[3:0] pc = 4'd0;
	always @(posedge clk or posedge rst) begin
		if (rst) begin 
			pc = 4'd0;
			out = memory[pc];
		end else begin 
			valueBuffer = memory[pc];
			if (valueBuffer[15:8] == 8'd1)
				out <= memory[valueBuffer[7:0]];
			pc = (pc == 9) ? 0 : pc + 1;
		end
	end

endmodule

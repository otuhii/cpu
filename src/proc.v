module proc(
	input clk,
	input rst,
	input wire[15:0] memory[0:255],
	output reg[15:0] out
);
	
	
	reg[7:0] registers[0:31];
	reg [15:0] valueBuffer;

	initial begin 
		out = 16'b0;
		valueBuffer = 16'b0;
		for (integer i = 0; i < 31; i = i + 1) begin 
			registers[i] = 8'b0;
		end
	end

	reg[7:0] pc = 4'd0;
	always @(posedge clk or posedge rst) begin
		if (rst) begin 
			pc <= 4'd0;
			out <= memory[pc];
		end else begin 
			valueBuffer = memory[pc];
			if (valueBuffer[15:11] == 5'd1)
				out <= memory[valueBuffer[10:0]];
			else if (valueBuffer[15:13] == 3'd6)
				registers[valueBuffer[12:8]] <= valueBuffer[7:0];   
			else if (valueBuffer[15:11] == 5'd2) begin
				$display("%h", registers[valueBuffer[4:0]]);
			end
			pc <= (pc == 255) ? 0 : pc + 1;
		end
	end

endmodule

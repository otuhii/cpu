module proc(
	input clk,
	input rst,
	output reg[3:0] out
);
	reg[3:0] count = 4'd1;
	always @(posedge clk) begin
		if (rst) begin 
			count = 4'd1;
			out = count;
		end else begin 
			out = count;
			count = (count == 10) ? 1 : count + 1;
		end
	end

endmodule

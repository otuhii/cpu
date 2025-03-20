module main(
	input rst,
	output reg[15:0] out[0:9]
);
	
	initial $readmemh("../txt/test.hex", out);

	always @(posedge rst) begin
		if (rst)
			for (integer i = 0; i < 10; i = i + 1) 
				out[i] = 16'd0;
	end


endmodule




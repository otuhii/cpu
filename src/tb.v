module tb;
	reg[15:0] mem[0:1023];
	reg clk;

	main scan(.rst(1'b0), .out(mem));
	
	initial begin 
		clk = 0;
		forever #5 clk = ~clk;
	end

	always @(posedge clk) begin 
		for (integer i = 0; i < 10; i++) 
			$display("%h", mem[i]);
		$finish;
	end



endmodule

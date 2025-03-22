module driver;
	wire [15:0] value;
	wire [15:0] memory[0:1023];
	reg clk;
	reg rst;

	main scan(rst, memory);
	proc pMod(clk, rst, memory, value);
	
	initial begin 
		clk = 0;
		forever #5 clk = ~clk;
	end

	always @(posedge clk) begin
		$display("%h", value);
	end 
	
	initial begin 
	#200;
	$finish;

	end
	

endmodule

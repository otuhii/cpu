module driver;
	wire [15:0] value;
	wire [15:0] memory[0:255];
	reg clk;
	reg rst;

	main scan(rst, memory);
	proc pMod(clk, rst, memory, value);
	
	initial begin 
		clk = 0;
		forever #5 clk = ~clk;
	end

	
	initial begin 
	#2000;
	$finish;

	end
	

endmodule

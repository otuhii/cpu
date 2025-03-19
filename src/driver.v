module driver;
	wire [3:0] out;
	reg clk;
	reg rst;

	proc pMod(clk, rst, out);
	

	initial begin 
		clk = 0;
		forever #5 clk = ~clk;
	end

	initial begin 
		$monitor("%d\n", out);
	end
	
	initial begin 
		#1000 $finish;
	end


endmodule

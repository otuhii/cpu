module tbMain;

	reg clk;
		
	initial begin	
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	main uut(clk);


endmodule

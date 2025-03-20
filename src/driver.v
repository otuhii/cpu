module driver;
	wire [15:0] value;
	wire [15:0] data[0:9];
	reg clk;
	reg rst;

	main memory(rst, data);
	proc pMod(clk, rst, data, value);
	
	initial begin 
		clk = 0;
		forever #5 clk = ~clk;
	end

	//assigning data from certain index into tmp because i cant pass data[idx] to $monitor
	always @(posedge clk) begin
		$display("%h", value);
	end 
	
	initial begin 
	#200;
	$finish;

	end
	

endmodule

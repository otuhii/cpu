module driver;
	reg rst, clk;
	reg[15:0] readBuffer[0:1023];
	int i, file;

	reg[15:0] initIn, initAddr;
	reg initWe;

	wire[15:0] memIn, memOut, memAddr;
	wire memWe;

	wire [15:0] procIn, procAddr;
	wire procWe;

	assign memIn = (rst) ? initIn : procIn;
	assign memAddr = (rst) ? initAddr : procAddr;
	assign memWe = (rst) ? initWe : procWe;
	
	mem memory(
		.clk(clk),
		.we(memWe),
		.addr(memAddr),
		.valIn(memIn),
		.valOut(memOut)
	);

	proc cpu(
		.clk(clk),
		.rst(rst),
		.fromMem(memOut),
		.we(procWe),
		.addr(procAddr),
		.toMem(procIn)
	);


	initial begin 
		rst = 1;
		clk = 0;
		initWe = 1;
		
		for (i = 0; i < 1024; i = i + 1) begin 
			readBuffer[i] = 16'b0;
		end

		file = $fopen("../txt/assembler/program.hex", "r");
		if (file) begin 	
			i = 0; //readCount
			while (!$feof(file) && i < 1024) begin 
				if ($fscanf(file, "%h\n", readBuffer[i]) !== 1) 
					$display("reading error");
				i = i + 1;
			end
		end else 
			$display("Error opening file");

		for (i = 0; i < 1024; i = i + 1) begin 
			initIn = readBuffer[i];
			initAddr = 16'd0+i;
			#10 clk = ~clk;
			#10 clk = ~clk;
		end
		

		rst = 0;
		initWe = 0;

		forever #10 clk = ~clk;


	end
	
	


endmodule

module driver;
	parameter MEM_WORDS = 262144;


	reg rst, clk;
	reg[31:0] readBuffer[0:MEM_WORDS-1];
	int i, file;

	wire [31:0] memIn, memOut, memAddr;
	wire memWe;

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
		.we(memWe),
		.addr(memAddr),
		.toMem(memIn)
	);


	initial begin 
		clk = 0;
		rst = 1;


		file = $fopen("../../txt/assembler/program.hex", "r");
		if (file) begin 
			$readmemh("../../txt/assembler/program.hex", memory.memory);
			$fclose(file);
		end else begin
			$display("Error opening file");
			$finish;
		end
	

		for (i = 0; i < 16; i++) cpu.registers[i] = 32'd0;


		#1 rst = 0;
	
		#220
		for (i = 0; i < 16; i = i + 1) begin 
			$display("%h", cpu.registers[i]);	
		end



		#5000 $finish;
	end
	always #10 clk = ~clk;

	

endmodule

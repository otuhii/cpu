module main(
	input rst,
	output reg[15:0] out[0:255]
);
	
	integer i;
	integer file, readCount;
	reg [15:0] readBuffer;

	initial begin 
		for (i = 0; i < 256; i = i + 1)
			out[i] = 16'b0;

		file = $fopen("../txt/assembler/program.hex", "r");
		if (file) begin 
			readCount = 0;
			while(!$feof(file) && readCount < 256) begin
				if($fscanf(file, "%h\n", readBuffer) == 1) begin
					out[readCount] = readBuffer;
					readCount = readCount + 1;
				end 
			end
			$fclose(file);
		end
		else begin 
			$display("Error opening file");
		end
	end


	always @(posedge rst) begin
		if (rst) begin
			i = 0;
			file = 0;
			readCount = 0;
			readBuffer = 16'b0;
			for (i = 0; i < 256; i = i + 1) 
				out[i] = 16'd0;

		end
	end


endmodule




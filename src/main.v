module main(input clk);
	integer               data_file    ; // file handler
	integer               scan_file    ; // file handler
	reg [15:0] captured_data;
	
	initial begin
	  data_file = $fopen("test.txt", "r");
	  if (data_file == 0) begin
	    $display("data_file handle was NULL");
	    $finish;
	  end
	end

	always @(posedge clk) begin
	  scan_file = $fscanf(data_file, "%h\n", captured_data);
	  $display("Number - %h", captured_data);
	  if ($feof(data_file)) 
		$finish;  
	end
endmodule

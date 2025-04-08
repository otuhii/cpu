module proc(
	input clk,
	input rst,
	input [31:0] fromMem,
	output reg we,
	output reg[31:0] addr,
	output reg[31:0] toMem
);
	reg[31:0] instructionReg;
	reg[31:0] registers[0:15]; //R13 → Stack Pointer (SP), R14 → Link Register (LR), R15 → Program Counter (PC) 


	typedef enum {
		START,
		FETCH,
		DECODE,
		EXECUTE
	} state_t;

	typedef enum {
		NONE,
		MOV,
		OUTR,
		LI
	} type_t;


	state_t state;
	type_t optype;


	always @ (posedge clk or posedge rst) begin 
		if (rst) begin
			state <= START;
			optype <= NONE;
			$display("rst");
			registers[15] <= 32'd0;
			we <= 0;
			addr <= 32'b0;
			toMem <= 32'b0;
		end else begin 
			case (state)
				START: begin 
					addr <= registers[15];
					state <= FETCH;
					optype <= NONE;
				end
				FETCH: begin
					instructionReg <= fromMem;
					state <= DECODE;
					addr <= registers[15] + 4;
				end
				DECODE: begin
					if (instructionReg == 32'hffffffff)
						$finish;
					case (instructionReg[24:21])
						4'b0011: optype <= LI;
						4'b0001: optype <= MOV;
						4'b0010: optype <= OUTR;
					endcase
					state <= EXECUTE;
				end
				EXECUTE: begin 
					case (optype)
						MOV: begin 
							$display("mov called");
							registers[instructionReg[15:12]] <= registers[instructionReg[3:0]];
							optype <= NONE;
						end
						LI: begin
							$display("li called");
							registers[instructionReg[15:12]] <= instructionReg[11:0];	
							optype <= NONE;
						end
						OUTR: begin 
							$display("outr - %h", registers[instructionReg[15:12]]);
							optype <= NONE;
						end
						default: optype <= NONE;
					endcase

					registers[15] <= registers[15] + 4;
					state <= FETCH;
				end
			endcase

		end
	end


endmodule

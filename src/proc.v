module proc(
	input clk,
	input rst,
	input[15:0] fromMem,
	output reg we,
	output reg[15:0] addr,
	output reg[15:0] toMem
);

	reg[15:0] instructionReg = 16'b0;
	reg[7:0] registers[0:31];
	reg[7:0] pc = 8'b0;

	typedef enum {
		FETCH,
		DECODE,
		EXECUTE,
		MEMORY
	} state_t;

	state_t state = FETCH;
	state_t nextState = DECODE;

	always @(*) begin 
		case (state)
			FETCH: nextState = DECODE;
			DECODE: nextState = EXECUTE;
			EXECUTE: 
				if (instructionReg[15:11] == 5'd1 || instructionReg[15:13] == 3'd1 || instructionReg[15:13] == 3'd2) begin  //outloc inst
					nextState = MEMORY;
				end else begin 
					nextState = FETCH;
				end
			MEMORY: nextState = FETCH;
			default: nextState = FETCH;
		endcase
		//$display("state ", state);
		//$display("nextState", nextState);
	end
	
	
	always @ (posedge clk or posedge rst) begin
		if (rst) begin 
			state <= FETCH;
			pc <= 8'd0;
			we <= 0;
			instructionReg <= 16'b0;
			addr <= 16'd0;
			toMem <= 16'd0;
		end else begin
			$display("[CLK] state=%s, instructionReg=%h, addr=%h, pc=%h", state.name(), instructionReg,addr, pc);
			case(state)
				FETCH: begin
					we <= 0;//reset write signal
					instructionReg <= fromMem;
					addr <= pc;
				end
				DECODE: begin
				end
				EXECUTE: begin
					if (instructionReg[15:11] == 5'd1) begin
						addr <= instructionReg[10:0];
					end
					else if (instructionReg[15:13] == 3'd1) begin //store 
						we <= 1;
						addr <= instructionReg[7:0];
						toMem <= registers[instructionReg[12:8]];
					end
					else if (instructionReg[15:13] == 3'd2) begin //load 
						addr <= instructionReg[7:0];
					end
					else if (instructionReg[15:13] == 3'd6) begin // li
						registers[instructionReg[12:8]] <= instructionReg[7:0];
					end else if (instructionReg[15:11] == 5'd2) begin // outr
						$display("%h", registers[instructionReg[4:0]]);
					end else if (instructionReg == 16'b0111011101110111) //endprog
						$finish;
					if (nextState != MEMORY) begin
						addr <= pc + 1;
						pc <= pc + 1;
					end
				end
				MEMORY: begin 
					if (instructionReg[15:11] == 5'd1) //outloc
						$display("%h", fromMem);
					else if (instructionReg[15:13] == 3'd1) //store
						//idk what to put here,
					//previously i had toMem assignment
					//but then moved it to execute stage
						we <= 0;
					else if (instructionReg[15:13] == 3'd2) //load
						registers[instructionReg[12:8]] <= fromMem;

					addr <= pc + 1;
					pc <= pc + 1;
				end
			endcase



			state <= nextState;
		end
	end


endmodule

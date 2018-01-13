//==============================================================================
// Control Unit for PUnC LC3 Processor
//==============================================================================

`include "Defines.v"

module PUnCControl(
	// External Inputs
	input  wire        	clk,            // Clock
	input  wire        	rst,            // Reset

	// Input Signals from DataPath
	input [15:0]		ir,
	input				nzp_match,

	//Instruction Register Controls
	output reg 			IR_clr,
	output reg			IR_ld,

	//Program Counter Controls
	output reg			PC_ld,
	output reg			PC_clr,
	output reg			PC_inc,
	output reg	[1:0]	PC_sel,		  

	//Memory Controls
	output reg			DMem_rd,
	output reg			DMem_wr,
	output reg	[1:0]	DMem_R_addr_sel,
	output reg 	[1:0]	DMem_W_addr_sel,

	//Register File Controls
	output reg	[1:0]	RF_W_data_sel,
	output reg			RF_W_addr_sel,
	output reg			RF_Rp_addr_sel,
	output reg			RF_W_wr,
	output reg			RF_Rp_rd,
	output reg			RF_Rq_rd,

	//Temp Register Control
	output reg 			temp_ld,

	//NZP Circuit Controls
	output reg			nzp_ld,
	output reg			nzp_clr,

	//ALU Controls
	output reg	[1:0]	ALU_sel,
	output reg			ALU_In_A
);

	// FSM States
	localparam STATE_INIT		= 3'd0;
	localparam STATE_FETCH		= 3'd1;
	localparam STATE_DECODE		= 3'd2;
	localparam STATE_EXECUTE	= 3'd3;
	localparam STATE_EXECUTE2	= 3'd4;
	localparam STATE_HALT		= 3'd5;
	

	// State, Next State
	reg [4:0] state, next_state;

	// Output Combinational Logic
	always @( * ) begin
		// Default values for outputs
		IR_clr 				= 1'd0;
		IR_ld 				= 1'd0;
		PC_ld 				= 1'd0;
		PC_clr 				= 1'd0;
		PC_inc 				= 1'd0;
		PC_sel 				= 2'd0;		
		DMem_rd 			= 1'd0;
		DMem_wr 			= 1'd0;
		DMem_R_addr_sel 	= 2'd0;
		DMem_W_addr_sel 	= 2'd0;
		RF_W_data_sel 		= 2'd0;
		RF_W_addr_sel 		= 1'd0;
		RF_Rp_addr_sel 		= 1'd0; 
		RF_W_wr 			= 1'd0;
		RF_Rp_rd 			= 1'd0;
		RF_Rq_rd 			= 1'd0;
		temp_ld 			= 1'd0;
		nzp_ld 				= 1'd0;
		nzp_clr 			= 1'd0;
		ALU_sel 			= 2'd0;
		ALU_In_A 			= 1'd0;

		// Add your output logic here
		case (state)
			STATE_INIT: begin
				PC_clr  	= 1'd1;
				IR_clr		= 1'd1;
				nzp_clr		= 1'd1;
			end

			STATE_FETCH: begin
				PC_inc 			= 1'd1;
				IR_ld			= 1'd1;
				DMem_rd			= 1'd1;
				DMem_R_addr_sel = `DMem_R_Addr_Sel_PC; 
			end

			STATE_DECODE: begin
			end

			STATE_EXECUTE: begin
				case(ir[`OC])
					`OC_ADD:begin
						RF_W_data_sel 	= `RF_W_Data_Sel_ALU;
						RF_W_addr_sel 	= `RF_W_Addr_Sel_11_9;
						RF_W_wr 		= 1'b1;
						RF_Rp_addr_sel 	= `RF_Rp_Addr_Sel_2_0;
						RF_Rq_rd		= 1'b1;
						nzp_ld			= 1'b1;
						ALU_sel			= `ALU_Fn_Sel_ADD;

						if(ir[5] == 0) begin
							RF_Rp_rd 	= 1'b1;
							ALU_In_A	= `ALU_In_A_Sel_Rp_Data;
						end
						
						else begin
							RF_Rp_rd	= 1'b0;
							ALU_In_A	= `ALU_In_A_4_0;
						end
					end

					`OC_AND:begin
						RF_W_data_sel 	= `RF_W_Data_Sel_ALU;
						RF_W_addr_sel 	= `RF_W_Addr_Sel_11_9;
						RF_W_wr 		= 1'b1;
						RF_Rq_rd		= 1'b1;
						nzp_ld			= 1'b1;
						ALU_sel			= `ALU_Fn_Sel_AND;

						if(ir[5] == 0) begin
							RF_Rp_rd 	= 1'b1;
							RF_Rp_addr_sel 	= `RF_Rp_Addr_Sel_2_0;
							ALU_In_A	= `ALU_In_A_Sel_Rp_Data;
						end
						
						else begin
							RF_Rp_rd	= 1'b0;
							ALU_In_A	= `ALU_In_A_4_0;
						end
					end

					`OC_BR: begin
						if (nzp_match == 1'b1) begin
							PC_ld 	= 1'b1;
							PC_sel 	= `PC_Data_Sel_PC_8_0;
						end
					end

					`OC_JMP: begin
						PC_ld 		= 1'b1;
						PC_sel 		= `PC_Data_Sel_RF_Rq_Data;
						RF_Rq_rd 	= 1'b1;
					end

					`OC_JSR: begin
						RF_W_data_sel 	= `RF_W_Data_Sel_PC;
						RF_W_addr_sel 	= `RF_W_Addr_Sel_R7;
						RF_W_wr			= 1'b1;
					end

					`OC_LD:begin
						DMem_rd 			= 1'b1;
						DMem_R_addr_sel 	= `DMem_R_Addr_Sel_PC_8_0;
						RF_W_data_sel 		= `RF_W_Data_Sel_DMem_R;
						RF_W_addr_sel 		= `RF_W_Addr_Sel_11_9;
						RF_W_wr 			= 1'b1;
						nzp_ld 				= 1'b1;
					end

					`OC_LDI:begin
						DMem_rd = 1'b1;
						DMem_R_addr_sel 	= `DMem_R_Addr_Sel_PC_8_0;
						RF_W_data_sel 		= `RF_W_Data_Sel_DMem_R;
						RF_W_addr_sel 		= `RF_W_Addr_Sel_11_9;
						RF_W_wr 			= 1'b1;
					end

					`OC_LDR:begin
						DMem_rd 			= 1'b1;
						DMem_R_addr_sel 	= `DMem_R_Addr_Sel_RF_Rq_5_0;
						RF_W_data_sel 		= `RF_W_Data_Sel_DMem_R;
						RF_W_addr_sel 		= `RF_W_Addr_Sel_11_9;
						RF_W_wr 			= 1'b1;
						RF_Rq_rd			= 1'b1;
						nzp_ld				= 1'b1;
					end

					`OC_LEA:begin
						RF_W_data_sel 		= `RF_W_Data_Sel_PC_8_0;
						RF_W_addr_sel 		= `RF_W_Addr_Sel_11_9;
						RF_W_wr 			= 1'b1;
						nzp_ld				= 1'b1;
					end

					`OC_NOT:begin
						RF_W_data_sel 	= `RF_W_Data_Sel_ALU;
						RF_W_addr_sel 	= `RF_W_Addr_Sel_11_9;
						RF_W_wr 		= 1'b1;
						RF_Rq_rd		= 1'b1;
						nzp_ld			= 1'b1;
						ALU_sel			= `ALU_Fn_Sel_NOT_B;
					end

					`OC_ST:begin
						DMem_wr 		= 1'b1;
						DMem_W_addr_sel	= `DMem_W_Addr_Sel_PC_8_0;
						RF_Rp_addr_sel	= `RF_Rp_Addr_Sel_11_9;
						RF_Rp_rd		= 1'b1;
					end

					`OC_STI:begin
						DMem_rd			= 1'b1;
						DMem_R_addr_sel	= `DMem_R_Addr_Sel_PC_8_0;
						temp_ld			= 1'b1;
					end

					`OC_STR:begin
						DMem_wr 		= 1'b1;
						DMem_W_addr_sel	= `DMem_W_Addr_Sel_RF_Rq_5_0;
						RF_Rq_rd		= 1'b1;
					end

					`OC_HLT:begin					
					end

				endcase
			end

			STATE_EXECUTE2:begin
				case(ir[`OC])
					`OC_JSR: begin
						PC_ld 	= 1'b1;
						if(ir[11] == 1'b1) begin
							PC_sel 	= `PC_Data_Sel_PC_10_0;
						end
						else begin
							PC_sel 	= `PC_Data_Sel_RF_Rq_Data;
						end			
					end

					`OC_LDI: begin
						DMem_rd = 1'b1;
						DMem_R_addr_sel 	= `DMem_R_Addr_Sel_RF_Rp_Data;
						RF_W_data_sel 		= `RF_W_Data_Sel_DMem_R;
						RF_W_addr_sel 		= `RF_W_Addr_Sel_11_9;
						RF_W_wr 			= 1'b1;
						RF_Rp_addr_sel		= `RF_Rp_Addr_Sel_11_9;
						RF_Rp_rd			= 1'b1;
						nzp_ld 				= 1'b1;
					end				

					`OC_STI:begin
						DMem_wr 		= 1'b1;
						DMem_W_addr_sel	= `DMem_W_Addr_Sel_Temp_Data;
						RF_Rp_addr_sel	= `RF_Rp_Addr_Sel_11_9;
						RF_Rp_rd		= 1'b1;
					end
				endcase
			end
		endcase
	end

	// Next State Combinational Logic
	always @( * ) begin
		//Default value for next state
		next_state = state;

		//Next-state logic
		case (state)
		 STATE_INIT: begin
            next_state = STATE_FETCH;
         end
         STATE_FETCH: begin
            next_state = STATE_DECODE;
         end
         STATE_DECODE: begin
            next_state = STATE_EXECUTE;
         end
         STATE_EXECUTE: begin
            if (ir[`OC] == `OC_JSR | ir[`OC] == `OC_LDI | ir[`OC] == `OC_STI) begin
            	next_state = STATE_EXECUTE2;
            end
			else if(ir[`OC] == `OC_HLT) begin
			  next_state = STATE_EXECUTE;
			end
            else begin
               next_state = STATE_FETCH;
            end
         end
         STATE_EXECUTE2: begin
            next_state = STATE_FETCH;
         end
		endcase
	end

	// State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
         state <= STATE_INIT;
      end
      else begin
         state <= next_state;
      end
	end

endmodule

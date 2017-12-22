//==============================================================================
// Module for PUnC LC3 Processor
//==============================================================================

`include "PUnCDatapath.v"
`include "PUnCControl.v"

module PUnC(
	// External Inputs
	input  wire        clk,            // Clock
	input  wire        rst,            // Reset

	// Debug Signals
	input  wire [15:0] mem_debug_addr,
	input  wire [2:0]  rf_debug_addr,
	output wire [15:0] mem_debug_data,
	output wire [15:0] rf_debug_data,
	output wire [15:0] pc_debug_data
);

	//----------------------------------------------------------------------
	// Interconnect Wires
	//----------------------------------------------------------------------
	//Instruction Register Controls
	wire 			IR_clr;
	wire			IR_ld;
	wire	[15:0]	ir;

	//Program Counter Controls
	wire			PC_ld;
	wire			PC_clr;
	wire			PC_inc;
	wire	[1:0]	PC_sel;	  

	//Memory Controls
	wire			DMem_rd;
	wire			DMem_wr;
	wire	[1:0]	DMem_R_addr_sel;
	wire 	[1:0]	DMem_W_addr_sel;

	//Register File Controls
	wire	[1:0]	RF_W_data_sel;
	wire			RF_W_addr_sel;
	wire			RF_Rp_addr_sel;
	wire			RF_W_wr;
	wire			RF_Rp_rd;
	wire			RF_Rq_rd;

	//Temp Register Control
	wire 			temp_ld;

	//NZP Circuit Controls
	wire			nzp_ld;
	wire			nzp_clr;
	wire			nzp_match;

	//ALU Controls
	wire	[1:0]	ALU_sel;
	wire			ALU_In_A;


	wire [1:0] rf_w_data_sel;
	wire rf_w_addr_sel;
	wire rf_w_wr;
	
	wire rf_rp_addr_sel;
	wire rf_rp_rd;
	wire rf_rq_rd;

	wire temp_ld;
	
	wire nzp_ld;
	wire nzp_clr;
	
	wire [1:0] alu_sel;
	wire alu_in_a;
	//----------------------------------------------------------------------
	// Control Module
	//----------------------------------------------------------------------
	PUnCControl ctrl(
		.clk            	(clk),
		.rst            	(rst),
		
		.ir					(ir),	
		.nzp_match			(nzp_match),
		
		.IR_clr				(IR_clr),
		.IR_ld				(IR_ld),
		
		.PC_ld				(PC_ld), 
		.PC_clr				(PC_clr),
		.PC_inc				(PC_inc),
		.PC_sel				(PC_sel),
		
		.DMem_rd			(DMem_rd),
		.DMem_wr			(DMem_wr),
		.DMem_R_addr_sel	(DMem_R_addr_sel),
		.DMem_W_addr_sel	(DMem_W_addr_sel),
		
		.RF_W_data_sel		(RF_W_data_sel),
		.RF_W_addr_sel		(RF_W_addr_sel),
		.RF_Rp_addr_sel		(RF_Rp_addr_sel),
		.RF_W_wr			(RF_W_wr),
		.RF_Rp_rd			(RF_Rp_rd),
		.RF_Rq_rd			(RF_Rq_rd),
		
		.temp_ld			(temp_ld),
		
		.nzp_ld				(nzp_ld),
		.nzp_clr			(nzp_clr),
		
		.ALU_sel			(ALU_sel),
		.ALU_In_A			(ALU_In_A)		
	);

	//----------------------------------------------------------------------
	// Datapath Module
	//----------------------------------------------------------------------
	PUnCDatapath dpath(
		.clk            	(clk),
		.rst            	(rst),
		
		.ir_out				(ir),
		.nzp_match			(nzp_match),
		
		.ir_clr				(IR_clr),
		.ir_ld				(IR_ld),
		
		.pc_ld				(PC_ld), 
		.pc_clr				(PC_clr),
		.pc_inc				(PC_inc),
		.pc_sel				(PC_sel),

		.dmem_rd			(DMem_rd),
		.dmem_wr			(DMem_wr),
		.dmem_r_addr_sel	(DMem_R_addr_sel),
		.dmem_w_addr_sel	(DMem_W_addr_sel),
		
		.rf_w_data_sel		(RF_W_data_sel),
		.rf_w_addr_sel		(RF_W_addr_sel),
		.rf_rp_addr_sel		(RF_Rp_addr_sel),
		.rf_w_wr			(RF_W_wr),
		.rf_rp_rd			(RF_Rp_rd),
		.rf_rq_rd			(RF_Rq_rd),
		
		.temp_ld			(temp_ld),
		
		.nzp_ld				(nzp_ld),
		.nzp_clr			(nzp_clr),
		
		.alu_sel			(ALU_sel),
		.alu_in_a_sel		(ALU_In_A),

		.mem_debug_addr   	(mem_debug_addr),
		.rf_debug_addr    	(rf_debug_addr),
		.mem_debug_data   	(mem_debug_data),
		.rf_debug_data    	(rf_debug_data),
		.pc_debug_data    	(pc_debug_data)
	);

endmodule

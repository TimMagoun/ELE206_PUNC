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

	// Declare your wires for connecting the datapath to the controller here
	wire [15:0] ir;
	wire nzp_match;
	
	wire ir_clr;
	wire ir_ld;
	
	wire pc_ld;
	wire pc_clr;
	wire pc_inc;
	wire [1:0] pc_sel;
	
	wire dmem_rd;
	wire dmem_wr;
	wire [1:0] dmem_r_addr_sel;
	wire [1:0] dmem_w_addr_sel;

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
		.clk             (clk),
		.rst             (rst),
		.ir(ir),
		.nzp_match(nzp_match),
		.IR_clr(ir_clr),
		.IR_ld(ir_ld),
		.PC_ld(pc_ld),
		.PC_clr(pc_clr),
		.PC_inc(pc_inc),
		.PC_sel(pc_sel),
		.DMem_rd(dmem_rd),
		.DMem_wr(dmem_wr),
		.DMem_R_addr_sel(dmem_r_addr_sel),
		.DMem_W_addr_sel(dmem_w_addr_sel),
		.RF_W_data_sel(rf_w_data_sel),
		.RF_W_addr_sel(rf_w_addr_sel),
		.RF_Rp_addr_sel(rf_rp_addr_sel),
		.RF_W_wr(rf_w_wr),
		.RF_Rp_rd(rf_rp_rd),
		.RF_Rq_rd(rf_rq_rd),
		.temp_ld(temp_ld),
		.nzp_ld(nzp_ld),
		.nzp_clr(nzp_clr),
		.ALU_sel(alu_sel),
		.ALU_In_A(alu_in_a)
		// Add more ports here
	);

	//----------------------------------------------------------------------
	// Datapath Module
	//----------------------------------------------------------------------
	PUnCDatapath dpath(
		.clk             (clk),
		.rst             (rst),

		.pc_ld(pc_ld),
		.pc_clr(pc_clr),
		.pc_inc(pc_inc),
		.pc_sel(pc_sel),
		.ir_ld(ir_ld),
		.ir_clr(ir_clr),
		.dmem_rd(dmem_rd),
		.dmem_wr(dmem_wr),
		.dmem_r_addr_sel(dmem_r_addr_sel),
		.dmem_w_addr_sel(dmem_w_addr_sel),
		.rf_w_data_sel(rf_w_data_sel),
		.rf_w_addr_sel(rf_w_addr_sel),
		.rf_w_wr(rf_w_wr),
		.rf_rp_addr_sel(rf_rp_addr_sel),
		.rf_rp_rd(rf_rp_rd),
		.rf_rq_rd(rf_rq_rd),
		.temp_ld(temp_ld),
		.nzp_ld(nzp_ld),
		.nzp_clr(nzp_clr),
		.alu_sel(alu_sel),
		.alu_in_a_sel(alu_in_a),
		.nzp_match(nzp_match),
		.ir_out(ir),

		.mem_debug_addr   (mem_debug_addr),
		.rf_debug_addr    (rf_debug_addr),
		.mem_debug_data   (mem_debug_data),
		.rf_debug_data    (rf_debug_data),
		.pc_debug_data    (pc_debug_data)

		// Add more ports here
	);

endmodule

//==============================================================================
// Datapath for PUnC LC3 Processor
//==============================================================================

`include "Memory.v"
`include "RegisterFile.v"
`include "Defines.v"

module PUnCDatapath(
	// External Inputs
	input  wire        clk,            // Clock
	input  wire        rst,            // Reset
	
	input wire pc_ld, 
	input wire pc_clr,
	input wire pc_inc,
	input wire [1:0] pc_sel,

	input wire ir_ld,
	input wire ir_clr,
	
	input wire dmem_rd,
	input wire dmem_wr,
	input wire [1:0] dmem_r_addr_sel,
	input wire [1:0] dmem_w_addr_sel,
	
	input wire [1:0] rf_w_data_sel,
	input wire rf_w_addr_sel,
	input wire rf_w_wr,
	
	input wire rf_rp_addr_sel,
	input wire rf_rp_rd,
	input wire rf_rq_rd,

	input wire temp_ld,

	input wire nzp_ld,
	input wire nzp_clr,

	input wire alu_sel [1:0],
	input wire alu_in_a_sel,

	output wire nzp_match,
	output wire [15:0] ir_out,

	// DEBUG Signals
	input  wire [15:0] mem_debug_addr,
	input  wire [2:0]  rf_debug_addr,
	output wire [15:0] mem_debug_data,
	output wire [15:0] rf_debug_data,
	output wire [15:0] pc_debug_data,

	// Add more ports here
);

	// Local Registers
	reg  [15:0] pc;
	reg  [15:0] ir;

	reg [15:0] ir_sext_10_0;
	reg [15:0] ir_sext_8_0;
	reg [15:0] ir_sext_5_0;
	reg [15:0] ir_sext_4_0;
	

	reg temp;

	reg dmem_r_addr;
	reg dmem_w_addr;
	reg dmem_r_data;

	reg rf_w_addr;
	reg rf_w_data;
	reg rf_rw_addr;
	reg rf_rp_addr;
	reg rf_rw_data;
	reg rf_rp_data;
	reg rf_rq_data;

	reg n;
	reg z; 
	reg p;

	reg alu_out;

	// Declare other local wires and registers here

	// Assign PC debug net
	assign pc_debug_data = pc;


	//----------------------------------------------------------------------
	// Memory Module
	//----------------------------------------------------------------------

	// 1024-entry 16-bit memory (connect other ports)
	Memory mem(
		.clk      (clk),
		.rst      (rst),
		.r_addr_0 (dmem_r_addr),
		.r_addr_1 (mem_debug_addr),
		.w_addr   (dmem_w_addr),
		.w_data   (rf_rp_data),
		.w_en     (dmem_wr),
		.r_data_0 (dmem_r_data),
		.r_data_1 (mem_debug_data)
	);

	//----------------------------------------------------------------------
	// Register File Module
	//----------------------------------------------------------------------

	// 8-entry 16-bit register file (connect other ports)
	RegisterFile rfile(
		.clk      (clk),
		.rst      (rst),
		.r_addr_0 (rf_rp_addr),
		.r_addr_1 (ir[8:6]),
		.r_addr_2 (rf_debug_addr),
		.w_addr   (rf_w_addr),
		.w_data   (rf_w_data),
		.w_en     (rf_w_wr),
		.r_data_0 (rf_rp_data),
		.r_data_1 (rf_rq_data),
		.r_data_2 (rf_debug_data)
	);

	//----------------------------------------------------------------------
	// Add all other datapath logic here
	//----------------------------------------------------------------------

	always @(*) begin

		//Sends IR to controller & sign extending
		ir_out = ir;	
		ir_sext_10_0 = {5{ir[10]},ir[10:0]};
		ir_sext_8_0 = {7{ir[8]},ir[8:0]};
		ir_sext_5_0 = {10{ir[5]},ir[5:0]};
		ir_sext_4_0 = {11{ir[4]},ir[4:0]};
		
		//checks nzp N&n | Z&z | P&p | NAND(NZP)
		nzp_match = (ir[BR_N] && n) || (ir[BR_Z] && z) || (ir[BR_P] && p) || (!ir[BR_N] && !ir[BR_Z] && !ir[BR_P]);
		
		//DMEM Muxes
		case (dmem_r_addr_sel)
			DMEM_R_ADDR_PC: begin
			dmem_r_addr = pc;
			end
			DMEM_R_ADDR_PC_SEXT_8_0: begin
			dmem_r_addr = pc + ir_sext_8_0;
			end
			DMEM_R_ADDR_RF_RP_DATA: begin
			dmem_r_addr = rf_rp_data;
			end
			DMEM_R_ADDR_RF_RQ_DATA_SEXT_5_0: begin
			dmem_r_addr = rf_rq_data + ir_sext_5_0;
			end
		endcase
		
		//TODO: Continue with muxes
	end

	//TODO: Add sequential logic

endmodule

//==============================================================================
// Memory with 2 read ports, 1 write port
//==============================================================================

module Memory
#(
	parameter N_ELEMENTS = 128,      // Number of Memory Elements
	parameter ADDR_WIDTH = 16,        // Address Width (in bits)
	parameter DATA_WIDTH = 16         // Data Width (in bits)
)(
	// Clock + Reset
	input                   clk,      // Clock
	input                   rst,      // Reset (All entries -> 0)

	// Read Address Channel
	input  [ADDR_WIDTH-1:0] r_addr_0, // Read Address 0
	input  [ADDR_WIDTH-1:0] r_addr_1, // Read Address 1

	// Write Address, Data Channel
	input  [ADDR_WIDTH-1:0] w_addr,   // Write Address
	input  [DATA_WIDTH-1:0] w_data,   // Write Data
	input                   w_en,     // Write Enable

	// Read Data Channel
	output [DATA_WIDTH-1:0] r_data_0, // Read Data 0
	output [DATA_WIDTH-1:0] r_data_1  // Read Data 1

);

	// Memory Unit
	reg [DATA_WIDTH-1:0] mem[N_ELEMENTS-1:0];


	//---------------------------------------------------------------------------
	// BEGIN MEMORY INITIALIZATION BLOCK
	//   - Paste the code you generate for memory initialization in synthesis
	//     here, deleting the current code.
	//   - Use the LC3 Assembler on Blackboard to generate your Verilog.
	//---------------------------------------------------------------------------
	localparam PROGRAM_LENGTH = 46;
	wire [DATA_WIDTH-1:0] mem_init[PROGRAM_LENGTH-1:0];

	assign mem_init[0] = 16'h200F;   // LD R0 #15
	assign mem_init[1] = 16'hEC18;   // LEA R6 #24
	assign mem_init[2] = 16'h903F;   // NOT R0 R0
	assign mem_init[3] = 16'h1021;   // ADD R0 R0 #1
	assign mem_init[4] = 16'hEB9A;   // LEA R5 #-102
	assign mem_init[5] = 16'hA20C;   // LDI R1 #12
	assign mem_init[6] = 16'h6653;   // LDR R3 R1 #19
	assign mem_init[7] = 16'h0407;   // BRZ #7
	assign mem_init[8] = 16'h14C0;   // ADD R2 R3 R0
	assign mem_init[9] = 16'h1885;   // ADD R4 R2 R5
	assign mem_init[10] = 16'h0601;   // BRZP #1
	assign mem_init[11] = 16'h1486;   // ADD R2 R2 R6
	assign mem_init[12] = 16'h7453;   // STR R2 R1 #19
	assign mem_init[13] = 16'h1261;   // ADD R1 R1 #1
	assign mem_init[14] = 16'h4FF7;   // JSR #-9
	assign mem_init[15] = 16'hF000;   // HALT
	assign mem_init[16] = 16'h000F;   // 000F
	assign mem_init[17] = 16'h0000;   // 0000
	assign mem_init[18] = 16'h0011;   // 0011
	assign mem_init[19] = 16'h0061;   // 0061
	assign mem_init[20] = 16'h0062;   // 0062
	assign mem_init[21] = 16'h0063;   // 0063
	assign mem_init[22] = 16'h0064;   // 0064
	assign mem_init[23] = 16'h0065;   // 0065
	assign mem_init[24] = 16'h0066;   // 0066
	assign mem_init[25] = 16'h0067;   // 0067
	assign mem_init[26] = 16'h0068;   // 0068
	assign mem_init[27] = 16'h0069;   // 0069
	assign mem_init[28] = 16'h006A;   // 006A
	assign mem_init[29] = 16'h006B;   // 006B
	assign mem_init[30] = 16'h006C;   // 006C
	assign mem_init[31] = 16'h006D;   // 006D
	assign mem_init[32] = 16'h006E;   // 006E
	assign mem_init[33] = 16'h006F;   // 006F
	assign mem_init[34] = 16'h0070;   // 0070
	assign mem_init[35] = 16'h0071;   // 0071
	assign mem_init[36] = 16'h0072;   // 0072
	assign mem_init[37] = 16'h0073;   // 0073
	assign mem_init[38] = 16'h0074;   // 0074
	assign mem_init[39] = 16'h0075;   // 0075
	assign mem_init[40] = 16'h0076;   // 0076
	assign mem_init[41] = 16'h0077;   // 0077
	assign mem_init[42] = 16'h0078;   // 0078
	assign mem_init[43] = 16'h0079;   // 0079
	assign mem_init[44] = 16'h007A;   // 007A
	assign mem_init[45] = 16'h0000;   // 0000

	//---------------------------------------------------------------------------
	// END MEMORY INITIALIZATION BLOCK
	//---------------------------------------------------------------------------

	// Continuous Read
	assign r_data_0 = mem[r_addr_0];
	assign r_data_1 = mem[r_addr_1];

	// Synchronous Reset + Write
	genvar i;
	generate
		for (i = 0; i < N_ELEMENTS; i = i + 1) begin : wport
			always @(posedge clk) begin
				if (rst) begin
					if (i < PROGRAM_LENGTH) begin
						`ifndef SIM
							mem[i] <= mem_init[i];
						`endif
					end
					else begin
						`ifndef SIM
							mem[i] <= 0;
						`endif
					end
				end
				else if (w_en && w_addr == i) begin
					mem[i] <= w_data;
				end
			end
		end
	endgenerate

endmodule

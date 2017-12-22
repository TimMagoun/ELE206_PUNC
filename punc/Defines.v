//==============================================================================
// Global Defines for PUnC LC3 Computer
//==============================================================================

// Add defines here that you'll use in both the datapath and the controller

//------------------------------------------------------------------------------
// Opcodes
//------------------------------------------------------------------------------
`define OC 15:12       // Used to select opcode bits from the IR

`define OC_ADD 4'b0001 // Instruction-specific opcodes
`define OC_AND 4'b0101
`define OC_BR  4'b0000
`define OC_JMP 4'b1100
`define OC_JSR 4'b0100
`define OC_LD  4'b0010
`define OC_LDI 4'b1010
`define OC_LDR 4'b0110
`define OC_LEA 4'b1110
`define OC_NOT 4'b1001
`define OC_ST  4'b0011
`define OC_STI 4'b1011
`define OC_STR 4'b0111
`define OC_HLT 4'b1111

`define IMM_BIT_NUM 5  // Bit for distinguishing ADDR/ADDI and ANDR/ANDI
`define IS_IMM 1'b1
`define JSR_BIT_NUM 11 // Bit for distinguishing JSR/JSRR
`define IS_JSR 1'b1

`define BR_N 11        // Location of special bits in BR instruction
`define BR_Z 10
`define BR_P 9

`define PC_Data_Sel_PC_8_0          2'd0    //Selecting PC_Data
`define PC_Data_Sel_PC_10_0         2'd1 
`define PC_Data_Sel_RF_Rq_Data      2'd2

`define DMem_R_Addr_Sel_PC          2'd0   //Selecting DMem_R_Addr
`define DMem_R_Addr_Sel_PC_8_0      2'd1
`define DMem_R_Addr_Sel_RF_Rp_Data  2'd2
`define DMem_R_Addr_Sel_RF_Rq_5_0   2'd3

`define DMem_W_Addr_Sel_PC_8_0      2'd0   //Selecting DMem_W_Addr
`define DMem_W_Addr_Sel_Temp_Data   2'd1
`define DMem_W_Addr_Sel_RF_Rq_5_0   2'd2

`define RF_W_Addr_Sel_R7            1'd0   //Selecting RF_W_Addr
`define RF_W_Addr_Sel_11_9          1'd1

`define RF_Rp_Addr_Sel_11_9         1'd0   //Selecting RF_Rp_Addr
`define RF_Rp_Addr_Sel_2_0          1'd1

`define RF_W_Data_Sel_ALU           2'd0   //Selecting RF_W_Data_ALU
`define RF_W_Data_Sel_PC_8_0        2'd1
`define RF_W_Data_Sel_DMem_R        2'd2
`define RF_W_Data_Sel_PC            2'd3

`define ALU_In_A_Sel_Rp_Data        1'd0   //Selecting ALU Input A
`define ALU_In_A_4_0                1'd1

`define ALU_Fn_Sel_PassA            2'd0   //Selecting ALU Functions
`define ALU_Fn_Sel_ADD              2'd1
`define ALU_Fn_Sel_AND              2'd2
`define ALU_Fn_Sel_NOT_B            2'd3  










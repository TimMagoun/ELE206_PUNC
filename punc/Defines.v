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

//MUX SELECT CONSTANTS

`define PC_SEL_PC_SEXT_8_0 2'd0
`define PC_SEL_PC_SEXT_10_0 2'd1
`define PC_SEL_RF_RQ_DATA 2'd2

`define DMEM_R_ADDR_PC 2'd0
`define DMEM_R_ADDR_PC_SEXT_8_0 2'd1
`define DMEM_R_ADDR_RF_RP_DATA 2'd2
`define DMEM_R_ADDR_RF_RQ_DATA_SEXT_5_0 2'd3

`define DMEM_W_ADDR_PC_SEXT_8_0 2'd0
`define DMEM_W_ADDR_TEMP_DATA 2'd1
`define DMEM_W_ADDR_RF_RQ_DATA_SEXT_5_0 2'd2

`define RF_W_ADDR_111 1'd0
`define RF_W_ADDR_IR_11_9 1'd1

`define RF_RP_ADDR_IR_11_9 1'd0
`define RF_RP_ADDR_IR_2_0 1'd1

`define RF_W_DATA_ALU 2'd0
`define RF_W_DATA_PC_SEXT_8_0 2'd1
`define RF_W_DATA_DMEM_R_DATA 2'd2
`define RF_W_DATA_PC 2'd3

`define ALU_IN_A_RP_DATA 1'd0
`define ALU_IN_A_IR_4_0 1'd1

`define ALU_SEL_PASS_A 2'd0
`define ALU_SEL_ADD 2'd1
`define ALU_SEL_AND 2'd2
`define ALU_SEL_NOT 2'd3
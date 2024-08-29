-------------------------------------------------------------------------
-- Design unit: RISC V package
-- Description: package with...
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package RISC_V_package is  
        
    -- inst_type defines the instructions decodable by the control unit
    type Instruction_type is (
        -- Base instructions
        LUI, AUIPC, JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU, 
        LB, LH, LW, LBU, LHU, SB, SH, SW, ADDI, SLTI, SLTIU, XORI, ORI, ANDI, 
        SLLI, SRLI, SRAI, ADD, SUB, SLLins, SLT, SLTU, XORins, SRLins, SRAins, ORins, ANDins, 
        FENCE, FENCEI, ECALL, EBREAK, CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI,

        -- Multiplication/Division instructions (M-extension)
        MUL, MULH, MULHSU, MULHU, DIV, DIVU, REMins, REMU,

        -- Atomic instructions (A-extension)
        LR_W, SC_W, AMOSWAP_W, AMOADD_W, AMOXOR_W, AMOAND_W, AMOOR_W, 
        AMOMIN_W, AMOMAX_W, AMOMINU_W, AMOMAXU_W,

        -- Floating-point instructions (F-extension)
        FLW, FSW, FMADD_S, FMSUB_S, FNMSUB_S, FNMADD_S, 
        FADD_S, FSUB_S, FMUL_S, FDIV_S, FSQRT_S, 
        FSGNJ_S, FSGNJN_S, FSGNJX_S, FMIN_S, FMAX_S, 
        FCVT_W_S, FCVT_WU_S, FMV_X_W, FEQ_S, FLT_S, FLE_S, 
        FCLASS_S, FCVT_S_W, FCVT_S_WU, FMV_W_X,

        -- Invalid instruction
        INVALID_INSTRUCTION
    );

    -- Instruction format types
    type Instruction_format is (R, I, S, B, U, J);

    -- Microinstruction structure for control signals
    type Microinstruction is record
        RegWrite    : std_logic;        -- Register file write control
        MemToReg    : std_logic;        -- Selects the data to the register file
        MemWrite    : std_logic;        -- Enable the data memory write
        instruction : Instruction_type; -- Decoded instruction 
        format      : Instruction_format; -- Select (R, I, S, B, U, J) ALU second operand        
    end record;

end RISC_V_package;




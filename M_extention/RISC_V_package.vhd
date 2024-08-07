-------------------------------------------------------------------------
-- Design unit: RISC V package
-- Description: package with...
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package RISC_V_package is  
        
    -- inst_type defines the instructions decodable by the control unit
    type Instruction_type is (LUI, AUIPC ,JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU, LB, LH, LW, LBU, LHU, SB, SH, SW, ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI, ADD, SUB, SLLins, SLT, SLTU, XORins, SRLins, SRAins, ORins, ANDins, FENCE, FENCEI, ECALL, EBREAK, CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI, MUL, MULH, MULHSU, MULHU, DIV, DIVU, REMins, REMU, INVALID_INSTRUCTION);

-- MUL, MULH, MULHSU, MULHU, DIV, DIVU, REMins, REMU

    type Instruction_format is (R,I,S,B,U,J);


    type Microinstruction is record
        RegWrite    : std_logic;        -- Register file write control
        MemToReg    : std_logic;        -- Selects the data to the register file
        MemWrite    : std_logic;        -- Enable the data memory write
        instruction : Instruction_type; -- Decoded instruction 
	format      : Instruction_format; --Select (R,I,S,B,U,J) ALU second operand        
    end record;
         
         
end RISC_V_package;



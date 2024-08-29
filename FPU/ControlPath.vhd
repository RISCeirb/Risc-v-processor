-------------------------------------------------------------------------
-- Design unit: Control path
-- Description: RISC-V control path supporting various instructions including
--              the M, A and F extensions.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.RISC_V_package.all;

entity ControlPath is
    port (  
        clock           : in std_logic;
        reset           : in std_logic;
        instruction     : in std_logic_vector(31 downto 0);
        uins            : out microinstruction
    );
end ControlPath;
                   

architecture behavioral of ControlPath is

    -- Alias to identify the instructions based on the 'opcode' and 'funct' fields
    alias  opcode: std_logic_vector(6 downto 0) is instruction(6 downto 0);
    alias  funct3: std_logic_vector(2 downto 0) is instruction(14 downto 12);
    alias  funct7: std_logic_vector(6 downto 0) is instruction(31 downto 25);
    alias  funct5: std_logic_vector(6 downto 0) is instruction(31 downto 27);
    alias  rd: std_logic_vector(4 downto 0) is instruction(11 downto 7);

    signal decodedInstruction: Instruction_type;    
    signal decodedformat: Instruction_format;

begin

    uins.instruction <= decodedInstruction;  -- Used to set the ALU operation

    -- Instruction decode
    decodedInstruction <=   -- U-type
                            LUI     when opcode = "0110111" else 
                            AUIPC   when opcode = "0010111" else
                            -- J-type 
                            JAL     when opcode = "1101111" else
                            -- I-type
                            JALR    when opcode = "1100111" and funct3 ="000" else
                            -- B-type
                            BEQ     when opcode = "1100011" and funct3 ="000" else
                            BNE     when opcode = "1100011" and funct3 ="001" else
                            BLT     when opcode = "1100011" and funct3 ="100" else
                            BGE     when opcode = "1100011" and funct3 ="101" else
                            BLTU    when opcode = "1100011" and funct3 ="110" else
                            BGEU    when opcode = "1100011" and funct3 ="111" else
                            -- Load I-type
                            LB      when opcode = "0000011" and funct3 ="000" else
                            LH      when opcode = "0000011" and funct3 ="001" else
                            LW      when opcode = "0000011" and funct3 ="010" else
                            LBU     when opcode = "0000011" and funct3 ="100" else
                            LHU     when opcode = "0000011" and funct3 ="101" else
                            -- Store S-type
                            SB      when opcode = "0100011" and funct3 ="000" else
                            SH      when opcode = "0100011" and funct3 ="001" else
                            SW      when opcode = "0100011" and funct3 ="010" else
                            -- I-type 
                            ADDI    when opcode = "0010011" and funct3 ="000" else
                            SLTI    when opcode = "0010011" and funct3 ="010" else
                            SLTIU   when opcode = "0010011" and funct3 ="011" else
                            XORI    when opcode = "0010011" and funct3 ="100" else
                            ORI     when opcode = "0010011" and funct3 ="110" else
                            ANDI    when opcode = "0010011" and funct3 ="111" else
                            SLLI    when opcode = "0010011" and funct3 ="001" and funct7="0000000" else 
                            SRLI    when opcode = "0010011" and funct3 ="101" and funct7="0000000" else  
                            SRAI    when opcode = "0010011" and funct3 ="101" and funct7="0100000" else                 
                            -- R-type
                            ADD     when opcode = "0110011" and funct3 ="000" and funct7="0000000" else  
                            SUB     when opcode = "0110011" and funct3 ="000" and funct7="0100000" else  
                            SLLins  when opcode = "0110011" and funct3 ="001" and funct7="0000000" else
                            SLT     when opcode = "0110011" and funct3 ="010" and funct7="0000000" else
                            SLTU    when opcode = "0110011" and funct3 ="011" and funct7="0000000" else
                            XORins  when opcode = "0110011" and funct3 ="100" and funct7="0000000" else
                            SRLins  when opcode = "0110011" and funct3 ="101" and funct7="0000000" else
                            SRAins  when opcode = "0110011" and funct3 ="101" and funct7="0100000" else
                            ORins   when opcode = "0110011" and funct3 ="110" and funct7="0000000" else
                            ANDins  when opcode = "0110011" and funct3 ="111" and funct7="0000000" else
			                -- Fence instruction
                            FENCE   when opcode = "0001111" and funct3 ="000" else
                            FENCEI  when opcode = "0001111" and funct3 ="001" else
                            -- Break instruction
                            ECALL   when instruction ="00000000000000000000000001110011" else 
                            EBREAK  when instruction ="00000000000100000000000001110011" else
                            -- CSR instruction                     
                            CSRRW   when opcode = "1110011" and funct3 ="001" else
                            CSRRS   when opcode = "1110011" and funct3 ="010" else
                            CSRRC   when opcode = "1110011" and funct3 ="011" else
                            CSRRWI  when opcode = "1110011" and funct3 ="101" else
                            CSRRSI  when opcode = "1110011" and funct3 ="110" else
                            CSRRCI  when opcode = "1110011" and funct3 ="111" else
                            -- M-Extension instruction 
                            MUL     when opcode = "0110011" and funct3 ="000" and funct7="0000001" else 
                            MULH    when opcode = "0110011" and funct3 ="001" and funct7="0000001" else 
                            MULHSU  when opcode = "0110011" and funct3 ="010" and funct7="0000001" else 
                            MULHU   when opcode = "0110011" and funct3 ="011" and funct7="0000001" else 
                            DIV     when opcode = "0110011" and funct3 ="100" and funct7="0000001" else 
                            DIVU    when opcode = "0110011" and funct3 ="101" and funct7="0000001" else 
                            REMins  when opcode = "0110011" and funct3 ="110" and funct7="0000001" else 
                            REMU    when opcode = "0110011" and funct3 ="111" and funct7="0000001" else 
                            -- Atomic A-extension instructions
                            LR_W        when opcode = "0101111" and funct3 = "010" and funct5="00010" else
                            SC_W        when opcode = "0101111" and funct3 = "010" and funct5="00011" else
                            AMOSWAP_W   when opcode = "0101111" and funct3 = "010" and funct5="00001" else
                            AMOADD_W    when opcode = "0101111" and funct3 = "010" and funct5="00000" else
                            AMOXOR_W    when opcode = "0101111" and funct3 = "010" and funct5="00100" else
                            AMOAND_W    when opcode = "0101111" and funct3 = "010" and funct5="01100" else
                            AMOOR_W     when opcode = "0101111" and funct3 = "010" and funct5="01000" else
                            AMOMIN_W    when opcode = "0101111" and funct3 = "010" and funct5="10000" else
                            AMOMAX_W    when opcode = "0101111" and funct3 = "010" and funct5="10100" else
                            AMOMINU_W   when opcode = "0101111" and funct3 = "010" and funct5="11000" else
                            AMOMAXU_W   when opcode = "0101111" and funct3 = "010" and funct5="11100" else
                            -- Float F-extension instructions
                            FLW         when opcode = "0000111" and funct3 = "010" else
                            FSW         when opcode = "0100111" and funct3 = "010" else
                            FMADD_S     when opcode = "1000011" else
                            FMSUB_S     when opcode = "1000111" else
                            FNMSUB_S    when opcode = "1001011" else
                            FNMADD_S    when opcode = "1001111" else
                            FADD_S      when opcode = "1010011" and funct7 = "0000000" else
                            FSUB_S      when opcode = "1010011" and funct7 = "0000100" else
                            FMUL_S      when opcode = "1010011" and funct7 = "0001000" else
                            FDIV_S      when opcode = "1010011" and funct7 = "0001100" else
                            FSQRT_S     when opcode = "1010011" and funct7 = "0101100" else
                            FSGNJ_S     when opcode = "1010011" and funct7 = "0010000" and funct3 = "000" else
                            FSGNJN_S    when opcode = "1010011" and funct7 = "0010000" and funct3 = "001" else
                            FSGNJX_S    when opcode = "1010011" and funct7 = "0010000" and funct3 = "010" else
                            FMIN_S      when opcode = "1010011" and funct7 = "0010100" and funct3 = "000" else
                            FMAX_S      when opcode = "1010011" and funct7 = "0010100" and funct3 = "001" else
                            FCVT_W_S    when opcode = "1010011" and funct7 = "1100000" else
                            FCVT_WU_S   when opcode = "1010011" and funct7 = "1100000" else
                            FMV_X_W     when opcode = "1010011" and funct7 = "1110000" and funct3 = "000" else
                            FEQ_S       when opcode = "1010011" and funct7 = "1010000" and funct3 = "010" else
                            FLT_S       when opcode = "1010011" and funct7 = "1010000" and funct3 = "001" else
                            FLE_S       when opcode = "1010011" and funct7 = "1010000" and funct3 = "000" else
                            FCLASS_S    when opcode = "1010011" and funct7 = "1110000" and funct3 = "001" else
                            FCVT_S_W    when opcode = "1010011" and funct7 = "1101000" else
                            FCVT_S_WU   when opcode = "1010011" and funct7 = "1101000" else
                            FMV_W_X     when opcode = "1010011" and funct7 = "1111000" and funct3 = "000" else


			    -- INVALID_INSTRUCTION
                            INVALID_INSTRUCTION ;    -- Invalid or not implemented instruction
            
    assert not (decodedInstruction = INVALID_INSTRUCTION and reset = '0')    
    report "******************* INVALID INSTRUCTION *************"
    severity error;    

    -- Set the instruction format for different instruction types
    uins.format <= decodedformat;  -- Used to set the Mux operation

    decodedformat  <=   R  when opcode = "0110011" else
                        I  when opcode = "0010011" or opcode = "0000011" or opcode = "1100111" else
                        U  when opcode = "0110111" or opcode = "0010111" else
                        S  when opcode = "0100011" else
                        B  when opcode = "1100011" else
                        J;

    -- Write for all types of instructions except S and B (Store and Branch)
    uins.RegWrite <= '1' when decodedformat = R or decodedformat = I or decodedformat = U or decodedformat = J 
    else '0';

    -- In load instructions, the data comes from the data memory
    uins.MemToReg <= '1' when decodedInstruction = LW or decodedInstruction = LH or decodedInstruction = LHU or decodedInstruction = LB or decodedInstruction = LBU  
    else '0';
        
    -- S-type instructions: Write data in the memory             
    uins.MemWrite <= '1' when decodedInstruction = SW or decodedInstruction = SH or decodedInstruction = SB 
    else '0';
    

end behavioral;


-------------------------------------------------------------------------
-- Design unit: Control path
-- Description: MIPS control path supporting ADDU, SUBU, AND, OR, LW, SW, 
--              ADDIU, ORI, SLT, BEQ, J, LUI instructions.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
--use work.MIPS_package.all;

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


--Risc-v version

    -- Alias to identify the instructions based on the 'opcode' and 'funct' fields
    
    
    alias  opcode: std_logic_vector(6 downto 0) is instruction(6 downto 0);
    alias  funct3: std_logic_vector(2 downto 0) is instruction(14 downto 12);
    alias  funct7: std_logic_vector(6 downto 0) is instruction(31 downto 25);
    
    
    -- Retrieves the rs fields from the instruction
    
    
    -- alias rs1: std_logic_vector(4 downto 0) is instruction(19 downto 15); --not useful, only return register is useful
    -- alias rs2: std_logic_vector(4 downto 0) is instruction(24 downto 20); --not useful, only return register is useful
    alias rd: std_logic_vector(4 downto 0) is instruction(11 downto 7);
 

    signal decodedInstruction: Instruction_type;    
   
    signal decodedformat: Instruction_format;
    
    
    
begin

    uins.instruction <= decodedInstruction;     -- Used to set the ALU operation
    
    
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


                            INVALID_INSTRUCTION ;    -- Invalid or not implemented instruction
            
    assert not (decodedInstruction = INVALID_INSTRUCTION and reset = '0')    
    report "******************* INVALID INSTRUCTION *************"
    severity error;    



    --    
     
    uins.format <= decodedformat;     -- Used to set the Mux operation

    decodedformat  <=   R  when opcode = "0110011" else
                        I  when opcode = "0010011" or opcode = "0000011" or opcode = "1100111" else
                        U  when opcode = "0110111" or opcode = "0010111" else
                        S  when opcode = "0100011" else
                        B  when opcode = "1100011" else
                        J;    
    
    -- Write for all type of instrcution except S and B (Store and Branch)
    
    uins.RegWrite <= '1' when decodedformat = R or decodedformat = I or decodedformat = U or decodedformat = J 
    else '0';
    
    -- In load instructions the data comes from the data memory
 
    uins.MemToReg <= '1' when decodedInstruction = LW or decodedInstruction = LH or decodedInstruction = LHU or decodedInstruction = LB or decodedInstruction = LBU  else '0';
        
    -- S-type instructions : Write data in the memory             

    uins.MemWrite <= '1' when decodedInstruction = SW or decodedInstruction = SH or decodedInstruction = SB else '0';
    
    -- need to code fence and break instruction and csr
    
    
end behavioral;

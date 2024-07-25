-------------------------------------------------------------------------
-- Design unit: Data path
-- Description: MIPS data path supporting ADDU, SUBU, AND, OR, LW, SW,  
--                  ADDIU, ORI, SLT, BEQ, J, LUI instructions.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
-- use work.MIPS_package.all;

use work.RISC_V_package.all;


   
entity DataPath is
    generic (
        PC_START_ADDRESS    : integer := 0
    );
    port (  
        pc                  : in  std_logic_vector(31 downto 0);
        new_pc              : out  std_logic_vector(31 downto 0);
        clock               : in  std_logic;
        reset               : in  std_logic;
        -- instructionAddress  : out std_logic_vector(31 downto 0);  -- Instruction memory address bus
        instruction         : in  std_logic_vector(31 downto 0);  -- Data bus from instruction memory
        dataAddress         : out std_logic_vector(31 downto 0);  -- Data memory address bus
        data_i              : in  std_logic_vector(31 downto 0);  -- Data bus from data memory 
        data_o              : out std_logic_vector(31 downto 0);  -- Data bus to data memory
        uins                : in  Microinstruction                -- Control path microinstruction
    );
end DataPath;


architecture structural of DataPath is

    signal incrementedPC, result, readData1, readData2, ALUoperand2, writeData: std_logic_vector(31 downto 0);
--    signal signExtended_i, signExtended_u, signExtended_s, signExtended_b, signExtended_j: std_logic_vector(31 downto 0);
--    signal new_pc: std_logic_vector(31 downto 0);
--    signal pc: std_logic_vector(31 downto 0);
    -- signal branchOffset, branchTarget: std_logic_vector(31 downto 0);
    -- signal jumpTarget: std_logic_vector(31 downto 0);
    -- signal writeRegister   : std_logic_vector(4 downto 0);
   
   
 -- Mips version  
    
    -- Retrieves the rs field from the instruction
    --alias rs: std_logic_vector(4 downto 0) is instruction(25 downto 21);
        
    -- Retrieves the rt field from the instruction
    --alias rt: std_logic_vector(4 downto 0) is instruction(20 downto 16);
        
    -- Retrieves the rd field from the instruction
    -- alias rd: std_logic_vector(4 downto 0) is instruction(15 downto 11);
    
    --signal zero : std_logic; 
    
  -- Risc-v version  
    
    -- Retrieves the rs1 field from the instruction

            alias rs1: std_logic_vector(4 downto 0) is instruction(19 downto 15); 
         
    -- Retrieves the rs2 field from the instruction

            alias rs2: std_logic_vector(4 downto 0) is instruction(24 downto 20);
        
    -- Retrieves the rd field from the instruction
        
            alias rd: std_logic_vector(4 downto 0) is instruction(11 downto 7);
    
     
     signal branch : std_logic; 
   
   
begin

    ---- Risc-v version  -------------

    -- Instruction memory is addressed by the PC register
    -- instructionAddress <= new_pc;
    -- incrementedPC points the next instruction address
    -- ADDER over the PC register
    -- ADDER_PC: incrementedPC <= STD_LOGIC_VECTOR(UNSIGNED(pc_q) + TO_UNSIGNED(4,32));
    
    -- PC register
--    PROGRAM_COUNTER:    entity work.RegisterNbits
--        generic map (
--            LENGTH      => 32,
--            INIT_VALUE  => PC_START_ADDRESS
--        )
--        port map (
--            clock       => clock,
--            reset       => reset,
--            ce          => '1', 
--            d           => pc_d, 
--            q           => pc_q
--        );
        
    PC_CALCULUS:  entity work.NEW_PC
    port map(  rs1             => readData1,
               pc              => pc,
               instruction     => instruction,
               new_pc          => new_pc,
               branch          => branch,
               uins            => uins 
            );

    -- Selects the second ALU operand
    -- MUX at the ALU input
    
    MUX_ALU_RISC_V:  entity work.MUX_ALU
    port map(  register2       => readData2,
               instruction     => instruction,
               data_mux        => ALUoperand2,
               uins            => uins 
            );

        -- Selects the instruction field witch contains the register to be written
    -- MUX at the register file input
   
   --   MUX_RF: writeRegister <= rs2 when uins.regDst = '0' else rd;

    
    -- Selects the data to be written in the register file
    -- MUX at the data memory output
    MUX_DATA_LOAD:  entity work.MUX_LOAD
    port map(   
                mem_data         => data_i,
                result_ALU       => result,
                writeData        => writeData,
                uins             => uins 
            );

    -- Data to data memory comes from the second read register at register file (enable to choose the bits give to the memory)

    MUX_DATA_STORE:  entity work.MUX_STORE
    port map(   rs2             => readData2,  
                data_to_mem     => data_o,                  
                uins            => uins 
            );

    
    -- ALU output address the data memory
    dataAddress <= result;
    
    
    -- Register file
    REGISTER_FILE: entity work.RegisterFile(structural)
        port map (
            clock            => clock,
            reset            => reset,            
            write            => uins.RegWrite,            
            readRegister1    => rs1,    
            readRegister2    => rs2,
            writeRegister    => rd,
            writeData        => writeData,          
            readData1        => readData1,        
            readData2        => readData2
        );
    
    
    -- Arithmetic/Logic Unit
    ALU: entity work.ALU(behavioral)
        port map (
            pc          => pc,
            operand1    => readData1,
            operand2    => ALUoperand2,
            result      => result,
            branch      => branch,
            operation   => uins.instruction
        );

end structural;   
   
      ------ Mips-version -----------
    
    
    
    
    
    
    
    -- Selects the instruction field witch contains the register to be written
    -- MUX at the register file input
 --   MUX_RF: writeRegister <= rs2 when uins.regDst = '0' else rd;
    
    
    
    -- Sign extends the low 16 bits of instruction 
 --   SIGN_EX: signExtended <= x"FFFF" & instruction(15 downto 0) when instruction(15) = '1' else 
       --             x"0000" & instruction(15 downto 0);
                    
                    
                    
    -- Zero extends the low 16 bits of instruction 
--    ZERO_EX: zeroExtended <= x"0000" & instruction(15 downto 0);
       
       
  
       
    -- Converts the branch offset from words to bytes (multiply by 4) 
    -- Hardware at the second ADDER input
    
    
 --   SHIFT_L: branchOffset <= signExtended(29 downto 0) & "00";
    
    
    
    -- Branch target address
    
    -- Branch ADDER
    
    
    -- ADDER_BRANCH: branchTarget <= STD_LOGIC_VECTOR(UNSIGNED(incrementedPC) + UNSIGNED(branchOffset));
    
    
    -- Jump target address
    --jumpTarget <= incrementedPC(31 downto 28) & instruction(25 downto 0) & "00";
    
    
    -- MUX which selects the PC value
    --MUX_PC: pc_d <= branchTarget when (uins.Branch and branch) = '1' else 
            --jumpTarget when uins.Jump = '1' else
            --incrementedPC;
      
    -- Selects the second ALU operand
    -- MUX at the ALU input
    --MUX_ALU: ALUoperand2 <= readData2 when uins.ALUSrc = "00" else
                            --zeroExtended when uins.ALUSrc = "01" else
                            --signExtended;
    
    -- Selects the data to be written in the register file
    -- MUX at the data memory output
    --MUX_DATA_MEM: writeData <= data_i when uins.memToReg = '1' else result;
    

    -- Data to data memory comes from the second read register at register file
    --data_o <= readData2;
    
    -- ALU output address the data memory
    --dataAddress <= result;
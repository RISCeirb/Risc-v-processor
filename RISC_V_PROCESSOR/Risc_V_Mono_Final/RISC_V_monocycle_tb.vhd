-------------------------------------------------------------------------
-- Design unit: RISC-V monocycle test bench
-- Description: 
-------------------------------------------------------------------------

library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISC_V_package.all;

-- librairy de simulation avec fichier txt

use std.textio.all;
use IEEE.std_logic_textio.all;

entity RISC_V_monocycle_tb is
end RISC_V_monocycle_tb;


architecture structural of RISC_V_monocycle_tb is

    signal clock: std_logic := '0';
    signal reset, MemWrite: std_logic;
    signal instructionAddress, dataAddress, instruction, data_i, data_o : std_logic_vector(31 downto 0);
    signal uins: Microinstruction;

    --constant MARS_INSTRUCTION_OFFSET    : std_logic_vector(31 downto 0) := x"00400000";
    --constant MARS_DATA_OFFSET           : std_logic_vector(31 downto 0) := x"10010000";
    
    
    constant RARS_INSTRUCTION_OFFSET    : std_logic_vector(31 downto 0) := x"00400000";
    constant RARS_DATA_OFFSET           : std_logic_vector(31 downto 0) := x"10010000";
    
begin

    clock <= not clock after 5 ns;
    
    reset <= '1', '0' after 7 ns;
                
        
    RISC_V_MONOCYCLE: entity work.RISC_V_monocycle(structural) 
        generic map (
            PC_START_ADDRESS => TO_INTEGER(UNSIGNED(RARS_INSTRUCTION_OFFSET))
            --PC_START_ADDRESS => TO_INTEGER(UNSIGNED(MARS_INSTRUCTION_OFFSET))
        )
        port map (
            clock               => clock,
            reset               => reset,
            
            -- Instruction memory interface
            instructionAddress  => instructionAddress,    
            instruction         => instruction,        
                 
             -- Data memory interface
            dataAddress         => dataAddress,
            data_i              => data_i,
            data_o              => data_o,
            MemWrite            => MemWrite
        );
    
    
    INSTRUCTION_MEMORY: entity work.Memory(behavioral)
        generic map (
            SIZE            => 100,                 -- Memory depth
            --START_ADDRESS   => MARS_INSTRUCTION_OFFSET,    -- MARS initial address (mapped to memory address 0x00000000)
            --imageFileName   => "BubbleSort_code.txt"
            START_ADDRESS   => RARS_INSTRUCTION_OFFSET, 
            imageFileName   => "instructionmemory.txt"
        )
        port map (
            clock           => clock,
            MemWrite        => '0',
            address         => instructionAddress,    
            data_i          => data_o,
            data_o          => instruction
        );
        
        
    DATA_MEMORY: entity work.Memory(behavioral)
        generic map (
            SIZE            => 100,             -- Memory depth
            --START_ADDRESS   => MARS_DATA_OFFSET,     -- MARS initial address (mapped to memory address 0x00000000)
            --imageFileName   => "BubbleSort_data.txt"
            START_ADDRESS   => RARS_DATA_OFFSET,
            imageFileName   => "datamemory.txt"
        )
        port map (
            clock           => clock,
            MemWrite        => MemWrite,
            address         => dataAddress, 
            data_i          => data_o,
            data_o          => data_i
        );    
    
end structural;



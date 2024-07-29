-------------------------------------------------------------------------
-- Design unit: MIPS monocycle
-- Description: Control and data paths port map
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--use work.MIPS_package.all;
use work.RISC_V_package.all;

entity RISC_V_monocycle is
    generic (
        PC_START_ADDRESS    : integer := 0 
    );
    port ( 
        clock, reset        : in std_logic;
        
        -- Instruction memory interface
        instructionAddress  : out std_logic_vector(31 downto 0);
        --pc                  : in  std_logic_vector(31 downto 0);
        --new_pc              : out  std_logic_vector(31 downto 0);
        instruction         : in  std_logic_vector(31 downto 0);
        
        -- Data memory interface
        dataAddress         : out std_logic_vector(31 downto 0);
        data_i              : in  std_logic_vector(31 downto 0);      
        data_o              : out std_logic_vector(31 downto 0);
        MemWrite            : out std_logic 
    );
end RISC_V_monocycle;

architecture structural of RISC_V_monocycle is
    
    signal uins: Microinstruction;
    signal new_pc: std_logic_vector(31 downto 0);
    signal pc: std_logic_vector(31 downto 0);

begin

     CONTROL_PATH: entity work.ControlPath(behavioral)
         port map (
             clock          => clock,
             reset          => reset,
             instruction    => instruction,
             uins           => uins
         );
         
         
     DATA_PATH: entity work.DataPath(structural)
         generic map (
            PC_START_ADDRESS => PC_START_ADDRESS
         )
         port map (
            clock               => clock,
            reset               => reset,
            
            uins                => uins,
             
        --    instructionAddress  => instructionAddress,
            new_pc              => new_pc,
            pc                  => pc,
            instruction         => instruction,
             
            dataAddress         => dataAddress,
            data_i              => data_i,
            data_o              => data_o
         );
         
         PROGRAM_COUNTER:    entity work.RegisterNbits
        generic map (
            LENGTH      => 32,
            INIT_VALUE  => PC_START_ADDRESS
        )
        port map (
            clock       => clock,
            reset       => reset,
            ce          => '1', 
            d           => new_pc, 
            q           => pc
        );
     instructionAddress <= pc;
     MemWrite <= uins.MemWrite;
     
end structural;

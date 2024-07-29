-------------------------------------------------------------------------
-- Design unit: Register
-- Description: Parameterizable length clock enabled register.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.RISC_V_package.all;

entity MEM_WB_Register is
    generic (
        LENGTH      : integer := 32;
        INIT_VALUE  : integer := 0 
    );
    port (  
        clock       : in std_logic;
        reset       : in std_logic;
        ce          : in std_logic;
        data_load_mem : in  std_logic_vector (LENGTH-1 downto 0);
        data_load_wb  : out std_logic_vector (LENGTH-1 downto 0);
        resultaluwb : out  std_logic_vector (LENGTH-1 downto 0);
        resultalumem : in std_logic_vector (LENGTH-1 downto 0);
        rd_mem       : in std_logic_vector(4 downto 0);
        rd_wb      : out std_logic_vector(4 downto 0);
        uins_mem    : in  Microinstruction;
        uins_wb     : out Microinstruction
    );
end MEM_WB_Register;


architecture behavioral of MEM_WB_Register is
begin

    process(clock, reset)
    begin
        if reset = '1' then
            data_load_wb <= STD_LOGIC_VECTOR(TO_UNSIGNED(INIT_VALUE, LENGTH));        
        
        elsif rising_edge(clock) then
            if ce = '1' then
                data_load_wb <= data_load_mem;
                uins_wb <= uins_mem;
                resultaluwb <= resultalumem;
                rd_wb <= rd_mem; 
            end if;
        end if;
    end process;
        
end behavioral;

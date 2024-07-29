-------------------------------------------------------------------------
-- Design unit: Register
-- Description: Parameterizable length clock enabled register.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.RISC_V_package.all;

entity ID_EX_Register is
    generic (
        LENGTH      : integer := 32;
        INIT_VALUE  : integer := 0 
    );
    port (  
        clock       : in std_logic;
        reset       : in std_logic; 
        ce          : in std_logic;
        pc_id       : in  std_logic_vector (LENGTH-1 downto 0);
        pc_ex       : out std_logic_vector (LENGTH-1 downto 0);
        instruction_id      : in  std_logic_vector (LENGTH-1 downto 0);
        instruction_ex      : out std_logic_vector (LENGTH-1 downto 0);
        uins_id     : in  Microinstruction;
        uins_ex     : out Microinstruction;
        -- rd_stall      : in std_logic_vector(4 downto 0);
        -- pc_stall : in std_logic;
        -- rd_ex       : out std_logic_vector(4 downto 0);
        -- rs1_ex       : out std_logic_vector(4 downto 0);
        -- rs2_ex       : out std_logic_vector(4 downto 0);
        data_1_id   : in  std_logic_vector (LENGTH-1 downto 0);
        data_1_ex   : out  std_logic_vector (LENGTH-1 downto 0);
        data_2_id   : in  std_logic_vector (LENGTH-1 downto 0);
        data_2_ex   : out  std_logic_vector (LENGTH-1 downto 0)
    );
end ID_EX_Register;


architecture behavioral of ID_EX_Register is


begin

    process(clock, reset)
    begin
        if reset = '1' then
            pc_ex <= STD_LOGIC_VECTOR(TO_UNSIGNED(INIT_VALUE, LENGTH));
        elsif rising_edge(clock)  then
               		pc_ex <= pc_id; 
	                uins_ex <= uins_id;
	                instruction_ex <= instruction_id;
	                data_1_ex <= data_1_id;
	                data_2_ex <= data_2_id;
			-- rd_ex     <= rd_stall;    
        end if;
    end process;
        
end behavioral;

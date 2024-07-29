-------------------------------------------------------------------------
-- Design unit: Register
-- Description: Parameterizable length clock enabled register.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

-- IF/ID register i will give an instruction to execute for each clock to the controll path 

entity IF_ID_Register is
    generic (
        LENGTH      : integer := 32;
        INIT_VALUE  : integer := 0 
    );
    port (  
        clock       : in std_logic;
        reset       : in std_logic; 
        ce          : in std_logic;
        pc_if           : in  std_logic_vector (LENGTH-1 downto 0);
        pc_id           : out std_logic_vector (LENGTH-1 downto 0);
        instruction_if           : in  std_logic_vector (LENGTH-1 downto 0);
        instruction_id         : out std_logic_vector (LENGTH-1 downto 0)
    );
end IF_ID_Register;


architecture behavioral of IF_ID_Register is
begin

    process(clock, reset)
    begin
        if reset = '1' then
            pc_id <= STD_LOGIC_VECTOR(TO_UNSIGNED(INIT_VALUE, LENGTH));
            -- instruction_id <= STD_LOGIC_VECTOR(TO_UNSIGNED(INIT_VALUE, LENGTH));
	    instruction_id <=   x"00000013";
           -- predict_id     <= '0';
        elsif rising_edge(clock) then
		if ce = '1' then
                	pc_id <= pc_if; 
                	instruction_id <= instruction_if;
		end if;
        end if;
    end process;
        
end behavioral;

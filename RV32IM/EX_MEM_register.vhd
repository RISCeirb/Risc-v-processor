-------------------------------------------------------------------------
-- Design unit: Register
-- Description: Parameterizable length clock enabled register.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.RISC_V_package.all;

entity EX_MEM_Register is
    generic (
        LENGTH      : integer := 32;
        INIT_VALUE  : integer := 0 
    );
    port (  
        clock       : in std_logic;
        reset       : in std_logic; 
        ce          : in std_logic;
        branch_ex   : in std_logic;
        branch_mem  : out std_logic;
        pc_cal      : in  std_logic_vector (LENGTH-1 downto 0);
        pc_mem      : out std_logic_vector (LENGTH-1 downto 0);
        resultaluex : in  std_logic_vector (LENGTH-1 downto 0);
        resultalumem : out std_logic_vector (LENGTH-1 downto 0);
	data_store_ex: in  std_logic_vector (LENGTH-1 downto 0);
	data_store_mem: out  std_logic_vector (LENGTH-1 downto 0);
        rd_ex       : in std_logic_vector(4 downto 0);
        rd_mem      : out std_logic_vector(4 downto 0);
        uins_ex     : in  Microinstruction;
        uins_mem    : out Microinstruction;
	reset_predict : in std_logic;
        predict_ex  : in std_logic;
        predict_mem  : out std_logic
    );
end EX_MEM_Register;


architecture behavioral of EX_MEM_Register is
begin

    process(clock, reset, reset_predict)
    begin
        if reset = '1' or reset_predict = '1' then
            predict_mem <= '0';
	    branch_mem  <= '0';
        elsif rising_edge(clock) then
                uins_mem <= uins_ex;
                branch_mem <= branch_ex;
                pc_mem <= pc_cal;
                resultalumem <= resultaluex;
                rd_mem <= rd_ex;
		data_store_mem <= data_store_ex;
		if  reset_predict = '1' then
	                	predict_mem <= '0';
			else
				predict_mem <= predict_ex;
			end if;
        end if;
    end process;
        
end behavioral;

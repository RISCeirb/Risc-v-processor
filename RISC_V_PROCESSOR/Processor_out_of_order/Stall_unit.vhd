library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISC_V_package.all;

entity Stall_unit is
    port ( 
        clock                   : in std_logic;
        branch_ex               : in std_logic;
	predict_ex              : in std_logic;
        enable_pipeline_jump    : out std_logic

    );
end Stall_unit;

architecture structural of Stall_unit is
    
    signal counter_up : unsigned(1 downto 0) := "00";


-- Stall the pipeline for thre cycle, the frist stall is immediate with the mux from the top level with branch_ch
-- We generate here the second and third stall for jump and branch

begin
    process(counter_up, clock, branch_ex, predict_ex)
    begin
	if rising_edge(clock) then
        case counter_up is
            when "00" =>
                   if branch_ex /= predict_ex then
	                   counter_up <= "01";
	               else
	                   counter_up <= "00";
	               end if;
            when "01" =>
                counter_up <= "10";
            when "10" =>
                counter_up <= "00";
            when others =>
                counter_up <= "00"; 
        end case;
	end if;
    end process;
    
    
    process(counter_up)
    begin
        case counter_up is
            when "00" =>
                enable_pipeline_jump       <= '1';   
            when "01" =>
                enable_pipeline_jump       <= '0';
            when "10" =>
                enable_pipeline_jump       <= '0';
	       when "11" =>
                enable_pipeline_jump       <= '0';
	       when others =>
                enable_pipeline_jump       <= '0';
        end case;
    end process;

--            uins.MemToReg     <= '0';
--            uins.MemWrite     <= '0';
--            uins.RegWrite     <= '0';
--            uins.format       <= I; 
--            uins.instruction  <= ADDI;
    


end structural;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.RISC_V_package.all;

entity MUX_STORE is
    port (  rs2             : in  std_logic_vector(31 downto 0);
            data_to_mem     : out  std_logic_vector(31 downto 0);
            uins            : in  Microinstruction 
            );
end MUX_STORE;

architecture Behavioral of MUX_STORE is

signal zeroExtended_16, zeroExtended_8: std_logic_vector(31 downto 0);

begin
    
    -- Zero extends the low 16 bits of instruction 
    ZERO_EX_16: zeroExtended_16 <= x"0000" & rs2(15 downto 0);

    -- Zero extends the low 8 bits of instruction 
    ZERO_EX_8:  zeroExtended_8 <= x"000000" & rs2(7 downto 0);

    data_to_mem <= rs2              when uins.instruction = SW  else
                   zeroExtended_16  when uins.instruction = SH  else
                   zeroExtended_8   when uins.instruction = SB  else
                   rs2;
                   
                        

end Behavioral;


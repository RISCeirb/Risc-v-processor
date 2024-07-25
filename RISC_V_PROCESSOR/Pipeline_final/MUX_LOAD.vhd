
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.RISC_V_package.all;

entity MUX_LOAD is
    port (  mem_data        : in  std_logic_vector(31 downto 0);
            result_ALU      : in  std_logic_vector(31 downto 0);
            writeData       : out std_logic_vector(31 downto 0);
            uins            : in  Microinstruction 
            );
end MUX_LOAD;

architecture Behavioral of MUX_LOAD is

signal zeroExtended_16, signExtended_16, zeroExtended_8, signExtended_8: std_logic_vector(31 downto 0);

begin

     -- Sign extends the low 16 bits of instruction 
    SIGN_EX_16: signExtended_16 <= x"FFFF" & mem_data(15 downto 0) when mem_data(15) = '1' else 
                    x"0000" & mem_data(15 downto 0);
     
     -- Sign extends the low 8 bits of instruction 
    SIGN_EX_8:  signExtended_8 <= x"FFFFFF" & mem_data(7 downto 0) when mem_data(15) = '1' else 
                    x"000000" & mem_data(7 downto 0);
                                   
    -- Zero extends the low 16 bits of instruction 
    ZERO_EX_16: zeroExtended_16 <= x"0000" & mem_data(15 downto 0);

    -- Zero extends the low 8 bits of instruction 
    ZERO_EX_8:  zeroExtended_8 <= x"000000" & mem_data(7 downto 0);
    
     writeData  <=  mem_data            when uins.instruction = LW  else
                    signExtended_16     when uins.instruction = LH  else
                    zeroExtended_16     when uins.instruction = LHU else
                    signExtended_8      when uins.instruction = LB  else
                    zeroExtended_8      when uins.instruction = LBU else 
                    result_ALU;

    

end Behavioral;


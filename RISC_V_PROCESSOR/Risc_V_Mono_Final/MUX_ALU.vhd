
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.RISC_V_package.all;

entity MUX_ALU is
    port (  register2           : in  std_logic_vector(31 downto 0);
            instruction         : in  std_logic_vector(31 downto 0);
            data_mux            : out std_logic_vector(31 downto 0);
            uins                : in  Microinstruction    
            );
end MUX_ALU;

architecture Behavioral of MUX_ALU is


signal signExtended_i, signExtended_u, signExtended_s, signExtended_b, signExtended_j: std_logic_vector(31 downto 0);

signal register2_data : std_logic_vector(31 downto 0);



begin
        register2_data  <= register2;

    -- Process for generating sign-extended values based on instruction format 
        signExtended_i <=   x"FFFFF" & instruction(31 downto 20) when instruction(31) = '1' else 
                            x"00000" & instruction(31 downto 20);
     
    -- Sign extends the 20 upper bits of instruction U-type instruction   
        signExtended_u <=   instruction(31 downto 12) & x"000";

    -- Sign extends the 12 bits of instruction S-type instruction      
        signExtended_s <=   x"FFFFF" & instruction(31 downto 25) & instruction(11 downto 7) when instruction(31) = '1' else 
                            x"00000" & instruction(31 downto 25) & instruction(11 downto 7);
                    
    -- Sign extends the 13 bits of instruction B-type instruction      
--        signExtended_b <=   x"FFFF" & "111" & instruction(31) & instruction(7) & instruction(30 downto 25) &  instruction(11 downto 8) & '0' when instruction(31) = '1' else 
--                            x"0000" & "000" & instruction(31) & instruction(7) & instruction(30 downto 25) &  instruction(11 downto 8) & '0';    
    
    -- Sign extends the 12 bits of instruction J-type instruction      
        signExtended_j <=   x"FFF"  & instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) when instruction(31) = '1' else 
                            x"000" & instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21); 

process (uins, signExtended_i, signExtended_u, signExtended_s, signExtended_b, signExtended_j, register2_data)
    begin  
        case uins.format is
            when R =>
                data_mux <= register2_data;     -- Take rs2
            when I =>
                data_mux <= signExtended_i;     -- Format for ALU
            when U =>
                data_mux <= signExtended_u;     -- Format for ALU
            when B =>
                data_mux <= register2;          -- Take rs2 and compare with rs1 in ALU
            when S =>
                data_mux <= signExtended_s;     -- ALU give address memory by adding rs1 + sign_s
            -- when J =>      -- J-Type will give PC + 4 in the alu
            when others =>
                data_mux <= (others => '0');    -- Default case, if needed
        end case;
    end process; 
 

end Behavioral;


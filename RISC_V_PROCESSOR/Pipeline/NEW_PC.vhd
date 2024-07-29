
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 
use work.RISC_V_package.all;

entity NEW_PC is
    port (  rs1             : in  std_logic_vector(31 downto 0);
            pc              : in  std_logic_vector(31 downto 0);
            instruction     : in  std_logic_vector(31 downto 0);
            new_pc          : out std_logic_vector(31 downto 0);
            branch          : in std_logic;
            uins            : in  Microinstruction 
            );
end NEW_PC;

architecture Behavioral of NEW_PC is

-- signal branchOffset, pc_d: std_logic_vector(31 downto 0);
-- signal jumpTarget, branchTarget: std_logic_vector(31 downto 0);
signal incrementedPC, signExtended_i, signExtended_u, signExtended_s, signExtended_b, signExtended_j: std_logic_vector(31 downto 0);

signal register2_data : std_logic_vector(31 downto 0);


begin

      ADDER_PC: incrementedPC <= STD_LOGIC_VECTOR(UNSIGNED(pc) + TO_UNSIGNED(4,32));
      
   --SHIFT_L: branchOffset <= signExtended_i(29 downto 0) & "00";       
    
--    -- Branch target address
--    -- Branch ADDER

--    ADDER_BRANCH: branchTarget <= STD_LOGIC_VECTOR(UNSIGNED(incrementedPC) + UNSIGNED(signExtended_i(29 downto 0) & "00"));

--    -- Jump target address
    --jumpTarget <= incrementedPC(31 downto 28) & instruction(25 downto 0) & "00";


    
--       MUX_PC: new_pc <=   
--                         branchTarget when (uins.Branch and branch) = '1' else 
--                         jumpTarget when uins.Jump = '1' else
--                         incrementedPC;

    -- Process for generating sign-extended values based on instruction format 
        signExtended_i <=   x"FFFFF" & instruction(31 downto 20) when instruction(31) = '1' else 
                            x"00000" & instruction(31 downto 20);
     
    -- Sign extends the 20 upper bits of instruction U-type instruction   
    --    signExtended_u <=   instruction(31 downto 12) & x"000";
                           
                    
    -- Sign extends the 12 bits of instruction S-type instruction      
    --    signExtended_s <=   x"FFFFF" & instruction(31 downto 25) & instruction(11 downto 7) when instruction(31) = '1' else 
        --                    x"00000" & instruction(31 downto 25) & instruction(11 downto 7);
                    
    -- Sign extends the 13 bits of instruction B-type instruction      
        signExtended_b <=   x"FFFF" & "111" & instruction(31) & instruction(7) & instruction(30 downto 25) &  instruction(11 downto 8) & '0' when instruction(31) = '1' else 
                            x"0000" & "000" & instruction(31) & instruction(7) & instruction(30 downto 25) &  instruction(11 downto 8) & '0';    
    
    -- Sign extends the 12 bits of instruction J-type instruction      
        signExtended_j <=   x"FF" & "111"  & instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0' when instruction(31) = '1' else 
                            x"00" & "000" & instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0'; 




process (uins, signExtended_i, signExtended_u, signExtended_s, signExtended_b, signExtended_j, register2_data, rs1, pc, branch)
    begin  
        case uins.instruction is
            -- B-type instruction 
            when BEQ  =>  
                if (branch ='1') then
                    new_pc <= STD_LOGIC_VECTOR(UNSIGNED(pc) + UNSIGNED(signExtended_b));
                else
                    new_pc <=  incrementedPC;
                end if;
	    when BNE  =>  
                if (branch ='1') then
                    new_pc <= STD_LOGIC_VECTOR(UNSIGNED(pc) + UNSIGNED(signExtended_b));
                else
                    new_pc <=  incrementedPC;
                end if;
	    when  BGE =>  
                if (branch ='1') then
                    new_pc <= STD_LOGIC_VECTOR(UNSIGNED(pc) + UNSIGNED(signExtended_b));
                else
                    new_pc <=  incrementedPC;
                end if;
	    when BGEU  =>  
                if (branch ='1') then
                    new_pc <= STD_LOGIC_VECTOR(UNSIGNED(pc) + UNSIGNED(signExtended_b));
                else
                    new_pc <=  incrementedPC;
                end if;
	    when BLT  =>  
                if (branch ='1') then
                    new_pc <= STD_LOGIC_VECTOR(UNSIGNED(pc) + UNSIGNED(signExtended_b));
                else
                    new_pc <=  incrementedPC;
                end if;
	    when  BLTU =>  
                if (branch ='1') then
                    new_pc <= STD_LOGIC_VECTOR(UNSIGNED(pc) + UNSIGNED(signExtended_b));
                else
                    new_pc <=  incrementedPC;
                end if;
            -- use J-type    
            when JAL =>  
                new_pc <= STD_LOGIC_VECTOR(UNSIGNED(pc) + UNSIGNED(signExtended_j));
            -- JALR use I-type format    
            when JALR => 
                new_pc <= STD_LOGIC_VECTOR(UNSIGNED(rs1)  + UNSIGNED(signExtended_i));
            -- PC + 4 default case    
            when others => -- R,U,I types
                new_pc <=  incrementedPC;
        end case;
    end process; 
 

end Behavioral;


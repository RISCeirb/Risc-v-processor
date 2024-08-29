library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISC_V_package.all;

entity Forward_unit is
    port (
	uins_ex :  in Instruction_format;
        -- Memread_ex   : in std_logic;
        RegWrite_mem : in std_logic;
        RegWrite_wb : in std_logic;
        rd_wb       : in std_logic_vector(4 downto 0);
        rd_mem      : in std_logic_vector(4 downto 0);
        rd_ex      : in std_logic_vector(4 downto 0);
        rs1_ex      : in std_logic_vector(4 downto 0);
        rs2_ex      : in std_logic_vector(4 downto 0);
        --rs1_id      : in std_logic_vector(4 downto 0);
        --rs2_id      : in std_logic_vector(4 downto 0);
        forwardRS1  : out std_logic_vector(1 downto 0);
        forwardRS2  : out std_logic_vector(1 downto 0)
        --enable_pipeline :out std_logic
    );
end Forward_unit;

architecture structural of Forward_unit is
    


begin
    -- FORWARD RS1 
    process(RegWrite_wb, RegWrite_mem ,rd_wb, rd_mem, rs1_ex, uins_ex)
    begin
	if (uins_ex = R or uins_ex = S or uins_ex = B or uins_ex = I) then -- Forward except J and U type
    -- FORWARD ALU RESULTS
            if (rd_mem = rs1_ex) and (RegWrite_mem='1') and (rd_mem /= "00000")then
                forwardRS1 <= "01";
    -- FORWARD MEM DATA             
            elsif (rd_wb = rs1_ex) and (RegWrite_wb='1') and (rd_wb /= "00000") 
	    -- elsif (rd_wb = rs1_ex) and (rd_wb /= "00000")
            and not ((rd_mem = rs1_ex) and (RegWrite_mem='1') and (rd_wb /= "00000"))then
                forwardRS1 <= "10";
            else
                forwardRS1 <= "00";
	       end if;
	end if;
    end process;
    -- FORWARD RS2
    process(RegWrite_wb, RegWrite_mem ,rd_wb, rd_mem, rs2_ex, uins_ex)
    begin
	if (uins_ex = R or uins_ex = S or uins_ex = B) then -- Forward except J and U and I type
    -- FORWARD ALU RESULTS
            if (rd_mem = rs2_ex) and (RegWrite_mem='1') and (rd_mem /= "00000") then
                forwardRS2 <= "01";
    -- FORWARD MEM DATA             
            elsif (rd_wb = rs2_ex) and (RegWrite_wb='1') and (rd_wb /= "00000") 
	    -- elsif (rd_wb = rs2_ex) and (rd_wb /= "00000")
            and not ((rd_mem = rs2_ex) and (RegWrite_mem='1') and (rd_mem /= "00000"))then
                forwardRS2 <= "10";
            else
                forwardRS2 <= "00";
	       end if;
	else
		forwardRS2 <= "00";
	end if;
    end process;
end structural;

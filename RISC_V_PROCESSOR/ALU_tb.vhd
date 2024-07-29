library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISC_V_package.all; -- Assuming RISC_V_package contains necessary definitions

entity ALU_tb is
end ALU_tb;

architecture tb_arch of ALU_tb is

    -- Constants for easier readability
    constant CLK_PERIOD : time := 10 ns;
    constant CLK_OPE : time := 1000 ns;
    -- Signals for ALU entity ports
    signal operand1     : std_logic_vector(31 downto 0);
    signal operand2     : std_logic_vector(31 downto 0);
    signal result       : std_logic_vector(31 downto 0);
    signal pc       : std_logic_vector(31 downto 0);
    signal branch       : std_logic;
    signal operation    : Instruction_type;

    -- Clock signal
    signal clk : std_logic := '0';

begin

    -- Instance of ALU entity
    UUT: entity work.ALU
        port map (
            pc          => pc,
            operand1    => operand1,
            operand2    => operand2,
            result      => result,
            branch      => branch,
            operation   => operation
        );

    -- Clock process
    process
    begin
        while now < 1000 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    process
    begin
        while now < 1000 ns loop
            operand1 <= "00000000000000000000000000001000"; -- Example values
            operand2 <= "00000000000000000000000000000100";
            wait for CLK_OPE / 3;
            operand1 <= "00000000000000000000000000001000"; -- Example values
            operand2 <= "00000000000000000000000000001000";
            wait for CLK_OPE / 3;
            operand1 <= "00000000000000000000000000000010"; -- Example values
            operand2 <= "10000000000000000000000000000100";
            wait for CLK_OPE / 3;
        end loop;
        wait;
    end process;

    -- Stimulus process
    
    -- Test case 1: ADD operation (R-type instruction)
    
    process (clk)
    begin

        if (clk'event and clk='1') then 
            if (operation = ADD) then
                operation <= SUB;
            elsif (operation = SUB) then
                operation <= SLLins;
            elsif (operation = SLLins) then
                operation <= SRLins;    
            elsif (operation = SRLins) then
                operation <= SRAins;
            elsif (operation = SRAins) then
                operation <= SLTU;    
            elsif (operation = SLTU) then
                operation <= SLT;
            elsif (operation = SLT) then
                operation <= ORins;
            elsif (operation = ORins) then
                operation <= XORins;    
            elsif (operation = XORins) then
                operation <= ANDins;        
            elsif (operation = ANDins) then
                operation <= ADD;
            else
                operation <= ADD;
            end if;
        end if;
     end process;  
     
 
--    process(clk)
--    begin

--        if (clk'event and clk='1') then 
--        -- Test case 1: ADD operation (R-type instruction)
--            if (operation = BEQ) then
--                operation <= BNE;
--            elsif (operation = BNE) then
--                operation <= BGE;
--            elsif (operation = BGE) then
--                operation <= BGEU;    
--            elsif (operation = BGEU) then
--                operation <= BLT;
--            elsif (operation = BLT) then
--                operation <= BLTU;    
--            elsif (operation = BLTU) then
--                operation <= BEQ;                  
--            else
--                operation <= BEQ;
--            end if;
--        end if;
--     end process; 

end tb_arch;

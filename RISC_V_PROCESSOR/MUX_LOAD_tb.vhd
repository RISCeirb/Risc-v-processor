
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISC_V_package.all;

entity MUX_LOAD_tb is
end MUX_LOAD_tb;

architecture tb_arch of MUX_LOAD_tb is

    -- Constants for easier readability
    constant CLK_PERIOD : time := 10 ns;

    -- Signals for MUX_LOAD entity ports
    signal mem_data     : std_logic_vector(31 downto 0);
    signal result_ALU   : std_logic_vector(31 downto 0);
    signal writeData    : std_logic_vector(31 downto 0);
    signal pc           : std_logic_vector(31 downto 0);
    signal uins         : Microinstruction;

    -- Clock signal
    signal clk : std_logic := '0';

begin

    -- Instance of MUX_LOAD entity
    UUT: entity work.MUX_LOAD
        port map (
            pc          => pc,
            mem_data    => mem_data,
            result_ALU  => result_ALU,
            writeData   => writeData,
            uins        => uins
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

    -- Stimulus process
    process
    begin
        -- Test case 1: Testing LW instruction (memToReg = '1', instruction = LW)
        mem_data <= x"12345678"; -- Example memory data
        result_ALU <= x"0000000A"; -- Example ALU result
        uins.memToReg <= '1';
        uins.instruction <= LW;
        wait for CLK_PERIOD;
        assert writeData = mem_data report "LW instruction failed" severity error;

        -- Test case 2: Testing LH instruction (memToReg = '1', instruction = LH)
        mem_data <= x"1234FFFF"; -- Example memory data (sign-extended LH)
        result_ALU <= x"0000000A"; -- Example ALU result
        uins.memToReg <= '1';
        uins.instruction <= LH;
        wait for CLK_PERIOD;
        assert writeData = x"FFFF000A" report "LH instruction failed" severity error;

        -- Test case 3: Testing LBU instruction (memToReg = '1', instruction = LBU)
        mem_data <= x"1234FF78"; -- Example memory data (zero-extended LBU)
        result_ALU <= x"0000000A"; -- Example ALU result
        uins.memToReg <= '1';
        uins.instruction <= LHU;
        wait for CLK_PERIOD;
        assert writeData = x"0000000A" report "LBU instruction failed" severity error;

        -- Add more test cases for other instructions and scenarios
        mem_data <= x"1234F378"; -- Example memory data (zero-extended LBU)
        result_ALU <= x"0000000A"; -- Example ALU result
        uins.memToReg <= '1';
        uins.instruction <= LB;
        wait for CLK_PERIOD;
        
        -- 
        mem_data <= x"1234F378"; -- Example memory data (zero-extended LBU)
        result_ALU <= x"0000000A"; -- Example ALU result
        uins.memToReg <= '1';
        uins.instruction <= LBU;
        wait for CLK_PERIOD;
        
        wait;
    end process;

end tb_arch;


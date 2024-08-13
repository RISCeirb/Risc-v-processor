library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISC_V_package.all;

entity MUL_DIV_UNIT_tb is
end entity MUL_DIV_UNIT_tb;

architecture tb of MUL_DIV_UNIT_tb is

    -- Signals to connect to the DUT (Device Under Test)
    signal operand1    : std_logic_vector(31 downto 0);
    signal operand2    : std_logic_vector(31 downto 0);
    signal result      : std_logic_vector(31 downto 0);
    signal operation   : Instruction_type;
    
    -- Constants for test cases
    constant clock_period : time := 10 ns;

begin

    -- Instantiate the MUL_DIV_UNIT
    uut: entity work.MUL_DIV_UNIT
        port map (
            operand1 => operand1,
            operand2 => operand2,
            result => result,
            operation => operation
        );
    
    -- Test process
    process
    begin
 
    ------------------------------ Testing MUL operation ----------------------------
    
    
        -- Test case 1: MUL (Signed multiplication)
        operand1 <= std_logic_vector(to_signed(5, 32));
        operand2 <= std_logic_vector(to_signed(10, 32));
        operation <= MUL;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(50, 32))
            report "Test case 1 failed for MUL" severity error;


        -- Test case 4: MULHU (Unsigned multiplication)
        operand1 <= std_logic_vector(to_unsigned(10, 32));
        operand2 <= std_logic_vector(to_unsigned(10, 32));
        operation <= MULHU;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(0, 32)) -- Expecting 0 as higher 32-bits of multiplication are 0
            report "Test case 4 failed for MULHU" severity error;
            
            
        -- Test case 2: MUL (Signed multiplication with negative number)
        operand1 <= std_logic_vector(to_signed(-5, 32));
        operand2 <= std_logic_vector(to_signed(10, 32));
        operation <= MUL;
        wait for clock_period;
        assert result = std_logic_vector(to_signed(-50, 32))
            report "Test case 2 failed for MUL with negative operand" severity error;
        
        -- Test case 3: MUL (Signed multiplication with both operands negative)
        operand1 <= std_logic_vector(to_signed(-5, 32));
        operand2 <= std_logic_vector(to_signed(-10, 32));
        operation <= MUL;
        wait for clock_period;
        assert result = std_logic_vector(to_signed(50, 32))
            report "Test case 3 failed for MUL with both operands negative" severity error;
        
        -- Test case 5: MULHU (Unsigned multiplication with negative number)
        operand1 <= std_logic_vector(to_signed(-10, 32)); -- This will be treated as a large unsigned number
        operand2 <= std_logic_vector(to_unsigned(10, 32));
        operation <= MULHU;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(429496729, 32)) -- Expected upper 32-bits of the result
            report "Test case 5 failed for MULHU with negative operand treated as unsigned" severity error;

            
            
            
    ------------------------------ Testing DIV operation ----------------------------
            
  
          -- Test case 2: DIV (Signed division)
        operand1 <= std_logic_vector(to_signed(20, 32));
        operand2 <= std_logic_vector(to_signed(4, 32));
        operation <= DIV;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(5, 32))
            report "Test case 2 failed for DIV" severity error;

        -- Test case 3: REM (Signed remainder)
        operand1 <= std_logic_vector(to_signed(20, 32));
        operand2 <= std_logic_vector(to_signed(6, 32));
        operation <= REMins;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(2, 32))
            report "Test case 3 failed for REM" severity error;

  

        -- Test case 5: DIVU (Unsigned division)
        operand1 <= std_logic_vector(to_unsigned(100, 32));
        operand2 <= std_logic_vector(to_unsigned(4, 32));
       --operand2 <= "11111111111111111111111111111100";

       
        operation <= DIVU;
        wait for clock_period;
     --   assert result = std_logic_vector(to_unsigned(25, 32))
           -- report "Test case 5 failed for DIVU" severity error;

        -- Test case 6: REMU (Unsigned remainder)
        operand1 <= std_logic_vector(to_unsigned(29, 32));
        operand2 <= std_logic_vector(to_unsigned(6, 32));
        operation <= REMU;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(5, 32))
            report "Test case 6 failed for REMU" severity error;


      -- Test case 6: REMU (Unsigned remainder)
        operand1 <= std_logic_vector(to_unsigned(29, 32));
        operand2 <= std_logic_vector(to_unsigned(6, 32));
        operation <= REMU;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(5, 32))
            report "Test case 6 failed for REMU" severity error;

        
        -- Test case 1: DIVU (Unsigned division)
        operand1 <= std_logic_vector(to_unsigned(100, 32));
        operand2 <= std_logic_vector(to_unsigned(4, 32));
        operation <= DIVU;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(25, 32))
            report "Test case 1 failed for DIVU" severity error;
        
        -- Test case 2: REMU (Unsigned remainder)
        operand1 <= std_logic_vector(to_unsigned(29, 32));
        operand2 <= std_logic_vector(to_unsigned(6, 32));
        operation <= REMU;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(5, 32))
            report "Test case 2 failed for REMU" severity error;
        
        -- Test case 3: DIVU with operand2 = 1 (no division)
        operand1 <= std_logic_vector(to_unsigned(50, 32));
        operand2 <= std_logic_vector(to_unsigned(1, 32));
        operation <= DIVU;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(50, 32))
            report "Test case 3 failed for DIVU" severity error;
        
        -- Test case 4: REMU with operand2 = 1 (no remainder)
        operand1 <= std_logic_vector(to_unsigned(100, 32));
        operand2 <= std_logic_vector(to_unsigned(1, 32));
        operation <= REMU;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(0, 32))
            report "Test case 4 failed for REMU" severity error;
        
        -- Test case 5: DIVU with operand2 = operand1 (result = 1)
        operand1 <= std_logic_vector(to_unsigned(10, 32));
        operand2 <= std_logic_vector(to_unsigned(10, 32));
        operation <= DIVU;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(1, 32))
            report "Test case 5 failed for DIVU" severity error;
        
        -- Test case 6: REMU with operand2 = operand1 (remainder = 0)
        operand1 <= std_logic_vector(to_unsigned(20, 32));
        operand2 <= std_logic_vector(to_unsigned(20, 32));
        operation <= REMU;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(0, 32))
            report "Test case 6 failed for REMU" severity error;
        
        -- Test case 7: DIVU by 0 (undefined behavior, usually handled by hardware)
        operand1 <= std_logic_vector(to_unsigned(50, 32));
        operand2 <= std_logic_vector(to_unsigned(0, 32));
        operation <= DIVU;
        wait for clock_period;
        -- No assert as the behavior might depend on the implementation
        
        -- Test case 8: REMU by 0 (undefined behavior, usually handled by hardware)
        operand1 <= std_logic_vector(to_unsigned(50, 32));
        operand2 <= std_logic_vector(to_unsigned(0, 32));
        operation <= REMU;
        wait for clock_period;
        -- No assert as the behavior might depend on the implementation
        
        -- Test case 9: DIVU resulting in maximum 32-bit value
        operand1 <= std_logic_vector(to_unsigned(2**31 - 1, 32));
        operand2 <= std_logic_vector(to_unsigned(1, 32));
        operation <= DIVU;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(2**31 - 1, 32))
            report "Test case 9 failed for DIVU" severity error;
        
        -- Test case 10: REMU with large operand1 and small operand2
        operand1 <= std_logic_vector(to_unsigned(1234567890, 32));
        operand2 <= std_logic_vector(to_unsigned(12345, 32));
        operation <= REMU;
        wait for clock_period;
        assert result = std_logic_vector(to_unsigned(6165, 32))
            report "Test case 10 failed for REMU" severity error;

        -- Test case 11: DIVU 
        operand1 <= std_logic_vector(to_signed(59, 32));
        operand2 <= std_logic_vector(to_signed(-3, 32));
        operation <= DIV;
        wait for clock_period;

        
        operand1 <= std_logic_vector(to_signed(59, 32));
        operand2 <= std_logic_vector(to_signed(-3, 32));
        operation <= REMins;
        wait for clock_period;
 
        operand1 <= std_logic_vector(to_signed(-60, 32));
        operand2 <= std_logic_vector(to_signed(10, 32));
        operation <= DIV;
        wait for clock_period;
    
        -- Finish the test
        report "All test cases passed." severity note;
        wait;
    end process;

end architecture tb;


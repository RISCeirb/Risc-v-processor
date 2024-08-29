
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISC_V_package.all;

entity Adder_float_tb is
end Adder_float_tb;

architecture testbench of Adder_float_tb is
    -- Signals for the DUT (Device Under Test)
    --signal operation   : Instruction_type;
    signal operand1    : std_logic_vector(31 downto 0);
    signal operand2    : std_logic_vector(31 downto 0);
    signal result      : std_logic_vector(31 downto 0);
    --signal exception   : std_logic;

--    -- Function to convert real numbers to IEEE 754 single-precision floating-point format
--    function real_to_float(val: real) return std_logic_vector is
--        variable float_val  : std_logic_vector(31 downto 0);
--        variable sign_bit   : std_logic;
--        variable exponent   : integer := 0;
--        variable mantissa   : real;
--        variable temp_val   : real;
--        constant bias       : integer := 127;
--    begin
--        -- Handle special case for zero
--        if val = 0.0 then
--            return (others => '0');
--        end if;

--        -- Determine the sign bit
--        if val < 0.0 then
--            sign_bit := '1';
--            temp_val := -val;
--        else
--            sign_bit := '0';
--            temp_val := val;
--        end if;

--        -- Normalize the value to be in the range [1, 2)
--        while temp_val >= 2.0 loop
--            temp_val := temp_val / 2.0;
--            exponent := exponent + 1;
--        end loop;
        
--        while temp_val < 1.0 loop
--            temp_val := temp_val * 2.0;
--            exponent := exponent - 1;
--        end loop;

--        -- Calculate the biased exponent
--        exponent := exponent + bias;

--        -- Calculate the mantissa by subtracting 1 (since the normalized value is in the range [1, 2))
--        mantissa := temp_val - 1.0;

--        -- Convert mantissa to binary
--        float_val := sign_bit & std_logic_vector(to_unsigned(exponent, 8)) & std_logic_vector(to_unsigned(integer(mantissa * (2.0 ** 23)), 23));

--        return float_val;
--    end function;

begin
    -- Instantiate the DUT
    UUT: entity work.Adder_float
        port map(
            --operation   => operation,
            operand1    => operand1,
            operand2    => operand2,
            result      => result
            --exception   => exception
        );

    -- Test process
    process
    begin
        -- Test 1: Simple addition of two positive numbers
        operand1 <= x"3fc00000"; -- 1.5 in IEEE 754
        operand2 <= x"40200000"; -- 2.5 in IEEE 754
        wait for 10 ns;
        -- 40800000 is expected 4

        -- Test 2: Simple addition of positive and negative number
        operand1 <= x"40200000"; -- -1.5 in IEEE 754
        operand2 <= x"bfc00000";  -- 2.5 in IEEE 754 bfc00000
        -- 0x3f800000 = 1
        
        wait for 10 ns;
        
        -- Test 3: Addition resulting in zero
        operand1 <= x"3fc00000";  -- 1.5 in IEEE 754
        operand2 <= x"bfc00000"; -- -1.5 in IEEE 754
        -- 0x00000000 ou 0x80000000 (0 ou -0)
        wait for 10 ns;

        -- Test 4: Edge case: Adding zero
        operand1 <= x"00000000";  -- 0.0 in IEEE 754
        operand2 <= x"40600000";  -- 3.5 in IEEE 754
        
        -- 40600000  = 3.5 
        wait for 10 ns;
        
        -- Test 5: 
        operand1 <= x"3f800000";  -- 1.0 in IEEE 754
        operand2 <= x"3f800000";  -- 1.0 in IEEE 754
        
        -- 40000000  = 2 
        wait for 10 ns;
        
        -- Test 5: 
        operand1 <= x"42000000";  -- 32 in IEEE 754
        operand2 <= x"42800000";  -- 64 in IEEE 754
        
        -- 0x42c00000 = 96
        
        wait for 10 ns;


        -- Finish simulation
        wait;
    end process;

end testbench;

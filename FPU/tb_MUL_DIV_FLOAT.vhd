library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;       -- For integer and binary vector manipulation
use work.RISC_V_package.all;    -- Assuming the package contains `FMUL_S` and `FDIV_S`

entity tb_MUL_DIV_FLOAT is
end tb_MUL_DIV_FLOAT;

architecture testbench of tb_MUL_DIV_FLOAT is

    -- Component declaration for the Unit Under Test (UUT)
    component MUL_DIV_FLOAT
        port(
            operation   : in Instruction_type;                -- Input RISC-V instruction
            operand1    : in  std_logic_vector(31 downto 0);  -- First operand (float/int)
            operand2    : in  std_logic_vector(31 downto 0);  -- Second operand (float/int)
            result      : out std_logic_vector(31 downto 0);  -- Output result (float/int)
            DZ          : out std_logic;                      -- Exception flag DIVIDE BY ZERO
            underflow   : out std_logic
        );
    end component;

    -- Signals to connect to UUT
    signal operation   : Instruction_type;
    signal operand1    : std_logic_vector(31 downto 0);
    signal operand2    : std_logic_vector(31 downto 0);
    signal result      : std_logic_vector(31 downto 0);
    signal DZ          : std_logic;
    signal underflow          : std_logic;
    
    -- Helper signals for floating-point values
    signal expected_result : std_logic_vector(31 downto 0);

begin
    -- Instantiate the Unit Under Test (UUT)
    UUT: MUL_DIV_FLOAT
        port map(
            operation   => operation,
            operand1    => operand1,
            operand2    => operand2,
            result      => result,
            DZ          => DZ,
            underflow   => underflow
        );

    -- Test process
    test_proc: process
    begin
        -- Test 1: Floating-point multiplication (FMUL_S)
        operand1 <= "01000001001000000000000000000000";  -- 10.0 in IEEE 754 single precision
        operand2 <= "01000000100000000000000000000000";  -- 4.0 in IEEE 754 single precision
        expected_result <= "01000010001000000000000000000000"; -- Expected result: 40.0 (10.0 * 4.0)

        operation <= FMUL_S;
        wait for 10 ns;

        -- Check if the result matches the expected value
        assert result = expected_result
        report "Test 1 (Multiplication) failed!" severity error;

        -- Test 2: Floating-point division (FDIV_S)
        operand1 <= "01000010001000000000000000000000";  -- 40.0 in IEEE 754 single precision
        operand2 <= "01000000100000000000000000000000";  -- 4.0 in IEEE 754 single precision
        expected_result <= "01000001001000000000000000000000"; -- Expected result: 10.0 (40.0 / 4.0)

        operation <= FDIV_S;
        wait for 10 ns;
        
        

        -- Check if the result matches the expected value
        assert result = expected_result
        report "Test 2 (Division) failed!" severity error;
        
        -- Test 2-bis: Floating-point division (FDIV_S)
        operand1 <= "01000010001000000000000000000000";  -- 40.0 in IEEE 754 single precision
        operand2 <= x"3f000000";  -- 0.5 in IEEE 754 single precision
        expected_result <= x"42a00000"; -- Expected result: 80.0 (40.0 / 0.5)

        operation <= FDIV_S;
        wait for 10 ns;
        
        assert result = expected_result
        report "Test 2-bis (Division) failed!" severity error;
        
        -- Test 2-c: Floating-point division (FDIV_S)
        operand1 <= "01000010001000000000000000000000";  -- 40.0 in IEEE 754 single precision
        operand2 <= x"3f333333";  -- 0.7 in IEEE 754 single precision
        expected_result <= x"42640000"; -- Expected result: 57.0 (40.0 / 0.7)

        operation <= FDIV_S;
        wait for 10 ns;
        
        assert result = expected_result
        report "Test 2-c (Division) failed!" severity error;

        -- Test 3: Division by zero
        operand1 <= "01000000100000000000000000000000";  -- 4.0 in IEEE 754 single precision
        operand2 <= "00000000000000000000000000000000";  -- 0.0 in IEEE 754 single precision

        operation <= FDIV_S;
        wait for 10 ns;

        -- Check if the divide-by-zero flag is set
        assert DZ = '1'
        report "Test 3 (Division by zero) failed!" severity error;

        -- Test 4: Negative multiplication
        operand1 <= "11000000100000000000000000000000";  -- -4.0 in IEEE 754 single precision
        operand2 <= "11000000100000000000000000000000";  -- -4.0 in IEEE 754 single precision
        expected_result <= "01000001100000000000000000000000"; -- Expected result: 16.0 (-4.0 * -4.0)

        operation <= FMUL_S;
        wait for 10 ns;

        -- Check if the result matches the expected value
        assert result = expected_result
        report "Test 4 (Negative Multiplication) failed!" severity error;

        -- Test 5: Multiplication by zero
        operand1 <= "00000000000000000000000000000000";  -- 0.0 in IEEE 754 single precision
        operand2 <= "01000000100000000000000000000000";  -- 4.0 in IEEE 754 single precision
        expected_result <= "00000000000000000000000000000000"; -- Expected result: 0.0 (0.0 * 4.0)

        operation <= FMUL_S;
        wait for 10 ns;

        -- Check if the result matches the expected value
        assert result = expected_result
        report "Test 5 (Multiplication by Zero) failed!" severity error;

        -- Test 6: Very small number multiplication (denormal)
        operand1 <= "00000000000000000000000000000001";  -- Smallest positive denormal number
        operand2 <= "00000000000000000000000000000001";  -- Smallest positive denormal number
        expected_result <= "00000000000000000000000000000000"; -- Expected result: 0.0 (underflow)

        operation <= FMUL_S;
        wait for 10 ns;

        -- Check if the result matches the expected value
        assert result = expected_result
        report "Test 6 (Very Small Number Multiplication) failed!" severity error;

        -- Test 7: Large number multiplication
        operand1 <= "01111111011111111111111111111111";  -- Max positive normal number
        operand2 <= x"0000803f";  -- 1.0 in IEEE 754 single precision
        expected_result <= "01111111011111111111111111111111"; -- Expected result: Max positive normal number

        operation <= FMUL_S;
        wait for 10 ns;

        -- Check if the result matches the expected value
        assert result = expected_result
        report "Test 7 (Large Number Multiplication) failed!" severity error;

        -- Test 8: Small / large division resulting in subnormal
        operand1 <= "00000000000000000000000000000001";  -- Smallest positive denormal number
        operand2 <= "01111111100000000000000000000000";  -- 2.0 in IEEE 754 single precision
        expected_result <= "00000000000000000000000000000000"; -- Expected result: Subnormal (or 0)

        operation <= FDIV_S;
        wait for 10 ns;

        -- Check if the result matches the expected value
        assert result = expected_result
        report "Test 8 (Division resulting in subnormal) failed!" severity error;

        -- End of simulation
        wait;
    end process test_proc;

end testbench;

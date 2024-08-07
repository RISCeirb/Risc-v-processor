library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISC_V_package.all;

entity DIV_UNIT is
    port(
        operand1    : in std_logic_vector(31 downto 0);
        operand2    : in std_logic_vector(31 downto 0);
        result      : out std_logic_vector(31 downto 0);
        operation   : in Instruction_type   
    );
end DIV_UNIT;

architecture behavioral of DIV_UNIT is

    signal temp, op1, op2, Q, R : UNSIGNED(31 downto 0);
    signal s_mul : UNSIGNED(63 downto 0);
    signal s_div, s_rem : UNSIGNED(31 downto 0);
    signal divisor, dividend : UNSIGNED(31 downto 0);
    signal quotient, remainder : UNSIGNED(31 downto 0);
    signal i : integer := 31;

begin

    op1 <= UNSIGNED(operand1);
    op2 <= UNSIGNED(operand2);
    
    result <= STD_LOGIC_VECTOR(temp);
    
    -- Multiplication operations
    s_mul <= 
        op1 * op2 when operation = MUL or operation = MULH else -- Signed multiplication
        op1 * op2 when operation = MULHSU else  -- Unsigned multiplication
        (op1(31) & op1) * ('0' & op2) when operation = MULHU else  -- Signed * unsigned
        (others => '0');

    -- Division and remainder operations
    process(op1, op2, operation)
    begin
        if (op2 = 0) then
            quotient <= (others => '0');
            remainder <= (others => '0');
        else
            divisor <= op2;
            dividend <= op1;
            quotient <= (others => '0');
            remainder <= (others => '0');
            for i in 31 downto 0 loop
                remainder <= remainder(30 downto 0) & dividend(31);
                dividend <= dividend(30 downto 0) & '0';
                if remainder >= divisor then
                    remainder <= remainder - divisor;
                    quotient <= unsigned(std_logic_vector(quotient)) or unsigned(std_logic_vector(to_unsigned(1, quotient'length) sll i));
                end if;
            end loop;
            s_div <= quotient;
            s_rem <= remainder;
        end if;
    end process;
    
    -- Select the final result
    temp <=
        s_mul(31 downto 0)  when operation = MUL   else 
        s_mul(63 downto 32) when operation = MULH or operation = MULHSU or operation = MULHU else
        s_div                when operation = DIV or operation = DIVU else
        s_rem                when operation = REMins or operation = REMU else
        (others => '0');

end behavioral;

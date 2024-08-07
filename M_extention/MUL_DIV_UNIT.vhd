library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISC_V_package.all;

entity MUL_DIV_UNIT is
    port(
        operand1    : in std_logic_vector(31 downto 0);
        operand2    : in std_logic_vector(31 downto 0);
        result      : out std_logic_vector(31 downto 0);
        operation   : in Instruction_type   
    );
end MUL_DIV_UNIT;

architecture behavioral of MUL_DIV_UNIT is

    signal temp, op1, op2 : UNSIGNED(31 downto 0);
    signal s_mul : UNSIGNED(63 downto 0);
    signal s_div, s_rem : UNSIGNED(31 downto 0);
    
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
            s_div <= (others => '0');
            s_rem <= (others => '0');
        else
            case operation is
                when DIV =>
                    s_div <= op1 / op2;
                    s_rem <= op1 mod op2;
                when DIVU =>
                    s_div <= op1 / op2;
                    s_rem <= op1 mod op2;
                when REMins =>
                    s_div <= (others => '0');
                    s_rem <= op1 mod op2;
                when REMU =>
                    s_div <= (others => '0');
                    s_rem <= op1 mod op2;
                when others =>
                    s_div <= (others => '0');
                    s_rem <= (others => '0');
            end case;
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

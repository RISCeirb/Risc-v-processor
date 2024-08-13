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
    signal s_result_div : UNSIGNED(31 downto 0);
    
begin

    result <= STD_LOGIC_VECTOR(temp);
    
    -- Multiplication operations
    s_mul <= 
        unsigned(operand1) * unsigned(operand2) when operation = MUL or operation = MULH or operation = MULHSU or operation = MULHU else     -- Signed multiplication
        --op1 * op2 when operation = MULHSU else                      -- Unsigned multiplication
        --op1 * op2 when operation = MULHU else                       -- Signed * unsigned
        (others => '0');
    
    
----------------------- TWO's complement needed for signed division ------------------------------
    
    process(operand1, operand2, operation)
    begin
        if (operation = DIV or operation = REMins) then
            if operand1(31) = '1' then 
                op1 <= unsigned(not(operand1)) + 1; -- Convert 2's complement negative number to positive
            else 
                op1 <= unsigned(operand1); -- Directly convert if positive
            end if;
            if operand2(31) = '1' then 
                op2 <= unsigned(not(operand2)) + 1; -- Convert 2's complement negative number to positive
            else 
                op2 <= unsigned(operand2); -- Directly convert if positive
            end if;
        else
                op1 <= UNSIGNED(operand1);
                op2 <= UNSIGNED(operand2);
        end if;
    end process;

    
 -------------------- Division and remainder operations -----------------------------------------
    process(op1, op2, operation)
    begin
        if (op2 = 0) then               -- division by 0
            s_div  <= (others => '1');  -- return -1
            s_rem <= op1;               -- remaider is the dividend
        elsif ((op1 = x"80000000") and (op1 = x"FFFFFFFF")) and (operation = DIV or operation = REMins) then   -- Overflow division of -2147483648 by -1 
            s_div  <= (others => '1');   -- retourne -1
            s_rem <= (others => '0');
        else
            case operation is
            -- Signed division
                when DIV =>
                    s_div <= op1 / op2;
                    s_rem <= op1 mod op2;
                when REMins =>
                    s_div <= (others => '0');
                    s_rem <= op1 mod op2;
            -- Unsigned division 
                when DIVU =>
                    s_div <= op1 / op2;
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

----------------------- TWO's complement the results if needed ------------------------------
    
    process(s_div, operation)
    begin
        if (operation = DIV and operand1(31) /= operand2(31) ) then
            s_result_div <= not(s_div) + 1;
        else 
            s_result_div <= s_div;
        end if;
    end process;
    
----------------------------------------------------------------------------------------------
    
    -- Select the final result
    temp <=
        s_mul(31 downto 0)   when operation = MUL   else 
        s_mul(63 downto 32)  when operation = MULH or operation = MULHSU or operation = MULHU else
        s_result_div         when operation = DIV or operation = DIVU else
        s_rem                when operation = REMins or operation = REMU else
        (others => '0');

end behavioral;

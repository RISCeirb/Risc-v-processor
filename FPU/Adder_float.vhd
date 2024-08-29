
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;       -- Entier et vecteurs binaires
use work.RISC_V_package.all;

entity Adder_float is
    port(
        --operation   : in Instruction_type;                -- Input RISC-V instruction
        operand1    : in std_logic_vector(31 downto 0);   -- First operand (float/int)
        operand2    : in std_logic_vector(31 downto 0);   -- Second operand (float/int)
        result      : out std_logic_vector(31 downto 0)  -- Output result (float/int)
        -- exception   : out std_logic                       -- Exception flag
    );
end Adder_float;

architecture behavioral of Adder_float is

    -- Extraction des champs (mantisse, exposant et signe) des flottants
    signal mantissa1, mantissa2 : unsigned(26 downto 0);
    signal exponent1, exponent2 : unsigned(7 downto 0);
    signal sign1, sign2         : std_logic;

    -- Pour manipuler les résultats intermédiaires
    signal aligned_mantissa1, aligned_mantissa2 : unsigned(26 downto 0);
    signal result_mantissa  : unsigned(26 downto 0);
    signal result_exponent  : unsigned(7 downto 0);
    signal result_sign      : std_logic;
    
    signal decalage : integer := 0;
    
    signal result_mantissa_normal  : unsigned(26 downto 0);
    signal result_exponent_normal  : unsigned(7 downto 0);
    
    signal exp_diff          : unsigned(7 downto 0);
    signal exception_flag    : std_logic := '0';

begin

-- Float addition et sub

    -- Alias pour faciliter la manipulation des champs
    sign1     <= operand1(31);
    sign2     <= operand2(31);

    exponent1 <= unsigned(operand1(30 downto 23));
    exponent2 <= unsigned(operand2(30 downto 23));
    
    mantissa1 <= "000" & '1' & unsigned(operand1(22 downto 0)) when operand1 /= x"00000000" and operand1 /= x"80000000" else (others => '0');
    mantissa2 <= "000" & '1' & unsigned(operand2(22 downto 0)) when operand2 /= x"00000000" and operand2 /= x"80000000" else (others => '0');

    -- Alignement des mantisses si les exposants sont différents
    process(exponent1, exponent2, mantissa1, mantissa2, exp_diff)
    begin
        if exponent1 > exponent2 then
            exp_diff <= exponent1 - exponent2;
            aligned_mantissa1 <= mantissa1;
            aligned_mantissa2 <= shift_right(mantissa2, to_integer(exp_diff)); -- Décalage de la mantisse
            result_exponent <= exponent1;
        elsif exponent2 > exponent1 then
            exp_diff <= exponent2 - exponent1;
            aligned_mantissa1 <= shift_right(mantissa1, to_integer(exp_diff)); -- Décalage de la mantisse
            aligned_mantissa2 <= mantissa2;
            result_exponent <= exponent2;
        else
            aligned_mantissa1 <= mantissa1;
            aligned_mantissa2 <= mantissa2;
            result_exponent <= exponent1;
        end if;
    end process;

    -- Addition ou soustraction des mantisses en fonction des signes
    process(sign1, sign2, aligned_mantissa1, aligned_mantissa2, result_mantissa)
    begin
        if sign1 = sign2 then
            result_mantissa <= aligned_mantissa1 + aligned_mantissa2; -- Addition si les signes sont égaux
            result_sign <= sign1;
        else
            if aligned_mantissa1 > aligned_mantissa2 then
                result_mantissa <= aligned_mantissa1 - aligned_mantissa2; -- Soustraction si les signes sont différents
                result_sign <= sign1;
            else
                result_mantissa <= aligned_mantissa2 - aligned_mantissa1;
                result_sign <= sign2;
            end if;
        end if;
    end process;

   -- Normalisation du résultat
    process(result_mantissa, result_exponent, decalage)
    begin
        -- Gestion des cas où le résultat est zéro
        if result_mantissa = "000000000000000000000000000" then
            result_exponent_normal <= (others => '0');  -- Zéro exponent
            result_mantissa_normal <= (others => '0');  -- Zéro mantisse
        elsif result_mantissa(24) = '1' then
            result_mantissa_normal <= shift_right(result_mantissa, 1);
            result_exponent_normal <= result_exponent + 1;
                
        else
            -- Trouver la première position du bit '1' et calculer le décalage
            for i in 23 downto 0 loop  -- Boucle correcte, en reverse
                if result_mantissa(i) = '1' then
                    decalage <= 23 - i ;
                    exit;  -- Quitte la boucle dès qu'on trouve le premier '1'
                end if;
            end loop;

            -- Normaliser la mantisse et ajuster l'exposant
            result_mantissa_normal <= shift_left(result_mantissa, decalage);
            result_exponent_normal <= result_exponent - to_unsigned(decalage, 8);
        end if;
    end process;

    -- PROCESS TO SIGNAL THE NaN (not a number)
    
    process(exponent1, exponent2, exception_flag)
    begin
        if exponent1 = "11111111" or exponent2 = "11111111" then
            exception_flag <= '1';
        else
            exception_flag <= '0';
        end if;
    end process;


    -- Construction du résultat final
    result <= result_sign & std_logic_vector(result_exponent_normal) & std_logic_vector(result_mantissa_normal(22 downto 0));
    --exception <= exception_flag;
    
end behavioral;

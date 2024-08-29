library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;       -- Entier et vecteurs binaires
use work.RISC_V_package.all;

entity MUL_DIV_FLOAT is
    port(
        operation   : in Instruction_type;                -- Input RISC-V instruction
        operand1    : in  std_logic_vector(31 downto 0);  -- First operand (float/int)
        operand2    : in  std_logic_vector(31 downto 0);  -- Second operand (float/int)
        result      : out std_logic_vector(31 downto 0);  -- Output result (float/int)
        DZ          : out std_logic;                      -- Exception flag DIVIDE BY ZERO
        underflow   : out std_logic
    );
end MUL_DIV_FLOAT;

architecture behavioral of MUL_DIV_FLOAT is

    -- Extraction des champs (mantisse, exposant et signe) des flottants
    signal mantissa1, mantissa2 : unsigned(23 downto 0);
    signal exponent1, exponent2 : unsigned(7 downto 0);
    signal sign1, sign2         : std_logic;

    -- Pour manipuler les résultats intermédiaires
    -- signal result_mantissa  : unsigned(23 downto 0);
    signal result_exponent  : unsigned(7 downto 0);
    signal result_sign      : std_logic;

    -- Variables pour multiplication et division
    signal product_mantissa : unsigned(47 downto 0);  -- Mantisse du produit (multiplication)
    signal division_mantissa : unsigned(23 downto 0); -- Mantisse du quotient (division)
    signal exception_flag    : std_logic := '0';

    signal result_mantissa_normal  : unsigned(23 downto 0);
    signal result_exponent_normal  : unsigned(7 downto 0);

    signal decalage : integer := 0;

begin
    -- Alias pour faciliter la manipulation des champs
    sign1     <= operand1(31);
    sign2     <= operand2(31);

    exponent1 <= unsigned(operand1(30 downto 23));
    exponent2 <= unsigned(operand2(30 downto 23));

   -- mantissa1 <= '1' & unsigned(operand1(22 downto 0)); -- Ajout du bit caché
   -- mantissa2 <= '1' & unsigned(operand2(22 downto 0)); -- Ajout du bit caché

    mantissa1 <= '1' & unsigned(operand1(22 downto 0)) when operand1 /= x"00000000" and operand1 /= x"80000000" else (others => '0');
    mantissa2 <= '1' & unsigned(operand2(22 downto 0)) when operand2 /= x"00000000" and operand2 /= x"80000000" else (others => '0');
    
    
    -- Processus pour gérer les opérations de multiplication et division
    process(operation, sign1, sign2, mantissa1, mantissa2, exponent1, exponent2, operand2, product_mantissa, division_mantissa, result_exponent, decalage)
    begin
        -- Reset decalage and exception flag at the beginning of each operation
        decalage <= 0;
        exception_flag <= '0';
        DZ <= '0';
        --underflow <= '0';
        
        case operation is
            -- Multiplication des flottants
            when FMUL_S =>  -- Operation de multiplication
                -- Sign du résultat (XOR des signes des opérandes)
                result_sign <= sign1 xor sign2;

                -- Addition des exposants et ajustement du biais (127 pour simple précision)
                result_exponent <= exponent1 + exponent2 - 127;

                -- Multiplication des mantisses
                product_mantissa <= mantissa1 * mantissa2;

                --
                if product_mantissa = "00000000000000000000000000000000000000000000000" then 
                    result_mantissa_normal <= (others => '0');
                    result_exponent_normal <= (others => '0');
                else
                    -- Normalisation si nécessaire
                    for i in 47 downto 0 loop
                        if product_mantissa(i) = '1' then
                            decalage <= 46 - i;
                            exit;
                        end if;
                    end loop;
                -- Normaliser la mantisse et ajuster l'exposant
                result_mantissa_normal <= shift_left(product_mantissa(47 downto 24), decalage + 1 );
                result_exponent_normal <= result_exponent - to_unsigned(decalage, 8);  
                
--                 -- **Gestion de l'underflow**
--                    if result_exponent_normal < 1 then
--                        underflow <= '1';
--                        --result_exponent_normal <= (others => '0');
--                        --result_mantissa_normal <= (others => '0');  -- Optionnel : fixer la mantisse à 0 en cas d'underflow complet
--                    end if;
                    
                end if;


            -- Division des flottants
            when FDIV_S =>  -- Operation de division
                -- Vérifier si operand2 est zéro
                if operand2(30 downto 0) = "0000000000000000000000000000000" then
                    exception_flag <= '1';  -- Lever une exception de division par zéro
                    DZ <= '1';  -- Set divide by zero flag
                else
                    -- Sign du résultat (XOR des signes des opérandes)
                    result_sign <= sign1 xor sign2;

                    -- Soustraction des exposants et ajustement du biais
                    result_exponent <= exponent1 - exponent2 + 127;

                    -- Division des mantisses
                    if mantissa2 = "100000000000000000000000" then
                        division_mantissa <= mantissa1;
                    else
                        division_mantissa <= mantissa1 / mantissa2;
                    end if;

                    -- Normalisation si nécessaire
                    --if division_mantissa = "000000000000000000000000" then
                       -- result_mantissa_normal <= (others => '0');
                        --result_exponent_normal <= result_exponent - 1;
                    --else
                        for i in 23 downto 0 loop
                            if division_mantissa(i) = '1' then
                                decalage <= 23 - i;
                                exit;
                            end if;
                        end loop;
                        -- Normaliser la mantisse et ajuster l'exposant
                        result_mantissa_normal <= shift_left(division_mantissa, decalage);
                        result_exponent_normal <= result_exponent - to_unsigned(decalage, 8);
                 --   end if;
                    
                end if;

            when others =>
                -- Si une autre opération est détectée, lever une exception
                exception_flag <= '1';
        end case;
    end process;

    -- Construction du résultat final : Signe, Exposant, Mantisse
    
    result <= result_sign & std_logic_vector(result_exponent_normal) & std_logic_vector(result_mantissa_normal(22 downto 0));
    
    underflow <= '1' when signed(result_exponent_normal) - 127 < 1 else '0';

    --underflow <= '1' when (signed(result_exponent_normal) - to_signed(127, 8)) < to_signed(1, 8) else '0';


end behavioral;

-------------------------------------------------------------------------
-- Design unit: FPU RISC-V
-- Description: Floating Point Unit (FPU) compatible with RISC-V
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;       -- Entier et veteurs biaires
use work.RISC_V_package.all;

entity FPU is
    port(
        rounding_mode : in std_logic_vector(2 downto 0);  -- rouding mode 
        operation   : in Instruction_type;                -- Input RISC-V instruction
        operand1    : in  std_logic_vector(31 downto 0);  -- First operand (float/int)
        operand2    : in  std_logic_vector(31 downto 0);  -- Second operand (float/int)
        operand3    : in  std_logic_vector(31 downto 0);  -- Third operand (for fused multiply-add)
        result      : out std_logic_vector(31 downto 0);  -- Output result (float/int)
        NV : out std_logic;                               --NV Invalid Operation
        DZ : out std_logic;                               --DZ Divide by Zero
        OverF: out std_logic;                             --OF Overflow
        UF : out std_logic;                               --UF Underflow
        NX : out std_logic                                --NX Inexact
    );
end FPU;


architecture structural of FPU is

signal resultat_mul_div : std_logic_vector(31 downto 0);
signal operand_add_sub_1, operand_add_sub_2  : std_logic_vector(31 downto 0);  

begin


        
        -- MUX for operand_add_sub_1
        MUX_OP1 : operand_add_sub_1 <= resultat_mul_div when (operation = FMADD_S or operation = FMSUB_S) else
                                     not(resultat_mul_div(31)) & resultat_mul_div(30 downto 0) when (operation = FNMSUB_S or operation = FNMADD_S) else
                                     operand1;
        
        -- MUX for operand_add_sub_2
        MUX_OP2 : operand_add_sub_2 <= operand3 when (operation = FMADD_S or operation = FNMSUB_S) else
                                     not(operand3(31)) & operand3(30 downto 0) when (operation = FMSUB_S or operation = FNMADD_S) else
                                     operand2 when operation = FADD_S else
                                     not(operand2(31)) & operand2(30 downto 0);
                         
        Adder_float:    entity work.Adder_float      
        port map (
            -- operation   => operation,
            operand1    => operand_add_sub_1,
            operand2    => operand_add_sub_2,
            result      => result
        );

        MUL_DIV_FLOAT:    entity work.MUL_DIV_FLOAT      
        port map (
            operation   =>  operation,  -- Input RISC-V instruction
            operand1    =>  operand1,   -- First operand (float/int)
            operand2    =>  operand2,   -- Second operand (float/int)
            result      =>  resultat_mul_div,     -- Output result (float/int)
            DZ   => DZ
        );

end structural;

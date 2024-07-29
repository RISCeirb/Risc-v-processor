-------------------------------------------------------------------------
-- Design unit: ALU
-- Description: 
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISC_V_package.all;

entity ALU is
    port(
        pc    : in std_logic_vector(31 downto 0);
        operand1    : in std_logic_vector(31 downto 0);
        operand2    : in std_logic_vector(31 downto 0);
        result      : out std_logic_vector(31 downto 0);
        branch        : out std_logic;
        operation   : in Instruction_type   
    );
end ALU;

architecture behavioral of ALU is

    signal temp, op1, op2: UNSIGNED(31 downto 0);

begin

    op1 <= UNSIGNED(operand1);
    op2 <= UNSIGNED(operand2);
    
    result <= STD_LOGIC_VECTOR(temp);
    
    -- Instructions register results
        
    temp <= 
    
    
    -- R-types instructions
  
            op1 + op2 when operation = ADD else --add
            op1 - op2 when operation = SUB else --sub
            
            
            
            shift_left(op1,to_integer(op2(4 downto 0))) when operation = SLLins else  --shift left SLL
            shift_right(op1,to_integer(op2(4 downto 0))) when operation = SRLins else --shift right SRL
            shift_right(op1,to_integer(op2(4 downto 0))) + shift_left(op1,32 - to_integer(op2(4 downto 0))) when operation = SRAins else --shift SRA 
            
            --compare unsigned SLTU
            
            (0=>'1', others=>'0')   when operation = SLTU and op1 < op2 else
            (others=>'0')           when operation = SLTU and not(op1 < op2) else
            
            --compare signed SLT
            
            (0=>'1', others=>'0')   when operation = SLT and signed(op1) < signed(op2) else
            (others=>'0')           when operation = SLT and not(signed(op1) < signed(op2)) else
            
            --logical operation
            
            op1 or op2 when operation = ORins else  --OR
            op1 xor op2 when operation = XORins else --XOR
            op1 and op2 when operation = ANDins else --AND
            
            
    -- I-types instructions (if rs2 = signextented)
    
            op1 + op2 when operation = ADDI else --ADDI
            
            -- SLTI et SLTIU (compare imediate)
            (0=>'1', others=>'0') when operation = SLTI and signed(op1) < signed(op2) else       --SLTI
            (others=>'0')         when operation = SLTI and not(signed(op1) < signed(op2)) else  --SLTI
            
            (0=>'1', others=>'0') when operation = SLTIU and op1 < op2  else           --SLTIU
            (others=>'0')         when operation = SLTIU and not(op1 < op2) else       --SLTIU
            
            -- Logical immediate operation
            
            op1 and op2 when operation = ANDI else --ANDI
            op1 or  op2 when operation = ORI  else  --ORI
            op1 xor op2 when operation = XORI else --XORI
            
            -- SLLI, SRLI, SRAI (imediate shift instruction) 
            
            shift_left(op1,to_integer(op2(4 downto 0))) when operation = SLLI else  --shift left SLLI
            shift_right(op1,to_integer(op2(4 downto 0))) when operation = SRLI else --shift right SRLI
            shift_right(op1,to_integer(op2(4 downto 0))) + shift_left(op1,32 - to_integer(op2(4 downto 0))) when operation = SRAI else --shift SRAI 
            
      -- U-types instructions 
                
            -- LUI and AUIPC 
            
            op2 when operation = LUI else                   -- LUI put the 20 high bit from the instruction to rs2
            op2 + unsigned(pc) when operation = AUIPC else  -- Puts pc + offset in rd
            
      -- B-types instructions
      
            op1 - op2  when operation = BEQ or operation = BNE or 
            operation = BGE or operation = BGE or 
            operation = BLT or operation = BLTU else
       
       
      -- J-types instructions
       
            unsigned (pc) + to_unsigned(4,32) when operation = JALR or operation = JAL else

      -- S-types instructions
            -- the alu result give the addresse the store with rs1 + sign_extented_s
      
            op1 + op2   when operation = SW or operation = SH or operation = SB else 
      
      -- I-types instructions (load)
            -- the alu result give the addresse the store with rs1 + sign_extented_i
      
      	    op1 + op2   when operation = LW or operation = LB or operation = LH or operation = LBU or operation = LHU else
      
      -- Default 
                  
            (others=>'0') ;    -- default 0

    -- Generates the branch flag
    
    
    branch <= '1'   when (temp = 0 and operation = BEQ) or (temp /= 0 and operation = BNE) or
                    (signed(op1) >= signed(op2) and operation = BGE) or ( op1 >= op2 and operation = BGEU) or
                    (signed(op1) < signed(op2)and operation = BLT) or ( op1 < op2 and operation = BLTU) or operation = JALR or operation = JAL
                    else '0'; 
    
end behavioral;


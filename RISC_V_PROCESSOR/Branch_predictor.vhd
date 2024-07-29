library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Branch_predictor is
    generic (
        SIZE      : integer := 512       -- Size of the branch history table ( Index of the pc )
    );
    port (
        branch_ex       : in std_logic; 
        clock           : in std_logic;
        reset           : in std_logic; 
        pc_if           : in std_logic_vector(31 downto 0);
        pc_ex           : in std_logic_vector(31 downto 0);
        pc_cal          : in std_logic_vector(31 downto 0);
        pc_predict      : out std_logic_vector(31 downto 0);
        predict_if      : out std_logic
    );
end Branch_predictor;


architecture structural of Branch_predictor is


type pc_br is array(0 to SIZE-1) of std_logic_vector(31 downto 0);
type prediction is array(0 to SIZE-1) of std_logic_vector(1 downto 0);
type tag is array(0 to SIZE-1) of std_logic_vector(19 downto 0);
type valid is array(0 to SIZE-1) of std_logic;


signal br : pc_br;
signal predict_branch : prediction;
signal tag_memory_table : tag;
signal valid_index : valid;

alias tag_pc_if is pc_if(31 downto 12);
alias index_if  is pc_if(11 downto 2);

alias tag_pc_ex is pc_ex(31 downto 12);
alias index_ex  is pc_ex(11 downto 2);

signal new_predict_branch : prediction;
signal writeEnable : std_logic_vector(SIZE-1 downto 0);
signal taken : std_logic;

signal incrementedPC : std_logic_vector(31 downto 0);

begin            

ADDER_PC: incrementedPC <= STD_LOGIC_VECTOR(UNSIGNED(pc_if) + TO_UNSIGNED(4,32));

Registers: for i in 0 to SIZE-1 generate        

        -- writeEnable(i) <= '1' when i > 0 and UNSIGNED(write_pc_number) = i and branch_ex = '1' else '0';
        
        writeEnable(i) <= '1' when  UNSIGNED(index_ex) = i and branch_ex = '1' else '0';
        
        
        -- tag of the memory cache
        
        tag : entity work.RegisterNbits 
            generic map (
                LENGTH      => 20
            )
            port map (
                clock   => clock, 
                reset   => reset, 
                ce      => writeEnable(i), 
                d       => pc_ex, 
                q       => tag_memory_table(i)
            );
            
                                
         -- Registers for pc_branch
            
         Data_br: entity work.RegisterNbits 
            generic map (
                LENGTH      => 32
            )
            port map (
                clock   => clock, 
                reset   => reset, 
                ce      => writeEnable(i), 
                d       => pc_cal, 
                q       => br(i)
            );
           
          -- Use the Fsm to choose to take the branch ( State actuelle for very pc in the history table)
          
          Data_prediction: entity work.RegisterNbits 
            generic map (
                LENGTH      => 2
                --INIT_VALUE  => 0        -- Set all the prediction to not taken
            )
            port map (
                clock   => clock, 
                reset   => reset, 
                ce      => writeEnable(i), 
                d       => predict_branch(i), 
                q       => new_predict_branch(i)
            );
                          
    end generate Registers;  
    
    pc_predict <=   br(TO_INTEGER(UNSIGNED(index_if))) when taken = '1' and valid_index(TO_INTEGER(UNSIGNED(index_if))) = '1' 
                    and tag_memory_table(TO_INTEGER(UNSIGNED(index_if))) = tag_pc_if else
                    incrementedPC;
    predict_if <=   taken;
                    
end structural;


architecture behavioral of Branch_predictor is

type pc_br is array(0 to SIZE-1) of std_logic_vector(31 downto 0);
type prediction is array(0 to SIZE-1) of std_logic_vector(1 downto 0);
type tag is array(0 to SIZE-1) of std_logic_vector(19 downto 0);
type valid is array(0 to SIZE-1) of std_logic;


signal br : pc_br;
signal predict_branch : prediction;
signal tag_memory_table : tag;
signal valid_index : valid;

alias tag_pc_if is pc_if(31 downto 12);
alias index_if  is pc_if(11 downto 2);

alias tag_pc_ex is pc_ex(31 downto 12);
alias index_ex  is pc_ex(11 downto 2);

signal new_predict_branch : prediction;
signal writeEnable : std_logic_vector(SIZE-1 downto 0);
signal taken : std_logic;

signal incrementedPC : std_logic_vector(31 downto 0);

begin            

-- process to write the history table when a branch or a jump is taken ( with pc_ex)

    process(clock, reset, branch_ex)
    begin
        
        if reset = '1' then
            for i in 0 to SIZE-1 loop
                tag_memory_table(i) <= (others=>'0');
                br(i) <= (others=>'0');
                predict_branch(i) <= (others=>'0');    -- Set all the prediction to not taken
                valid_index(i) <= '0';
            end loop;
        elsif rising_edge(clock) then 
            if (branch_ex = '1') then 
                br(TO_INTEGER(UNSIGNED(index_ex))) <= pc_cal;
                tag_memory_table(TO_INTEGER(UNSIGNED(index_ex))) <= tag_pc_ex;
                predict_branch(TO_INTEGER(UNSIGNED(index_ex))) <= new_predict_branch(TO_INTEGER(UNSIGNED(index_ex)));
                valid_index(TO_INTEGER(UNSIGNED(index_ex))) <= '1';
            end if;
        end if;
            
    end process;  
    
--if (tag_memory_table(TO_INTEGER(UNSIGNED(index_ex))) = tag_pc_ex) then
--                    br(TO_INTEGER(UNSIGNED(index_ex))) <= pc_cal;
--                    predict_branch(TO_INTEGER(UNSIGNED(index_ex))) <= "00";
--                else
--                    br(TO_INTEGER(UNSIGNED(index_ex))) <= pc_cal;
--                    predict_branch(TO_INTEGER(UNSIGNED(index_ex))) <= new_predict_branch(TO_INTEGER(UNSIGNED(index_ex)));
--                end if;
   
-- Process to update prediction FSM 

    process(clock, branch_ex, predict_branch)
    begin
        if rising_edge(clock) then
            if (tag_memory_table(TO_INTEGER(UNSIGNED(index_ex))) = tag_pc_ex) then  -- corrspondance and update of the dynamic branch predition
                if branch_ex = '1' then
                    case predict_branch(TO_INTEGER(UNSIGNED(index_ex))) is
                        when "11" =>
                            new_predict_branch(TO_INTEGER(UNSIGNED(index_ex))) <= "11";
                        when "10" =>
                            new_predict_branch(TO_INTEGER(UNSIGNED(index_ex))) <= "11";
                        when "01" =>
                            new_predict_branch(TO_INTEGER(UNSIGNED(index_ex))) <= "10";
                        when others =>
                            new_predict_branch(TO_INTEGER(UNSIGNED(index_ex))) <= "01";
                    end case;
                else
                    case predict_branch(TO_INTEGER(UNSIGNED(index_ex))) is
                        when "11" =>
                            new_predict_branch(TO_INTEGER(UNSIGNED(index_ex))) <= "10";
                        when "10" =>
                            new_predict_branch(TO_INTEGER(UNSIGNED(index_ex))) <= "01";
                        when "01" =>
                            new_predict_branch(TO_INTEGER(UNSIGNED(index_ex))) <= "00";
                        when others =>
                            new_predict_branch(TO_INTEGER(UNSIGNED(index_ex))) <= "00";
                    end case;
                end if;
            end if;
        end if;
    end process;


    -- Process to determine branch taken or not
    process(index_if)
    begin
            case predict_branch(TO_INTEGER(UNSIGNED(index_if))) is
                when "11" | "10" =>
                    taken <= '1';
                when "01" | "00" =>
                    taken <= '0';
                when others =>
                    taken <= '0';
            end case;
    end process;


    pc_predict <=   br(TO_INTEGER(UNSIGNED(index_if))) when taken = '1' and valid_index(TO_INTEGER(UNSIGNED(index_if))) = '1' 
                    and tag_memory_table(TO_INTEGER(UNSIGNED(index_if))) = tag_pc_if else
                    incrementedPC;
    predict_if <=   taken;
    -- predict_id <=   predict_branch(TO_INTEGER(UNSIGNED(index_id)))(1);
                    
end behavioral;
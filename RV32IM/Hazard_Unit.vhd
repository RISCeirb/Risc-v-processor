library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.RISC_V_package.all;

entity Hazard_Unit is
    port (
	-- clock        : in std_logic;
        Memread_ex   : in std_logic;
--        RegWrite_mem : in std_logic;
--        RegWrite_wb : in std_logic;
--        rd_wb       : in std_logic_vector(4 downto 0);
--        rd_mem      : in std_logic_vector(4 downto 0);
        rd_ex      : in std_logic_vector(4 downto 0);
--        rs1_ex      : in std_logic_vector(4 downto 0);
--        rs2_ex      : in std_logic_vector(4 downto 0);
        rs1_id      : in std_logic_vector(4 downto 0);
        rs2_id      : in std_logic_vector(4 downto 0);
--        forwardRS1  : out std_logic_vector(1 downto 0);
--        forwardRS2  : out std_logic_vector(1 downto 0);
        enable_pipeline_data :out std_logic
    );
end Hazard_Unit;

architecture structural of Hazard_Unit is
    
-- signal counter_up : unsigned(1 downto 0) := "00";

begin
    process(Memread_ex, rd_ex,rs1_id, rs2_id)
    begin
    -- Stall pipeline for load (data dependancy)
	-- if rising_edge(clock) then
	       if( Memread_ex = '1' and (rd_ex = rs1_id or rd_ex = rs2_id)) then
	            enable_pipeline_data <= '0';
	       else
	            enable_pipeline_data <= '1';
	       end if;
	-- end if;
    end process;
end structural;

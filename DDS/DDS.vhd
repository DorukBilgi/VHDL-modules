library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dds is
    Port (
    
     clk : in STD_LOGIC;
     s_axis_phase_tvalid : IN STD_LOGIC;
     s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
     m_axis_data_tvalid : OUT STD_LOGIC;
     m_axis_data_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
     
     );
end dds; 

architecture Behavioral of dds is


COMPONENT dds_compiler_0
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_phase_tvalid : IN STD_LOGIC;
    s_axis_phase_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

begin
your_instance_name : dds_compiler_0
  PORT MAP (
    aclk => clk,
    s_axis_phase_tvalid => s_axis_phase_tvalid,
    s_axis_phase_tdata => s_axis_phase_tdata,
    m_axis_data_tvalid => m_axis_data_tvalid,
    m_axis_data_tdata => m_axis_data_tdata
  );
  
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dds_tb is
end dds_tb;

architecture Behavioral of dds_tb is
    
    signal clk                 : STD_LOGIC                      := '1';
    signal s_axis_phase_tvalid : STD_LOGIC                      := '0';
    signal s_axis_phase_tdata  : STD_LOGIC_VECTOR(15 DOWNTO 0)  := (others => '0');
    signal m_axis_data_tvalid  : STD_LOGIC                      := '0';
    signal m_axis_data_tdata   : STD_LOGIC_VECTOR(7 DOWNTO 0)   := (others => '0');
    
    signal writeShftReg : std_logic_vector(5 downto 0) := "110000";
    signal readShftReg  : std_logic_vector(5 downto 0) := "000011";
    signal counter      : unsigned(31 downto 0)        := (others => '0');
    
begin

    DUT : entity work.dds
    
    port map(
    
     clk                 => clk,
     s_axis_phase_tvalid => s_axis_phase_tvalid,
     s_axis_phase_tdata  => s_axis_phase_tdata,
     m_axis_data_tvalid  => m_axis_data_tvalid,
     m_axis_data_tdata   => m_axis_data_tdata
    
    ); 
    
clk <= not clk after 4 ns;  
    
Wavegen_Proc : process
begin
 wait until clk='1';
end process Wavegen_Proc;
    
shiftregPro : process (clk) is
 begin  
 if clk'event and clk = '1' then
    writeShftReg <= writeShftReg(writeShftReg'high-1 downto 0) & writeShftReg(writeShftReg'high);
    readShftReg  <= readShftReg(readShftReg'high-1 downto 0) & readShftReg(readShftReg'high);
 end if;

end process shiftregPro;    

counter_Proc : process (clk) is
 begin  
   if clk'event and clk = '1' then

     counter <= counter + 1;
    
  end if;
 end process counter_Proc;

 
FrequencySwap : process (clk) is
 begin  
   if clk'event and clk = '1' then
   
     if(counter > 9 and counter <= 41) then
     s_axis_phase_tvalid  <= '1';
     s_axis_phase_tdata   <= std_logic_vector(to_unsigned(2**15,16));  
     elsif(counter > 41 and counter <= 73) then
     s_axis_phase_tvalid  <= '1';
     s_axis_phase_tdata   <= std_logic_vector(to_unsigned(20000,16));  
     elsif(counter <= 105 and counter > 73) then   
     s_axis_phase_tvalid  <= '1';
     s_axis_phase_tdata   <= std_logic_vector(to_unsigned(13776,16));  
     elsif(counter > 105 and counter <= 137) then
     s_axis_phase_tvalid  <= '1';
     s_axis_phase_tdata   <= std_logic_vector(to_unsigned(2000,16));  
     elsif(counter > 137) then
     s_axis_phase_tvalid  <= '1';
     s_axis_phase_tdata   <= std_logic_vector(to_unsigned(20000,16));  
     end if;
     
  end if;
 end process FrequencySwap;
    
    

end Behavioral;

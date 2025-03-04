library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DDS_PRI_RAM_moving_average_tb is
end DDS_PRI_RAM_moving_average_tb;

architecture Behavioral of DDS_PRI_RAM_moving_average_tb is
    
    signal iClk               : STD_LOGIC                      := '1';
    signal iRst               : STD_LOGIC                      := '0';
    signal iPW                : STD_LOGIC_VECTOR(7 DOWNTO 0)   := (others => '0');
    signal iPRI               : STD_LOGIC_VECTOR(7 DOWNTO 0)   := (others => '0');
    signal oDataOut           : STD_LOGIC_VECTOR(7 DOWNTO 0)   := (others => '0');
    signal oEN                : STD_LOGIC                      := '0';
 
    signal counter            : unsigned(31 downto 0)          := (others => '0');
    
 
begin

    DUT : entity work.DDS_PRI_RAM_moving_average
    
    port map(
    
     iClk                 => iClk,
     iRst                 => iRst,
     iPW                  => iPW,
     iPRI                 => iPRI,
     oDataOut             => oDataOut,
     oEN                  => oEN
     
    ); 
    
iClk <= not iClk after 2 ns;  

reset_Proc : process
 begin  
 
   iRst <= '1';
   wait for 1 us;
   iRst <= '0';
   wait;
   
end process reset_Proc;
 
Wavegen_Proc : process
begin

 wait until iClk='1';

end process Wavegen_Proc;
    
counter_Proc : process (iClk) is
 begin  
 
   if iClk'event and iClk = '1' then
   
     if(iRst = '1') then
     counter <= (others => '0');
     else
     counter <= counter + 1;
     end if;
     
  end if;
  
 end process counter_Proc;
 
FrequencySwap : process (iClk) is
 begin  
 
   if iClk'event and iClk = '1' then
    if(iRst = '1') then
    
     iPW   <= (others => '0');
     iPRI  <= (others => '0');
     --iFreq <= (others => '0');
     
     else
     
     iPW   <= "00110010";--50
     iPRI  <= "11001000";--200
     --iFreq <= "10100111";--167 
     
   end if;
  end if;
 end process FrequencySwap;
    
end Behavioral;

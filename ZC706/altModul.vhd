library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 

entity altModul is
port (

    iClk   : in  std_logic;
    oLED  : out  STD_LOGIC_VECTOR ( 1 downto 0 )
    
    );                     
end altModul;

architecture Behavioral of altModul is

signal counter    : natural range 0 to 200000000 := 0;
signal oLED_mem  : STD_LOGIC_VECTOR ( 1 downto 0 ):= (others => '0');

begin

LED_Pro : process (iClk) is
begin
     if (iClk'event and iClk = '1') then
     
      if(counter = 0 )then
     
     oLED_mem(0) <= '0';
     oLED_mem(1) <= '0';

     
     elsif(counter = 50000000)then
     
     oLED_mem(0) <= '1';
     oLED_mem(1) <= '0';

     elsif(counter = 100000000 )then
     
     oLED_mem(0) <= '0';
     oLED_mem(1) <= '1';
 
     counter <= 0;
     
     end if;
     
     counter <= counter + 1;        
     
     oLED(0)   <= oLED_mem(0);
     oLED(1)   <= oLED_mem(1);

                                   
     end if;
     
end process LED_Pro;
     
end Behavioral;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity counter_4bit is
 generic (
    cCountBitW : integer := 4);         -- sayacin kac bit olacagi
 port (
     iClk       : in  std_logic;         -- clk input
     iRst       : in  std_logic;         -- reset input
     iCountEn   : in  std_logic;         -- sayac aktif
     iCountLim  : in  std_logic_vector(cCountBitW-1 downto 0);  -- sayacin limiti
     oCountDone : out std_logic;         -- bir tur bitti isareti
     oCount     : out std_logic_vector(cCountBitW-1 downto 0)   -- sayilan deger
    );
end entity counter_4bit;

architecture Behavioral of counter_4bit is

  signal count_temp : std_logic_vector(cCountBitW-1 downto 0) := (others => '0');
  signal mem        : std_logic                               := '0';
 
 begin
   process (iClk) is
   begin  -- process
     if iClk'event and iClk = '1' then  -- rising clock edge
       if(iRst  = '0' ) then
         count_temp <= "0000";
        elsif(iCountEn = '1') then
          count_temp <= std_logic_vector(unsigned(count_temp) + 1);
          if count_temp = iCountLim then
            mem        <= '1';
            count_temp <= "0000";
           else
            mem <= '0';
          end if;
        end if;
      end if;
   end process; -- duzenlendi.
        
        oCountDone <= mem;
        oCount     <= count_temp ;
        
end Behavioral;
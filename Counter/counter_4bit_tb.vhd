library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_4bit_tb is
end counter_4bit_tb;

architecture Behavioral of counter_4bit_tb is
    signal iClk          : std_logic ;
    signal iRst_tb       : std_logic  ;
    signal iCountEn_tb   : std_logic  ;  -- inputs 
    signal iCountLim_tb  : std_logic_vector(3 downto 0);
    signal oCountDone_tb : std_logic ;  -- outputs
    signal oCount_tb     : std_logic_vector(3 downto 0);
    
begin
   
    UUT : entity work.counter_4bit 
      port map (
        iRst       => iRst_tb, 
        iClk       => iClk, 
        iCountEn   => iCountEn_tb, 
        iCountLim  => iCountLim_tb, 
        oCountDone => oCountDone_tb, 
        oCount     => oCount_tb
        );

    clock_process: process
    begin
         iClk <= '1';
         wait for 10 ns;
         iClk <= '0';
         wait for 10 ns;
    end process;
    
    stimulus_process: process
    begin 
          iCountLim_tb <= "1110"; -- limit yok.
          iCountEn_tb  <= '1';
          iRst_tb      <= '1';
          wait for 300 ns;    
          iCountLim_tb <= "1010"; -- limit var 10'a kadar say.
          iCountEn_tb  <= '1';
          iRst_tb      <= '1';
          wait for 220 ns;  
          iCountLim_tb <= "1111"; -- limit yok. 200 ns sonra reset enable.
          iCountEn_tb  <= '1';
          iRst_tb      <= '1';
          wait for 200 ns;  
          iRst_tb <= '0';
          wait for 10 ns; -- 10 ns boyunca reset enable 
          iCountLim_tb <= "1111"; -- limit yok.
          iCountEn_tb  <= '1';
          iRst_tb      <= '1';
          wait;
    end process;   
        
end Behavioral;

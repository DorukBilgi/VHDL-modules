library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_8bit_tb is
end counter_8bit_tb;

architecture Behavioral of counter_8bit_tb is
    signal iClk          : std_logic ;
    signal iRst_tb       : std_logic ;
    signal iCountEn_tb   : std_logic ;  -- inputs 
    signal iCountLim_tb  : std_logic_vector(7 downto 0);
    signal oCountDone_tb : std_logic ;  -- outputs
    signal oCount_tb     : std_logic_vector(7 downto 0);
    
begin
    -- connecting testbench signals with counter_4bit.vhd
    UUT : entity work.counter_8bit 
      port map (
        iRst => iRst_tb, 
        iClk => iClk, 
        iCountEn => iCountEn_tb,
        iCountLim => iCountLim_tb, 
        oCountDone => oCountDone_tb, 
        oCount => oCount_tb
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
          iCountLim_tb <= "11111111"; -- limit yok. 600 ns boyunca sayac sayiyor.
          iCountEn_tb  <= '1';
          iRst_tb      <= '1';
          wait for 600 ns;    
          iRst_tb <= '0';
          wait for 10 ns;  -- 10 ns boyunca reset enable
          iRst_tb <= '1';
       wait;
    end process;
        
end Behavioral;
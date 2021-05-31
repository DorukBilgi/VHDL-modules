library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity BRAM_entity_tb is

end BRAM_entity_tb;

architecture Behavioral of BRAM_entity_tb is

  constant cRamWidth  : integer := 32;
  constant cDataWidth : integer := 16;

  signal clk    : std_logic                               := '1';
  signal iRst   : std_logic                               := '0';
  signal iWen   : std_logic                               := '0';
  signal iWData : std_logic_vector(cDataWidth-1 downto 0) :=(others => '0');
  signal iREn   : std_logic                               := '0';
  signal oRData : std_logic_vector(cDataWidth-1 downto 0) :=(others => '0');
  signal oEmpty : std_logic                               :='0';
  signal oFull  : std_logic                               :='0';
  
  signal sayac_temp    : std_logic_vector(7 downto 0)   := (others => '0');

begin

  DUT : entity work.BRAM_entity
     generic map (
       cRamWidth  => cRamWidth,
       cDataWidth => cDataWidth)
     port map (
       iClk   => clk,
       iRst   => iRst,
       iWen   => iWen,
       iWData => iWData,
       iREn   => iREn,
       oRData => oRData,
       oEmpty => oEmpty,
       oFull  => oFull
       );
       
       
clk <= not clk after 10 ns;
         
WaveGen_Proc : process
begin
  wait until clk='1';         
end process WaveGen_Proc;

reset_Proc : process
 begin  
   iRst <= '1';
   wait for 1 us;
   iRst <= '0';
   wait;
 end process reset_Proc;

dataWritePro: process (clk) is
begin
  if clk'event and clk = '1' then
    if(iRst = '1') then
      iWen <= '0';
      iWData <= (others => '0');
    else 
      iWen <= '1';
      iWData <= std_logic_vector(unsigned(iWData)+1);
      sayac_temp   <= std_logic_vector(unsigned(sayac_temp) + 1);
    end if;
    if(sayac_temp = "00100001")then
           
        iWen         <= '0'; -- write off mode 
        iREn         <= '1';
        iWData <= (others => '0');
        sayac_temp   <= std_logic_vector(unsigned(sayac_temp) + 1);
           
    end if;
           
    if(sayac_temp > "00100001")then -- yazma islemi bitti. okuma yapýlacak.
            
        iWen         <= '0'; -- write off mode 
        iREn         <= '1';
        iWData <= (others => '0');
        sayac_temp   <= std_logic_vector(unsigned(sayac_temp) + 1);
         
    end if;
  end if;
end process dataWritePro;    

end Behavioral;

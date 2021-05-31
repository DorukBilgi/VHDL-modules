library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity BRAM_dual_port_tb is

end BRAM_dual_port_tb;

architecture Behavioral of BRAM_dual_port_tb is

  constant cRamWidth  : integer := 32;
  constant cDataWidth : integer := 16;

  signal clkA    : std_logic                               := '1';
  signal clkB    : std_logic                               := '1';
  signal iRst    : std_logic                               := '0';
  signal iWen    : std_logic                               := '0';
  signal iWData  : std_logic_vector(cDataWidth-1 downto 0) :=(others => '0');
  signal iREn    : std_logic                               := '0';
  signal oRData  : std_logic_vector(cDataWidth-1 downto 0) :=(others => '0');
  signal oEmpty  : std_logic                               :='0';
  signal oFull   : std_logic                               :='0';
  
  signal sayac_temp_yazma    : std_logic_vector(7 downto 0)     := (others => '0');
  signal sayac_temp_okuma    : std_logic_vector(7 downto 0)     := (others => '0');

begin

  DUT : entity work.BRAM_dual_port
     generic map (
       cRamWidth  => cRamWidth,
       cDataWidth => cDataWidth)
     port map (
       iClkA  => clkA,
       iClkB  => clkB,
       iRst   => iRst,
       iWen   => iWen,
       iWData => iWData,
       iREn   => iREn,
       oRData => oRData,
       oEmpty => oEmpty,
       oFull  => oFull
       );
       
clkA <= not clkA after 10 ns;
clkB <= not clkB after 10 ns;

WaveGen_Proc : process
begin
  wait until clkA='1';
  wait until clkB='1';         
end process WaveGen_Proc;


reset_Proc : process
 begin  
   iRst <= '1';
   wait for 1 us;
   iRst <= '0';
   wait;
 end process reset_Proc;


dataWritePro: process (clkA) is
begin
  if clkA'event and clkA = '1' then
    if(iRst = '1') then
      iWen   <= '0';
      iWData <= (others => '0');
    elsif(iREn = '0') then
      iWen               <= '1';
      iWData             <= std_logic_vector(unsigned(iWData)+1);
      sayac_temp_yazma   <= std_logic_vector(unsigned(sayac_temp_yazma) + 1);     
    elsif(sayac_temp_yazma = "01100001" and iREn = '0' )then          
      iWen               <= '0'; 
      iWData             <= (others => '0');
      sayac_temp_yazma   <= std_logic_vector(unsigned(sayac_temp_yazma) + 1);
    else 
      iWen               <= '0'; 
      iWData             <= (others => '0');       
    end if;

  end if;
end process dataWritePro;    

dataReadPro: process (clkB) is
begin
  if clkB'event and clkB = '1' then
    if(iRst = '1') then
      iREn <= '0';
    else            
    if(sayac_temp_yazma > "00100001")then -- yazma islemi bitti. okuma yapýlacak. 
      iREn               <= '1';
      sayac_temp_okuma   <= std_logic_vector(unsigned(sayac_temp_okuma) + 1);        
    end if;
  end if;
end if;
end process dataReadPro; 
end Behavioral;
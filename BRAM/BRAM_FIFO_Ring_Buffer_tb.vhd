library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity BRAM_FIFO_Ring_Buffer_tb is

end BRAM_FIFO_Ring_Buffer_tb;

architecture Behavioral of BRAM_FIFO_Ring_Buffer_tb is

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
  
  signal counter      : unsigned(31 downto 0) := (others => '0');
  signal writeShftReg : std_logic_vector(5 downto 0) := "110000";
  signal readShftReg  : std_logic_vector(5 downto 0) := "000011";

begin

  DUT : entity work.BRAM_FIFO_Ring_Buffer
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

counter_Proc : process (clkA) is
 begin  
   if clkA'event and clkA = '1' then
     if(iRst = '1') then
     counter <= (others => '0');
     else
     counter <= counter + 1;
     end if;
  end if;
 end process counter_Proc;


shiftregPro : process (clkA) is
 begin  
 if clkA'event and clkA = '1' then
    writeShftReg <= writeShftReg(writeShftReg'high-1 downto 0) & writeShftReg(writeShftReg'high);
    readShftReg  <= readShftReg(readShftReg'high-1 downto 0) & readShftReg(readShftReg'high);
 end if;

end process shiftregPro;


writePro : process (clkA) is
 begin  
   if clkA'event and clkA = '1' then
     if(iRst = '1') then
     iWen <= '0';
     iWData <= (others => '0');
     elsif(counter > 9 and counter <= 41) then
     iWen    <= '1';
     iWData  <= std_logic_vector(unsigned(iWData)+1);
     elsif(counter > 41 and counter <= 73) then
     iWen <= '0';
     iWData <= (others => '0');
     elsif(counter <= 105 and counter > 73) then
     iWen <= '1';
     iWData  <= std_logic_vector(unsigned(iWData)+1);
     elsif(counter > 105 and counter <= 137) then
     iWen <= '0';
     iWData <= (others => '0');
     elsif(counter > 137) then
     iWen <= writeShftReg(writeShftReg'high);
     end if;
  end if;
 end process writePro;

readPro : process (clkB) is
 begin  
   if clkB'event and clkB = '1' then
     if(iRst = '1') then
     iRen <= '0';
     elsif(counter > 41 and counter <= 73) then
     iRen <= '1';
     elsif(counter <= 105 and counter > 73) then
     iRen <= '0';
     elsif(counter > 105 and counter <= 137) then
     iRen <= '1';
     elsif(counter > 137) then
     iRen <= readShftReg(readShftReg'high);
     end if;
  end if;
 end process readPro;

end Behavioral;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_8bit is
  port(
    iClk       : in  std_logic;
    iCountEn   : in  std_logic;
    iRst       : in std_logic;
    iCountLim  : in std_logic_vector(7 downto 0);
    oCountDone : out std_logic;
    oCount     : out std_logic_vector(7 downto 0));
end counter_8bit;

architecture Behavioral of counter_8bit is
  constant cCountBitW  : integer := 4;
  signal   cnt1Done, cnt2Done  : std_logic;
  signal   Q                   : std_logic_vector(7 downto 0);
  signal   cnt1, cnt2          : std_logic_vector(3 downto 0);

 component counter_4bit
    port(
     iClk       : in std_logic;
     iCountEn   : in std_logic;
     iRst       : in std_logic;
     iCountLim  : in  std_logic_vector(3 downto 0);
     oCountDone : out std_logic;
     oCount     : out std_logic_vector(3 downto 0));       
 end component;
 
begin
   counter1: entity work.counter_4bit
    generic map (
      cCountBitW => cCountBitW)
    port map (
      iClk       => iClk,
      iRst       => iRst,
      iCountEn   => iCountEn,
      iCountLim  => iCountLim(3 downto 0),
      oCountDone => cnt1Done,
      oCount     => cnt1
      );

  counter2: entity work.counter_4bit
    generic map (
      cCountBitW => cCountBitW)
    port map (
      iClk       => iClk,
      iRst       => iRst,
      iCountEn   => cnt1Done,
      iCountLim  => iCountLim(7 downto 4),
      oCountDone => cnt2Done,
      oCount     => cnt2
      );

  oCountDone <= cnt2Done;
  Q          <= cnt2 & cnt1;
  oCount     <= Q;   
  
end Behavioral;

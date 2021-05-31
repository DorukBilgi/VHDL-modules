library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 

entity BRAM_entity is
  generic (
    cRamWidth  : integer := 32;
    cDataWidth : integer := 16
    );
  port (
    iClk   : in  std_logic;
    iRst   : in  std_logic;
    iWen   : in  std_logic;                      -- write enable pin
    iWData : in  std_logic_vector(cDataWidth-1 downto 0);  -- write data
    iREn   : in std_logic;
    oRData : out std_logic_vector(cDataWidth-1 downto 0);  -- read data
    oEmpty : out std_logic; 
    oFull  : out std_logic
    );                     -- ram full

end entity BRAM_entity;

architecture Behavioral of BRAM_entity is

COMPONENT blk_mem_gen_manuel
  PORT (
    clka  : IN STD_LOGIC;
    ena   : IN STD_LOGIC;
    wea   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    dina  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

    signal ramEn      : std_logic                     :='1';
    signal ramWEn     : std_logic_vector(0 downto 0)  := (others => '0');
    signal ramREn     : std_logic_vector(0 downto 0)  := (others => '0');
    signal ramAddr    : std_logic_vector(4 downto 0)  := (others => '0');
    signal ramDataIn  : std_logic_vector(15 downto 0) := (others => '0');
    signal ramDataOut : std_logic_vector(15 downto 0) := (others => '0');
    signal writeCount : std_logic_vector(5 downto 0)  := (others => '0');
    signal readCount  : std_logic_vector(5 downto 0)  := (others => '0');
    signal ramFull    : std_logic                     :='0';
    signal ramEmpty   : std_logic                     :='0';
    
begin


your_instance_name : blk_mem_gen_manuel
  PORT MAP (
    clka  => iClk,
    ena   => ramEn,
    wea   => ramWEn, 
    addra => ramAddr,
    dina  => ramDataIn,
    douta => ramDataOut
  );

ramPro : process (iClk) is
begin
 if iClk'event and iClk = '1' then
         ramFull <= '0';
         oFull   <= ramFull; 
  if(iRst = '1')then
     writeCount <=  (others => '0');
     readCount <=  (others => '0');
     ramFull    <= '0';
     oFull    <= ramFull;
     ramEmpty    <= '0';
     oEmpty    <= ramEmpty;
     ramWEn(0)  <= '0';
     ramREn(0)  <= '0';
     ramDataIn  <= (others => '0');
  elsif(iWen = '1' ) then
     writeCount <= std_logic_vector(unsigned(writeCount)+1);
     ramWEn(0) <= '1';
     ramDataIn <= iWData;
     ramAddr <= writeCount(4 downto 0);
     if(writeCount = "011111") then
       ramFull <= '1';
       oFull   <= ramFull;
      else 
         ramFull <= '0';
         oFull   <= ramFull; 
      end if;
  elsif(iREn = '1')then
     readCount <= std_logic_vector(unsigned(readCount)+1);
     ramWEn(0) <= '0';
     ramREn(0) <= '1';
     ramAddr <= readCount(4 downto 0);
     oRData <= ramDataOut;
         if(readCount = writeCount and writeCount /= "000000")then
          ramEmpty <= '1';
          oEmpty   <= ramEmpty;
         else
          ramEmpty <= '0';
          oEmpty   <= ramEmpty; 
         end if;
   else
   ramWEn(0) <= '0';
   ramDataIn <= (others => '0');
 end if;        
  
  
end if;

end process ramPro;
   
end Behavioral;

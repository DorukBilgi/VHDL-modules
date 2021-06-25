library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity UART2_tb is

generic(

    gClkFreq  : integer := 250_000;
    gBaudRate : integer := 83_300;
    gStopBit  : integer := 2

);

end UART2_tb;

architecture Behavioral of UART2_tb is

signal    iClk        : std_logic                    := '0';
signal    iRst        : std_logic                    := '0';

    -- UART 1 --
      
signal    iTx_Data1   :  std_logic_vector (7 downto 0) := (others => '0'); -- tx data
signal    iTx_Start1  :  std_logic := '0'; -- tx en
   
signal    oRx_Data1   :  std_logic_vector (7 downto 0) := (others => '0'); -- rx data
    
--signal    iRx1        : std_logic := '0'; -- rx
--signal    oTx1        : std_logic := '0'; -- tx
    
signal    oTxDone1    : std_logic := '0'; -- tx tamamlandý
signal    oTxBusy1    : std_logic := '0'; -- tx busy
    
signal    oRxDone1    : std_logic := '0'; -- rx tamamlandý
signal    oRxBusy1    : std_logic := '0'; -- rx busy
    
    -- UART 2 --
    
signal    iTx_Data2   :  std_logic_vector (7 downto 0) := (others => '0'); -- tx data
signal    iTx_Start2  :  std_logic := '0'; -- tx en
   
signal    oRx_Data2   :  std_logic_vector (7 downto 0) := (others => '0'); -- rx data
    
--signal    iRx2        : std_logic := '0'; -- rx
--signal    oTx2        : std_logic := '0'; -- tx
    
signal    oTxDone2    : std_logic := '0'; -- tx tamamlandý
signal    oTxBusy2    : std_logic := '0'; -- tx busy
    
signal    oRxDone2    : std_logic := '0'; -- rx tamamlandý
signal    oRxBusy2    : std_logic := '0'; -- rx busy

constant cClockPeriod : time := 4 ns; -- 250 MHz ---> 4 ns

--constant c_hex43		: std_logic_vector (9 downto 0) := '1' & x"43" & '0'; -- start bit logic 0 (LSB) / stop bit logic 1 (MSB)
--constant c_hexA5		: std_logic_vector (9 downto 0) := '1' & x"A5" & '0'; -- start bit logic 0 (LSB) / stop bit logic 1 (MSB)

begin

    UART_2 : entity work.UART2

    generic map (
    
      gClkFreq  => gClkFreq,
      gBaudRate => gBaudRate,
      gStopBit  => gStopBit
    
    )
    
  port map (
  
     iClk         => iClk,
     iRst         => iRst,
     
     -- UART1 --
     
     iTx_Data1    => iTx_Data1,
     iTx_Start1   => iTx_Start1,
     oRx_Data1    => oRx_Data1,
     --iRx1         => iRx1,
     --oTx1         => oTx1,
     oTxDone1     => oTxDone1,
     oTxBusy1     => oTxBusy1,
     oRxDone1     => oRxDone1,
     oRxBusy1     => oRxBusy1,
     
     -- UART2 --
     
     iTx_Data2    => iTx_Data2,
     iTx_Start2   => iTx_Start2,
     oRx_Data2    => oRx_Data2,
     -- iRx2         => iRx2,
     -- oTx2         => oTx2,
     oTxDone2     => oTxDone2,
     oTxBusy2     => oTxBusy2,
     oRxDone2     => oRxDone2,
     oRxBusy2     => oRxBusy2
      
  ); 

P_CLKGEN : process begin

iClk	<= '0';
wait for cClockPeriod/2;
iClk	<= '1';
wait for cClockPeriod/2;

end process P_CLKGEN;

P_STIMULI : process begin

 iRst       <= '1';
 iTx_Data1  <= x"00";
 iTx_Data2  <= x"00";
 iTx_Start1 <= '0';
 iTx_Start2 <= '0';
 
wait for cClockPeriod*10; 

iRst        <= '0';

--wait for cClockPeriod*10; 

iTx_Data1	<= x"51";
iTx_Start1	<= '1';
iTx_Data2	<= x"43";
iTx_Start2	<= '1';

wait for cClockPeriod;

iTx_Start1	<= '0';
iTx_Start2	<= '0';

wait for 1.2 us;

iTx_Data1	<= x"A7";
iTx_Start1	<= '1';
iTx_Data2	<= x"B7";
iTx_Start2	<= '1';

wait for cClockPeriod;

iTx_Start1	<= '0';
iTx_Start2	<= '0';

wait until (rising_edge(oTxDone1) and rising_edge(oTxDone2));

wait for 1 us;

assert false
report "SIM DONE"
severity failure;


end process P_STIMULI;
end Behavioral;

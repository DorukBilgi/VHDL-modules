library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity UART_tx_tb is

generic(

    gClkFreq  : integer := 250_000;
    gBaudRate : integer := 83_300;
    gStopBit  : integer := 2

);

end UART_tx_tb;

architecture Behavioral of UART_tx_tb is

signal iClk     : std_logic                    := '0';
signal iRst     : std_logic                    := '0';
signal iDataIn  : std_logic_vector(7 downto 0) := (others => '0');
signal iTxStart : std_logic                    := '0';
signal oTx      : std_logic                    := '0';
signal oTxDone  : std_logic                    := '0';
signal oTxBusy  : std_logic                    := '0';

constant cClockPeriod : time := 4 ns; -- 250 MHz ---> 4 ns

--constant c_hex43		: std_logic_vector (9 downto 0) := '1' & x"43" & '0'; -- start bit logic 0 (LSB) / stop bit logic 1 (MSB)
--constant c_hexA5		: std_logic_vector (9 downto 0) := '1' & x"A5" & '0'; -- start bit logic 0 (LSB) / stop bit logic 1 (MSB)

begin

    DUT : entity work.UART_tx
    
    generic map(
    
    gClkFreq  => gClkFreq,
    gBaudRate => gBaudRate,
    gStopBit  => gStopBit
        
    )
    
    port map(
    
     iClk        => iClk,
     iRst        => iRst,
     iDataIn     => iDataIn,
     iTxStart    => iTxStart,
     oTx         => oTx,
     oTxDone     => oTxDone,
     oTxBusy     => oTxBusy
     
    ); 
    

P_CLKGEN : process begin

iClk	<= '0';
wait for cClockPeriod/2;
iClk	<= '1';
wait for cClockPeriod/2;

end process P_CLKGEN;

P_STIMULI : process begin

 iRst      <= '1';
 iDataIn   <= x"00";
 iTxStart  <= '0';
 
wait for cClockPeriod*10; 

iRst        <= '0';

--wait for cClockPeriod*10; 

iDataIn		<= x"51";
iTxStart	<= '1';
wait for cClockPeriod;
iTxStart	<= '0';

wait for 1.2 us;

iDataIn		<= x"A3";
iTxStart	<= '1';
wait for cClockPeriod;
iTxStart	<= '0';

wait until (rising_edge(oTxDone));

wait for 1 us;

assert false
report "SIM DONE"
severity failure;


end process P_STIMULI;
end Behavioral;

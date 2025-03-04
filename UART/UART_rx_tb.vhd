library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity UART_rx_tb is

generic(

    gClkFreq  : integer := 250_000;
    gBaudRate : integer := 83_300

);

end UART_rx_tb;

architecture Behavioral of UART_rx_tb is

signal iClk             : std_logic                     := '0';
signal iRst             : std_logic                     := '0';
signal iRx              : std_logic                     := '0';
signal oDataOut         : std_logic_vector(7 downto 0)  := (others => '0');
signal oRxDone          : std_logic                     := '0';
signal oRxBusy          : std_logic                     := '0';


constant cClockPeriod   : time := 4 ns; -- 250 MHz ---> 4 ns
constant c_baud115200	: time := 12 ns;
constant c_hex43		: std_logic_vector (9 downto 0) := '1' & x"43" & '0'; -- start bit logic 0 (LSB) / stop bit logic 1 (MSB)
constant c_hexA5		: std_logic_vector (9 downto 0) := '1' & x"A5" & '0'; -- start bit logic 0 (LSB) / stop bit logic 1 (MSB)

begin

    DUT : entity work.UART_rx
    
    generic map(
    
    gClkFreq  => gClkFreq,
    gBaudRate => gBaudRate
        
    )
    
    port map(
    
     iClk        => iClk,
     iRst        => iRst,
     iRx         => iRx,
     oDataOut    => oDataOut,
     oRxDone     => oRxDone,
     oRxBusy     => oRxBusy
     
    ); 
    
P_CLKGEN : process begin

iClk	<= '0';
wait for cClockPeriod/2;
iClk	<= '1';
wait for cClockPeriod/2;

end process P_CLKGEN;

P_STIMULI : process begin

 iRst      <= '1';
 iRx       <= '1';
 
wait for cClockPeriod*4; 
    
     iRst  <= '0';
     
wait for 6 ns; 

for i in 0 to 9 loop

	iRx <= c_hex43(i);
	wait for c_baud115200;
	
end loop;

wait for 1 us;

for i in 0 to 9 loop

	iRx <= c_hexA5(i);
	wait for c_baud115200;
	
end loop; 

wait for 5 us;

assert false
report "SIM DONE"
severity failure;

end process P_STIMULI;


end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity UART_rxx is
generic (

    gClkFreq    : integer := 50_000;
    gBaudRate   : integer := 60
    
);

port (

    iClk		: in std_logic;
 --   iRst        : in std_logic;
    iRx     	: in std_logic;
    oDataOut	: out std_logic_vector (7 downto 0);
    oRxDone	    : out std_logic;
    oRxBusy     : out std_logic
    
);

end UART_rxx;

architecture Behavioral of UART_rxx is

constant cBitTimerLimit : integer := gClkFreq/gBaudRate;

type states is (sIDLE, sSTART, sDATA, sSTOP);
signal state         : states                            := sIDLE;

signal bittimer      : integer range 0 to cBitTimerLimit := 0;
signal bitcounter    : integer range 0 to 7              := 0;
signal shiftreg	     : std_logic_vector (7 downto 0)     := (others => '0');
signal oDataOut_temp : std_logic_vector (7 downto 0)     := (others => '0');
signal Done          :  std_logic                        := '0'; -- Done Buffer

begin

 process (iClk) begin
     if iClk'event and iClk = '1' then
--       if( iRst = '1' )then

--        oDataOut_temp      <= (others => '0');
--        oRxDone            <= '0';
--        Done               <= '0';
--        oRxBusy            <= '0';
--        bittimer           <= 0;
--        bitcounter         <= 0;
--        shiftreg           <= (others => '0');
--        state              <= sIDLE;
        
--        else 
        
	case state is
	
		when sIDLE =>
			
			oRxDone	 <= '0';
			Done     <= '0';
			bittimer <= 0;
			
			if (iRx = '0') then
			
				state	<= sSTART;
				oRxBusy <= '1';
				
			end if;
		
		    
		when sSTART =>
		
			if (bittimer = cBitTimerLimit-1) then
			
				state		<= sDATA;
				shiftreg    <= iRx & (shiftreg(7 downto 1));
				bittimer	<= 0;
				
			else
			
				bittimer	<= bittimer + 1;
				
			end if;
		
		when sDATA =>
		           		       
			if (bittimer = cBitTimerLimit-1) then
			
				if (bitcounter = 7) then
				
					state	    <= sSTOP;
					bitcounter	<= 0;
					
				else
				
					bitcounter	<= bitcounter + 1;
					shiftreg    <= iRx & (shiftreg(7 downto 1));		    

				end if;
				
				    bittimer	<= 0;
				    
			else
			    
				bittimer   <= bittimer + 1;
				
			end if;
		
		when sSTOP =>
		
			if (bittimer = cBitTimerLimit-1) then
			
				state			<= sIDLE;
				bittimer		<= 0;
				oRxDone      	<= '1';
				Done        	<= '1';
				oRxBusy         <= '0';
				
			else
			
				bittimer  <= bittimer + 1;
				
			end if;			
	
	end case;

   end if;
   
 -- end if;
  
  oDataOut_temp <= shiftreg;
  
end process;

  oDataOut <= oDataOut_temp when Done = '1'; -- Done buffer

end Behavioral;
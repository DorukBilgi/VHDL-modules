library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use IEEE.math_real.ALL;


entity UART_tx is
generic(

    gClkFreq  : integer := 50_000;
    gBaudRate : integer := 60;
    gStopBit  : integer := 2

 );
port (

    iClk     : in std_logic;    
   -- iRst     : in std_logic;
    iDataIn  : in std_logic_vector (7 downto 0);
    iTxStart : in std_logic;
    oTx      : out std_logic;
    oTxDone  : out std_logic;
    oTxBusy  : out std_logic
    
 );

end UART_tx;

architecture Behavioral of UART_tx is
    
    constant cBitTimerLimit : integer := integer(ceil(real(gClkFreq)/real(gBaudRate)));
    constant cStopBitLimit  : integer := integer(ceil(real(gClkFreq)/real(gBaudRate)));
    
    type states is (sIDLE, sSTART, sDATA, sSTOP);
    signal state            : states  := sIDLE;
    
    signal bittimer         : integer range 0 to cStopBitLimit := 0;
    signal bitcounter       : integer range 0 to 7             := 0;
    signal shiftreg         : std_logic_vector (7 downto 0)    := (others => '0'); 

begin
    
process (iClk) is
   begin  -- process   
     if iClk'event and iClk = '1' then 
--        if( iRst = '1' )then

--        oTx           <= '1';
--        oTxDone       <= '0';
--        oTxBusy       <= '0';
--        bittimer      <= 0;
--        bitcounter    <= 0;
--        shiftreg      <= (others => '0');
--        state         <= sIDLE;
       
--        else    
     
          case state is 
         
             when sIDLE  =>
                 
                 oTx        <= '1';
                 oTxDone    <= '0';
                 bitcounter <= 0;
                 
                 if(iTxStart = '1')then
                 
                 state      <= sSTART;
                 oTxBusy    <= '1';
                 oTx        <= '0';
                 shiftreg   <= iDataIn; 
                     
                 end if;
                 
             when sSTART =>
             
                 if(bittimer = cBitTimerLimit-1 )then
                 
                 state                <= sDATA;
                 oTx                  <= shiftreg(0);
                 shiftreg(7)          <= shiftreg(0);
                 shiftreg(6 downto 0) <= shiftreg(7 downto 1);
                 bittimer             <= 0;
                 
                 else
                 
                 bittimer   <= bittimer + 1;
                 
                 end if;  
  
             when sDATA  =>
             
                 if(bitcounter = 7) then
                 
                    if(bittimer = cBitTimerLimit-1)then
                    
                    bitcounter  <= 0;
                    state       <= sSTOP;
                    oTx         <= '1';
                    bittimer    <= 0;
                    
                    else
                    
                    bittimer    <= bittimer + 1;
                    
                    end if;
                 
                 else
                 
                   if(bittimer = cBitTimerLimit-1)then
                   
                   shiftreg(7)          <= shiftreg(0);
                   shiftreg(6 downto 0) <= shiftreg(7 downto 1); -- seri
                   oTx                  <= shiftreg(0);
                   bitcounter           <= bitcounter + 1;
                   bittimer             <= 0;
                   
                   else
                   
                   bittimer             <= bittimer + 1;
                    
                   end if;
                   
                 end if;
                 
             when sSTOP  =>
                 
                 if(bittimer = cStopBitLimit-1)then 
                 
                   state     <= sIDLE;
                   oTxDone   <= '1';
                   oTxBusy   <= '0';
                   bittimer  <= 0;
                   
                  else 
                   
                   bittimer <= bittimer + 1;
                   
                  end if;
                  
          end case;

        end if;
        
--     end if;

end process;

end Behavioral;

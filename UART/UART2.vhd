library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART2 is

generic(

    gClkFreq  : integer := 250_000;
    gBaudRate : integer := 83_300;
    gStopBit  : integer := 2

 );
 
port (

    iClk      : in std_logic;
    iRst      : in std_logic;
    
    -- UART 1 --
    
    iTx_Data1   : in std_logic_vector (7 downto 0); -- tx data
    iTx_Start1  : in std_logic; -- tx en
    
    oRx_Data1   : out std_logic_vector (7 downto 0); -- rx data
    
    --iRx1        : in std_logic; -- rx
    --oTx1        : out std_logic; -- tx
    
    oTxDone1    : out std_logic; -- tx tamamlandý
    oTxBusy1    : out std_logic; -- tx busy
    
    oRxDone1    : out std_logic; -- rx tamamlandý
    oRxBusy1    : out std_logic; -- rx busy
    
    -- UART 2 --
    
    iTx_Data2  : in std_logic_vector (7 downto 0); -- tx data
    iTx_Start2 : in std_logic; -- tx en
    
    oRx_Data2  : out std_logic_vector (7 downto 0); -- rx data
    
    --iRx2       : in std_logic; -- rx
    --oTx2       : out std_logic; -- tx
    
    oTxDone2   : out std_logic; -- tx tamamlandý
    oTxBusy2   : out std_logic; -- tx busy
    
    oRxDone2   : out std_logic; -- rx tamamlandý
    oRxBusy2   : out std_logic -- rx busy
    
    
 );

end UART2;

architecture Behavioral of UART2 is

component UART

    generic(

    gClkFreq  : integer := 250_000;
    gBaudRate : integer := 83_300;
    gStopBit  : integer := 2

    );
    
    port(
    
 
    iClk      : in std_logic;
    iRst      : in std_logic;
    
    iTx_Data  : in std_logic_vector (7 downto 0); -- tx data
    iTx_Start : in std_logic; -- tx en
    
    oRx_Data  : out std_logic_vector (7 downto 0); -- rx data
    
    iRx       : in std_logic; -- rx
    oTx       : out std_logic; -- tx
    
    oTxDone   : out std_logic; -- tx tamamlandý
    oTxBusy   : out std_logic; -- tx busy
    
    oRxDone   : out std_logic; -- rx tamamlandý
    oRxBusy   : out std_logic -- rx busy
    
     );       

 end component;

signal tel1 :  std_logic                        := '0'; -- Done Buffer
signal tel2 :  std_logic                        := '0'; -- Done Buffer


begin

UART_1 : entity work.UART

    generic map (
    
      gClkFreq   => gClkFreq,
      gBaudRate  => gBaudRate,
      gStopBit   => gStopBit
    
    )
    
  port map (
  
     iClk        => iClk,
     iRst        => iRst,
     iTx_Data    => iTx_Data1,
     iTx_Start   => iTx_Start1,
     oRx_Data    => oRx_Data1,
     iRx         => tel1,
     oTx         => tel2,
     oTxDone     => oTxDone1,
     oTxBusy     => oTxBusy1,
     oRxDone     => oRxDone1,
     oRxBusy     => oRxBusy1
      
  ); 

UART_2 : entity work.UART

    generic map (
    
      gClkFreq  => gClkFreq,
      gBaudRate => gBaudRate,
      gStopBit  => gStopBit
    
    )
    
    port map (
  
     iClk        => iClk,
     iRst        => iRst,
     iTx_Data    => iTx_Data2,
     iTx_Start   => iTx_Start2,
     oRx_Data    => oRx_Data2,
     iRx         => tel2,
     oTx         => tel1,
     oTxDone     => oTxDone2,
     oTxBusy     => oTxBusy2,
     oRxDone     => oRxDone2,
     oRxBusy     => oRxBusy2
      
    );

end Behavioral;

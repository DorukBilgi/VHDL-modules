library IEEE;
Library UNISIM ;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use UNISIM.vcomponents.all;
entity UART is

generic(

    gClkFreq  : integer := 50_000;
    gBaudRate : integer := 60;
    gStopBit  : integer := 2

 );
 
port (

    iClk      : in std_logic;
   -- iRst      : in std_logic;
    
    iTx_Data  : in std_logic_vector (7 downto 0); -- tx data
    iTx_Start : in std_logic;     -- tx en
    
    oRx_Data  : out std_logic_vector (7 downto 0); -- rx data
    
    iRx       : in std_logic; -- rx
    oTx       : out std_logic; -- tx
    
    oTxDone   : out std_logic; -- tx tamamlandı
    oTxBusy   : out std_logic; -- tx busy
    
    oRxDone   : out std_logic; -- rx tamamlandı
    oRxBusy   : out std_logic -- rx busy
    
 );

end UART;

architecture Behavioral of UART is

component UART_tx

    generic(

    gClkFreq  : integer := 50_000;
    gBaudRate : integer := 60;
    gStopBit  : integer := 2

    );
    
    port(
    
     iClk       : in std_logic;
    -- iRst       : in std_logic;
     iDataIn    : in std_logic_vector (7 downto 0);
     iTxStart   : in std_logic; 
     oTx        : out std_logic;
     oTxDone    : out std_logic;
     oTxBusy    : out std_logic
     
     );       

 end component;

component UART_rxx

    generic (

    gClkFreq  : integer := 50_000;
    gBaudRate : integer := 60
    
    );

    port(
    
     iClk       : in std_logic;    
  --   iRst       : in std_logic;
     iRx        : in std_logic;
     oRxDone    : out std_logic;
     oDataOut   : out std_logic_vector(7 downto 0);
     oRxBusy    : out std_logic
     
     );       

 END COMPONENT;


 
begin

transmitter: entity work.UART_tx

    generic map (
    
      gClkFreq  => gClkFreq,
      gBaudRate => gBaudRate,
      gStopBit  => gStopBit
    
    )
    
  port map (
  
      iClk       => iClk,
     -- iRst       => iRst,
      iDataIn    => iTx_Data,
      iTxStart   => iTx_Start, 
      oTx        => oTx,
      oTxDone    => oTxDone,
      oTxBusy    => oTxBusy
      
  ); 

reciever: entity work.UART_rxx

    generic map (
    
      gClkFreq  => gClkFreq,
      gBaudRate => gBaudRate
    
    )
    
    port map (
  
      iClk       => iClk,
    --  iRst       => iRst,
      iRx        => iRx,
      oDataOut   => oRx_Data,
      oRxDone    => oRxDone,
      oRxBusy    => oRxBusy
      
    );




end Behavioral;
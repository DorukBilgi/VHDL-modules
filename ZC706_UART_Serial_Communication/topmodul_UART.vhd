library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity topmodul_UART is
    generic(

    gClkFreq_UART1_tx  : integer := 100_000; -- clk100
    gClkFreq_UART2_rx  : integer := 60_000;  -- clk60 
    
    gBaudRate          : integer := 115;     -- 115200 bits per second 
    gStopBit           : integer := 2

    );
    Port (     
    
    clk_p    : in std_logic;
    clk_n    : in std_logic;

    DDR_addr          : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba            : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n         : inout STD_LOGIC;
    DDR_ck_n          : inout STD_LOGIC;
    DDR_ck_p          : inout STD_LOGIC;
    DDR_cke           : inout STD_LOGIC;
    DDR_cs_n          : inout STD_LOGIC;
    DDR_dm            : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq            : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n         : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p         : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt           : inout STD_LOGIC;
    DDR_ras_n         : inout STD_LOGIC;
    DDR_reset_n       : inout STD_LOGIC;
    DDR_we_n          : inout STD_LOGIC;
    FIXED_IO_ddr_vrn  : inout STD_LOGIC;
    FIXED_IO_ddr_vrp  : inout STD_LOGIC;
    FIXED_IO_mio      : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk   : inout STD_LOGIC;
    FIXED_IO_ps_porb  : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    
--    ledler_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
--    led0 : out std_logic;
--    led1 : out std_logic;
--    led2 : out std_logic;
--    led3 : out std_logic;

    iRx1_in    : in STD_LOGIC;
    oTx1_out   : out STD_LOGIC;
    otx1_e     : out std_logic;
    orx1_e     : out std_logic;
    
    iRx2_in    : in STD_LOGIC;
    oTx2_out   : out STD_LOGIC;
    otx2_e     : out std_logic;
    orx2_e     : out std_logic
    
    );
    
end topmodul_UART;

architecture Behavioral of topmodul_UART is

COMPONENT zc706_UART_wrapper
  PORT (
  
    DDR_addr          : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba            : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n         : inout STD_LOGIC;
    DDR_ck_n          : inout STD_LOGIC;
    DDR_ck_p          : inout STD_LOGIC;
    DDR_cke           : inout STD_LOGIC;
    DDR_cs_n          : inout STD_LOGIC;
    DDR_dm            : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq            : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n         : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p         : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt           : inout STD_LOGIC;
    DDR_ras_n         : inout STD_LOGIC;
    DDR_reset_n       : inout STD_LOGIC;
    DDR_we_n          : inout STD_LOGIC;
    FIXED_IO_ddr_vrn  : inout STD_LOGIC;
    FIXED_IO_ddr_vrp  : inout STD_LOGIC;
    FIXED_IO_mio      : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk   : inout STD_LOGIC;
    FIXED_IO_ps_porb  : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    ledler_tri_o      : out STD_LOGIC_VECTOR ( 3 downto 0 );
    clk50M            : out STD_LOGIC
    
  );
  
  END COMPONENT;
  
component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  clk_out2          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

COMPONENT UART
  generic(

    gClkFreq  : integer := 50_000;
    gBaudRate : integer := 60; 
    gStopBit  : integer := 2

  );
  
port (

    iClk      : in std_logic;
    
    iTx_Data  : in std_logic_vector (7 downto 0); -- tx data
    iTx_Start : in std_logic;     -- tx en
    
    oRx_Data  : out std_logic_vector (7 downto 0); -- rx data
    
    iRx       : in std_logic; -- rx
    oTx       : out std_logic; -- tx
    
    oTxDone   : out std_logic; -- tx tamamlandý
    oTxBusy   : out std_logic; -- tx busy
    
    oRxDone   : out std_logic; -- rx tamamlandý
    oRxBusy   : out std_logic -- rx busy
    
 );
 
  END COMPONENT;

  signal clk50M  :  STD_LOGIC; -- wrapper clock for GPIO LEDS 
   
  signal clk156  :  STD_LOGIC; -- system clock        -- clock wizard input
   
  signal clk100  :  STD_LOGIC; -- UART 1 for transmit -- clock wizard output
   
  signal clk60   :  STD_LOGIC; -- UART 2 for receive  -- clock wizard output
   
  signal ledler_tri_o_temp                      : std_logic_vector(3 downto 0) :=(others=>'0');
      
  signal Tx_Data_in                             : std_logic_vector(7 downto 0) := x"00";
  signal Tx_Start                               : STD_LOGIC:= '0'; 
  signal Tx_Start_d1, Tx_Start_d2, Tx_Start_d3  : STD_LOGIC:= '0'; 
   
  signal Tx_Done           : STD_LOGIC:= '0'; 
  signal Tx_Busy           : STD_LOGIC:= '0'; 
    
  signal Rx_Done           : STD_LOGIC:= '0'; 
  signal Rx_Busy           : STD_LOGIC:= '0'; 
   
  signal oRx_Data_out_temp : std_logic_vector(7 downto 0) :=(others=>'0');
  signal oRx_Data_out      : std_logic_vector(7 downto 0) :=(others=>'0');
   
  signal Rx_Data_in        : STD_LOGIC;
    
  signal counter           : std_logic_vector(31 downto 0) :=(others=>'0');
  signal Rx_Done_temp      : STD_LOGIC  := '0';
  signal oTx_out_temp      : STD_LOGIC  := '0'; 
   
  signal null1 : std_logic:='0';
  signal null2 : std_logic_vector(7 downto 0) :=(others=>'0');
  signal null3 : std_logic:='0';
  signal null4 : std_logic:='0';
  signal null5 : std_logic_vector(7 downto 0) :=(others=>'0');
  signal null6 : std_logic:='0';
  signal null7 : std_logic:='0';
  signal null8 : std_logic:='0';
  signal null9 : std_logic:='0';
   
  --debug signals---
  signal tx_start_debug       : std_logic                    :='0';
  signal oTx_out_debug        : std_logic                    :='0';
  signal Tx_Done_debug        : std_logic                    :='0';
  signal Tx_Busy_debug        : std_logic                    :='0';
  signal Tx_Data_in_debug     : std_logic_vector(7 downto 0) := x"00";
  
  signal Rx_Done_debug        : std_logic                    :='0';
  signal Rx_Busy_debug        : std_logic                    :='0';
  signal oRx_Data_out_debug   : std_logic_vector(7 downto 0) :=(others=>'0');
  signal iRx_in_debug         : std_logic                    :='0';
  
  signal error_counter        : natural range 0 to 100000    := 0;
 
  signal error_counter_debug  : natural range 0 to 500000000 := 0;
 
  type states is (sIDLE, sD, sO, sR, sU, sK, sENTER);
  signal state, next_state             : states;
  signal state_debug, next_state_debug : states;
  
  ------
  attribute MARK_DEBUG                       : string;
  attribute MARK_DEBUG of tx_start_debug     : signal is "TRUE";
  attribute MARK_DEBUG of oTx_out_debug      : signal is "TRUE";	
  attribute MARK_DEBUG of Tx_Done_debug      : signal is "TRUE";	
  attribute MARK_DEBUG of Tx_Busy_debug      : signal is "TRUE";	
  attribute MARK_DEBUG of Tx_Data_in_debug   : signal is "TRUE";	
  		
  attribute MARK_DEBUG of Rx_Done_debug      : signal is "TRUE";	
  attribute MARK_DEBUG of Rx_Busy_debug      : signal is "TRUE";			
  attribute MARK_DEBUG of oRx_Data_out_debug : signal is "TRUE";					
  attribute MARK_DEBUG of iRx_in_debug       : signal is "TRUE";  
    
  attribute MARK_DEBUG of error_counter_debug: signal is "TRUE"; 
   
  attribute MARK_DEBUG of state_debug        : signal is "TRUE";
  attribute MARK_DEBUG of next_state_debug   : signal is "TRUE";
    
begin

--debug signals--
tx_start_debug      <= Tx_Start;
oTx_out_debug       <= oTx_out_temp;
Tx_Done_debug       <= Tx_Done;
Tx_Busy_debug       <= Tx_Busy;
Tx_Data_in_debug    <= Tx_Data_in;

oRx_data_out_debug  <= oRx_Data_out;                    
iRx_in_debug        <= iRx2_in;          
Rx_Done_debug       <= Rx_Done;
Rx_Busy_debug       <= Rx_Busy;

error_counter_debug <= error_counter;

state_debug         <=   state;
next_state_debug    <=   next_state;

------------
oTx1_out            <= oTx_out_temp;


 otx1_e <= '1';
 orx1_e <= '1';


 otx2_e <= '0';
 orx2_e <= '0';
 
 
   IBUFDS_for_clk156 : IBUFDS
   generic map (
      DIFF_TERM    => FALSE, -- Differential Termination 
      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD   => "DEFAULT")
   port map (
      O  => clk156,  -- Buffer output
      I  => clk_p,  -- Diff_p buffer input (connect directly to top-level port)
      IB => clk_n -- Diff_n buffer input (connect directly to top-level port)
   );

clk_gen : clk_wiz_0
   port map ( 
   -- Clock out ports  
   clk_out1 => clk100,
   clk_out2 => clk60,
   -- Status and control signals                
   reset    => '0',
   locked   => OPEN,
   -- Clock in ports
   clk_in1  => clk156
 );

your_instance_name : zc706_UART_wrapper
  PORT MAP (
  
    DDR_addr           =>  DDR_addr,
    DDR_ba             =>  DDR_ba,
    DDR_cas_n          =>  DDR_cas_n,
    DDR_ck_n           =>  DDR_ck_n,
    DDR_ck_p           =>  DDR_ck_p,
    DDR_cke            =>  DDR_cke,
    DDR_cs_n           =>  DDR_cs_n,
    DDR_dm             =>  DDR_dm,
    DDR_dq             =>  DDR_dq,
    DDR_dqs_n          =>  DDR_dqs_n,
    DDR_dqs_p          =>  DDR_dqs_p,
    DDR_odt            =>  DDR_odt,
    DDR_ras_n          =>  DDR_ras_n,
    DDR_reset_n        =>  DDR_reset_n, 
    DDR_we_n           =>  DDR_we_n,
    FIXED_IO_ddr_vrn   =>  FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp   =>  FIXED_IO_ddr_vrp,
    FIXED_IO_mio       =>  FIXED_IO_mio,
    FIXED_IO_ps_clk    =>  FIXED_IO_ps_clk,
    FIXED_IO_ps_porb   =>  FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb  =>  FIXED_IO_ps_srstb,
    ledler_tri_o       =>  ledler_tri_o_temp,
    clk50M             =>  clk50M
    
  );
  
--led0 <= ledler_tri_o_temp(0);
--led1 <= ledler_tri_o_temp(1);
--led2 <= ledler_tri_o_temp(2);
--led3 <= ledler_tri_o_temp(3);

  UART_1 : UART  -- transmitter  
   generic map(
    
    gClkFreq   => gClkFreq_UART1_tx,
    gBaudRate  => gBaudRate,
    gStopBit   => gStopBit
        
   )
  PORT MAP (
 
    iCLK       =>  clk100 ,
   
    iTx_Data   =>  Tx_Data_in  ,
    iTx_Start  =>  Tx_Start_d3   ,
    oTx        =>  oTx_out_temp ,
    
    oRx_Data   =>  null2  ,
    iRx        =>  null1 ,  
    
    oTxDone    =>  Tx_Done  ,
    oTxBusy    =>  Tx_Busy ,
    oRxDone    =>  null3 , 
    oRxBusy    =>  null4
    
  );
  
UART_2 : UART  -- receiver 
   generic map(
    
    gClkFreq   => gClkFreq_UART2_rx,
    gBaudRate  => gBaudRate,
    gStopBit   => gStopBit
        
   )
  PORT MAP (
 
    iCLK       =>   clk60 ,
  
    iTx_Data   =>   null5 ,
    iTx_Start  =>   null6 ,
    oTx        =>   null7 ,
    
    oRx_Data   =>   oRx_Data_out  ,
    iRx        =>   iRx2_in ,    
     
    oTxDone    =>   null8 ,
    oTxBusy    =>   null9 ,
    oRxDone    =>   Rx_Done ,
    oRxBusy    =>   Rx_Busy
    
  );

transmit_Proc : process (clk100) is
 begin  
 
   if clk100'event and clk100 = '1' then
     
     if(unsigned(counter) = to_unsigned(10000000,32)) then  -- 100000000 (1s) -- 100000000 (100ms)
     
     counter     <= (others=>'0'); 
     Tx_Start    <= '1';
     -- Tx_Data_in <= std_logic_vector(unsigned(Tx_Data_in) + 1) ; -- ASCII Test
     
     else 
     
     counter     <= std_logic_vector(unsigned(counter) + 1);
     Tx_Start    <= '0';
     
     end if;
     
     Tx_Start_d1 <= Tx_Start;
     Tx_Start_d2 <= Tx_Start_d1;
     Tx_Start_d3 <= Tx_Start_d2;
     
  end if;
  
 end process transmit_Proc;


state_machine0 : process (clk100) is
 begin  
 
   if clk100'event and clk100 = '1' then
   
     state <= next_state;
   
   end if;
   
 end process state_machine0;
 
state_machine1: process (clk100) is
begin

if (clk100'event and clk100 = '1') then

     case (state) is

         when sIDLE =>
               Tx_Data_in <= x"00";
               if Tx_Start = '1' then
                next_state <= sD;
               end if;
         when sD =>
               Tx_Data_in <= x"44";
               if Tx_Start = '1' then
                next_state <= sO;
               end if;
         when sO =>
               Tx_Data_in <= x"4F";
               if Tx_Start = '1' then
                next_state <= sR;
               end if;
         when sR  =>
               Tx_Data_in <= x"52";
               if Tx_Start = '1' then
                next_state <= sU;
               end if;
         when sU  =>
               Tx_Data_in <= x"55";
               if Tx_Start = '1' then
                next_state <= sK;
               end if;
         when sK =>
               Tx_Data_in <= x"4B";
               if Tx_Start = '1' then
                next_state <= sENTER;
               end if;
         when sENTER  =>
               Tx_Data_in <= x"0D";
               if Tx_Start = '1' then
                next_state <= sIDLE;
               end if;             
     end case;
          
      end if;
 end process;


errorcounter_Proc : process (clk60) is 
begin

 if clk60'event and clk60 = '1' then

  Rx_Done_temp <= Rx_Done;
  
     if(Rx_Done_temp = '1') then
     
       if(Tx_Data_in /= oRx_Data_out) then
      
       error_counter <= error_counter + 1;
      
       end if;
   
     end if;
    
 end if;
     
end process errorcounter_Proc;

end Behavioral;



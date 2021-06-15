library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DDS_PRI_RAM is

    Port (
      
     iClk          : in STD_LOGIC;
     iRst          : in STD_LOGIC;
     iPW           : in STD_LOGIC_VECTOR(7 DOWNTO 0);
     iPRI          : in STD_LOGIC_VECTOR(7 DOWNTO 0);
     oDataOut      : out STD_LOGIC_VECTOR(7 DOWNTO 0); 
     oEN           : out STD_LOGIC
    
     );
     
end DDS_PRI_RAM; 

architecture Behavioral of DDS_PRI_RAM is

COMPONENT blk_mem_gen_0
  PORT (
  
    clka  : IN STD_LOGIC;
    ena   : IN STD_LOGIC;
    wea   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    dina  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    
  );
END COMPONENT;


COMPONENT COUNTER

    PORT(
    
     iClk       : in std_logic;
     iCountEn   : in std_logic;
     iRst       : in std_logic;
     iCountLim  : in  std_logic_vector(15 downto 0);
     oCountDone : out std_logic;
     oCount     : out std_logic_vector(15 downto 0)
     
     );       

 END COMPONENT;
 
COMPONENT dds_compiler_0
  PORT (
  
    aclk                : IN STD_LOGIC;
    aresetn             : IN STD_LOGIC;
    s_axis_phase_tvalid : IN STD_LOGIC;
    s_axis_phase_tdata  : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_data_tvalid  : OUT STD_LOGIC;
    m_axis_data_tdata   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    
  );
END COMPONENT;

--RAM signals
signal RAM_En             : std_logic                     := '0';
signal RAM_Wen            : std_logic_vector(0 downto 0)  := (others => '0');
signal RAM_Ren            : std_logic_vector(0 downto 0)  := (others => '0');
signal RAM_WriteData_mem  : std_logic_vector(15 downto 0) := (others => '0');
signal RAM_DataOut_mem    : std_logic_vector(15 downto 0) := (others => '0');
signal RAM_addr_mem       : STD_LOGIC_VECTOR(1 DOWNTO 0)  := (others => '0');
signal RAM_WriteData      : std_logic_vector(15 downto 0) := (others => '0');
signal RAM_DataOut        : std_logic_vector(15 downto 0) := (others => '0');
signal RAM_addr           : STD_LOGIC_VECTOR(1 DOWNTO 0)  := (others => '0');
signal RAM_sayac          : std_logic_vector(15 downto 0) := (others => '0');
signal readcount          : STD_LOGIC_VECTOR(1 DOWNTO 0)  := (others => '0');

--Counter Signals
 signal oCountDone        : std_logic                     := '0';
 signal oCount            : std_logic_vector(7 downto 0)  := (others => '0');
 signal iCountEn          : std_logic                     := '0';
 signal iCountLim         : std_logic_vector(7 downto 0)  := (others => '0');
 signal CounterRst        : std_logic                     := '0';
 
 --DDS Signals
 signal oDataOut_mem      : STD_LOGIC_VECTOR(7 DOWNTO 0)  := (others => '0');
 signal oDataValid_mem    : STD_LOGIC                     := '0';
 signal tvalid            : STD_LOGIC                     := '0'; 
 signal phaseVal          : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
 signal DDSRst            : STD_LOGIC                     := '1';-- Active Low due to 2 Clock Cycle
 signal oDataOutValid     : STD_LOGIC                     := '0';
 
-- signal fazdeger       : unsigned(31 DOWNTO 0)         :=  (others => '0');--(2**16/250)*unsigned(iFreq(7 downto 0));
  
begin

  ddsblock : dds_compiler_0
  PORT MAP (
  
    aclk                => iClk,
    aresetn             => DDSRst,
    s_axis_phase_tvalid => tvalid,
    s_axis_phase_tdata  => phaseVal,
    m_axis_data_tvalid  => oDataValid_mem,
    m_axis_data_tdata   => oDataOut_mem
    
  );
 
     iCountLim <= std_logic_vector(unsigned(iPRI)-1);
     
counterblock: entity work.COUNTER
    generic map (
    cCountBitW => 8
    )
  port map (
  
      iClk       => iClk,
      iRst       => CounterRst,
      iCountEn   => iCountEn,
      iCountLim  => iCountLim, 
      oCountDone => oCountDone,
      oCount     => oCount
  
  );
      
  blockram : blk_mem_gen_0
  PORT MAP (
  
    clka  => iClk,
    ena   => RAM_En,
    wea   => RAM_Wen,
    addra => RAM_addr_mem,
    dina  => RAM_WriteData_mem,
    douta => RAM_DataOut_mem
    
  );
     oDataOutValid      <=  oDataValid_mem;  
      
process (iClk) is
   begin  -- process
     if iClk'event and iClk = '1' then  -- rising clock edge
     
      RAM_sayac       <= std_logic_vector(unsigned(RAM_sayac) + 1);        
      RAM_WriteData   <= RAM_WriteData_mem;
      RAM_addr        <= RAM_addr_mem;
      RAM_WriteData   <= RAM_WriteData_mem;
      RAM_DataOut     <= RAM_DataOut_mem;
      
        if( iRst = '1' )then
        
             iCountEn      <= '0';
             phaseVal      <= (others => '0');
             tvalid        <= '0';
             CounterRst    <= '1';
             DDSRst        <= '0';
             oDataOut      <= (others => '0');
             RAM_Wen       <= (others => '0');
             RAM_WriteData <= (others => '0');
             RAM_DataOut   <= (others => '0');
             RAM_addr      <= (others => '0');
             RAM_sayac     <= (others => '0');
             oEN           <=  '0';
             
         elsif(RAM_sayac = "0000000000000000")then
             
             RAM_En            <= '1';
             RAM_Wen           <= (others => '1');
             RAM_WriteData_mem <= "0000101000111110";--std_logic_vector(to_unsigned(2622,16)); -- 10 mHZ
             RAM_addr_mem      <= "00";
             
         elsif(RAM_sayac = "0000000000000001")then
             
             RAM_En            <= '1';
             RAM_Wen           <= (others => '1');
             RAM_WriteData_mem <= "0001010001111011";--std_logic_vector(to_unsigned(5243,16)); -- 20 mHZ
             RAM_addr_mem      <= "01";
         
         elsif(RAM_sayac = "0000000000000010")then
             
             RAM_En            <= '1';
             RAM_Wen           <= (others => '1');
             RAM_WriteData_mem <= "0010100011110101";--std_logic_vector(to_unsigned(10485,16)); -- 40 mHZ
             RAM_addr_mem      <= "10";
         
         elsif(RAM_sayac = "0000000000000011")then
             
             RAM_En            <= '1';
             RAM_Wen           <= (others => '1');
             RAM_WriteData_mem <= "0101000111101100";--std_logic_vector(to_unsigned(20972,16)); -- 80 mHZ
             RAM_addr_mem      <= "11";
             
        elsif(RAM_sayac = "0000000000000100")then
             
             RAM_Wen           <= (others => '0');
             RAM_WriteData_mem <= (others => '0');
             RAM_Ren           <= (others => '1');
             RAM_addr_mem      <= readcount;
             readcount         <= std_logic_vector(unsigned(readcount) + 1);
             
        elsif(RAM_sayac >= "0000000000000111")then     
        
            if(oCount = std_logic_vector(unsigned(iPRI)-3)) then
        
                RAM_addr_mem  <= readcount;
                readcount     <= std_logic_vector(unsigned(readcount) + 1);
             
            elsif( unsigned(oCount) < unsigned(iPW) )then
                
                oEN         <=  '1';
                iCountEn    <=  '1';
                DDSRst      <=  '1';
                CounterRst  <=  '0';
                tvalid      <=  '1'; 
                phaseVal    <=  std_logic_vector(to_unsigned(2**15,16)) & RAM_DataOut_mem;
                oDataOut    <=  oDataOut_mem;
                
            else
                
                oEN          <=  '0';
                DDSRst       <=  '1';
                CounterRst   <=  '0';
                tvalid       <=  '0';        
                oDataOut     <=  (others => '0');

            end if; 

        end if;
        
  end if;   
  
end process; -- duzenlendi
  
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DDS_PRI is

    Port (
      
     iClk          : in STD_LOGIC;
     iRst          : in STD_LOGIC;
     iPW           : in STD_LOGIC_VECTOR(7 DOWNTO 0);
     iPRI          : in STD_LOGIC_VECTOR(7 DOWNTO 0);
     iFreq         : in  unsigned(7 DOWNTO 0);
     oDataOut      : out STD_LOGIC_VECTOR(7 DOWNTO 0);
     oDataOutValid : out STD_LOGIC
    
     );
     
end DDS_PRI; 

architecture Behavioral of DDS_PRI is

COMPONENT COUNTER
    PORT(
    
     iClk       : in std_logic;
     iCountEn   : in std_logic;
     iRst       : in std_logic;
     iCountLim  : in  std_logic_vector(15 downto 0);
     oCountDone : out std_logic;
     oCount     : out std_logic_vector(15 downto 0));       
 
 END COMPONENT;
 
COMPONENT dds_compiler_0
  PORT (
  
    aclk : IN STD_LOGIC;
    aresetn : IN STD_LOGIC;
    s_axis_phase_tvalid : IN STD_LOGIC;
    s_axis_phase_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    
  );
END COMPONENT;

--Counter Signals
 signal oCountDone     : std_logic                     := '0';
 signal oCount         : std_logic_vector(7 downto 0) := (others => '0');
 signal iCountEn       : std_logic                     := '0';
 signal iCountLim      : std_logic_vector(7 downto 0) := (others => '0');
 signal CounterRst     : std_logic                     := '0';
 
 --DDS Signals
 signal oDataOut_mem   : STD_LOGIC_VECTOR(7 DOWNTO 0)  := (others => '0');
 signal oDataValid_mem : STD_LOGIC                     := '0';
 signal tvalid         : STD_LOGIC                     := '0'; 
 signal phaseVal       : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
 signal DDSRst         : std_logic                     := '1';-- Active Low due to 2 Clock Cycle
 
 signal fazdeger       : unsigned(31 DOWNTO 0)         :=  (others => '0');--(2**16/250)*unsigned(iFreq(7 downto 0));
 
 signal oneclocksignal : std_logic                     := '0';
 signal sayac_temp     : std_logic_vector(15 downto 0) := (others => '0');
 signal sayac_temp_2   : std_logic_vector(15 downto 0) := (others => '0');
 
begin

your_instance_name : dds_compiler_0
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
      
     oDataOutValid         <=  oDataValid_mem;  
    
process (iClk) is
   begin  -- process
     if iClk'event and iClk = '1' then  -- rising clock edge
        if( iRst = '1' )then
        
             iCountEn     <= '0';
             phaseVal     <= (others => '0');
             tvalid       <= '0';
             CounterRst   <= '1';
             DDSRst       <= '0';
             oDataOut     <= (others => '0');
             
        elsif( unsigned(oCount) < unsigned(iPW) )then
        
            DDSRst                <=  '1';
            CounterRst            <=  '0';
            tvalid                <=  '1';
            iCountEn              <=  '1';
            fazdeger              <=  to_unsigned(2**15,16) & to_unsigned(13107,16);
            -- M = (2^32/250)*(iFreq); bu deðerler iFreq = 167 için ...
            phaseVal              <=  std_logic_vector(to_unsigned(2**15,16) & to_unsigned(13107,16));
            oDataOut              <=  oDataOut_mem;
            
        else
        
            DDSRst                <=  '1';
            CounterRst            <=  '0';
            tvalid                <=  '0';        
            oDataOut              <=  (others => '0');

           end if; 

     end if;
     
end process; -- duzenlendi
  

end Behavioral;

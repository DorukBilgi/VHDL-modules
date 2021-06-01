library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 

entity BRAM_FIFO_Ring_Buffer is
  generic (
    cRamWidth  : integer := 32;
    cDataWidth : integer := 16
    );
  port (
    iClkA   : in  std_logic;
    iClkB   : in  std_logic; -- port A ve port B icin iki ayri clock
    iRst    : in  std_logic;
    iWen    : in  std_logic;                     
    iWData  : in  std_logic_vector(cDataWidth-1 downto 0); 
    iREn    : in std_logic;
    oRData  : out std_logic_vector(cDataWidth-1 downto 0); 
    oEmpty  : out std_logic; 
    oFull   : out std_logic
    );                    
    
end entity BRAM_FIFO_Ring_Buffer;

architecture Behavioral of BRAM_FIFO_Ring_Buffer is

COMPONENT blk_mem_gen_0
  PORT (
    clka  : IN STD_LOGIC;
    ena   : IN STD_LOGIC;
    wea   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    dina  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb  : IN STD_LOGIC;
    enb   : IN STD_LOGIC;
    web   : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    dinb  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

   
    signal ramEn_A       : std_logic                     :='1';
    signal ramEn_B       : std_logic                     :='1';
    signal ramWEn_A      : std_logic_vector(0 downto 0)  := (others => '0');
    signal ramWEn_B      : std_logic_vector(0 downto 0)  := (others => '0');
    signal ramREn_A      : std_logic_vector(0 downto 0)  := (others => '0');
    signal ramREn_B      : std_logic_vector(0 downto 0)  := (others => '0');
    
    signal ramAddr_A    : std_logic_vector(4 downto 0)  := (others => '0');
    signal ramAddr_B    : std_logic_vector(4 downto 0)  := (others => '0');
    
    signal ramDataIn_A  : std_logic_vector(15 downto 0) := (others => '0');
    signal ramDataIn_B  : std_logic_vector(15 downto 0) := (others => '0');
    
    signal ramDataOut_A : std_logic_vector(15 downto 0) := (others => '0');
    signal ramDataOut_B : std_logic_vector(15 downto 0) := (others => '0');
    
    signal writeCount : std_logic_vector(5 downto 0)  := (others => '0');
    signal readCount  : std_logic_vector(5 downto 0)  := (others => '0');
    signal ramFull    : std_logic                     := '0';
    signal ramEmpty   : std_logic                     := '0';
   
    signal FifoWriteCount : std_logic_vector(5 downto 0)  := (others => '0');
    signal FifoReadCount  : std_logic_vector(5 downto 0)  := "100000";
    
begin

your_instance_name : blk_mem_gen_0
  PORT MAP (
    clka  => iClkA,
    ena   => ramEn_A,
    wea   => ramWEn_A,
    addra => ramAddr_A,     ----******
    dina  => ramDataIn_A,
    douta => ramDataOut_A, -- okuma datalar?
    clkb  => iClkB,
    enb   => ramEn_B,
    web   => ramWEn_B,
    addrb => ramAddr_B,      ---*****
    dinb  => ramDataIn_B,
    doutb => ramDataOut_B -- yazma datalar?
  );
  

  
ramProWrite : process (iClkA) is
begin
   if (iClkA'event and iClkA = '1') then
     oFull   <= ramFull; 
    if(iRst = '1')then
     FifowriteCount   <=  (others => '0');
     writeCount       <=  (others => '0');
     ramFull          <= '0';
     oFull            <= ramFull;
     ramWEn_A(0)      <= '0';
     ramREn_A(0)      <= '0';
     ramDataIn_A      <= (others => '0');                                                             
    elsif(iWen = '1' and iRen = '0')then 
     ramWEn_A(0)     <= '1';
     ramREn_A(0)     <= '0';
     ramDataIn_A     <= iWData;
     ramAddr_A       <= writeCount(4 downto 0); 
     FifowriteCount  <= std_logic_vector(unsigned(FifowriteCount)+1);   
          if(writeCount = "100000") then
            writeCount <=  (others => '0');
          else  
            writeCount <= std_logic_vector(unsigned(writeCount)+1);
          end if;   
    else
        ramWEn_A(0) <= '0';
        ramDataIn_A <= (others => '0');                                                        
    end if;
        if(FifowriteCount > "011111" )then
          ramFull  <= '1';
          oFull    <= '1';
        else 
          ramFull <= '0';
          oFull   <= '0'; 
        end if;            
    if(ramempty = '1') then
      FifowriteCount  <=  (others => '0');
    end if;                                
   end if;                                    
end process ramProWrite;


ramProRead : process (iClkB) is
begin
     if (iClkB'event and iClkB = '1') then

       if(iRst = '1')then
        FiforeadCount    <=  (others => '0');
        readCount        <=  (others => '0');  
        ramEmpty         <= '0';
        oEmpty           <= ramEmpty;
        ramWEn_B(0)      <= '0';
        ramREn_B(0)      <= '0';
        ramDataIn_B      <= (others => '0');                                                            
       elsif(iREn = '1' and iWen = '0' )then
        ramWEn_B(0)   <= '0';
        ramREn_B(0)   <= '1';
        ramAddr_B     <= readCount(4 downto 0);
        oRData        <= ramDataOut_B;

        FiforeadCount <= std_logic_vector(unsigned(FiforeadCount)-1);
        if(FiforeadCount = FifowriteCount or readCount = "011111" )then
              ramEmpty  <= '1';
              oEmpty    <= ramEmpty;     
           else
              ramEmpty <= '0';
              oEmpty   <= ramEmpty; 
           end if;     
        if(readCount = "011111") then
           readCount <= "000000";                     
        else
           readCount <= std_logic_vector(unsigned(readCount)+1);
        end if;                                                              
       end if; 
       if(ramempty = '1') then
       FifoReadCount <= "100000";
       end if;                                                              
     end if;
     
end process ramProRead;
     
end Behavioral;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------------------

entity BRAM_wrapper_tb is

end entity BRAM_wrapper_tb;

-------------------------------------------------------------------------------

architecture rtl of BRAM_wrapper_tb is

  -- component ports
  signal BRAM_PORTA_0_addr : STD_LOGIC_VECTOR (31 downto 0);
  signal BRAM_PORTA_0_din  : STD_LOGIC_VECTOR (31 downto 0);
  signal BRAM_PORTA_0_dout : STD_LOGIC_VECTOR (31 downto 0);
  signal BRAM_PORTA_0_en   : STD_LOGIC;
  signal BRAM_PORTA_0_rst  : STD_LOGIC;
  signal BRAM_PORTA_0_we   : STD_LOGIC_VECTOR (3 downto 0);

  -- clock
  signal clk : std_logic := '1';

  signal addr_temp : std_logic_vector(31 downto 0) := (others => '0');
  signal din_temp : std_logic_vector(31 downto 0) := (others => '0');
  signal sayac_temp : std_logic_vector(7 downto 0) := (others => '0');
  
begin  -- architecture rtl

  -- component instantiation
  DUT: entity work.BRAM_wrapper
    port map (
      BRAM_PORTA_0_addr => BRAM_PORTA_0_addr,
      BRAM_PORTA_0_clk  => clk,
      BRAM_PORTA_0_din  => BRAM_PORTA_0_din,
      BRAM_PORTA_0_dout => BRAM_PORTA_0_dout,
      BRAM_PORTA_0_en   => BRAM_PORTA_0_en,
      BRAM_PORTA_0_rst  => BRAM_PORTA_0_rst,
      BRAM_PORTA_0_we   => BRAM_PORTA_0_we);


  
  -- clock generation
  clk <= not clk after 10 ns;

  -- waveform generation
  WaveGen_Proc: process
  begin
                
    wait until clk = '1';
  end process WaveGen_Proc;


  writePro: process (clk) is
  begin  -- process writePro
    if clk'event and clk = '1' then  -- rising clock edge
            
       BRAM_PORTA_0_en     <= '1';  --Enable RAM always. 
       BRAM_PORTA_0_rst    <= '0'; -- reset yok
       BRAM_PORTA_0_addr   <= addr_temp;  
       BRAM_PORTA_0_din    <= din_temp;

       if(sayac_temp <= "00001110")then -- yazma islemi devam
           
        BRAM_PORTA_0_we     <= "1111";
        sayac_temp          <= std_logic_vector(unsigned(sayac_temp) + 1);
        addr_temp           <= std_logic_vector(unsigned(addr_temp) + 1);
        din_temp            <= std_logic_vector(unsigned(din_temp) + 1);
             
       end if;
           
       if(sayac_temp = "00001111")then
           
        BRAM_PORTA_0_we     <= "0000"; -- write off mode 
        din_temp            <= "00000000000000000000000000000000"; -- gelen data default
        addr_temp           <= "00000000000000000000000000000100"; --reset the address value for reading from memory location "4"
        -- neden bilmiyorum 120 ns sonra verdiğim dataları çıkışta gözlemleyebiliyorum. başlangıçta 120 ns boyunca dataout 0
        sayac_temp          <= std_logic_vector(unsigned(sayac_temp) + 1);
           
       end if;
           
       if(sayac_temp > "00001111")then -- yazma islemi bitti. okuma yapılacak.
            
        BRAM_PORTA_0_we     <= "0000"; -- write off mode 
        din_temp            <= "00000000000000000000000000000000"; -- gelen data default
        sayac_temp          <= std_logic_vector(unsigned(sayac_temp) + 1);
        addr_temp           <= std_logic_vector(unsigned(addr_temp) + 1);
            
       end if;

    end if;
  end process writePro;



end architecture rtl;

-------------------------------------------------------------------------------

configuration BRAM_wrapper_tb_rtl_cfg of BRAM_wrapper_tb is
  for rtl
  end for;
end BRAM_wrapper_tb_rtl_cfg;

-------------------------------------------------------------------------------

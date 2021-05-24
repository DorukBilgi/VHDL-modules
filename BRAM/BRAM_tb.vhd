-- Program tarafından oluşturulmuş olan BRAM_wrapper dosyası için testbench dosyası.
-- Bu dosya ile block ram karakteristiği gözlemlenmek istendi.

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity BRAM_wrapper_tb is
end;

architecture bench of BRAM_wrapper_tb is

  component BRAM_wrapper
    port (
      BRAM_PORTA_0_addr : in STD_LOGIC_VECTOR ( 31 downto 0 );
      BRAM_PORTA_0_clk  : in STD_LOGIC;
      BRAM_PORTA_0_din  : in STD_LOGIC_VECTOR ( 31 downto 0 );
      BRAM_PORTA_0_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
      BRAM_PORTA_0_en   : in STD_LOGIC;
      BRAM_PORTA_0_rst  : in STD_LOGIC;
      BRAM_PORTA_0_we   : in STD_LOGIC_VECTOR ( 3 downto 0 )
    );
  end component;

  signal BRAM_PORTA_0_addr  : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal BRAM_PORTA_0_clk   : STD_LOGIC;
  signal BRAM_PORTA_0_din   : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal BRAM_PORTA_0_dout  : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal BRAM_PORTA_0_en    : STD_LOGIC;
  signal BRAM_PORTA_0_rst   : STD_LOGIC;
  signal BRAM_PORTA_0_we    : STD_LOGIC_VECTOR ( 3 downto 0 ) ;

begin

  uut: BRAM_wrapper port map ( 
      BRAM_PORTA_0_addr => BRAM_PORTA_0_addr,
      BRAM_PORTA_0_clk  => BRAM_PORTA_0_clk,
      BRAM_PORTA_0_din  => BRAM_PORTA_0_din,
      BRAM_PORTA_0_dout => BRAM_PORTA_0_dout,
      BRAM_PORTA_0_en   => BRAM_PORTA_0_en,
      BRAM_PORTA_0_rst  => BRAM_PORTA_0_rst,
      BRAM_PORTA_0_we   => BRAM_PORTA_0_we );

    clock_process: process
    begin
         BRAM_PORTA_0_clk <= '1';
         wait for 1 ns;
         BRAM_PORTA_0_clk <= '0';
         wait for 1 ns;
    end process;
    
    stimulus_process: process
    begin 
         BRAM_PORTA_0_rst    <= '0';
         BRAM_PORTA_0_addr   <= "00000000000000000000000000000000";
         BRAM_PORTA_0_din    <= "00000000000000000000000000000000";
         wait for 12 ns;
            
        for i in 0 to 255 loop
            BRAM_PORTA_0_en <= '1';  --Enable RAM always.
            BRAM_PORTA_0_we <= "1111";
            wait for 2 ns;
            BRAM_PORTA_0_addr <= std_logic_vector(unsigned(BRAM_PORTA_0_addr) + 1);
            BRAM_PORTA_0_din  <= std_logic_vector(unsigned(BRAM_PORTA_0_din) + 1);
        end loop;  
        
        BRAM_PORTA_0_addr  <= "00000000000000000000000000000000";  --reset the address value for reading from memory location "0"
        BRAM_PORTA_0_din   <= "00000000000000000000000000000000";
  
        for i in 0 to 255 loop
            BRAM_PORTA_0_en <= '1';  --Enable RAM always.
            BRAM_PORTA_0_we <= "0000";
            wait for 2 ns;
            BRAM_PORTA_0_addr <= std_logic_vector(unsigned(BRAM_PORTA_0_addr) + 1);
        end loop;
       
          wait;
    end process;
    
end;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity top is
    Port (     
    
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    GPIO_0_tri_o_top : out STD_LOGIC_VECTOR ( 3 downto 0 );
    oLED : out STD_LOGIC_VECTOR ( 3 downto 0 )
    );
    
end top;

architecture Behavioral of top is

COMPONENT design_1_wrapper
  PORT (
  
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    GPIO_0_tri_o : out STD_LOGIC_VECTOR ( 3 downto 0 );
    clk50M : out STD_LOGIC
    
  );
  END COMPONENT;

COMPONENT altLED
  PORT (
  
    iClk   : in  std_logic;
    oLED  : out  STD_LOGIC_VECTOR ( 3 downto 0 )
    
  );
  END COMPONENT;

   signal clk50M :  STD_LOGIC;

   
begin
your_instance_name : design_1_wrapper
  PORT MAP (
  
    DDR_addr   => DDR_addr,
    DDR_ba   => DDR_ba,
    DDR_cas_n   => DDR_cas_n,
    DDR_ck_n   => DDR_ck_n,
    DDR_ck_p   => DDR_ck_p,
    DDR_cke   => DDR_cke,
    DDR_cs_n   =>  DDR_cs_n,
    DDR_dm   => DDR_dm,
    DDR_dq   =>  DDR_dq,
    DDR_dqs_n   =>  DDR_dqs_n,
    DDR_dqs_p   =>  DDR_dqs_p,
    DDR_odt   =>  DDR_odt,
    DDR_ras_n   =>  DDR_ras_n,
    DDR_reset_n   =>  DDR_reset_n, 
    DDR_we_n   =>  DDR_we_n,
    FIXED_IO_ddr_vrn  =>  FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp   =>  FIXED_IO_ddr_vrp,
    FIXED_IO_mio   =>  FIXED_IO_mio,
    FIXED_IO_ps_clk   =>  FIXED_IO_ps_clk,
    FIXED_IO_ps_porb   =>  FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb   =>  FIXED_IO_ps_srstb,
    GPIO_0_tri_o   =>  GPIO_0_tri_o_top,
    clk50M   => clk50M
    
  );
  

  your_instance_name_1 : altLED
  PORT MAP (
 
    iCLK    =>   clk50M,
    oLED    =>  oLED
    
  );
  

     
end Behavioral;





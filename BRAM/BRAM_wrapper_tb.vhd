-------------------------------------------------------------------------------
-- Title      : Testbench for design "BRAM_wrapper"
-- Project    :
-------------------------------------------------------------------------------
-- File       : BRAM_wrapper_tb.vhd
-- Author     : osmant  <otutaysalgir@meteksan.com>
-- Company    :
-- Created    : 2021-05-24
-- Last update: 2021-05-24
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2021
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-05-24  1.0      otutaysalgir	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

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
    -- insert signal assignments here

    wait until clk = '1';
  end process WaveGen_Proc;



  writePro: process (clk) is
  begin  -- process writePro
    if clk'event and clk = '1' then  -- rising clock edge
      -- kodlarını buraya yaz
    end if;
  end process writePro;


end architecture rtl;

-------------------------------------------------------------------------------

configuration BRAM_wrapper_tb_rtl_cfg of BRAM_wrapper_tb is
  for rtl
  end for;
end BRAM_wrapper_tb_rtl_cfg;

-------------------------------------------------------------------------------

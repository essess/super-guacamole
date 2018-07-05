---
 -- Copyright (c) 2018 Sean Stasiak. All rights reserved.
 -- Developed by: Sean Stasiak <sstasiak@protonmail.com>
 -- Refer to license terms in license.txt; In the absence of such a file,
 -- contact me at the above email address and I can provide you with one.
---

library ieee;
use ieee.std_logic_1164.all, ieee.numeric_std.all;

entity top is
  port( btn1_in, btn2_in            : in  std_logic;
        clk50m_in                   : in  std_logic;
        ld1_out, smpclk_out, db_out : out std_logic );
end entity;

architecture arch of top is

  component debounce is
    generic( samples : integer range 2 to integer'high := 4 );
    port( d_in                 : in  std_logic;
          rst_in, sampleclk_in : in  std_logic;
          q_out                : out std_logic );
  end component;

  signal sampleclk : unsigned(14 downto 0);
  signal q         : std_logic;

begin

  db: debounce
    generic map( samples=>8 )
    port map( d_in=>btn1_in,
              rst_in=>btn2_in, sampleclk_in=>sampleclk(14),
              q_out=>q );

  db_out  <= q;
  ld1_out <= q;
  
  smpclk_out <= sampleclk(14);

  clk: process(clk50m_in)
  begin
    if rising_edge(clk50m_in) then
      sampleclk <= sampleclk +1;
    end if;
  end process;

end architecture;
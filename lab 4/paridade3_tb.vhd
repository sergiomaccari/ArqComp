-- ============================================================
-- Lab VHDL 1 - Drill 2: testbench do detector de paridade de 3 bits
-- (construido ANTES da arquitetura, como pede o roteiro)
-- Sergio Roncato Maccari - UTFPR - Arquitetura de Computadores
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

entity paridade3_tb is
end;

architecture a_paridade3_tb of paridade3_tb is
    component paridade3
        port( x0     : in  std_logic;
              x1     : in  std_logic;
              x2     : in  std_logic;
              impar  : out std_logic
            );
    end component;
    signal x0,x1,x2 : std_logic;
    signal impar    : std_logic;
begin
    uut: paridade3 port map( x0    => x0,
                             x1    => x1,
                             x2    => x2,
                             impar => impar);

    process
    begin
        -- as 8 combinacoes possiveis, na ordem x2x1x0 = 000 .. 111
        x2 <= '0'; x1 <= '0'; x0 <= '0';
        wait for 50 ns;          -- zero bits em 1 -> esperado impar = '0'
        x2 <= '0'; x1 <= '0'; x0 <= '1';
        wait for 50 ns;          -- um   bit  em 1 -> esperado impar = '1'
        x2 <= '0'; x1 <= '1'; x0 <= '0';
        wait for 50 ns;          -- um   bit  em 1 -> esperado impar = '1'
        x2 <= '0'; x1 <= '1'; x0 <= '1';
        wait for 50 ns;          -- dois bits em 1 -> esperado impar = '0'
        x2 <= '1'; x1 <= '0'; x0 <= '0';
        wait for 50 ns;          -- um   bit  em 1 -> esperado impar = '1'
        x2 <= '1'; x1 <= '0'; x0 <= '1';
        wait for 50 ns;          -- dois bits em 1 -> esperado impar = '0'
        x2 <= '1'; x1 <= '1'; x0 <= '0';
        wait for 50 ns;          -- dois bits em 1 -> esperado impar = '0'
        x2 <= '1'; x1 <= '1'; x0 <= '1';
        wait for 50 ns;          -- tres bits em 1 -> esperado impar = '1'
        wait;
    end process;
end architecture;

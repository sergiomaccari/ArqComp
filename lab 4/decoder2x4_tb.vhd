-- ============================================================
-- Lab VHDL 1 - Drill 1: testbench do decoder 2x4
-- (construido ANTES da arquitetura, como pede o roteiro)
-- Sergio Roncato Maccari - UTFPR - Arquitetura de Computadores
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

entity decoder2x4_tb is
end;

architecture a_decoder2x4_tb of decoder2x4_tb is
    component decoder2x4
        port( sel0 : in  std_logic;
              sel1 : in  std_logic;
              y0   : out std_logic;
              y1   : out std_logic;
              y2   : out std_logic;
              y3   : out std_logic
            );
    end component;
    signal sel0,sel1      : std_logic;
    signal y0,y1,y2,y3    : std_logic;
begin
    uut: decoder2x4 port map( sel0 => sel0,
                              sel1 => sel1,
                              y0   => y0,
                              y1   => y1,
                              y2   => y2,
                              y3   => y3);

    process
    begin
        -- percorre as 4 combinacoes possiveis de selecao
        sel1 <= '0';
        sel0 <= '0';
        wait for 50 ns;          -- esperado: y3y2y1y0 = 0001
        sel1 <= '0';
        sel0 <= '1';
        wait for 50 ns;          -- esperado: y3y2y1y0 = 0010
        sel1 <= '1';
        sel0 <= '0';
        wait for 50 ns;          -- esperado: y3y2y1y0 = 0100
        sel1 <= '1';
        sel0 <= '1';
        wait for 50 ns;          -- esperado: y3y2y1y0 = 1000
        -- volta ao inicio para confirmar que nao ficou nada "preso"
        sel1 <= '0';
        sel0 <= '0';
        wait for 50 ns;          -- esperado: y3y2y1y0 = 0001
        wait;
    end process;
end architecture;

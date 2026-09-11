-- ============================================================
-- Lab VHDL 1 - Drill 1: decoder 2x4
-- Sergio Roncato Maccari - UTFPR - Arquitetura de Computadores
--
-- Tabela verdade:
--   sel1 sel0 | y3 y2 y1 y0
--    0    0   |  0  0  0  1
--    0    1   |  0  0  1  0
--    1    0   |  0  1  0  0
--    1    1   |  1  0  0  0
--
-- Expressoes logicas extraidas da tabela (mintermos):
--   y0 = (not sel1) and (not sel0)
--   y1 = (not sel1) and sel0
--   y2 = sel1 and (not sel0)
--   y3 = sel1 and sel0
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

entity decoder2x4 is
    port( sel0 : in  std_logic;
          sel1 : in  std_logic;
          y0   : out std_logic;
          y1   : out std_logic;
          y2   : out std_logic;
          y3   : out std_logic
        );
end entity;

architecture a_decoder2x4 of decoder2x4 is
begin
    -- as quatro linhas sao "executadas" em paralelo: sao 4 portas AND
    y0 <= (not sel1) and (not sel0);
    y1 <= (not sel1) and sel0;
    y2 <= sel1 and (not sel0);
    y3 <= sel1 and sel0;
end architecture;

-- ============================================================
-- Lab VHDL 1 - Drill 2: detector de paridade de 3 bits
-- Saida em '1' quando ha um numero IMPAR de bits de entrada em '1'.
-- Sergio Roncato Maccari - UTFPR - Arquitetura de Computadores
--
-- Tabela verdade:
--   x2 x1 x0 | qtd de 1s | impar
--    0  0  0 |     0     |   0
--    0  0  1 |     1     |   1   <- mintermo
--    0  1  0 |     1     |   1   <- mintermo
--    0  1  1 |     2     |   0
--    1  0  0 |     1     |   1   <- mintermo
--    1  0  1 |     2     |   0
--    1  1  0 |     2     |   0
--    1  1  1 |     3     |   1   <- mintermo
--
-- Soma dos mintermos (nao ha simplificacao possivel por Karnaugh,
-- os 1s ficam todos isolados no mapa):
--   impar = (not x2 and not x1 and     x0)
--        or (not x2 and     x1 and not x0)
--        or (    x2 and not x1 and not x0)
--        or (    x2 and     x1 and     x0)
--
-- Observacao: essa expressao e exatamente x2 xor x1 xor x0, que e a
-- forma classica do detector de paridade. Foi mantida a forma em
-- soma-de-produtos por ter sido extraida diretamente da tabela verdade.
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

entity paridade3 is
    port( x0     : in  std_logic;
          x1     : in  std_logic;
          x2     : in  std_logic;
          impar  : out std_logic
        );
end entity;

architecture a_paridade3 of paridade3 is
begin
    impar <= ((not x2) and (not x1) and      x0 )
          or ((not x2) and      x1  and (not x0))
          or (     x2  and (not x1) and (not x0))
          or (     x2  and      x1  and      x0 );
end architecture;

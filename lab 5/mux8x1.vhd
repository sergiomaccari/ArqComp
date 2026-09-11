-- ============================================================
-- Lab VHDL 2 - Exercicio 1: multiplexador 8x1 com restricoes
-- Sergio Roncato Maccari - UTFPR - Arquitetura de Computadores
--
-- Restricoes do enunciado:
--   entradas 0, 1 e 5 estao sempre em '0'  -> viram constante '0'
--   entradas 3 e 7    estao sempre em '1'  -> viram constante '1'
--   entradas 2, 4 e 6 sao variaveis        -> viram pinos de entrada
-- Logo a entidade tem apenas 3 pinos de dados e 3 pinos de selecao.
--
-- Tabela verdade (versao reduzida):
--   sel2 sel1 sel0 | saida
--    0    0    0   |  '0'     (entrada 0, fixa)
--    0    0    1   |  '0'     (entrada 1, fixa)
--    0    1    0   | entr2    (variavel)
--    0    1    1   |  '1'     (entrada 3, fixa)
--    1    0    0   | entr4    (variavel)
--    1    0    1   |  '0'     (entrada 5, fixa)
--    1    1    0   | entr6    (variavel)
--    1    1    1   |  '1'     (entrada 7, fixa)
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

entity mux8x1 is
    port( sel0,sel1,sel2    : in  std_logic;
          entr2,entr4,entr6 : in  std_logic;
          saida             : out std_logic
        );
end entity;

architecture a_mux8x1 of mux8x1 is
begin
    saida <= '0'   when sel2='0' and sel1='0' and sel0='0' else
             '0'   when sel2='0' and sel1='0' and sel0='1' else
             entr2 when sel2='0' and sel1='1' and sel0='0' else
             '1'   when sel2='0' and sel1='1' and sel0='1' else
             entr4 when sel2='1' and sel1='0' and sel0='0' else
             '0'   when sel2='1' and sel1='0' and sel0='1' else
             entr6 when sel2='1' and sel1='1' and sel0='0' else
             '1'   when sel2='1' and sel1='1' and sel0='1' else
             '0';  -- else obrigatorio: cobre 'U', 'X' etc. e evita latch
end architecture;

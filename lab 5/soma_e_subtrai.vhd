-- ============================================================
-- Lab VHDL 2 - Exercicio 2: circuito soma_e_subtrai (8 bits)
-- Copiado do roteiro, ja com as saidas extras "maior" e "x_negativo".
-- Sergio Roncato Maccari - UTFPR - Arquitetura de Computadores
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;      -- para usarmos UNSIGNED

entity soma_e_subtrai is
    port ( x,y              : in  unsigned(7 downto 0);
           soma,subt        : out unsigned(7 downto 0);
           maior,x_negativo : out std_logic
         );
end entity;

architecture a_soma_e_subtrai of soma_e_subtrai is
begin
    soma <= x+y;
    subt <= x-y;

    -- comparacao so vale para numeros positivos, pois x e y sao unsigned
    maior <= '1' when x>y  else
             '0' when x<=y else
             '0';

    -- o "negativo" e apenas a copia do MSB (interpretacao em compl. de 2)
    x_negativo <= x(7);
end architecture;

-- ============================================================
-- Lab VHDL 2 - Exercicio 2: testbench do circuito soma_e_subtrai
-- Sergio Roncato Maccari - UTFPR - Arquitetura de Computadores
--
-- Constantes escritas em binario de 8 bits, pois o VHDL nao aceita
-- inteiros soltos em sinais do tipo unsigned (a largura tem que bater).
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity soma_e_subtrai_tb is
end;

architecture a_soma_e_subtrai_tb of soma_e_subtrai_tb is
    component soma_e_subtrai
        port ( x,y              : in  unsigned(7 downto 0);
               soma,subt        : out unsigned(7 downto 0);
               maior,x_negativo : out std_logic
             );
    end component;
    signal x,y       : unsigned(7 downto 0);
    signal soma,subt : unsigned(7 downto 0);
    signal maior     : std_logic;
    signal x_negativo: std_logic;
begin
    uut: soma_e_subtrai port map( x          => x,
                                  y          => y,
                                  soma       => soma,
                                  subt       => subt,
                                  maior      => maior,
                                  x_negativo => x_negativo);

    process
    begin
        -- caso 1: soma e subtracao simples, sem nenhum estouro
        x <= "00000011";           --   3
        y <= "00000101";           --   5
        wait for 50 ns;            -- soma=00001000 (8), subt=11111110 (-2)
                                   -- maior=0, x_negativo=0

        -- caso 2: subtracao que da zero, soma ainda cabe em 8 bits
        x <= "01100100";           -- 100
        y <= "01100100";           -- 100
        wait for 50 ns;            -- soma=11001000 (200), subt=00000000 (0)
                                   -- maior=0, x_negativo=0
                                   -- repare: soma "parece negativa" (MSB=1),
                                   -- mas so porque 200 nao cabe em 8 bits
                                   -- com sinal. Quem interpreta e o programador.

        -- caso 3: 200+200 estoura os 8 bits sem sinal (400 - 256 = 144)
        x <= "11001000";           -- 200
        y <= "11001000";           -- 200
        wait for 50 ns;            -- soma=10010000 (144), subt=00000000 (0)
                                   -- maior=0, x_negativo=1

        -- caso 4: numero negativo na entrada -> 18 + (-3) = 15
        x <= "00010010";           --  18
        y <= "11111101";           -- 253 sem sinal = -3 em complemento de 2
        wait for 50 ns;            -- soma=00001111 (15), subt=00010101 (21)
                                   -- maior=0 (pois 18 < 253 como unsigned)
                                   -- x_negativo=0

        -- caso 5: o exemplo do proprio roteiro, 200+100
        x <= "11001000";           -- 200
        y <= "01100100";           -- 100
        wait for 50 ns;            -- soma=00101100 (44, houve vai-um)
                                   -- subt=01100100 (100)
                                   -- maior=1, x_negativo=1

        -- caso 6: tudo zero
        x <= "00000000";           --   0
        y <= "00000000";           --   0
        wait for 50 ns;            -- soma=00000000, subt=00000000
                                   -- maior=0, x_negativo=0

        -- caso 7: maior valor possivel + 1 -> da a volta e zera
        x <= "11111111";           -- 255
        y <= "00000001";           --   1
        wait for 50 ns;            -- soma=00000000 (0), subt=11111110 (254)
                                   -- maior=1, x_negativo=1
        wait;
    end process;
end architecture;

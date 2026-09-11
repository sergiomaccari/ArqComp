-- ============================================================================
-- Lab VHDL 2 - TAREFA PARA ENTREGAR: testbench da ULA de 16 bits
-- Sergio Roncato Maccari - UTFPR - Arquitetura de Computadores
--
-- As constantes vao todas em binario de 16 bits porque o VHDL nao aceita
-- inteiro solto em sinal unsigned e a largura precisa bater exatamente.
-- Ao lado de cada uma esta o valor em decimal sem sinal e, quando o MSB
-- esta em 1, tambem o valor lido em complemento de 2.
--
-- Cobertura: as 8 operacoes, entradas negativas, carry sem overflow,
-- overflow sem carry, carry e overflow juntos, e a flag zero aparecendo
-- tanto numa operacao aritmetica quanto numa logica.
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula
        port( entrada_a     : in  unsigned(15 downto 0);
              entrada_b     : in  unsigned(15 downto 0);
              selec_op      : in  unsigned(2 downto 0);
              resultado     : out unsigned(15 downto 0);
              flag_zero     : out std_logic;
              flag_negativo : out std_logic;
              flag_carry    : out std_logic;
              flag_overflow : out std_logic
            );
    end component;

    signal entrada_a     : unsigned(15 downto 0);
    signal entrada_b     : unsigned(15 downto 0);
    signal selec_op      : unsigned(2 downto 0);
    signal resultado     : unsigned(15 downto 0);
    signal flag_zero     : std_logic;
    signal flag_negativo : std_logic;
    signal flag_carry    : std_logic;
    signal flag_overflow : std_logic;

begin

    uut: ula port map( entrada_a     => entrada_a,
                       entrada_b     => entrada_b,
                       selec_op      => selec_op,
                       resultado     => resultado,
                       flag_zero     => flag_zero,
                       flag_negativo => flag_negativo,
                       flag_carry    => flag_carry,
                       flag_overflow => flag_overflow);

    process
    begin

        -- =================================================================
        -- SOMA  (selec_op = 000)
        -- =================================================================
        selec_op <= "000";

        -- 1) soma trivial: 3 + 5 = 8, nao estoura de jeito nenhum
        entrada_a <= "0000000000000011";   --      3
        entrada_b <= "0000000000000101";   --      5
        wait for 50 ns;   -- resultado=0000000000001000 (8)
                          -- Z=0  N=0  C=0  OV=0

        -- 2) entrada negativa: 18 + (-3) = 15
        entrada_a <= "0000000000010010";   --     18
        entrada_b <= "1111111111111101";   --  65533 = -3
        wait for 50 ns;   -- resultado=0000000000001111 (15)
                          -- Z=0  N=0  C=1  OV=0
                          -- o C=1 aqui e normal: somando sem sinal
                          -- 18+65533 passa de 65535. Lendo com sinal,
                          -- a conta esta certa e OV=0.

        -- 3) resultado zero: 5 + (-5) = 0  -> acende a flag zero
        entrada_a <= "0000000000000101";   --      5
        entrada_b <= "1111111111111011";   --  65531 = -5
        wait for 50 ns;   -- resultado=0000000000000000 (0)
                          -- Z=1  N=0  C=1  OV=0

        -- 4) carry SEM overflow: 40000 + 30000 = 70000, nao cabe em 16 bits
        entrada_a <= "1001110001000000";   --  40000 = -25536
        entrada_b <= "0111010100110000";   --  30000
        wait for 50 ns;   -- resultado=0001000101110000 (4464)
                          -- Z=0  N=0  C=1  OV=0
                          -- sem sinal estourou (C=1); com sinal as entradas
                          -- tem sinais diferentes, entao nao ha overflow.

        -- 5) overflow SEM carry: 20000 + 20000 = 40000, positivo virou negativo
        entrada_a <= "0100111000100000";   --  20000
        entrada_b <= "0100111000100000";   --  20000
        wait for 50 ns;   -- resultado=1001110001000000 (40000 = -25536)
                          -- Z=0  N=1  C=0  OV=1
                          -- cabe nos 16 bits sem sinal (C=0), mas em
                          -- complemento de 2 dois positivos deram negativo.

        -- 6) carry E overflow juntos: (-20000) + (-20000) = -40000
        entrada_a <= "1011000111100000";   --  45536 = -20000
        entrada_b <= "1011000111100000";   --  45536 = -20000
        wait for 50 ns;   -- resultado=0110001111000000 (25536)
                          -- Z=0  N=0  C=1  OV=1
                          -- dois negativos deram positivo: OV=1.

        -- =================================================================
        -- SUBTRACAO  (selec_op = 001)
        -- =================================================================
        selec_op <= "001";

        -- 7) subtracao sem emprestimo: 5 - 3 = 2
        entrada_a <= "0000000000000101";   --      5
        entrada_b <= "0000000000000011";   --      3
        wait for 50 ns;   -- resultado=0000000000000010 (2)
                          -- Z=0  N=0  C=0  OV=0

        -- 8) subtracao com emprestimo: 3 - 5 = -2
        entrada_a <= "0000000000000011";   --      3
        entrada_b <= "0000000000000101";   --      5
        wait for 50 ns;   -- resultado=1111111111111110 (65534 = -2)
                          -- Z=0  N=1  C=1  OV=0
                          -- C=1 indica o emprestimo: sem sinal, 3-5 nao
                          -- existe. Com sinal o -2 esta correto, OV=0.

        -- 9) overflow na subtracao: 20000 - (-20000) = 40000, nao cabe
        entrada_a <= "0100111000100000";   --  20000
        entrada_b <= "1011000111100000";   --  45536 = -20000
        wait for 50 ns;   -- resultado=1001110001000000 (40000 = -25536)
                          -- Z=0  N=1  C=1  OV=1

        -- 10) subtracao dando zero
        entrada_a <= "0000000000000000";   --      0
        entrada_b <= "0000000000000000";   --      0
        wait for 50 ns;   -- resultado=0000000000000000 (0)
                          -- Z=1  N=0  C=0  OV=0

        -- =================================================================
        -- E / AND  (selec_op = 010)
        -- =================================================================
        selec_op <= "010";

        -- 11) mascara bit a bit
        entrada_a <= "1111000011110000";
        entrada_b <= "1100110011001100";
        wait for 50 ns;   -- resultado=1100000011000000
                          -- Z=0  N=1  C=0  OV=0
                          -- C e OV ficam em 0: nao e operacao aritmetica.

        -- 12) AND que zera tudo -> flag zero numa operacao logica
        entrada_a <= "1111000011110000";
        entrada_b <= "0000111100001111";
        wait for 50 ns;   -- resultado=0000000000000000
                          -- Z=1  N=0  C=0  OV=0

        -- =================================================================
        -- OU / OR  (selec_op = 011)
        -- =================================================================
        selec_op <= "011";

        -- 13) uniao dos bits
        entrada_a <= "1111000011110000";
        entrada_b <= "1100110011001100";
        wait for 50 ns;   -- resultado=1111110011111100
                          -- Z=0  N=1  C=0  OV=0

        -- =================================================================
        -- NAO / NOT  (selec_op = 100) -- so usa entrada_a
        -- =================================================================
        selec_op <= "100";

        -- 14) inverte todos os bits
        entrada_a <= "1111000011110000";
        entrada_b <= "0000000000000000";   -- ignorada nesta operacao
        wait for 50 ns;   -- resultado=0000111100001111
                          -- Z=0  N=0  C=0  OV=0

        -- 15) not de tudo em 1 da zero
        entrada_a <= "1111111111111111";   --  65535 = -1
        entrada_b <= "0000000000000000";   -- ignorada
        wait for 50 ns;   -- resultado=0000000000000000
                          -- Z=1  N=0  C=0  OV=0

        -- =================================================================
        -- DESLOCA PARA A ESQUERDA  (selec_op = 101) -- so usa entrada_a
        -- =================================================================
        selec_op <= "101";

        -- 16) deslocar para a esquerda dobra o valor: 13 -> 26
        entrada_a <= "0000000000001101";   --     13
        entrada_b <= "0000000000000000";   -- ignorada
        wait for 50 ns;   -- resultado=0000000000011010 (26)
                          -- Z=0  N=0  C=0  OV=0

        -- 17) o MSB cai fora na borda esquerda
        entrada_a <= "1000000000000001";   --  32769
        entrada_b <= "0000000000000000";   -- ignorada
        wait for 50 ns;   -- resultado=0000000000000010 (2)
                          -- Z=0  N=0  C=0  OV=0

        -- =================================================================
        -- DESLOCA PARA A DIREITA  (selec_op = 110) -- so usa entrada_a
        -- =================================================================
        selec_op <= "110";

        -- 18) deslocar para a direita divide por 2 (sem sinal): 13 -> 6
        entrada_a <= "0000000000001101";   --     13
        entrada_b <= "0000000000000000";   -- ignorada
        wait for 50 ns;   -- resultado=0000000000000110 (6)
                          -- Z=0  N=0  C=0  OV=0

        -- 19) entra '0' pela esquerda, o LSB cai fora
        entrada_a <= "1000000000000001";   --  32769
        entrada_b <= "0000000000000000";   -- ignorada
        wait for 50 ns;   -- resultado=0100000000000000 (16384)
                          -- Z=0  N=0  C=0  OV=0

        -- =================================================================
        -- PASSA A  (selec_op = 111) -- copia entrada_a para a saida
        -- =================================================================
        selec_op <= "111";

        -- 20) copia um valor com o MSB em 1
        entrada_a <= "1010101010101010";   --  43690 = -21846
        entrada_b <= "1111111111111111";   -- ignorada
        wait for 50 ns;   -- resultado=1010101010101010
                          -- Z=0  N=1  C=0  OV=0

        -- 21) copia zero
        entrada_a <= "0000000000000000";   --      0
        entrada_b <= "1111111111111111";   -- ignorada
        wait for 50 ns;   -- resultado=0000000000000000
                          -- Z=1  N=0  C=0  OV=0

        wait;
    end process;
end architecture;

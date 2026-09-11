-- ============================================================================
-- Lab VHDL 2 - TAREFA PARA ENTREGAR: ULA de 16 bits
-- Sergio Roncato Maccari - UTFPR - Arquitetura de Computadores
--
-- Duas entradas de dados de 16 bits, uma saida de resultado de 16 bits,
-- uma entrada de selecao de operacao de 3 bits e quatro flags de 1 bit.
--
-- ---------------------------------------------------------------------------
-- OPERACOES (as 8 combinacoes de selec_op estao cobertas):
--   selec_op | operacao        | resultado
--   ---------+-----------------+--------------------------------------------
--     000    | soma            | entrada_a + entrada_b
--     001    | subtracao       | entrada_a - entrada_b
--     010    | e (AND)         | entrada_a and entrada_b     (bit a bit)
--     011    | ou (OR)         | entrada_a or  entrada_b     (bit a bit)
--     100    | nao (NOT)       | not entrada_a               (bit a bit)
--     101    | desloca_esq     | entrada_a deslocado 1 bit para a esquerda
--     110    | desloca_dir     | entrada_a deslocado 1 bit para a direita
--     111    | passa_a         | entrada_a (usado para MOV/copia)
--
-- Nao ha divisao, conforme pedido no roteiro.
--
-- ---------------------------------------------------------------------------
-- FLAGS
-- O sorteio das instrucoes de salto da equipe nao estava disponivel quando
-- este arquivo foi escrito, entao as QUATRO flags foram implementadas; assim
-- qualquer par de saltos sorteado fica atendido.
--
--   flag_zero     : '1' quando o resultado da operacao e zero.
--   flag_negativo : copia do MSB do resultado (bit 15), ou seja, o sinal do
--                   resultado quando ele e lido em complemento de 2.
--   flag_carry    : estouro da operacao NAO SINALIZADA. Na soma e o vai-um
--                   que sobraria no 17o bit; na subtracao e o "vem-um"
--                   (emprestimo), que aparece quando entrada_a < entrada_b
--                   lidos como numeros sem sinal. Nas operacoes logicas e de
--                   deslocamento a flag fica em '0', pois nao ha aritmetica.
--   flag_overflow : estouro da operacao SINALIZADA (complemento de 2). Na
--                   soma so ocorre quando as duas entradas tem o mesmo sinal
--                   e o resultado sai com o sinal trocado; na subtracao so
--                   ocorre quando as entradas tem sinais diferentes e o
--                   resultado sai com sinal diferente do de entrada_a.
--                   Nas demais operacoes fica em '0'.
--
-- Truque do 17o bit: para capturar o carry, as entradas sao estendidas para
-- 17 bits com um '0' na frente (concatenacao) e a conta e feita nessa largura
-- maior. O bit 16 do resultado estendido e exatamente o carry/emprestimo, e
-- os bits 15..0 sao o resultado de 16 bits que interessa.
-- ============================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;      -- para usarmos UNSIGNED

entity ula is
    port( entrada_a     : in  unsigned(15 downto 0);
          entrada_b     : in  unsigned(15 downto 0);
          selec_op      : in  unsigned(2 downto 0);
          resultado     : out unsigned(15 downto 0);
          flag_zero     : out std_logic;
          flag_negativo : out std_logic;
          flag_carry    : out std_logic;
          flag_overflow : out std_logic
        );
end entity;

architecture a_ula of ula is

    -- entradas e contas estendidas para 17 bits, para pescar o carry
    signal entrada_a_estendida : unsigned(16 downto 0);
    signal entrada_b_estendida : unsigned(16 downto 0);
    signal soma_estendida      : unsigned(16 downto 0);
    signal subtracao_estendida : unsigned(16 downto 0);

    -- resultado de cada operacao; todas sao calculadas ao mesmo tempo,
    -- pois sao circuitos fisicos separados ligados ao mux de saida
    signal res_soma        : unsigned(15 downto 0);
    signal res_subtracao   : unsigned(15 downto 0);
    signal res_e           : unsigned(15 downto 0);
    signal res_ou          : unsigned(15 downto 0);
    signal res_nao         : unsigned(15 downto 0);
    signal res_desloca_esq : unsigned(15 downto 0);
    signal res_desloca_dir : unsigned(15 downto 0);
    signal res_passa_a     : unsigned(15 downto 0);

    -- saida do mux, realimentada para o calculo das flags
    signal resultado_interno : unsigned(15 downto 0);

    -- flags parciais de cada operacao aritmetica
    signal carry_soma         : std_logic;
    signal carry_subtracao    : std_logic;
    signal overflow_soma      : std_logic;
    signal overflow_subtracao : std_logic;

begin

    -- ---------------------------------------------------------------
    -- Bloco aritmetico (17 bits para nao perder o vai-um)
    -- ---------------------------------------------------------------
    entrada_a_estendida <= '0' & entrada_a;
    entrada_b_estendida <= '0' & entrada_b;

    soma_estendida      <= entrada_a_estendida + entrada_b_estendida;
    subtracao_estendida <= entrada_a_estendida - entrada_b_estendida;

    res_soma      <= soma_estendida(15 downto 0);
    res_subtracao <= subtracao_estendida(15 downto 0);

    carry_soma      <= soma_estendida(16);
    carry_subtracao <= subtracao_estendida(16);

    -- ---------------------------------------------------------------
    -- Bloco logico (bit a bit)
    -- ---------------------------------------------------------------
    res_e   <= entrada_a and entrada_b;
    res_ou  <= entrada_a or  entrada_b;
    res_nao <= not entrada_a;

    -- ---------------------------------------------------------------
    -- Bloco de deslocamento (feito so com recorte e concatenacao)
    -- ---------------------------------------------------------------
    res_desloca_esq <= entrada_a(14 downto 0) & '0';
    res_desloca_dir <= '0' & entrada_a(15 downto 1);

    -- ---------------------------------------------------------------
    -- Passagem direta
    -- ---------------------------------------------------------------
    res_passa_a <= entrada_a;

    -- ---------------------------------------------------------------
    -- Mux de saida: escolhe qual das operacoes vai para o resultado
    -- ---------------------------------------------------------------
    resultado_interno <= res_soma        when selec_op="000" else
                         res_subtracao   when selec_op="001" else
                         res_e           when selec_op="010" else
                         res_ou          when selec_op="011" else
                         res_nao         when selec_op="100" else
                         res_desloca_esq when selec_op="101" else
                         res_desloca_dir when selec_op="110" else
                         res_passa_a     when selec_op="111" else
                         "0000000000000000";   -- else obrigatorio: evita latch

    resultado <= resultado_interno;

    -- ---------------------------------------------------------------
    -- Flags
    -- ---------------------------------------------------------------

    -- zero: vale '1' so quando os 16 bits do resultado estao apagados
    flag_zero <= '1' when resultado_interno = "0000000000000000" else
                 '0';

    -- negativo: e so a copia do MSB do resultado
    flag_negativo <= resultado_interno(15);

    -- overflow da soma: mesmos sinais na entrada, sinal trocado na saida
    overflow_soma <= (     entrada_a(15)  and      entrada_b(15)  and (not res_soma(15)))
                  or ((not entrada_a(15)) and (not entrada_b(15)) and      res_soma(15) );

    -- overflow da subtracao: sinais diferentes na entrada e resultado com
    -- sinal diferente do de entrada_a
    overflow_subtracao <= (     entrada_a(15)  and (not entrada_b(15)) and (not res_subtracao(15)))
                       or ((not entrada_a(15)) and      entrada_b(15)  and      res_subtracao(15) );

    -- carry e overflow so fazem sentido nas operacoes aritmeticas
    flag_carry <= carry_soma      when selec_op="000" else
                  carry_subtracao when selec_op="001" else
                  '0';

    flag_overflow <= overflow_soma      when selec_op="000" else
                     overflow_subtracao when selec_op="001" else
                     '0';

end architecture;

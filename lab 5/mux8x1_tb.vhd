-- ============================================================
-- Lab VHDL 2 - Exercicio 1: testbench do multiplexador 8x1
-- Sergio Roncato Maccari - UTFPR - Arquitetura de Computadores
-- ============================================================

library ieee;
use ieee.std_logic_1164.all;

entity mux8x1_tb is
end;

architecture a_mux8x1_tb of mux8x1_tb is
    component mux8x1
        port( sel0,sel1,sel2    : in  std_logic;
              entr2,entr4,entr6 : in  std_logic;
              saida             : out std_logic
            );
    end component;
    signal sel0,sel1,sel2    : std_logic;
    signal entr2,entr4,entr6 : std_logic;
    signal saida             : std_logic;
begin
    uut: mux8x1 port map( sel0  => sel0,
                          sel1  => sel1,
                          sel2  => sel2,
                          entr2 => entr2,
                          entr4 => entr4,
                          entr6 => entr6,
                          saida => saida);

    process
    begin
        -- ---- Rodada 1: entradas variaveis em entr2=1, entr4=0, entr6=1 ----
        entr2 <= '1'; entr4 <= '0'; entr6 <= '1';

        sel2 <= '0'; sel1 <= '0'; sel0 <= '0';
        wait for 50 ns;      -- entrada 0 (fixa)   -> esperado '0'
        sel2 <= '0'; sel1 <= '0'; sel0 <= '1';
        wait for 50 ns;      -- entrada 1 (fixa)   -> esperado '0'
        sel2 <= '0'; sel1 <= '1'; sel0 <= '0';
        wait for 50 ns;      -- entrada 2 = entr2  -> esperado '1'
        sel2 <= '0'; sel1 <= '1'; sel0 <= '1';
        wait for 50 ns;      -- entrada 3 (fixa)   -> esperado '1'
        sel2 <= '1'; sel1 <= '0'; sel0 <= '0';
        wait for 50 ns;      -- entrada 4 = entr4  -> esperado '0'
        sel2 <= '1'; sel1 <= '0'; sel0 <= '1';
        wait for 50 ns;      -- entrada 5 (fixa)   -> esperado '0'
        sel2 <= '1'; sel1 <= '1'; sel0 <= '0';
        wait for 50 ns;      -- entrada 6 = entr6  -> esperado '1'
        sel2 <= '1'; sel1 <= '1'; sel0 <= '1';
        wait for 50 ns;      -- entrada 7 (fixa)   -> esperado '1'

        -- ---- Rodada 2: inverte as variaveis (entr2=0, entr4=1, entr6=0) ----
        -- so as posicoes 2, 4 e 6 devem mudar; as fixas nao podem mexer.
        entr2 <= '0'; entr4 <= '1'; entr6 <= '0';

        sel2 <= '0'; sel1 <= '0'; sel0 <= '0';
        wait for 50 ns;      -- esperado '0' (nao muda)
        sel2 <= '0'; sel1 <= '0'; sel0 <= '1';
        wait for 50 ns;      -- esperado '0' (nao muda)
        sel2 <= '0'; sel1 <= '1'; sel0 <= '0';
        wait for 50 ns;      -- entrada 2 = entr2  -> esperado '0' (mudou)
        sel2 <= '0'; sel1 <= '1'; sel0 <= '1';
        wait for 50 ns;      -- esperado '1' (nao muda)
        sel2 <= '1'; sel1 <= '0'; sel0 <= '0';
        wait for 50 ns;      -- entrada 4 = entr4  -> esperado '1' (mudou)
        sel2 <= '1'; sel1 <= '0'; sel0 <= '1';
        wait for 50 ns;      -- esperado '0' (nao muda)
        sel2 <= '1'; sel1 <= '1'; sel0 <= '0';
        wait for 50 ns;      -- entrada 6 = entr6  -> esperado '0' (mudou)
        sel2 <= '1'; sel1 <= '1'; sel0 <= '1';
        wait for 50 ns;      -- esperado '1' (nao muda)
        wait;
    end process;
end architecture;

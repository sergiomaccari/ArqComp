# Lab VHDL 2 — Multiplexação, Barramentos, Números: a ULA

Sérgio Roncato Maccari — UTFPR / DAELN — Arquitetura de Computadores

## Arquivos

| Arquivo | O que é | Entrega? |
|---|---|:--:|
| `mux8x1.vhd` / `mux8x1_tb.vhd` | Exercício 1 — mux 8x1 com entradas fixas | não |
| `soma_e_subtrai.vhd` / `soma_e_subtrai_tb.vhd` | Exercício 2 — testbench do circuito do roteiro | não |
| **`ula.vhd` / `ula_tb.vhd`** | **Tarefa para entregar — ULA de 16 bits** | **SIM** |

> A entrega é só `ula.vhd` + `ula_tb.vhd`.

## Exercício 1 — Mux 8x1 com restrições

Entradas 0, 1 e 5 sempre `'0'`; entradas 3 e 7 sempre `'1'`. Só 2, 4 e 6 variam,
então a entidade fica com **3 pinos de dados** (`entr2`, `entr4`, `entr6`) e
**3 pinos de seleção**. As constantes entram direto no `when-else`, sem virar pino.

| sel2 sel1 sel0 | saída |
|:--:|:--:|
| 0 0 0 | `'0'` (fixa) |
| 0 0 1 | `'0'` (fixa) |
| 0 1 0 | `entr2` |
| 0 1 1 | `'1'` (fixa) |
| 1 0 0 | `entr4` |
| 1 0 1 | `'0'` (fixa) |
| 1 1 0 | `entr6` |
| 1 1 1 | `'1'` (fixa) |

O testbench roda as 8 seleções duas vezes, invertendo `entr2/entr4/entr6` na
segunda rodada — assim dá pra ver que só as posições 2, 4 e 6 mudam e que as
fixas ficam paradas.

## Exercício 2 — soma_e_subtrai

Circuito de 8 bits do roteiro, com as saídas extras `maior` e `x_negativo`.
O testbench cobre 7 casos: soma/subtração simples, subtração que dá negativo,
estouro de 8 bits (`200+200`), entrada negativa (`18 + (-3)`), o exemplo
`200+100` do próprio roteiro, tudo zero e `255+1` (dá a volta).

## Tarefa para entregar — ULA de 16 bits

### Interface

```
entrada_a     : in  unsigned(15 downto 0)
entrada_b     : in  unsigned(15 downto 0)
selec_op      : in  unsigned(2 downto 0)
resultado     : out unsigned(15 downto 0)
flag_zero     : out std_logic
flag_negativo : out std_logic
flag_carry    : out std_logic
flag_overflow : out std_logic
```

### Operações

| `selec_op` | Operação | Resultado |
|:--:|---|---|
| `000` | soma | `entrada_a + entrada_b` |
| `001` | subtração | `entrada_a - entrada_b` |
| `010` | e (AND) | `entrada_a and entrada_b`, bit a bit |
| `011` | ou (OR) | `entrada_a or entrada_b`, bit a bit |
| `100` | não (NOT) | `not entrada_a`, bit a bit |
| `101` | desloca_esq | `entrada_a` 1 bit para a esquerda |
| `110` | desloca_dir | `entrada_a` 1 bit para a direita |
| `111` | passa_a | `entrada_a` (serve de MOV) |

Mínimo pedido eram 4 operações (soma, subtração e mais duas) — foram feitas 8,
que é o que cabe nos 3 bits de seleção, sem sobrar combinação descoberta.
**Não há divisão**, como o roteiro pede.

Cada operação é um bloco físico separado calculado em paralelo; o `when-else` no
final é o **mux de saída** que escolhe qual deles vai para `resultado`.

### Flags

O sorteio dos saltos condicionais da equipe não estava à mão quando isso foi
escrito, então **as quatro flags foram implementadas** — assim qualquer par
sorteado (EQ/NE → Z, CS/CC/HS/LO → C, MI/PL → N, VS/VC → V, e os compostos) fica
atendido. Se o sorteio pedir só duas, é só apagar as outras da entidade.

- **`flag_zero`** — `'1'` quando os 16 bits do resultado estão apagados.
- **`flag_negativo`** — cópia do MSB (bit 15) do resultado.
- **`flag_carry`** — estouro **não sinalizado**. Na soma é o vai-um que sobraria
  no 17º bit; na subtração é o empréstimo, que aparece quando
  `entrada_a < entrada_b` lidos sem sinal. Nas operações lógicas e de
  deslocamento fica em `'0'`, pois não há aritmética.
- **`flag_overflow`** — estouro **sinalizado** (complemento de 2). Na soma só
  ocorre com as duas entradas de mesmo sinal e resultado de sinal trocado; na
  subtração, com entradas de sinais diferentes e resultado de sinal diferente do
  de `entrada_a`. Nas demais operações fica em `'0'`.

**Truque do 17º bit:** para pescar o carry, as entradas são estendidas para 17
bits com um `'0'` na frente (concatenação) e a conta roda nessa largura maior. O
bit 16 do resultado estendido *é* o carry/empréstimo; os bits 15..0 são o
resultado que interessa.

### Testbench

21 casos, cobrindo as 8 operações. Os de maior interesse:

| # | Caso | Por que está lá |
|:--:|---|---|
| 2 | `18 + (-3) = 15` | entrada negativa (complemento de 2) |
| 3 | `5 + (-5) = 0` | flag zero numa operação aritmética |
| 4 | `40000 + 30000` | **carry sem overflow** (estoura sem sinal, não estoura com sinal) |
| 5 | `20000 + 20000` | **overflow sem carry** (cabe sem sinal, dois positivos dão negativo) |
| 6 | `(-20000) + (-20000)` | **carry e overflow juntos** |
| 8 | `3 - 5 = -2` | empréstimo na subtração |
| 9 | `20000 - (-20000)` | overflow na subtração |
| 12 | `AND` que zera tudo | flag zero numa operação lógica |
| 17 | desloca esq. de `0x8001` | MSB caindo fora na borda |

Todas as constantes estão em **binário de 16 bits**, porque o VHDL não aceita
inteiro solto em sinal `unsigned` e a largura precisa bater. Ao lado de cada uma
há um comentário com o valor decimal.

## Como compilar e simular

```bash
ghdl -a ula.vhd
ghdl -a ula_tb.vhd
ghdl -r ula_tb --wave=ula_tb.ghw
gtkwave ula_tb.ghw
```

Idem para `mux8x1` e `soma_e_subtrai`.

## Conformidade com as regras de avaliação

- Só foi usado VHDL que aparece nos dois PDFs: `when-else` (sempre terminado em
  `else` com constante, para não gerar latch), `unsigned` + `numeric_std`,
  `and` / `or` / `not`, `+` / `-`, comparações, concatenação `&`, slicing,
  `component` + `port map`, e `process` + `wait for` **apenas nos testbenches**
  (que é como o roteiro do Lab 1 ensina a escrevê-los).
- **Não há `process` nem `if` em nenhum arquivo de circuito** — só descrição
  concorrente.
- Sem `std_logic_vector`, sem `to_integer`/`to_unsigned`/`resize`, sem literais
  hexadecimais, sem `others`, sem `with-select`, sem `std_logic_arith`.

## Estado da verificação

Analisado, elaborado e simulado com **GHDL 4.1.0**. Os 21 casos do testbench da
ULA foram conferidos um a um contra um modelo de referência independente
(resultado + as 4 flags): **0 divergências**, as 8 operações cobertas.

As mensagens `NUMERIC_STD."=": metavalue detected` que aparecem no início da
simulação são normais: acontecem em `@0ms`, antes da primeira atribuição, quando
os sinais ainda estão em `'U'`. Não são erros.

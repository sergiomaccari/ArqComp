# Lab VHDL 1 — Tutorial de Introdução ao VHDL

Sérgio Roncato Maccari — UTFPR / DAELN — Arquitetura de Computadores

> Este laboratório **não precisa ser entregue nem apresentado** (drills de fixação).

## Arquivos

| Arquivo | O que é |
|---|---|
| `porta.vhd` / `porta_tb.vhd` | Porta AND do tutorial |
| `decoder2x4.vhd` / `decoder2x4_tb.vhd` | **Drill 1** — decoder 2x4 |
| `paridade3.vhd` / `paridade3_tb.vhd` | **Drill 2** — detector de paridade de 3 bits |

Os testbenches dos dois drills foram escritos **antes** das arquiteturas, como o
roteiro exige.

## Drill 1 — Decoder 2x4

| sel1 | sel0 | y3 | y2 | y1 | y0 |
|:--:|:--:|:--:|:--:|:--:|:--:|
| 0 | 0 | 0 | 0 | 0 | 1 |
| 0 | 1 | 0 | 0 | 1 | 0 |
| 1 | 0 | 0 | 1 | 0 | 0 |
| 1 | 1 | 1 | 0 | 0 | 0 |

Cada saída é um mintermo da tabela:

```
y0 = (not sel1) and (not sel0)
y1 = (not sel1) and      sel0
y2 =      sel1  and (not sel0)
y3 =      sel1  and      sel0
```

## Drill 2 — Detector de paridade de 3 bits

Saída em `'1'` quando o número de bits em `'1'` é **ímpar**.

| x2 | x1 | x0 | qtd de 1s | impar |
|:--:|:--:|:--:|:--:|:--:|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 | **1** |
| 0 | 1 | 0 | 1 | **1** |
| 0 | 1 | 1 | 2 | 0 |
| 1 | 0 | 0 | 1 | **1** |
| 1 | 0 | 1 | 2 | 0 |
| 1 | 1 | 0 | 2 | 0 |
| 1 | 1 | 1 | 3 | **1** |

No mapa de Karnaugh os quatro 1s ficam isolados, então não há simplificação — a
soma de produtos extraída direto da tabela é a expressão final:

```
impar = (not x2 and not x1 and     x0)
     or (not x2 and     x1 and not x0)
     or (    x2 and not x1 and not x0)
     or (    x2 and     x1 and     x0)
```

Equivale a `x2 xor x1 xor x0` (forma clássica do detector de paridade), mas foi
mantida a soma de produtos por ter vindo direto da tabela verdade.

## Como compilar e simular

```bash
ghdl -a porta.vhd
ghdl -a porta_tb.vhd
ghdl -r porta_tb --wave=porta_tb.ghw
gtkwave porta_tb.ghw
```

Idem para `decoder2x4` e `paridade3` (analisar o circuito primeiro, depois o
testbench, e rodar a entidade do testbench — sem o `.vhd`).

## Estado da verificação

Tudo analisado, elaborado e simulado com **GHDL 4.1.0**: as três simulações
reproduzem exatamente as tabelas verdade acima.

# Processador multiciclo RISC-V — figuras redesenhadas

Material montado a partir de `../microprocessadores.jpeg`.

Fonte original: Patterson & Hennessy, *Computer Organization and Design —
RISC-V Edition*, **seção online 4.5** "A Multicycle Implementation",
Figuras **e4.5.4** (caminho de dados) e **e4.5.12** (máquina de estados),
página 282.e5.

O "e" nos números de figura e na página marca material eletrônico — essa seção
não está no livro impresso. A edição (1ª ou 2ª) não é identificável pela foto.

## Arquivos

| Arquivo | O que é |
|---|---|
| `RISC-V_multiciclo.html` | A página completa: os dois diagramas redesenhados em SVG, explicação bloco a bloco, tabela dos sinais de controle e um simulador ciclo a ciclo. Abre direto no navegador (duplo clique). |
| `figuras-ampliadas/` | Recortes ampliados 3× da foto original, usados para conferir os rótulos. Úteis para checar qualquer detalhe do desenho impresso. |

A mesma página está publicada em:
https://claude.ai/code/artifact/529454c5-2e9c-41ac-83dd-00d4ed33bbdc

## Sobre o HTML

É um arquivo único e autocontido — todo o CSS, o JavaScript e os dois SVGs estão
dentro dele. A única coisa que vem de fora são as fontes do Google Fonts; sem
internet a página continua funcionando, só troca a tipografia.

## Duas observações sobre a figura original

1. **`RegDst` nos estados 4 e 7 da FSM** é herança da edição MIPS. Não existe mux
   RegDst no caminho de dados ao lado, nem `RegDst` entre as saídas da unidade de
   controle. No RISC-V o destino é sempre `rd` = `Instruction[11–7]`.

2. **O rótulo `Instruction [6–0]` entrando no ALU control.** Só o opcode não
   distingue `add` de `sub` de `and` — no RISC-V são todos o mesmo opcode. O que
   o ALU control precisa é de `funct3` = `Instruction[14–12]` e do bit 30
   (`funct7`), que é como a Figura 4.29 do mesmo livro rotula.

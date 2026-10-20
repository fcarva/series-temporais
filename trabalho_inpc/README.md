---
title: "Lista 01 — INPC (roteiro)"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
status: rascunho
tags:
  - series-temporais
  - mestrado/ppgeco
  - trabalho
aliases:
  - Trabalho INPC
---

# Lista 01: modelagem Box-Jenkins do INPC

Este é o trabalho da Lista 01 (LST01, avaliação parcial). A tarefa é modelar uma série real pelo ciclo de Box-Jenkins, da inspeção gráfica à previsão avaliada fora da amostra. O relatório está em [relatorio.md](relatorio.md), e todos os números saem de [inpc.R](inpc.R).

## Arquivos

| Arquivo | O que é |
|---|---|
| [inpc.R](inpc.R) | script único, na ordem das questões Q1 a Q7, mais dois complementos |
| [relatorio.md](relatorio.md) | o texto, com tabelas e figuras; os números são conferidos pelo build |
| `dados_utilizados.csv` | o banco efetivamente usado (jan/2000 a set/2026), gerado pelo script |
| `sessionInfo.txt` | versões do R e dos pacotes, gerado pelo script |
| [grade_sarima.csv](grade_sarima.csv) | log-verossimilhança, AIC e BIC dos 64 SARIMA estimados |
| [previsao_m1.csv](previsao_m1.csv) | previsão de out/2026 a set/2027, com IC de 95% |
| `figuras/` | nove figuras: série, sazonalidade, FAC/FACP, raízes, resíduos, sobrediferenciação, validação, estabilidade e previsão |
| [../dados/inpc.csv](../dados/inpc.csv) | número-índice e variação mensal, mar/1979 a set/2026 (SIDRA, tabela 1736) |

## Roteiro (as questões da Lista 01)

| Questão | Pergunta | Ferramenta | Resposta |
|---|---|---|---|
| 1 | O que o gráfico mostra? É preciso transformar? | série em nível, boxplot mensal | sazonal, sem tendência; nenhuma transformação |
| 2 | Qual é $d$? E $D$? DS ou TS? | ADF (3 especificações), PP, KPSS, OCSB | $d=D=0$ para a variação; o índice é DS |
| 3 | Quais candidatos? | FAC/FACP com 36 defasagens | M1, M2 e M3 (AR(1) com SAR, SMA ou os dois) |
| 4 | Qual modelo? | MV exata, AIC/BIC, raízes | AIC: M1; BIC: M2; fica o M1, para prever |
| 5 | Os resíduos são ruído branco? | Ljung-Box, JB, ARCH-LM, sobreajuste | sim, menos a normalidade |
| 6 | Quanto custa diferenciar demais? | M1 com $d=1$ | raiz MA exatamente unitária |
| 7 | Prevê bem fora da amostra? | 24 meses, origem fixa e móvel, RW e SN | bate o RW, não o SN |
| 8 | Teoria (manuscrita) | dois exercícios da lista teórica | sugestão: Q9 e Q12 |

## Escolhas que a dupla precisa saber defender

1. **Modelar a variação, não o índice.** O índice é I(1), e a variação, que é a sua diferença logarítmica, é I(0). O modelo da variação com $d=0$ é um ARIMA($p$,1,$q$) do log do índice.
2. **A constante no ADF.** Sem ela, o teste não rejeita a raiz unitária, mas essa especificação está errada para uma série de média 0,5 (Q2b).
3. **M1 e não M2.** O AIC e o BIC discordam, como a teoria prevê. Como o objetivo é prever, vale o critério eficiente (Q4e).
4. **O JB rejeita, e isso não invalida o modelo.** O problema é de caudas, por choques identificáveis. Afeta os intervalos, não a consistência.
5. **Perder para o ingênuo sazonal é um resultado.** O enunciado proíbe mudar o modelo para virar o resultado (Q7f).

> [!WARNING]
> **Antes de entregar**
> - Comunicar ao professor a escolha da série.
> - Gerar o PDF: `Rscript caderno/montar_caderno.R`. O volume 3 traz este roteiro e o relatório.
> - Entregar `inpc.R`, `dados_utilizados.csv` e `sessionInfo.txt` junto com o PDF.
> - Resolver à mão a Questão 8.

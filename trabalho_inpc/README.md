---
title: "Trabalho em dupla — INPC (roteiro)"
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

# Trabalho em dupla: INPC

A tarefa é estimar um modelo da família ARIMA/SARIMA para o INPC mensal e defender a escolha. O relatório está em [relatorio.md](relatorio.md), e todos os números saem de [inpc.R](inpc.R).

## Arquivos

| Arquivo | O que é |
|---|---|
| [inpc.R](inpc.R) | script único: identificação → estimação → diagnóstico → estabilidade → previsão |
| [relatorio.md](relatorio.md) | o texto, com tabelas e figuras; os números são conferidos pelo build |
| [grade_sarima.csv](grade_sarima.csv) | log-verossimilhança, AIC e BIC dos 64 SARIMA estimados |
| [previsao_m1.csv](previsao_m1.csv) | previsão de out/2026 a set/2027, com IC de 95% |
| `figuras/` | seis figuras: séries, sazonalidade, FAC/FACP, resíduos, estabilidade e previsão |
| [../dados/inpc.csv](../dados/inpc.csv) | número-índice e variação mensal, mar/1979 a set/2026 (SIDRA, tabela 1736) |

## Roteiro (o ciclo de Box-Jenkins da AU03)

| Etapa | Pergunta | Ferramenta | Seção |
|---|---|---|---|
| 1. Dados | Qual série e qual amostra? | variação mensal, jan/2000 a set/2026 | §1 |
| 2. Identificação | É estacionária? Tem sazonalidade? Qual ordem? | gráficos, ADF, KPSS, FAC/FACP | §2 |
| 3. Estimação | Qual modelo? | MV exata, grade SARIMA, AIC/BIC | §3 |
| 4. Diagnóstico | Os resíduos são ruído branco? | Ljung-Box, ARCH-LM, Jarque-Bera, QQ-plot | §4 |
| 5. Estabilidade | Os parâmetros são constantes? | Chow (mar/2020), CUSUM, estimação recursiva | §5 |
| 6. Avaliação | Prevê bem fora da amostra? | janela recursiva, RMSE/MAD/MASE, DM, Winkler | §6 |
| 7. Previsão | E os próximos 12 meses? | M1 com IC de 95% | §7 |

## Escolhas que a dupla precisa saber defender

1. **Variação mensal, não o índice.** O índice é I(1), e a variação, que é a sua diferença logarítmica, é I(0). O modelo ARMA da variação é um ARIMA(p,1,q) do log do índice (lista, Q10a).
2. **Não diferenciar a inflação.** Ela já é estacionária, e diferenciar de novo cria MA não invertível (Q9).
3. **Início em 2000.** O regime de metas começa em 1999. Antes disso há quebras de regime óbvias.
4. **M1 ou M2.** O AIC e o BIC discordam, como previsto pela teoria (Q14b). A escolha depende do objetivo (prever ou identificar) e deve ser dita explicitamente.
5. **JB rejeita, e isso não invalida o modelo.** O problema é de caudas, por choques identificáveis. Isso afeta os intervalos, não a consistência.

## O que ainda depende do enunciado do professor

> [!WARNING]
> **Confira antes de entregar**
> - **Período amostral e tamanho do teste.** Se o enunciado fixar outra amostra, mude `INICIO` e `N_TESTE` em `inpc.R` e rode o build: ele aponta cada frase que precisa ser reescrita.
> - **Formato da entrega** (PDF, script, apresentação). O relatório em Markdown vira PDF com `pandoc relatorio.md -o relatorio.pdf`, se houver LaTeX instalado.
> - **Se o professor pedir a série em nível** (índice) em vez da variação: o caminho é ARIMA($p$,1,$q$) no log. O §2 já justifica, e basta ajustar o `ajusta()`.

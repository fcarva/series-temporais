---
title: "Índice de materiais (locais, fora do git)"
tags:
  - series-temporais
  - meta
aliases:
  - Materiais — séries temporais
---

# Índice de materiais

Os PDFs ficam em `materiais/`, que está **no `.gitignore`**: o repositório é público. Os originais estão na pasta "Econometria II" do Google Drive. O texto extraído fica em `materiais/_txt/<id>.txt` (`pdftotext -layout -enc UTF-8`) e alimenta o detector de cópia do lint.

## Aulas (Prof. Guilherme Pereira, Econometria II, PPGEco/UFES, 2026)

| Id | Arquivo local | Tema | Págs. | Módulos |
|---|---|---|---|---|
| AU01 | `materiais/aulas/aula_01_ppgeco_2026.pdf` | Introdução: estacionariedade, ergodicidade, processos de referência, FAC e FACP, momentos do passeio aleatório | 50 | 01 |
| AU02 | `materiais/aulas/aula_02_ppgeco_2026.pdf` | Processos estacionários: equações a diferenças, operador $L$, processo linear geral, estacionariedade e invertibilidade, MA($q$), AR($p$), ARMA, Yule-Walker, FACP, estimação por MV, AIC e BIC | 99 | 01, 02, 04, 05 |
| AU03 | `materiais/aulas/aula_03_ppgeco_2026.pdf` | Diagnóstico e avaliação: Box-Jenkins, JB, Ljung-Box, Breusch-Godfrey, ARCH, Chow, CUSUM, janelas, previsão iterada × direta, RMSE/MAD/MAPE/MASE, Diebold-Mariano, Winkler, CRPS, Christoffersen | 60 | 04, 05, trabalho |
| MAT | `materiais/aulas/tendencias_raizes_unitarias.pdf` | MATTOS, R. S. *Tendências e raízes unitárias*. UFJF, 2019: tendência determinística × estocástica, Beveridge-Nelson, Dickey-Fuller | 50 | 01, 03 |

## Lista

| Id | Arquivo local | Conteúdo |
|---|---|---|
| LST | `materiais/listas/exercicios_arma_arima_sarima_2026.pdf` | **Lista de exercícios: processos ARMA, ARIMA e SARIMA** (16 questões, 6 blocos). Mapa no [README](README.md) |

## Livros (pasta "Econometria II" no Drive)

| Id | Referência | Para quê |
|---|---|---|
| ENDERS | ENDERS, W. *Applied Econometric Time Series*. 4ª ed. Wiley, 2014 | caps. 1–2 (equações a diferenças, ARMA) e 4 (raiz unitária): o nível do curso |
| HAMILTON | HAMILTON, J. D. *Time Series Analysis*. Princeton, 1994 | caps. 2–5: operadores, ARMA, previsão e MV com rigor |
| BJRL | BOX, G.; JENKINS, G.; REINSEL, G.; LJUNG, G. *Time Series Analysis: Forecasting and Control*. 5ª ed. Wiley, 2016 | a convenção de sinal da lista; SARIMA (cap. 9), previsão (cap. 5) |
| TSAY | TSAY, R. S. *Analysis of Financial Time Series*. 3ª ed. Wiley, 2010 | cap. 2 (modelos lineares) e 3 (heterocedasticidade condicional) |

## Dados

| Id | Fonte | Arquivo |
|---|---|---|
| INPC | IBGE, SIDRA, tabela 1736 (variáveis 44 e 2289) | [dados/inpc.csv](dados/inpc.csv), versionado, atualizado por `scripts/baixar_inpc.R` |

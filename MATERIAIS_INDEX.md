---
title: "Índice de materiais (locais, fora do git)"
tags:
  - series-temporais
  - meta
aliases:
  - Materiais — séries temporais
---

# Índice de materiais

Os PDFs ficam em `materiais/`, que está **no `.gitignore`**: o repositório é público. Os originais estão na pasta "Econometria II" do Google Drive. O texto extraído fica em `materiais/_txt/<id>.txt` (`pdftotext -layout -enc UTF-8`) e alimenta o detector de cópia do lint. Os links abaixo abrem no Obsidian e nos clones que têm `materiais/`; no GitHub, não.

## Aulas (Prof. Guilherme Pereira, Econometria II, PPGEco/UFES, 2026)

| Id | Arquivo local | Tema | Págs. | Módulos |
|---|---|---|---|---|
| EQD | [revisao_equacoes_diferencas.pdf](materiais/aulas/revisao_equacoes_diferencas.pdf) | Revisão de equações de diferenças de 1ª e 2ª ordem (CHIANG; WAINWRIGHT, caps. 17–18) | 26 | 01, 02 |
| AU01 | [aula_01_ppgeco_2026.pdf](materiais/aulas/aula_01_ppgeco_2026.pdf) | Introdução: estacionariedade, ergodicidade, processos de referência, FAC e FACP, momentos do passeio aleatório | 50 | 01 |
| AU02 | [aula_02_ppgeco_2026.pdf](materiais/aulas/aula_02_ppgeco_2026.pdf) | Processos estacionários: equações a diferenças, operador $L$, processo linear geral, estacionariedade e invertibilidade, MA($q$), AR($p$), ARMA, Yule-Walker, FACP, estimação por MV, AIC e BIC | 99 | 01, 02, 04, 05 |
| AU03 | [aula_03_ppgeco_2026.pdf](materiais/aulas/aula_03_ppgeco_2026.pdf) | Diagnóstico e avaliação: Box-Jenkins, JB, Ljung-Box, Breusch-Godfrey, ARCH, Chow, CUSUM, janelas, previsão iterada × direta, RMSE/MAD/MAPE/MASE, Diebold-Mariano, Winkler, CRPS, Christoffersen | 60 | 04, 05, trabalho |
| AU04 | [aula_04_ppgeco_2026.pdf](materiais/aulas/aula_04_ppgeco_2026.pdf) | Tendência determinística × estocástica e testes de raiz unitária | 42 | 03 |
| AU05 | [aula_05_ppgeco_2026.pdf](materiais/aulas/aula_05_ppgeco_2026.pdf) | ARIMA e SARIMA | 21 | 03, 06 |
| AU06 | [aula_06_ppgeco_2026.pdf](materiais/aulas/aula_06_ppgeco_2026.pdf) | Regressão com séries temporais: exogeneidade, DL, ARDL, ECM, causalidade de Granger | 56 | — |
| MAT | [tendencias_raizes_unitarias.pdf](materiais/aulas/tendencias_raizes_unitarias.pdf) | MATTOS, R. S. *Tendências e raízes unitárias*. UFJF, 2019: tendência determinística × estocástica, Beveridge-Nelson, Dickey-Fuller | 50 | 01, 03 |

## Listas

| Id | Arquivo local | Conteúdo |
|---|---|---|
| LST | [exercicios_arma_arima_sarima_2026.pdf](materiais/listas/exercicios_arma_arima_sarima_2026.pdf) | **Lista de exercícios: processos ARMA, ARIMA e SARIMA** (16 questões, 6 blocos). Mapa no [README](README.md) |
| LST01 | [lista_01_2026_empirica.pdf](materiais/listas/lista_01_2026_empirica.pdf) | **Lista 01, avaliação parcial**: modelagem Box-Jenkins de uma série (Q1–Q7 empíricas, Q8 teórica manuscrita). Resolvida em [trabalho_inpc](trabalho_inpc/README.md) |

## Livros (pasta "Econometria II" no Drive)

| Id | Referência | Para quê |
|---|---|---|
| ENDERS | [ENDERS, W. *Applied Econometric Time Series*. 4ª ed. Wiley, 2014](materiais/livros/enders_2014.pdf) | caps. 1–2 (equações a diferenças, ARMA) e 4 (raiz unitária): o nível do curso |
| HAMILTON | [HAMILTON, J. D. *Time Series Analysis*. Princeton, 1994](materiais/livros/hamilton_1994.pdf) | caps. 2–5: operadores, ARMA, previsão e MV com rigor |
| BJRL | [BOX, G.; JENKINS, G.; REINSEL, G.; LJUNG, G. *Time Series Analysis: Forecasting and Control*. 5ª ed. Wiley, 2016](materiais/livros/box_jenkins_reinsel_ljung.pdf) | a convenção de sinal da lista; SARIMA (cap. 9), previsão (cap. 5). PDF escaneado, sem texto pesquisável |
| TSAY | [TSAY, R. S. *Analysis of Financial Time Series*. 3ª ed. Wiley, 2010](materiais/livros/tsay_2010.pdf) | cap. 2 (modelos lineares) e 3 (heterocedasticidade condicional) |
| PESARAN | [PESARAN, M. H. *Time Series and Panel Data Econometrics*. Oxford, 2015](materiais/livros/pesaran_2015.pdf) | referência avançada; ARDL e cointegração (aula 06) |

Lista de leituras do curso: [leituras_2026.xlsx](materiais/leituras_2026.xlsx).

## Dados

| Id | Fonte | Arquivo |
|---|---|---|
| INPC | IBGE, SIDRA, tabela 1736 (variáveis 44 e 2289) | [dados/inpc.csv](dados/inpc.csv), versionado, atualizado por `scripts/baixar_inpc.R` |

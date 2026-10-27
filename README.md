---
title: "Econometria II — séries temporais"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
tags:
  - series-temporais
  - mestrado/ppgeco
aliases:
  - Séries temporais — repositório
---

# Econometria II: séries temporais

Material de estudo de Econometria II (PPGEco/UFES, 2026, Prof. Guilherme Pereira). A **primeira parte** cobre os processos ARMA, ARIMA e SARIMA. A **segunda** começa com a regressão com séries temporais: DL, ARDL, ECM e Granger, no [módulo 07](07_regressao_dinamica/07_teoria.md). O repositório tem três produtos:

1. **A lista de exercícios resolvida.** São as 16 questões da lista "Processos ARMA, ARIMA e SARIMA", com a demonstração passo a passo e cada número conferido em R.
2. **O módulo de regressão dinâmica (AU06).** Teoria com demonstrações e sete exercícios próprios, alguns de Monte Carlo, também conferidos em R.
3. **O trabalho em dupla (Lista 01, avaliação parcial).** É a modelagem Box-Jenkins do **INPC** mensal, questão por questão: inspeção, raiz unitária, identificação, estimação, diagnóstico, sobrediferenciação e previsão fora da amostra, com relatório e código reprodutível.

É o mesmo desenho do repositório de Econometria I: notas em Markdown compatíveis com o Obsidian (abra **a raiz do repositório** como cofre), scripts R que geram todos os números, testes e um build que confere nota contra R.

> [!IMPORTANT]
> **Material de terceiros fica fora do git**
> Aulas, lista e livros moram em `materiais/`, que está no `.gitignore`: o repositório é público. As notas citam os materiais por id (`AU02`, `LST`, `MAT`). Ver [MATERIAIS_INDEX.md](MATERIAIS_INDEX.md).

## Início rápido

Linux ou macOS, da raiz:

```bash
Rscript R/00_setup.R          # instala forecast, tseries, urca, lmtest, strucchange, testthat, jsonlite
bash scripts/build.sh         # testes, todos os scripts, conferência dos números e lint
```

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File scripts\build.ps1
```

Para só o trabalho do INPC: `Rscript trabalho_inpc/inpc.R`. Para atualizar a série com o último mês do IBGE: `Rscript scripts/baixar_inpc.R` e, depois, o build. Ele aponta quais números do relatório mudaram.

## Como estudar

| Para… | Abra |
|---|---|
| **Treinar para a prova de 05/11** | [prova/](prova/README.md): guia com estratégia de tempo e as lições da P1 de Econometria I, [banco de variações](prova/banco.md) das 16 questões, três simulados com gabarito e rubrica e o [log de erros](prova/log_erros.md); no papel, `caderno/pdf/caderno_volume5_prova.pdf` e `caderno_prova_simulados.pdf` |
| **Fazer o trabalho em dupla (Lista 01)** | [trabalho_inpc/](trabalho_inpc/README.md): roteiro, [relatório](trabalho_inpc/relatorio.md) e [código](trabalho_inpc/inpc.R) |
| Entender a lógica e a ordem de estudo | [PLANO_ESTUDO.md](PLANO_ESTUDO.md) |
| Revisar fórmulas | [formulario/formulario.md](formulario/formulario.md) |
| **Estudar a Lista 01 para a prova** | [guia de estudo](lista01/guia_estudo.md): o porquê de cada teste, armadilhas e 20 perguntas com resposta |
| **Lista 01 (entrega): código, relatório e laboratório** | [lista01/](lista01/README.md): INPC de jan/2013 a set/2026; scripts Q1–Q7, `relatorio_lista01.Rmd` e o [laboratório](lista01/laboratorio_lista01.md) em script único |
| Estudar no papel | `caderno/`: três volumes em PDF (ver [caderno/README.md](caderno/README.md)) |
| Levar tudo para o Obsidian | `Rscript scripts/exportar_obsidian.R`: espelha o repositório numa pasta do cofre `88f5c4b837449c13` |
| Saber qual sinal usar no MA | [CONVENCOES.md](CONVENCOES.md) §2 |
| Estudar DL, ARDL, ECM e Granger (AU06) | [07_teoria](07_regressao_dinamica/07_teoria.md) e [07_lista](07_regressao_dinamica/07_lista.md) |
| Achar um exercício | o mapa abaixo |

## Mapa da lista (16 questões)

| Bloco da lista | Questões | Módulo | Resolução | Teoria |
|---|---|---|---|---|
| 1. Processos, estacionariedade e momentos | Q1–Q4 | 01 | [01_lista](01_processos_estacionariedade/01_lista.md) | [01_teoria](01_processos_estacionariedade/01_teoria.md) |
| 2. AR, MA e ARMA | Q5–Q8 | 02 | [02_lista](02_arma/02_lista.md) | [02_teoria](02_arma/02_teoria.md) |
| 3. Integrados, ARIMA e SARIMA | Q9–Q12 | 03 | [03_lista](03_arima_sarima/03_lista.md) | [03_teoria](03_arima_sarima/03_teoria.md) |
| 4. Identificação, estimação e diagnóstico | Q13–Q14 | 04 | [04_lista](04_estimacao_selecao/04_lista.md) | na própria nota |
| 5. Previsão | Q15 | 05 | [05_lista](05_previsao/05_lista.md) | na própria nota |
| 6. Aplicações | Q16 | 06 | [06_lista](06_aplicacao_sarima/06_lista.md) | — |

| Q | Em uma linha | Resposta-chave |
|---|---|---|
| 1 | Momentos do passeio com drift | $E=10+ct$, $\operatorname{Var}=t\sigma^2$, $\operatorname{Cov}=(t-k)\sigma^2$: não estacionário |
| 2 | Passeio com drift e tendência | média quadrática, mesma variância; $\Delta$ e depois tirar a tendência |
| 3 | FAC de $z_1+2z_2$ | $\gamma=(9{,}70;\ -5{,}52;\ 1{,}20;\ 0,\dots)$: MA(2) |
| 4 | Wold | AR(1): $\psi_j=\phi^j$; invertibilidade ⇒ AR($\infty$) convergente |
| 5 | Três modelos em $B$ | AR(1); MA(2) invertível; o terceiro é um **MA(1) disfarçado** (fator comum) |
| 6 | ARMA(1,1) | $\rho_k=\phi^{k-1}\rho_1$; $\psi_j=(\phi-\theta)\phi^{j-1}$, $\pi_j=(\phi-\theta)\theta^{j-1}$ |
| 7 | AR(2) | $\rho_1=\phi_1/(1-\phi_2)$; $\gamma_0$ fechado |
| 8 | V ou F | V, F, F, F, F |
| 9 | Sobrediferenciação | $(1-\phi B)w_t=(1-B)\varepsilon_t$: MA não invertível |
| 10 | ARIMA × tendência determinística | DS × TS; diferenciar TS cria MA(1) com $\theta=1$ |
| 11 | SAR(1)$_4$ | FAC só em $4m$; o multiplicativo é um AR(5) com 3 restrições |
| 12 | SARIMA(1,1,0)(0,1,1)$_4$ | perde 5 obs.; equações de previsão; o MA some a partir de $h=5$ |
| 13 | MV condicional do AR(1) | é o MQO |
| 14 | AIC e BIC | os dois escolhem o ARMA(1,1); BIC consistente, AIC eficiente |
| 15 | Previsão ARMA | $E(\cdot\mid\mathcal F_T)$; erro MA($h-1$); ARIMA(0,1,1) = SES com $\alpha=1-\theta$ |
| 16 | SARIMA(1,1,1)(0,1,1)$_{12}$ | 4 parâmetros; FAC com grupo 11-12-13; BIC ou LR |

## O trabalho do INPC (Lista 01) em quatro linhas

1. A variação mensal é I(0), sem raiz unitária sazonal ($d=D=0$). ADF com constante, PP e KPSS concordam, e o log do índice é I(1).
2. A FAC e a FACP apontam para um AR(1) com sazonalidade de 12 meses. O AIC escolhe o SARIMA(1,0,0)(1,0,1)₁₂, e o BIC escolhe o SARIMA(1,0,0)(1,0,0)₁₂. Fica o primeiro, porque o objetivo é prever.
3. Os resíduos são ruído branco, sem ARCH, mas não normais. O sobreajuste não acrescenta nada, e uma diferença a mais leva o MA à raiz unitária.
4. Nos 24 meses de validação, o modelo bate o passeio aleatório, mas não o ingênuo sazonal.

Os detalhes estão em [trabalho_inpc/relatorio.md](trabalho_inpc/relatorio.md).

## Estrutura

```text
series-temporais/
├── NN_tema/          módulo: NN_teoria.md, NN_lista.md, NN_tema.R, figuras/ (01–06: parte 1; 07: regressão dinâmica)
├── prova/           prova de 05/11: guia, banco de variações, 3 simulados + gabaritos, log de erros, prova.R
├── trabalho_inpc/    Lista 01: inpc.R, relatorio.md, figuras/, dados usados, sessionInfo, grade e previsões em CSV
├── dados/            inpc.csv (IBGE/SIDRA, público)
├── formulario/       todas as fórmulas
├── caderno/          gera o caderno em PDF (pandoc + LuaLaTeX); o PDF fica fora do git
├── R/                helpers (raiz, resultados, estilo gráfico, séries: pesos, raízes, FAC teórica, multiplicadores do ARDL)
├── tests/testthat/   identidades da teoria conferidas contra o R
├── scripts/          build.sh, build.ps1, run_all, check_numbers, lint, baixar_inpc
├── resultados/       números gerados pelos scripts (conferidos contra as notas)
└── materiais/        (fora do git) aulas, lista, livros, texto extraído
```

## Estado atual

Build completo passando em 27/10/2026 (dados até set/2026): **229 testes** do testthat, **17 scripts** executados (inclusive `prova/prova.R`), **991 números** das notas conferidos contra o R e lint sem erros. O trabalho do INPC segue o enunciado da Lista 01, questão por questão.

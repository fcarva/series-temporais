---
title: "Lista 01 — versão completa em R (pós-graduação)"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
status: rascunho
tags:
  - series-temporais
  - mestrado/ppgeco
  - trabalho
aliases:
  - Lista 01 — código completo
---

# Lista 01: o código completo, questão por questão

Esta pasta é uma versão autossuficiente da parte empírica da Lista 01 (Questões 1 a 7), pronta para entregar. Ela segue as normas de entrega:
- o código comentado, na ordem de execução;
- o banco efetivamente usado;
- o `sessionInfo()`;
- o relatório em PDF, gerado direto do código, sem nenhum número digitado à mão.

A série é o **INPC em nível** (número-índice), de **jan/2013 a set/2026 (165 meses)**, modelado como $y_t=100\ln P_t$. A série longa, de jan/2000 a set/2026, fica em `dados/inpc_2000_2026.csv` e entra só como checagem de robustez (Q2d e seção 8 do guia). A diferença em relação a [trabalho_inpc/](../trabalho_inpc/README.md) é a série de partida: lá a série modelada é a variação mensal, com $d=0$; aqui é o índice, com $d=1$. Os modelos são equivalentes (um SARMA para $\Delta y$ é um SARIMA com $d=1$ para $y$). Partir do índice, porém, exercita todas as etapas que o enunciado pede: transformação, testes no nível e na diferença e sobrediferenciação para $d=2$.

> [!TIP]
> **Para estudar para a prova**
> Comece pelo [guia de estudo](guia_estudo.md). Ele explica, questão por questão, o que cada passo está tentando descobrir, por que cada teste e não outro, como o teste funciona por dentro e o que o INPC respondeu. Explica também por que a janela é 2013–2026 e não 2000–2026. Termina com as armadilhas mais comuns e 20 perguntas de prova com resposta.

## A versão da dupla em Quarto (variação mensal, $d=0$)

A pasta [dupla/](dupla/revisao.md) tem a versão em Quarto feita pela dupla, que modela a variação mensal do INPC com $d=0$. Ela foi revisada e completada: [inpc_lista_1_revisado.qmd](dupla/inpc_lista_1_revisado.qmd), com a base `dupla/inpc_13_a_26.csv`. A [revisão](dupla/revisao.md) lista o que estava errado e por quê.

## O jeito mais simples: um script só, em qualquer lugar

[lista01_inpc.R](lista01_inpc.R) é autossuficiente. Copie-o para qualquer pasta e rode no RStudio, bloco a bloco, ou com `Rscript lista01_inpc.R`; é preciso ter R e internet. O script:
1. instala os pacotes que faltarem (`forecast`, `tseries`, `urca`, `lmtest`, `FinTS`, `jsonlite`);
2. baixa o INPC da API do IBGE (SIDRA, tabela 1736), com o período fixo jan/2013–set/2026, definido em duas linhas no topo (`INICIO` e `FIM`);
3. roda os testes das Questões 1 a 7 na ordem da lista.

Cada passo é comentado como num roteiro de investigação: a pergunta, a fórmula por extenso, as hipóteses, o que esperar sob $H_0$ e como ler o resultado. Os testes imprimem a decisão em português, e os gráficos aparecem na janela de plots, já anotados (no gráfico da previsão, por exemplo, a cobertura do intervalo aparece no título). O script grava na pasta a base usada (`inpc_lista01.csv`) e as versões dos pacotes (`sessionInfo_lista01.txt`).

## Como rodar a versão completa

```bash
Rscript lista01/rodar_tudo.R            # scripts 01–07 + relatorio_lista01.pdf
Rscript lista01/rodar_tudo.R --sem-pdf  # só os scripts
```

No Windows, use `scripts\r.ps1 lista01\rodar_tudo.R`. Para o PDF é preciso LaTeX com LuaLaTeX e as fontes Libertinus (TeX Live ou MiKTeX).

## Laboratório com `sidrar` e auditoria (comece por aqui)

[lab/lab_inpc.R](lab/lab_inpc.R) é a versão para mexer no RStudio. Ela baixa o INPC com o `sidrar` (com cache em `lab/dados/`), deixa todos os parâmetros na seção 0 (janela, candidatos, modelo escolhido, horizonte, data do Chow) e segue o ciclo de Box-Jenkins da aula 03. Responde cada item da Q1 à Q7 com tabelas no formato do enunciado, sem nenhum número digitado nos comentários. Ver [lab/README.md](lab/README.md).

A [auditoria](AUDITORIA.md) cruza o enunciado, os slides e as seis versões do trabalho que existem no repositório. O principal achado é que as versões chegam a conclusões opostas na Q7. No índice, o SARIMA bate os benchmarks; na inflação mensal, não bate o sazonal ingênuo. As duas leituras estão certas, e a entrega precisa mostrar as duas.

## Laboratório: a lista inteira num script simples

[laboratorio_lista01.R](laboratorio_lista01.R) é um **script R único e linear**, com cerca de 300 linhas e nenhuma função própria. Ele lê a base, roda a bateria de testes e responde cada item da lista nos comentários `#'`. Usa as bibliotecas principais:
- `forecast`: `Arima`, `forecast`, `accuracy`, `checkresiduals`, `ndiffs`/`nsdiffs`;
- `urca`: `ur.df`, `ur.pp`, `ur.kpss`;
- `tseries`: Jarque-Bera e KPSS;
- `lmtest`: `coeftest`;
- `FinTS`: ARCH-LM.

É o arquivo para estudar rodando no RStudio. Os scripts `01_`…`07_` e o `relatorio_lista01.Rmd` são a versão completa. Todas as versões usam só as ferramentas das aulas 01 a 03, do texto de Mattos (2019), leitura do curso para raiz unitária, e as que o enunciado pede. O comando `Rscript lista01/renderizar_laboratorio.R` transforma o laboratório em PDF e na nota [laboratorio_lista01.md](laboratorio_lista01.md), que aparece no Obsidian e no volume 4 do caderno.

## Arquivos, na ordem de execução

| Arquivo | Questão | O que faz e com quais ferramentas |
|---|---|---|
| `00_configuracao.R` | — | pacotes, semente, caminhos e funções auxiliares (correlograma com banda $\pm1{,}96/\sqrt T$, polinômios regular × sazonal, raízes inversas) |
| `01_dados_inspecao.R` | Q1 | gráficos em nível e em log; amplitude × média anual; inflação média de cada ano e de cada mês; maiores e menores valores |
| `02_raiz_unitaria.R` | Q2 | ADF (`urca::ur.df`, defasagens por AIC/BIC com $p_{\max}$ de Schwert, p-valor de MacKinnon), PP, KPSS; as três versões do ADF lidas como em Mattos (2019, seção 2.2); ADF com 11 dummies sazonais centradas (MAT, seção 2.6) para $D$; DF-GLS (MAT, seção 2.4) e a série longa (2000–2026) para DS × TS |
| `03_identificacao.R` | Q3 | FAC/FACP com 48 defasagens, banda $\pm1{,}96/\sqrt T$, leitura em $s-1,s,s+1$; três candidatos |
| `04_estimacao_selecao.R` | Q4 | MV exata dos candidatos; tabela única; conferência numérica de que $\sigma^2$ entra em $k$; regra de parcimônia quando AIC e BIC divergem; raízes no círculo unitário; grade de 64 SARIMA |
| `05_diagnostico.R` | Q5 | painel de resíduos; Ljung-Box com $\nu=K-(p+q+P+Q)$; Jarque-Bera; ARCH-LM (`FinTS`); McLeod-Li; Chow em mar/2020, CUSUM e CUSUM-Q (`strucchange`, aula 03); caminho dos 64 modelos com o motivo de cada descarte; sobreajuste com teste $t$ |
| `06_sobrediferenciacao.R` | Q6 | o modelo com $d=2$, com e sem o MA extra: $\widehat\theta$, raiz MA, $\widehat\sigma^2$, FAC; o $\rho_1$ teórico de $\Delta^2y$ |
| `07_previsao.R` | Q7 | 24 meses de validação; esquema 1 (origem fixa) e 2 (um passo, coeficientes fixos via `Arima(y, model = ...)`); RMSE/MAE/MAPE contra passeio aleatório e sazonal ingênuo; Diebold-Mariano (HLN) e cobertura incondicional de Christoffersen ($LR_{uc}$), da aula 03 |
| `rodar_tudo.R` | — | roda tudo em processos separados, grava `saidas/sessionInfo.txt` e gera o PDF |
| `relatorio_lista01.Rmd` | Q1–Q7 | o relatório: lê `saidas/` e escreve cada número inline |
| `dados/inpc_lista01.csv` | — | o banco: INPC (SIDRA, tabela 1736), jan/2013 a set/2026 |
| `dados/inpc_2000_2026.csv` | Q2(d) | a série longa, só para a checagem de robustez |
| `simples/lista01_simples.qmd` | Q1–Q8 | a versão simples, para propor à dupla: só a pergunta, o código curto (`forecast`, `urca`, `tseries`, `lmtest`, `FinTS`) e uma frase por resultado; baixa o INPC direto do SIDRA com `sidrar` e compara o ARIMA sem sazonal com o SARIMA |
| `referencias_inpc.md` | Q2 e relatório | a literatura sobre modelar um índice de preços (preços I(1) × I(2)), o exemplo 3 do Mattos lado a lado com o INPC e o que citar |

## O que o código encontrou (para estudar)

| Questão | Resultado |
|---|---|
| Q1 | índice com tendência; a inflação média anual vai de 0,17% a.m. (2017) a 0,89% a.m. (2015); sazonalidade em $\Delta y$ (fev, mar e dez altos; ago baixo); o gráfico de amplitude × média não decide, e o log é escolhido pela interpretação |
| Q2 | nenhum teste rejeita a raiz unitária no nível (ADF com AIC e BIC, com e sem dummies sazonais, PP, DF-GLS); na versão com tendência, isso quer dizer DS (MAT); o KPSS também não rejeita (dados pouco informativos). Adota-se $d=1$; $D=0$ (dummies sazonais significativas e FAC sazonal que cai logo). Com a série longa, o ADF passa a rejeitar e o KPSS também: conflito causado pela crise de 2002–2003 |
| Q3 | FACP com pico em 1 e valor no limite da banda em 2; sazonalidade fraca em 12; candidatos AR(1)+SAR, AR(1)+SMA e AR(2)+SAR |
| Q4 | o AIC escolhe SARIMA(2,1,0)(1,0,0)₁₂ e o BIC escolhe SARIMA(1,1,0)(1,0,0)₁₂; o $\phi_2$ do primeiro não é significativo ($p=0{,}11$): pela parcimônia, fica o SARIMA(1,1,0)(1,0,0)₁₂ |
| Q5 | ruído branco e sem ARCH; o JB rejeita por caudas (choques de jun/2018, jul/2022 e fev/2025); Chow ($p=0{,}77$), CUSUM ($p=0{,}37$) e CUSUM-Q não rejeitam a estabilidade; o sobreajuste não é significativo |
| Q6 | com $d=2$, $\widehat\theta=-1{,}0000$ (raiz MA unitária); $\widehat\sigma^2$ sobe 19,9% sem o MA extra; o AR troca de sinal |
| Q7 | bate o passeio aleatório e o sazonal ingênuo nos dois esquemas (DM significativo a 5%); cobertura de 100% no esquema 1 e de 92% no esquema 2 |

> [!WARNING]
> **Antes de entregar**
> - Trocar `[nomes da dupla]` no cabeçalho do `.Rmd`.
> - Comunicar ao professor a escolha da série.
> - Entregar a pasta inteira: o código, `dados/`, `saidas/sessionInfo.txt` e o PDF.
> - Questão 8: resolver à mão dois exercícios da lista teórica (sugestão: Q6 e Q12, resolvidos em [02_lista](../02_arma/02_lista.md) e [03_lista](../03_arima_sarima/03_lista.md)).

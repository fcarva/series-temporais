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

A série é o **INPC em nível** (número-índice), modelado como $y_t=100\ln P_t$. A diferença em relação a [trabalho_inpc/](../trabalho_inpc/README.md) é a série de partida: lá a série modelada é a variação mensal, com $d=0$; aqui é o índice, com $d=1$. Os modelos são equivalentes (um SARMA para $\Delta y$ é um SARIMA com $d=1$ para $y$). Partir do índice, porém, exercita todas as etapas que o enunciado pede: transformação, testes no nível e na diferença e sobrediferenciação para $d=2$.

## O jeito mais simples: um script só, em qualquer lugar

[lista01_inpc.R](lista01_inpc.R) é autossuficiente e não depende do repositório. Basta copiá-lo para qualquer pasta e rodar `Rscript lista01_inpc.R`, numa máquina com R e internet. O script:
1. instala os pacotes que faltarem (`forecast`, `tseries`, `urca`, `lmtest`, `FinTS`, `jsonlite`);
2. baixa o INPC da API do IBGE (SIDRA, tabela 1736), com o período fixo jan/2000–set/2026;
3. roda os testes das Questões 1 a 7, com a resposta de cada item em comentário.

Ele deixa na pasta a base usada (`inpc_lista01.csv`), os gráficos (`graficos_lista01.pdf`) e as versões dos pacotes (`sessionInfo_lista01.txt`). Esses são os três itens de reprodutibilidade que as normas de entrega pedem.

## Como rodar a versão completa

```bash
Rscript lista01/rodar_tudo.R            # scripts 01–07 + relatorio_lista01.pdf
Rscript lista01/rodar_tudo.R --sem-pdf  # só os scripts
```

No Windows, use `scripts\r.ps1 lista01\rodar_tudo.R`. Para o PDF é preciso LaTeX com LuaLaTeX e as fontes Libertinus (TeX Live ou MiKTeX).

## Laboratório: a lista inteira num script simples

[laboratorio_lista01.R](laboratorio_lista01.R) é um **script R único e linear**, com cerca de 300 linhas e nenhuma função própria. Ele lê a base, roda a bateria de testes e responde cada item da lista nos comentários `#'`. Usa as bibliotecas principais:
- `forecast`: `Arima`, `forecast`, `accuracy`, `checkresiduals`, `ndiffs`/`nsdiffs`;
- `urca`: `ur.df`, `ur.pp`, `ur.kpss`;
- `tseries`: Jarque-Bera e KPSS;
- `lmtest`: `coeftest`;
- `FinTS`: ARCH-LM.

É o arquivo para estudar rodando no RStudio. Os scripts `01_`…`07_` e o `relatorio_lista01.Rmd` são a versão completa, com os testes extras de robustez. O comando `Rscript lista01/renderizar_laboratorio.R` transforma o laboratório em PDF e na nota [laboratorio_lista01.md](laboratorio_lista01.md), que aparece no Obsidian e no volume 4 do caderno.

## Arquivos, na ordem de execução

| Arquivo | Questão | O que faz e com quais ferramentas |
|---|---|---|
| `00_configuracao.R` | — | pacotes, semente, caminhos e funções auxiliares (correlograma com banda de Bartlett, polinômios regular × sazonal, raízes inversas) |
| `01_dados_inspecao.R` | Q1 | gráficos em nível e em log; amplitude × média e $\lambda$ de Box-Cox (Guerrero e MV); quebras na inclinação (Bai-Perron, `strucchange`); outliers AO/LS/TC (Chen-Liu, `tsoutliers`); sazonalidade |
| `02_raiz_unitaria.R` | Q2 | ADF (`urca::ur.df`, defasagens por AIC/BIC com $p_{\max}$ de Schwert, p-valor de MacKinnon), PP, KPSS; procedimento sequencial de Dolado et al. com $\tau_3,\phi_3,\phi_2,\tau_2,\phi_1,\tau_1$; OCSB, Canova-Hansen e HEGY (`uroot`) para $D$; DF-GLS, Zivot-Andrews e subamostra pós-quebra para DS × TS |
| `03_identificacao.R` | Q3 | FAC/FACP com 48 defasagens, bandas $\pm1{,}96/\sqrt T$ e de Bartlett, leitura em $s-1,s,s+1$; três candidatos |
| `04_estimacao_selecao.R` | Q4 | MV exata dos candidatos (e de um extra com dummies sazonais acumuladas); tabela única; conferência numérica de que $\sigma^2$ entra em $k$; pesos de Akaike; LR; raízes no círculo unitário; grade de 64 SARIMA |
| `05_diagnostico.R` | Q5 | painel de resíduos; Ljung-Box com $\nu=K-(p+q+P+Q)$; Jarque-Bera; ARCH-LM (`FinTS`); McLeod-Li; caminho dos 64 modelos com o motivo de cada descarte; intervenções nos outliers; sobreajuste com teste $t$ e LR |
| `06_sobrediferenciacao.R` | Q6 | o modelo com $d=2$, com e sem o MA extra: $\widehat\theta$, raiz MA, $\widehat\sigma^2$, FAC; o $\rho_1$ teórico de $\Delta^2y$ |
| `07_previsao.R` | Q7 | 24 meses de validação; esquema 1 (origem fixa) e 2 (um passo, coeficientes fixos via `Arima(y, model = ...)`); RMSE/MAE/MAPE contra passeio aleatório e sazonal ingênuo; extras: passeio com drift, Diebold-Mariano (HLN), Kupiec e Mincer-Zarnowitz com HAC (`sandwich`) |
| `rodar_tudo.R` | — | roda tudo em processos separados, grava `saidas/sessionInfo.txt` e gera o PDF |
| `relatorio_lista01.Rmd` | Q1–Q7 | o relatório: lê `saidas/` e escreve cada número inline |
| `dados/inpc_lista01.csv` | — | o banco: INPC (SIDRA, tabela 1736), jan/2000 a set/2026 |

## O que o código encontrou (para estudar)

| Questão | Resultado |
|---|---|
| Q1 | índice com tendência exponencial; log justificado (amplitude × média, $\lambda$ de Guerrero = 0,30); uma quebra na inflação média em jan/2004; 5 outliers (nov/2002, jun/2003, jun/2018, jul/2022, fev/2025) |
| Q2 | **ambiguidade real**: o ADF com AIC e o Zivot-Andrews rejeitam a raiz unitária; o PP, o DF-GLS e o ADF com BIC na subamostra não rejeitam; o KPSS rejeita a estacionariedade em tendência. Adota-se $d=1$ (testes mais confiáveis, teoria das metas de inflação, ausência de MA unitário em $\Delta y$); $D=0$ (OCSB, HEGY e Canova-Hansen concordam) |
| Q3 | FACP trunca em 1, pico sazonal em 12 e um pico em 13 que sugere estrutura multiplicativa; candidatos com AR(1) e SAR, SMA ou os dois |
| Q4 | o AIC escolhe SARIMA(1,1,0)(1,0,1)₁₂ e o BIC escolhe SARIMA(1,1,0)(1,0,0)₁₂ (o LR não rejeita $\Theta_1=0$ a 5%); quase cancelamento SAR-SMA perto do círculo |
| Q5 | ruído branco e sem ARCH; o JB rejeita por caudas; com intervenções, o JB cai de 402 para 10; o sobreajuste não é significativo |
| Q6 | com $d=2$, $\widehat\theta=-1{,}0000$ (raiz MA unitária); $\widehat\sigma^2$ sobe 17,5% sem o MA extra; o AR troca de sinal |
| Q7 | bate o passeio aleatório e o sazonal ingênuo nos dois esquemas (DM significativo), mas empata com o passeio com drift; cobertura de 100% no esquema 1 e de 92% no esquema 2 |

> [!WARNING]
> **Antes de entregar**
> - Trocar `[nomes da dupla]` no cabeçalho do `.Rmd`.
> - Comunicar ao professor a escolha da série.
> - Entregar a pasta inteira: o código, `dados/`, `saidas/sessionInfo.txt` e o PDF.
> - Questão 8: resolver à mão dois exercícios da lista teórica (sugestão: Q6 e Q12, resolvidos em [02_lista](../02_arma/02_lista.md) e [03_lista](../03_arima_sarima/03_lista.md)).

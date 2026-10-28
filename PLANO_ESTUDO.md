---
title: "Plano de estudo — Econometria II, parte 1"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
tags:
  - series-temporais
  - mestrado/ppgeco
aliases:
  - Plano Econometria II
---

# Plano de estudo — Econometria II, parte 1 (ARMA, ARIMA e SARIMA)

## Objetivo

Sair da primeira parte do curso capaz de três coisas:

1. **Derivar no papel** os momentos, a FAC, os pesos $\psi_j$ e $\pi_j$, as condições de estacionariedade e invertibilidade e as equações de previsão de qualquer ARMA ou SARIMA de ordem baixa, nas duas convenções de sinal.
2. **Rodar o ciclo Box-Jenkins numa série real**: o trabalho do INPC, da identificação à previsão avaliada fora da amostra.
3. **Defender as escolhas**: por que não diferenciar, por que AIC ou BIC, o que o JB rejeitar significa e o que não significa.

## Ordem sugerida

| Etapa | Módulo | Aulas | Lista | Ponte com o INPC |
|---|---|---|---|---|
| 1 | [01 Processos e estacionariedade](01_processos_estacionariedade/01_teoria.md) | AU01, AU02 | Q1–Q4 | log do índice × variação mensal |
| 2 | [02 AR, MA e ARMA](02_arma/02_teoria.md) | AU02 | Q5–Q8 | ler a FAC/FACP da inflação |
| 3 | [03 ARIMA e SARIMA](03_arima_sarima/03_teoria.md) | AU02, MAT | Q9–Q12 | ADF/KPSS, por que $d=0$ na inflação, sazonalidade |
| 4 | [04 Estimação e seleção](04_estimacao_selecao/04_lista.md) | AU02, AU03 | Q13–Q14 | grade de 64 SARIMA, AIC × BIC |
| 5 | [05 Previsão](05_previsao/05_lista.md) | AU02, AU03 | Q15 | previsão 12 meses, IC, Winkler |
| 6 | [06 SARIMA aplicado](06_aplicacao_sarima/06_lista.md) | AU03 | Q16 | comparar modelos aninhados |
| 7 | [Trabalho INPC (Lista 01)](trabalho_inpc/README.md) | AU03, AU04, AU05 | LST01 | tudo junto |
| 8 | [07 Regressão dinâmica](07_regressao_dinamica/07_teoria.md) | AU06 | E1–E7 (próprios) | parte 2: começa a regressão com séries |
| **Prova** | no papel, o volume único `caderno/pdf/caderno_p1_completo.pdf`; na tela, a [apostila](apostila/README.md) (um capítulo por bloco), depois a [lista comentada](lista_comentada/README.md) e [prova/](prova/README.md): banco e 3 simulados | AU01–AU05 | Q1–Q16 | **05/11/2026**: 5–6 questões da lista, 1h50–2h; plano diário de 29/10 a 05/11 no [guia](prova/README.md#5-plano-até-a-prova) |

Em cada módulo, a sequência é sempre a mesma:
1. ler a teoria e refazer as demonstrações `DNN.k` no papel;
2. resolver a questão da lista **antes** de abrir a resolução;
3. rodar o script e olhar as figuras;
4. marcar o checklist só quando conseguir reproduzir sem olhar.

## Divisão do trabalho em dupla (sugestão)

| Parte | O que fazer | Arquivo |
|---|---|---|
| A | dados, inspeção, raiz unitária e identificação | [relatório](trabalho_inpc/relatorio.md), Q1–Q3 |
| B | estimação, seleção, diagnóstico e sobrediferenciação | Q4–Q6 |
| A + B | previsão fora da amostra, complementos e conclusão; revisar o texto um do outro; cada um resolve à mão os dois exercícios da Q8 | Q7 e Q8 |

O código é um só ([inpc.R](trabalho_inpc/inpc.R)). As duas pessoas rodam o mesmo script e obtêm os mesmos números.

## Instruções para o agente

1. Leia [CONVENCOES.md](CONVENCOES.md) primeiro, sobretudo o §2, sobre o sinal do MA.
2. Nunca copie a lista nem os slides: parafraseie e cite pelo id.
3. Todo número vem do R, com `registrar()` no script e a tabela `chave_R | nota` em comentário HTML na nota.
4. Antes de qualquer commit, rode `bash scripts/build.sh` e confira `git ls-files` (nada de `materiais/`).

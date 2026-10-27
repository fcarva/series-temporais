---
title: "Lista 01 — laboratório em R (INPC via sidrar)"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
status: revisado
tags:
  - series-temporais
  - mestrado/ppgeco
  - laboratorio
aliases:
  - Laboratório INPC
---

# Laboratório da Lista 01

Um script só, [lab_inpc.R](lab_inpc.R), para rodar e mexer no RStudio. Ele baixa o INPC do SIDRA com o `sidrar`, percorre o ciclo de Box-Jenkins da aula 03 e responde a Lista 01 item a item, da Q1 à Q7. Nasceu da [auditoria](../AUDITORIA.md) e corrige o que ela apontou nas versões anteriores.

## Rodar

No RStudio, com o projeto `series-temporais.Rproj` aberto, abra `lista01/lab/lab_inpc.R` e rode seção por seção (`Ctrl+Alt+T`). Os pacotes que faltarem são instalados na primeira vez.

Para o relatório, com todos os números escritos pelo código:

```r
rmarkdown::render("lista01/lab/lab_inpc.R")                                   # HTML
rmarkdown::render("lista01/lab/lab_inpc.R", output_format = "pdf_document")   # PDF (LuaLaTeX)
```

## Mexer

Tudo o que se ajusta está na seção 0:

| Parâmetro | Padrão | Para quê |
|---|---|---|
| `INICIO`, `FIM` | `"201301"`, `"202609"` | janela da série (AAAAMM) |
| `ATUALIZAR` | `FALSE` | `TRUE` baixa do SIDRA de novo; `FALSE` usa o CSV salvo e reproduz os mesmos números |
| `CANDIDATOS` | C1, C2, C3 | os três modelos da Q3; edite depois de ler a FAC e a FACP |
| `ESCOLHIDO` | `NA` | `NA` aplica a regra da Q4(e); ou force `"C3"`, por exemplo |
| `H` | 24 | meses de validação (Q7) |
| `DATA_QUEBRA` | `c(2020, 3)` | data do Chow, fixada a priori |
| `ROBUSTEZ_LONGA` | `TRUE` | repete ADF e KPSS desde jan/2000 (Q2d) |

Mudar a janela gera um CSV novo em `dados/`, com a janela no nome. O CSV antigo continua lá.

## O que fica gravado

- `dados/inpc_201301_202609.csv`: o banco efetivamente usado (mês, índice), que vai na entrega;
- `dados/inpc_200001_202609.csv`: a série longa da Q2(d);
- `sessionInfo.txt`: as versões do R e dos pacotes, regravado a cada execução (fora do git; o da entrega sai da sua máquina).

## Boas práticas que o script segue

1. **Nenhum número digitado.** Os comentários dizem o que procurar e como ler; os números saem do código.
2. **Dados com cache.** O download fica gravado, com checagens de meses faltando e de valores inválidos. Sem internet, o script roda igual.
3. **Uma fonte por decisão.** Os candidatos, a escolha e as datas ficam na seção 0, e as questões seguintes leem dali. Trocar o modelo não exige editar a Q5, a Q6 nem a Q7.
4. **Tabelas no formato do enunciado.** A Q2(a) sai com estatística, crítico, p-valor, defasagens e critério; a Q4(a), em tabela única; a Q7, com modelos nas linhas e esquemas nas colunas.
5. **Os testes da aula 03 completos:** Ljung-Box com gl corrigido, JB, ARCH-LM, McLeod-Li, Chow, CUSUM, CUSUM-Q, DM com a correção HLN, Winkler e Christoffersen.
6. **A Q7 nas duas escalas.** No índice, como pede o enunciado; na inflação mensal, onde os benchmarks deixam de ser triviais ([auditoria, seção 1](../AUDITORIA.md)).

## O que o INPC respondeu (jan/2013 a set/2026)

| Questão | Resultado |
|---|---|
| Q2 | nível: nenhum teste rejeita (ADF $p=0{,}40$; PP $p=0{,}62$; DF-GLS); KPSS também não. Diferença: ADF e PP rejeitam, KPSS não: $d=1$. Dummies sazonais conjuntamente significativas, OCSB e CH dão 0: $D=0$. Na série longa, ADF e KPSS rejeitam os dois |
| Q4 | AIC escolhe o C3, SARIMA(2,1,0)(1,0,0)₁₂, e o BIC escolhe o C1, SARIMA(1,1,0)(1,0,0)₁₂. $\Delta$AIC = 0,51 e $\phi_2$ com $p=0{,}11$: fica o C1 |
| Q5 | Ljung-Box não rejeita em 12, 24 e 36; sem ARCH; JB rejeita (jun/2018, jul/2022, fev/2025); Chow, CUSUM e CUSUM-Q estáveis; sobreajuste não significativo |
| Q6 | com $d=2$, MA = $-1{,}000$ no R (raiz unitária); $\widehat\sigma^2$ sobe 19,9% com as mesmas ordens |
| Q7 | no índice, bate os dois benchmarks nos dois esquemas (DM significativo). Na inflação, não supera nem o passeio aleatório da inflação (DM $p=0{,}06$) nem o sazonal ingênuo da inflação (DM $p=0{,}61$, com RMSE menor para o ingênuo). Cobertura de 100% no esquema 1 e de 91,7% no esquema 2 |

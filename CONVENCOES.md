---
title: "Convenções do repositório"
tags:
  - series-temporais
  - meta
aliases:
  - Convenções — séries temporais
---

# Convenções do repositório

Este arquivo é o contrato para quem escreve aqui, seja você, seja um agente. Ele segue o mesmo desenho do repositório de Econometria I, adaptado para séries temporais.

## 1. Estrutura e ids

| Pasta | Conteúdo | id dos resultados |
|---|---|---|
| `NN_tema/` (01–07) | `NN_teoria.md` (01–03 e 07), `NN_lista.md`, `NN_tema.R`, `figuras/` | `m01` … `m07` |
| `trabalho_inpc/` | trabalho em dupla: `inpc.R`, `relatorio.md`, `figuras/`, CSVs gerados | `inpc` |
| `dados/` | `inpc.csv` (SIDRA/IBGE, dado público, versionado) | — |
| `R/` | helpers: `raiz.R`, `resultados.R`, `estilo_grafico.R`, `series.R` | — |
| `tests/testthat/` | identidades da teoria conferidas contra o R | — |
| `scripts/` | `build.sh`, `build.ps1`, `r.ps1`, `run_all.R`, `check_numbers.R`, `lint_repo.R`, `baixar_inpc.R` | — |
| `materiais/` | **fora do git**: aulas, lista, livros, `_txt/` | — |

Nomes de arquivo em ASCII, minúsculas, sem espaço nem acento. Os ids dos materiais (`AU01`, `LST`, `MAT`…) estão em [MATERIAIS_INDEX.md](MATERIAIS_INDEX.md).

## 2. Notação

A notação de referência é a **da lista** (`LST`), porque é ela que se resolve e se entrega. Quando a lista e as aulas divergem, vale a lista. Dentro de cada questão, preserve a notação do enunciado: $a_t$, $\varepsilon_t$ ou $u_t$, $B$ ou $L$.

| Objeto | Escrever | Não usar |
|---|---|---|
| Operador de defasagem | $B$ (lista) ou $L$ (aulas), conforme a questão | misturar os dois na mesma resposta |
| Ruído branco | $a_t\sim RB(0,\sigma_a^2)$, $\varepsilon_t\sim RB(0,\sigma^2)$ | WN |
| Esperança, variância, covariância | $E(\cdot)$, $\operatorname{Var}(\cdot)$, $\operatorname{Cov}(\cdot,\cdot)$, com parênteses | $E[\cdot]$, $V[\cdot]$ |
| Autocovariância e FAC | $\gamma_k$, $\rho_k=\gamma_k/\gamma_0$; amostrais $\widehat\gamma_k$, $\widehat\rho_k$ | ACF no texto (use FAC) |
| FACP | $\phi_{kk}$ | |
| Pesos | $\psi_j$ (MA($\infty$), $\psi_0=1$) e $\pi_j$ (AR($\infty$), $y_t=\sum_{j\ge1}\pi_jy_{t-j}+a_t$) | |
| Previsão | $y_{T+h\mid T}=E(y_{T+h}\mid\mathcal F_T)$, erro $e_T(h)$ | |
| Estimadores | chapéu largo: $\widehat\phi$, $\widehat\sigma^2$ | `\hat` |

### O sinal do MA

> [!CAUTION]
> **Duas convenções convivem e mudam as fórmulas**
> - **Box-Jenkins** (lista, exceto Q8): $\theta(B)=1-\theta_1B-\dots-\theta_qB^q$.
> - **Sinal positivo** (aulas AU02, Q8 da lista, Hamilton, `stats::arima`): $\theta(L)=1+\theta_1L+\dots$
>
> Toda resposta começa dizendo qual usa. Os helpers de [R/series.R](R/series.R) recebem `sinal_ma = "bj"` ou `"r"`. Os coeficientes impressos pelo `Arima` do R estão **sempre** na convenção de sinal positivo.

**Critérios de informação.** A AU02 define $AIC=\frac{-2\ln L+2k}{T}$ e $BIC=\frac{-2\ln L+k\ln T}{T}$. O R reporta as versões sem a divisão por $T$. Com $T$ comum, a ordenação é a mesma; nas notas, reporte as duas quando o professor pedir. Ao contar $k$, inclua a variância do erro, como faz a Q14.

## 3. Frontmatter

```yaml
---
title: "Módulo 02 — Lista resolvida (Q5–Q8)"
modulo: "02"
disciplina: Econometria II (PPGEco/UFES)
professor: Guilherme Pereira
periodo: 2026
aulas: "AU02"
lista: [5, 6, 7, 8]
status: rascunho          # rascunho | verificado
verificacao:
  derivacao: ok           # pendente | ok | corrigir
  numerica: ok
tags:
  - series-temporais
  - mestrado/ppgeco
aliases:
  - ARMA — lista
---
```

Os aliases são únicos no repositório: o lint recusa duplicados.

## 4. Callouts, matemática e links

Herdados do repositório de Econometria I.

- **Callouts:** só os cinco que o GitHub renderiza, `NOTE`, `TIP`, `IMPORTANT`, `WARNING` e `CAUTION`. O marcador fica sozinho na linha, e o título vai em negrito na linha seguinte.
- **Matemática:** cifrão simples no meio da frase e duplo em bloco, com linha em branco antes e depois.
  - Vírgula decimal: `0{,}05` dentro da matemática, `0,05` no texto.
  - Dentro de tabela, use `\mid` e `\lvert` em vez de `|`.
  - Use `\lt` antes de uma letra.
- **Links:** relativos em Markdown, que funcionam no GitHub e no Obsidian (abra a raiz do repositório como cofre).

## 5. Demonstrações

Cabeçalho `### DNN.k · Título`, seguido de:
1. um `NOTE` com o que se quer provar;
2. **Passo a passo.**, com uma justificativa por linha: [RB], estacionariedade, a hipótese usada;
3. o resultado em `\boxed{}`;
4. quando couber, um `TIP` "Como o professor pode torcer".

## 6. Números e conferência

**Todo número citado nas notas vem do R.**

1. O script registra o valor com `registrar("m02_q6_rho1", g1 / g0)` e, no fim, chama `gravar_resultados("m02")`.
2. A nota cita o valor numa tabela `chave_R | nota` **dentro de um comentário HTML**: é conferência, não leitura.
3. O `scripts/check_numbers.R` compara a nota com o R, com tolerância de meia unidade da última casa decimal escrita.

Quando a série do INPC é atualizada, o build aponta exatamente quais números do relatório mudaram.

## 7. Código R

- Todo script começa com o bootstrap que acha a raiz pelo `.repo-root` e carrega `R/`.
- `set.seed()` antes de qualquer simulação.
- Os scripts rodam sem internet, com dados de `dados/`. O único script com rede é `scripts/baixar_inpc.R`.
- Figuras: `salvar_figura()` (PNG + SVG), com a paleta Flexoki de `R/estilo_grafico.R`. O título é uma frase que conclui algo, e o rodapé leva `Fonte:`.
- Pacotes: `forecast`, `tseries`, `urca`, `lmtest`, `strucchange`, `testthat` e `jsonlite`.

## 8. Direitos autorais (repositório público)

- Nada de `materiais/` entra no git. As notas citam por id: "AU02, p. 41", "lista, Q11".
- Enunciados são **parafraseados**, nunca copiados. O lint recusa 12 palavras seguidas iguais às de `materiais/_txt/`.
- O INPC é dado público do IBGE e pode ser versionado.

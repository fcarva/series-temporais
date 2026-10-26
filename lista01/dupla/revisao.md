---
title: "Lista 01 — revisão do .qmd da dupla"
disciplina: Econometria II (PPGEco/UFES)
periodo: 2026
lista: LST01
status: rascunho
tags:
  - series-temporais
  - mestrado/ppgeco
  - trabalho
aliases:
  - Revisão do qmd da dupla
---

# Revisão do `.qmd` da dupla: o que está certo e o que está errado

O arquivo original modela a **variação mensal do INPC**, em % a.m., de jan/2013 a set/2026, com $d=0$. A versão corrigida e completa é [inpc_lista_1_revisado.qmd](inpc_lista_1_revisado.qmd), que lê [inpc_13_a_26.csv](inpc_13_a_26.csv) da mesma pasta.

Os números do original foram todos reproduzidos no R e **batem** (por exemplo, $\tau_3=-5{,}202$ e AIC do M1 de $128{,}65$). O problema não está nas contas, mas em afirmações e em respostas incompletas.

> [!NOTE]
> **Variação ($d=0$) ou índice ($d=1$)?**
> As duas abordagens são equivalentes. A variação mensal é, aproximadamente, a primeira diferença do log do índice. Por isso o SARIMA(1,0,0)(1,0,0)$_{12}$ da variação tem praticamente os mesmos coeficientes do SARIMA(1,1,0)(1,0,0)$_{12}$ do log do índice, que é o modelo da [versão do repositório](../README.md). A dupla precisa escolher uma das duas para entregar. A do índice exercita mais itens da lista: transformação, raiz unitária no nível e $d=1$.

## Erros de conteúdo

| Onde | O que o original diz | O problema | Correção |
|---|---|---|---|
| Q1 | "não é possível identificar um padrão sazonal" | fevereiro, março e dezembro são altos e agosto é baixo; no ADF com 11 dummies sazonais centradas (Mattos, 2019, seção 2.6), 4 dummies são significativas a 5%. O próprio texto da Q3 acha o pico em 12 | há sazonalidade, fraca e determinística |
| Q1 | "não há evidência de mudança permanente de nível" | o próprio texto descreve 2015–16 e 2020–22 como mais altos; a média anual vai de $0{,}17\%$ a.m. (2017) a $0{,}90\%$ a.m. (2015) | há mudanças de patamar da média, temporárias; Chow e CUSUM (aula 03) não rejeitam a estabilidade do modelo |
| Q2(c) | a série é "estritamente estacionária" | os testes de raiz unitária falam de estacionariedade **fraca** (média, variância e autocovariâncias constantes); estacionariedade estrita é sobre a distribuição inteira e não é testada | "estacionária (no sentido fraco)" |
| Q2(d) | o DF-GLS "pode confundir a alta persistência da inflação com uma raiz unitária" | é o contrário: o DF-GLS foi feito para ter **mais** poder contra alternativas persistentes. A não rejeição vem de `lag.max = 12`: no `urca`, isso fixa 12 defasagens, sem seleção. Com 12, dá $-1{,}213$; com 1, dá $-3{,}650$ e rejeita (crítico $-1{,}94$) | problema de especificação, não do teste. Mattos (2019, seção 2.4) lembra que o DF-GLS, como o ADF, exige escolher antes o número de defasagens |
| Q2(d) | não responde se a série é DS ou TS | a variação não tem tendência nenhuma; é I(0) em torno da média, o "processo estacionário" da classificação de Mattos (2019). Quem é diferença estacionária (DS) é o **log do índice**: tendência determinística (o drift) mais tendência estocástica | responder explicitamente |
| Q4(a) | "Intercepto" | no `arima()`, o *intercept* é a **média** $\mu=0{,}461$, não a constante da equação, que é $c=\mu(1-\phi)(1-\Phi)=0{,}187$ | chamar de média |
| Q4(d) | o `arima()` **não** conta $\widehat\sigma^2$ em $k$ | **errado**, e os próprios números do original desmentem: o AIC do M1 é $128{,}65$ com $\ln L=-60{,}33$, o que implica $k=(AIC+2\ln L)/2=4$. O M1 tem 3 coeficientes; o quarto parâmetro é a variância. A documentação de `?arima` e o `logLik()` (`df = 4`) confirmam | o R **inclui** $\widehat\sigma^2$ em $k$. Atenção: a convenção da aula 02 (slides 98–99) é $k=p+q+1$, sem $\widehat\sigma^2$; a afirmação do original vale para a aula, não para o R. A resposta certa diz as duas coisas |

## Respostas incompletas

- **Q1:** não diz por que não se transforma a série. A razão é que a variação já é uma taxa e tem valores negativos e nulos, o que impede o log.
- **Q2(a):** o original diz $p<0{,}01$, mas o `urca` não dá p-valor. Os p-valores precisam vir de MacKinnon (`punitroot`). A defasagem máxima foi 12 sem justificativa; a regra de Schwert dá 13.
- **Q2(b):** usa o $p$ do teste $t$ da tendência para tirá-la. Isso só vale porque a raiz unitária foi rejeitada; o texto precisa dizer isso. Mattos (2019, seção 2.2.5) dá o critério mais simples: a versão se escolhe pelo gráfico, e uma taxa que oscila em torno de uma média pede a versão só com constante.
- **Q2(c):** a lista pede para **repetir os testes na série diferenciada**, e o original só roda `ndiffs`, que não é visto nas aulas. Para $D$, a versão revisada usa o ADF com dummies sazonais centradas e a FAC nos múltiplos de 12.
- **Q3(a):** usa 24 defasagens, que é exatamente o mínimo de dois ciclos. Com 36, a leitura de $2s$ e $3s$ fica mais clara. O `ts()` foi criado sem `start`, então os gráficos não mostram as datas.
- **Q3(b):** não responde sobre $2s$, $3s$ e $s\pm1$, que a questão pede explicitamente. A Q3(c) fala em pico "nas vizinhanças" de 12, o que a Q3(b) não sustenta.
- **Q4(a):** a tabela foi **digitada à mão**. A lista exige que o código reproduza exatamente os números do relatório, e qualquer reestimação desatualiza a tabela. O original também não comenta que no M3 nem o SAR nem o SMA são significativos ($t$ de $0{,}74$ e $-0{,}41$): é o sintoma de parâmetros redundantes.
- **Q4(f):** chama `plot()` duas vezes por modelo com títulos "AR Roots" e "MA Roots", mas cada chamada já desenha as duas. Falta a conclusão: as raízes inversas dentro do círculo equivalem a raízes fora, logo os modelos são estacionários e invertíveis.
- **Q5 a Q7:** ausentes. A versão revisada responde todas.

## O que a versão revisada encontrou nas questões que faltavam

- **Q5:** os resíduos do M1 são ruído branco e sem ARCH, mas não normais, por três choques (jun/2018, jul/2022, fev/2025). O sobreajuste não é significativo, e Chow (mar/2020) e CUSUM não rejeitam a estabilidade dos parâmetros.
- **Q6:** com $d=1$, o MA vai para $-1$, a variância residual sobe e o AR troca de sinal: os sintomas clássicos de sobrediferenciação.
- **Q7:** na variação, o M1 bate o passeio aleatório, mas **perde para o sazonal ingênuo**. No RMSE, são $0{,}388$ contra $0{,}317$ no esquema 1 e $0{,}410$ contra $0{,}366$ no esquema 2, sem diferença significativa no Diebold-Mariano. A cobertura do intervalo é de $95{,}8\%$. O **MAPE não serve** nesta série: ela tem meses com inflação zero (1 na validação), o que torna o MAPE infinito, e muitos meses perto de zero, que o inflam. A aula 03 (slides 46 e 49) faz o mesmo alerta e indica o MASE, que a versão revisada passou a reportar.

## Problemas de reprodutibilidade

- **Caminho da base:** `read_excel("C:/Users/.../inpc_13_a_26.xlsx")` só roda naquele computador. A base precisa estar na pasta do trabalho, lida por caminho relativo.
- **Pacotes:** o `library(seasonal)` não é usado e exige o programa X-13 instalado; o `forecast` é carregado duas vezes.
- **Bibliografia:** o YAML aponta para `referencia.bib`, que não veio junto. Sem ele, o Quarto não compila.
- **Entrega:** falta o `sessionInfo()` exigido pelas normas.

<!-- conferência numérica
| chave_R | nota |
|---|---|
| l01_dupla_tau3 | -5,202 |
| l01_dupla_aic1 | 128,65 |
| l01_adfsaz_var | -4,87 |
| l01_dupla_dfgls12 | -1,213 |
| l01_dupla_dfgls1 | -3,650 |
| l01_dupla_mu | 0,461 |
| l01_dupla_c | 0,187 |
| l01_dupla_ll1 | -60,33 |
| l01_dupla_k1 | 4 |
| l01_dupla_ncoef1 | 3 |
| l01_dupla_t_sar3 | 0,74 |
| l01_dupla_t_sma3 | -0,41 |
| l01_dupla_rmse_m1 | 0,388 |
| l01_dupla_rmse_sn1 | 0,317 |
| l01_dupla_rmse_m2 | 0,410 |
| l01_dupla_rmse_sn2 | 0,366 |
| l01_dupla_cob | 95,8 |
| l01_dupla_zeros | 1 |
-->

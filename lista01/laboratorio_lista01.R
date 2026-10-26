#' ---
#' title: "Lista 01 — Box-Jenkins do INPC, passo a passo em R"
#' subtitle: "Econometria II · PPGEco/UFES · bateria de testes das Questões 1 a 7"
#' lang: pt-BR
#' tags: [series-temporais, mestrado/ppgeco, laboratorio]
#' aliases: [Laboratório Lista 01]
#' output:
#'   pdf_document:
#'     latex_engine: lualatex
#'     toc: true
#'     highlight: tango
#'   md_document:
#'     variant: "markdown_strict+tex_math_dollars+pipe_tables+backtick_code_blocks+yaml_metadata_block"
#'     preserve_yaml: true
#' geometry: margin=2.2cm
#' fontsize: 10pt
#' mainfont: Libertinus Serif
#' monofont: DejaVu Sans Mono
#' mathfont: Libertinus Math
#' header-includes:
#'   - \usepackage{unicode-math}
#' ---
#'
#' Script único e linear: lê a base, roda a bateria de testes e responde a lista, questão
#' por questão. Rode bloco a bloco no RStudio. Para virar PDF e nota do Obsidian, use
#' `Rscript lista01/renderizar_laboratorio.R`.
#'
#' **Série.** INPC/IBGE (SIDRA, tabela 1736), índice mensal de jan/2013 a set/2026 (165 meses).
#' Modela-se $y_t = 100\ln P_t$, de modo que $\Delta y_t$ é a inflação mensal em %.
#'
#' **Sinal do MA.** O R escreve o MA como $1 + \theta B$; a lista escreve $1 - \theta B$.

#+ setup, include = FALSE
knitr::opts_chunk$set(comment = "#>", fig.width = 9, fig.height = 4.5, dpi = 130, message = FALSE, warning = FALSE)
if (knitr::is_latex_output()) knitr::opts_chunk$set(out.width = "100%")

#' # Pacotes e dados

#+ dados
library(forecast)   # Arima, forecast, accuracy, checkresiduals, ndiffs, nsdiffs, BoxCox.lambda
library(tseries)    # jarque.bera.test, kpss.test
library(urca)       # ur.df, ur.pp, ur.kpss (com as regressões auxiliares completas)
library(lmtest)     # coeftest
library(FinTS)      # ArchTest (ARCH-LM)

arq <- if (file.exists("dados/inpc_lista01.csv")) "dados/inpc_lista01.csv" else "lista01/dados/inpc_lista01.csv"
dados <- read.csv(arq)
P  <- ts(dados$indice, start = c(2013, 1), frequency = 12)   # índice em nível
y  <- 100 * log(P)                                            # série modelada
dy <- diff(y)                                                 # inflação mensal (%)
length(y)                                                     # T >= 120
summary(as.numeric(dy))

#' # Questão 1 — Inspeção gráfica e transformação

#+ q1, fig.height = 7
par(mfrow = c(3, 1), mar = c(3, 4, 2, 1))
plot(P,  main = "INPC em nível", ylab = "índice", xlab = "")
plot(y,  main = "100 × log(INPC)", ylab = "y", xlab = "")
plot(dy, main = "Inflação mensal (Δy)", ylab = "% a.m.", xlab = ""); abline(h = mean(dy), lty = 2)
par(mfrow = c(1, 1))

#+ q1b
monthplot(dy, main = "Δy por mês do ano", ylab = "% a.m.")
c(guerrero = BoxCox.lambda(P, method = "guerrero"),   # lambda de Box-Cox: 0 = log, 1 = nada
  mv = BoxCox.lambda(P, method = "loglik"))

#' **Resposta (a).**
#'
#' - **Tendência:** forte no nível (o índice dobra em 13 anos). Em log, vira quase uma reta.
#' - **Inclinação:** a inclinação do log (a inflação) muda: mais alta até 2016, baixa em
#'   2017–2020, alta no pós-pandemia (2020–2022) e menor depois.
#' - **Nível:** não há mudança de nível; choques no índice não são revertidos.
#' - **Sazonalidade:** aparece só em $\Delta y$. Fevereiro, março e dezembro são altos,
#'   agosto é baixo.
#' - **Outliers:** são os picos de $\Delta y$ (jun/2018, jul/2022, fev/2025).
#' - **Dispersão:** muda pouco com o nível nesta janela. Os dois $\lambda$ de Box-Cox
#'   discordam: o de máxima verossimilhança (0,3) aponta o log, o de Guerrero (0,7) aponta
#'   não transformar.
#'
#' **Transformação:** log. Quem decide é a interpretação: com log, $\Delta y$ é a taxa de
#' inflação e o drift é uma taxa média, que pode ser constante. Sem log, o drift seria um
#' aumento em pontos de índice, que cresce com o nível.

#' # Questão 2 — Ordem de integração
#'
#' ## (a) ADF, PP e KPSS no nível
#'
#' Regressão do ADF: $\Delta y_t = \alpha + \beta t + \gamma y_{t-1} + \sum_i \delta_i\Delta y_{t-i} + e_t$.
#'
#' - **ADF e PP:** $H_0$ é raiz unitária ($\gamma = 0$).
#' - **KPSS:** $H_0$ é estacionariedade.
#'
#' As defasagens do ADF são escolhidas por AIC, até 13 (regra de Schwert, $12(T/100)^{1/4}$).

#+ q2a
adf_ct <- ur.df(y, type = "trend", lags = 13, selectlags = "AIC")
summary(adf_ct)
summary(ur.pp(y, type = "Z-tau", model = "trend", lags = "long"))
summary(ur.kpss(y, type = "tau", lags = "long"))

#' ## (b) Constante e tendência
#'
#' A série sobe por 13 anos. Sob a alternativa ela só pode ser estacionária **em torno de
#' uma tendência**, então o teste começa com constante e tendência. Depois segue o
#' procedimento sequencial: se o $\phi_3$ (que testa $\beta = \gamma = 0$) não rejeita, a
#' tendência sai, e passa-se ao modelo só com constante:

#+ q2b
summary(ur.df(y, type = "drift", lags = 13, selectlags = "AIC"))@teststat   # tau2, phi1
summary(ur.df(y, type = "none",  lags = 13, selectlags = "AIC"))@teststat   # tau1

#' **Resposta.** O caminho do procedimento sequencial:
#'
#' - **Com tendência:** $\tau_3$ não rejeita a raiz unitária, e o $\phi_3$ não rejeita
#'   $\beta = \gamma = 0$: a tendência é dispensável.
#' - **Só com constante:** $\tau_2$ não rejeita, mas o $\phi_1$ rejeita $\alpha = \gamma = 0$.
#'   Como $\gamma = 0$ ficou, quem é diferente de zero é a constante: passeio com **drift**.
#' - **Sem determinísticos:** $\tau_1$ é positivo, o sintoma de ter omitido o drift.
#'
#' ## (c) Série diferenciada e diferença sazonal

#+ q2c
summary(ur.df(dy, type = "drift", lags = 13, selectlags = "AIC"))@teststat
kpss.test(dy)                          # H0: estacionária
ndiffs(y)                              # d sugerido (KPSS sequencial)
nsdiffs(y, test = "ocsb")              # D sugerido pelo OCSB (H0: precisa de 1 - B^12)

#' **Resposta.** Em $\Delta y$, o ADF rejeita com folga e o KPSS não rejeita: **$d = 1$**.
#' O teste OCSB não pede diferença sazonal: **$D = 0$**, e a sazonalidade é determinística.
#'
#' ## (d) DS ou TS?
#'
#' No nível, ADF e PP não rejeitam a raiz unitária, e o KPSS também não rejeita a
#' estacionariedade: os dados são pouco informativos. **Adota-se DS ($d = 1$).** As razões:
#'
#' 1. Todos os testes de raiz unitária apontam DS, e o procedimento sequencial termina em
#'    passeio com drift.
#' 2. O KPSS tem pouco poder em amostra curta.
#' 3. Sob metas de inflação, o nível de preços não volta a uma trajetória fixa.
#' 4. A Q5 mostra que $\Delta y$ não tem MA unitário, que seria o sinal de diferenciação em
#'    excesso.

#' # Questão 3 — FAC, FACP e candidatos

#+ q3, fig.height = 5
tsdisplay(dy, lag.max = 48, main = "Δy: FAC e FACP com 48 defasagens (4 ciclos sazonais)")
round(cbind(FAC = acf(dy, 13, plot = FALSE)$acf[-1], FACP = pacf(dy, 13, plot = FALSE)$acf), 3)

#' **Resposta (b).**
#'
#' - **Parte regular:** a FACP tem um pico claro em 1, e o valor em 2 fica no limite da
#'   banda ($\pm 0{,}15$). A FAC decai: AR(1), com o AR(2) como alternativa.
#' - **Defasagem sazonal:** há um pico em 12 na FAC (dentro da banda na FACP). Ele cabe
#'   tanto num SAR(1) (decaimento em 12, 24, …) quanto num SMA(1) (corte em 12).
#'
#' **(c) Candidatos**, todos com $d = 1$, $D = 0$ e drift (a inflação média):
#'
#' - **C1:** SARIMA(1,1,0)(1,0,0)$_{12}$;
#' - **C2:** SARIMA(1,1,0)(0,0,1)$_{12}$;
#' - **C3:** SARIMA(2,1,0)(1,0,0)$_{12}$.

#' # Questão 4 — Estimação e seleção

#+ q4
C1 <- Arima(y, order = c(1, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
C2 <- Arima(y, order = c(1, 1, 0), seasonal = c(0, 0, 1), include.drift = TRUE, method = "ML")
C3 <- Arima(y, order = c(2, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
coeftest(C1); coeftest(C2); coeftest(C3)
tab <- rbind(C1 = c(C1$nobs, C1$sigma2, C1$loglik, C1$aic, C1$bic),
             C2 = c(C2$nobs, C2$sigma2, C2$loglik, C2$aic, C2$bic),
             C3 = c(C3$nobs, C3$sigma2, C3$loglik, C3$aic, C3$bic))
colnames(tab) <- c("n efetivo", "sigma2", "logLik", "AIC", "BIC")
round(tab, 3)

#' **(b)** $n = T - d - sD = 165 - 1 = 164$ nos três modelos.
#'
#' **(c)** A comparação é **válida**: os três modelos têm a mesma variável, o mesmo $d$ e o
#' mesmo $D$, logo a mesma amostra efetiva. Com $d$ diferente, a verossimilhança seria de
#' outra série, e o AIC deixaria de ser comparável.
#'
#' **(d)** O R conta $\widehat\sigma^2$ em $k$, como mostra a conta à mão:

#+ q4d
k <- length(coef(C1)) + 1                    # coeficientes + sigma2
c(AIC_manual = -2 * C1$loglik + 2 * k, AIC_R = C1$aic)

#' **(e)** O AIC escolhe **C3** e o BIC escolhe **C1**: o BIC pune mais cada parâmetro
#' ($\ln n \approx 5{,}1$ contra 2).
#'
#' - O BIC é **consistente**: escolhe o modelo verdadeiro, se ele estiver entre os
#'   candidatos, com probabilidade que tende a 1.
#' - O AIC é **eficiente** para prever.
#'
#' O objetivo aqui é prever (Q7), o que favorece o AIC. Mas a vantagem do C3 é de só 0,5
#' ponto de AIC, menos que 2, e o $\phi_2$ não é significativo. O teste LR confirma:

#+ q4e
LR <- 2 * (C3$loglik - C1$loglik)
c(LR = LR, p = pchisq(LR, 1, lower.tail = FALSE))

#' Fica o **C1**, o mais parcimonioso. A regra (AIC, salvo diferença menor que 2) foi fixada
#' antes de olhar a validação.
#'
#' **(f)** Raízes inversas dentro do círculo unitário: o modelo é estacionário.

#+ q4f, fig.height = 4
plot(C1)

#' A raiz inversa regular é $\widehat\phi \approx 0{,}51$. As 12 sazonais têm módulo
#' $\widehat\Phi^{1/12} \approx 0{,}87$: um $\widehat\Phi$ pequeno vira raízes inversas de
#' módulo alto, mas ainda dentro do círculo.

#' # Questão 5 — Diagnóstico
#'
#' **(a)** O painel abaixo mostra os resíduos no tempo, a FAC e o histograma. O
#' `checkresiduals` já roda o Ljung-Box com os graus de liberdade corrigidos. O QQ-plot vem
#' em seguida.

#+ q5a, fig.height = 5
checkresiduals(C1, lag = 24)
qqnorm(residuals(C1)); qqline(residuals(C1))

#' **(b) e (c)** Os testes. No Ljung-Box, $\nu = K - (p + q + P + Q) = 24 - 2 = 22$.

#+ q5bc
Box.test(residuals(C1), lag = 24, type = "Ljung-Box", fitdf = 2)
jarque.bera.test(residuals(C1))
ArchTest(residuals(C1), lags = 12)

#' **Resposta.**
#'
#' - **Ljung-Box:** não rejeita; os resíduos são ruído branco.
#' - **ARCH-LM:** não rejeita; não há heterocedasticidade condicional.
#' - **Jarque-Bera:** **rejeita** a normalidade, por caudas pesadas.
#'
#' **(d)** O diagnóstico de autocorrelação não falhou. A não normalidade vem de choques
#' pontuais (greve dos caminhoneiros em 2018, corte de tributos em 2022, bônus de Itaipu
#' em 2025). Ela afeta os intervalos de previsão, mas não a consistência do estimador.
#' Modelos sem o AR(1) foram descartados, porque deixam autocorrelação nos resíduos
#' (Ljung-Box rejeita).
#'
#' **(e) Sobreajuste:** um AR e um MA a mais.

#+ q5e
coeftest(Arima(y, order = c(2, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML"))["ar2", ]
coeftest(Arima(y, order = c(1, 1, 1), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML"))["ma1", ]

#' **Resposta.** Nenhum dos coeficientes extras é significativo, então a especificação está
#' adequada. O MA extra fica longe de $-1$, o que confirma que $\Delta y$ não foi
#' sobrediferenciada.

#' # Questão 6 — Sobrediferenciação ($d^* + 1 = 2$)

#+ q6
D2  <- Arima(y, order = c(1, 2, 0), seasonal = c(1, 0, 0), method = "ML")   # mesmas ordens
D2m <- Arima(y, order = c(1, 2, 1), seasonal = c(1, 0, 0), method = "ML")   # com um MA a mais
coeftest(D2m)
abs(polyroot(c(1, coef(D2m)["ma1"])))                  # raiz do MA
c(sigma2_d1 = C1$sigma2, sigma2_d2 = D2$sigma2, sigma2_d2_MA = D2m$sigma2)
c(rho1_d1 = acf(residuals(C1), plot = FALSE)$acf[2], rho1_d2 = acf(residuals(D2), plot = FALSE)$acf[2],
  rho1_serie_d2 = acf(diff(dy), plot = FALSE)$acf[2])

#' **Resposta.**
#'
#' - **(a)** $\widehat\theta \approx -1$ (na convenção da lista, $\theta = 1$). A raiz do MA é 1,
#'   **sobre o círculo unitário**: o modelo fica não invertível.
#' - **(b)** $\widehat\sigma^2$ aumenta com a diferença extra, cerca de 20% sem o MA.
#' - **(c)** A série $\Delta^2 y$ tem $\rho_1$ negativo, perto de $-(1-\phi)/2$. No modelo,
#'   o AR troca de sinal para absorver esse $\rho_1$.
#' - **(d)** Os sinais práticos de sobrediferenciação: MA perto de $-1$, AR que troca de
#'   sinal, $\rho_1 \approx -0{,}5$ e $\sigma^2$ que sobe.

#' # Questão 7 — Previsão fora da amostra
#'
#' O treino vai até $T_0 = T - 24$, e os 24 meses finais são a validação. As métricas são
#' calculadas no índice $P = e^{y/100}$.

#+ q7, fig.height = 4.5
T0 <- length(y) - 24
y_treino <- window(y, end = time(y)[T0])
P_treino <- window(P, end = time(P)[T0])
P_teste  <- window(P, start = time(P)[T0 + 1])
fit <- Arima(y_treino, order = c(1, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")   # C1

# Esquema 1: origem fixa, h = 1..24, com IC de 95%
prev1 <- forecast(fit, h = 24, level = 95)
plot(prev1, include = 48, main = "Esquema 1: previsão de 24 meses (em 100 log P)")
lines(window(y, start = time(y)[T0 + 1]), col = "red")

# Esquema 2: um passo à frente, SEM reestimar (mesmos coeficientes do treino)
prev2 <- window(fitted(Arima(y, model = fit)), start = time(y)[T0 + 1])

# Benchmarks no índice: passeio aleatório e sazonal ingênuo
rw1 <- naive(P_treino, h = 24)$mean                                            # origem fixa
sn1 <- snaive(P_treino, h = 24)$mean
rw2 <- window(stats::lag(P, -1), start = start(P_teste), end = end(P_teste))    # um passo: P_{t-1}
sn2 <- window(stats::lag(P, -12), start = start(P_teste), end = end(P_teste))   # um passo: P_{t-12}

metricas <- c("RMSE", "MAE", "MAPE")
rbind("SARIMA, esquema 1"            = accuracy(exp(prev1$mean / 100), P_teste)[, metricas],
      "SARIMA, esquema 2"            = accuracy(exp(prev2 / 100), P_teste)[, metricas],
      "Passeio aleatório, esquema 1" = accuracy(rw1, P_teste)[, metricas],
      "Passeio aleatório, esquema 2" = accuracy(rw2, P_teste)[, metricas],
      "Sazonal ingênuo, esquema 1"   = accuracy(sn1, P_teste)[, metricas],
      "Sazonal ingênuo, esquema 2"   = accuracy(sn2, P_teste)[, metricas])

# (g) cobertura do IC de 95% do esquema 1
mean(P_teste >= exp(prev1$lower / 100) & P_teste <= exp(prev1$upper / 100))

#' **Resposta.**
#'
#' - **(f)** O SARIMA supera o passeio aleatório e o sazonal ingênuo nos dois esquemas e
#'   nas três métricas. O sazonal ingênuo vai muito mal porque, no índice, ele repete o
#'   nível de 12 meses antes, sem a inflação do ano. O modelo não foi alterado em função
#'   desses resultados.
#' - **(g)** Todas as 24 observações caíram dentro do IC de 95% do esquema 1: a cobertura
#'   empírica (100%) é maior que a nominal. O intervalo de um modelo integrado se abre
#'   com $h$, e os 24 erros de uma única origem são correlacionados entre si.
#'
#' **Versões do software** (exigidas na entrega):

#+ sessao
sessionInfo()

---
title: "Lista 01 — Box-Jenkins do INPC, passo a passo em R"
subtitle: "Econometria II · PPGEco/UFES · bateria de testes das Questões 1 a 7"
lang: pt-BR
tags: [series-temporais, mestrado/ppgeco, laboratorio]
aliases: [Laboratório Lista 01]
output:
  pdf_document:
    latex_engine: lualatex
    toc: true
    highlight: tango
  md_document:
    variant: "markdown_strict+tex_math_dollars+pipe_tables+backtick_code_blocks+yaml_metadata_block"
    preserve_yaml: true
geometry: margin=2.2cm
fontsize: 10pt
mainfont: Libertinus Serif
monofont: DejaVu Sans Mono
mathfont: Libertinus Math
header-includes:
  - \usepackage{unicode-math}
---

Script único e linear: lê a base, roda a bateria de testes e responde a
lista, questão por questão. Rode bloco a bloco no RStudio. Para virar
PDF e nota do Obsidian, use `Rscript lista01/renderizar_laboratorio.R`.

**Série.** INPC/IBGE (SIDRA, tabela 1736), índice mensal de jan/2000 a
set/2026. Modela-se $y_t = 100\ln P_t$, de modo que $\Delta y_t$ é a
inflação mensal em %.

**Sinal do MA.** O R escreve o MA como $1 + \theta B$; a lista escreve
$1 - \theta B$.

# Pacotes e dados

``` r
library(forecast)   # Arima, forecast, accuracy, checkresiduals, ndiffs, nsdiffs, BoxCox.lambda
library(tseries)    # jarque.bera.test, kpss.test
library(urca)       # ur.df, ur.pp, ur.kpss (com as regressões auxiliares completas)
library(lmtest)     # coeftest
library(FinTS)      # ArchTest (ARCH-LM)

arq <- if (file.exists("dados/inpc_lista01.csv")) "dados/inpc_lista01.csv" else "lista01/dados/inpc_lista01.csv"
dados <- read.csv(arq)
P  <- ts(dados$indice, start = c(2000, 1), frequency = 12)   # índice em nível
y  <- 100 * log(P)                                            # série modelada
dy <- diff(y)                                                 # inflação mensal (%)
length(y)                                                     # T >= 120
```

    #> [1] 321

``` r
summary(as.numeric(dy))
```

    #>    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    #> -0.6019  0.2097  0.4491  0.4983  0.6999  3.3336

# Questão 1 — Inspeção gráfica e transformação

``` r
par(mfrow = c(3, 1), mar = c(3, 4, 2, 1))
plot(P,  main = "INPC em nível", ylab = "índice", xlab = "")
plot(y,  main = "100 × log(INPC)", ylab = "y", xlab = "")
plot(dy, main = "Inflação mensal (Δy)", ylab = "% a.m.", xlab = ""); abline(h = mean(dy), lty = 2)
```

![](laboratorio_lista01_files/figure-markdown_strict/q1-1.png)

``` r
par(mfrow = c(1, 1))
```

``` r
monthplot(dy, main = "Δy por mês do ano", ylab = "% a.m.")
```

![](laboratorio_lista01_files/figure-markdown_strict/q1b-1.png)

``` r
BoxCox.lambda(P)                  # lambda de Box-Cox (Guerrero): perto de 0 => log
```

    #> [1] 0.30218

**Resposta (a).**

-   **Tendência:** forte e exponencial no nível. Em log, vira quase uma
    reta.
-   **Inclinação:** a inclinação do log (a inflação) é maior em
    2000–2003 do que depois.
-   **Nível:** não há mudança de nível; choques no índice não são
    revertidos.
-   **Sazonalidade:** aparece só em $\Delta y$. Janeiro e dezembro são
    altos, agosto é baixo.
-   **Outliers:** são os picos de $\Delta y$ (nov/2002, jun/2018,
    jul/2022, fev/2025).
-   **Dispersão:** cresce com o nível, e o $\lambda$ de Box-Cox perto de
    0 indica o log.

**Transformação:** log, que também faz de $\Delta y$ a taxa de inflação.
\# Questão 2 — Ordem de integração

## (a) ADF, PP e KPSS no nível

Regressão do ADF:
$\Delta y_t = \alpha + \beta t + \gamma y_{t-1} + \sum_i \delta_i\Delta y_{t-i} + e_t$.

-   **ADF e PP:** $H_0$ é raiz unitária ($\gamma = 0$).
-   **KPSS:** $H_0$ é estacionariedade.

As defasagens do ADF são escolhidas por AIC, até 16 (regra de Schwert,
$12(T/100)^{1/4}$).

``` r
adf_ct <- ur.df(y, type = "trend", lags = 16, selectlags = "AIC")
summary(adf_ct)
```

    #> 
    #> ############################################### 
    #> # Augmented Dickey-Fuller Test Unit Root Test # 
    #> ############################################### 
    #> 
    #> Test regression trend 
    #> 
    #> 
    #> Call:
    #> lm(formula = z.diff ~ z.lag.1 + 1 + tt + z.diff.lag)
    #> 
    #> Residuals:
    #>      Min       1Q   Median       3Q      Max 
    #> -1.24711 -0.18159 -0.01683  0.18339  1.88355 
    #> 
    #> Coefficients:
    #>               Estimate Std. Error t value Pr(>|t|)    
    #> (Intercept)  18.561272   4.604915   4.031 7.12e-05 ***
    #> z.lag.1      -0.024595   0.006173  -3.985 8.57e-05 ***
    #> tt            0.011485   0.002968   3.870 0.000135 ***
    #> z.diff.lag1   0.556982   0.057836   9.630  < 2e-16 ***
    #> z.diff.lag2   0.083394   0.066203   1.260 0.208811    
    #> z.diff.lag3  -0.027160   0.066298  -0.410 0.682356    
    #> z.diff.lag4   0.056359   0.066266   0.850 0.395759    
    #> z.diff.lag5  -0.006893   0.066145  -0.104 0.917076    
    #> z.diff.lag6  -0.068187   0.066137  -1.031 0.303406    
    #> z.diff.lag7  -0.053780   0.066241  -0.812 0.417526    
    #> z.diff.lag8   0.055240   0.066038   0.836 0.403573    
    #> z.diff.lag9   0.065900   0.066062   0.998 0.319342    
    #> z.diff.lag10  0.078738   0.065873   1.195 0.232954    
    #> z.diff.lag11 -0.066462   0.065367  -1.017 0.310124    
    #> z.diff.lag12  0.191503   0.065292   2.933 0.003627 ** 
    #> z.diff.lag13 -0.107687   0.057354  -1.878 0.061450 .  
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    #> 
    #> Residual standard error: 0.3289 on 288 degrees of freedom
    #> Multiple R-squared:  0.4769, Adjusted R-squared:  0.4497 
    #> F-statistic: 17.51 on 15 and 288 DF,  p-value: < 2.2e-16
    #> 
    #> 
    #> Value of test-statistic is: -3.9846 9.5682 8.8206 
    #> 
    #> Critical values for test statistics: 
    #>       1pct  5pct 10pct
    #> tau3 -3.98 -3.42 -3.13
    #> phi2  6.15  4.71  4.05
    #> phi3  8.34  6.30  5.36

``` r
summary(ur.pp(y, type = "Z-tau", model = "trend", lags = "long"))
```

    #> 
    #> ################################## 
    #> # Phillips-Perron Unit Root Test # 
    #> ################################## 
    #> 
    #> Test regression with intercept and trend 
    #> 
    #> 
    #> Call:
    #> lm(formula = y ~ y.l1 + trend)
    #> 
    #> Residuals:
    #>      Min       1Q   Median       3Q      Max 
    #> -0.97252 -0.28336 -0.04849  0.19416  2.69218 
    #> 
    #> Coefficients:
    #>             Estimate Std. Error t value Pr(>|t|)    
    #> (Intercept) 9.874502   5.049341   1.956   0.0514 .  
    #> y.l1        0.988619   0.006129 161.302   <2e-16 ***
    #> trend       0.004727   0.002994   1.579   0.1154    
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    #> 
    #> Residual standard error: 0.4336 on 317 degrees of freedom
    #> Multiple R-squared:  0.9999, Adjusted R-squared:  0.9999 
    #> F-statistic: 1.727e+06 on 2 and 317 DF,  p-value: < 2.2e-16
    #> 
    #> 
    #> Value of test-statistic, type: Z-tau  is: -2.3837 
    #> 
    #>            aux. Z statistics
    #> Z-tau-mu             -0.4562
    #> Z-tau-beta            2.3806
    #> 
    #> Critical values for Z statistics: 
    #>                      1pct      5pct    10pct
    #> critical values -3.990366 -3.425396 -3.13553

``` r
summary(ur.kpss(y, type = "tau", lags = "long"))
```

    #> 
    #> ####################### 
    #> # KPSS Unit Root Test # 
    #> ####################### 
    #> 
    #> Test is of type: tau with 16 lags. 
    #> 
    #> Value of test-statistic is: 0.1696 
    #> 
    #> Critical value for a significance level of: 
    #>                 10pct  5pct 2.5pct  1pct
    #> critical values 0.119 0.146  0.176 0.216

## (b) Constante e tendência

A série sobe por 26 anos. Sob a alternativa ela só pode ser estacionária
**em torno de uma tendência**, então o caso certo inclui constante e
tendência. O $\phi_3$ (que testa $\beta = \gamma = 0$) confirma que a
tendência importa. Nos outros casos a conclusão muda:

``` r
summary(ur.df(y, type = "drift", lags = 16, selectlags = "AIC"))@teststat   # tau2, phi1
```

    #>                tau2     phi1
    #> statistic -1.820608 20.74708

``` r
summary(ur.df(y, type = "none",  lags = 16, selectlags = "AIC"))@teststat   # tau1
```

    #>               tau1
    #> statistic 5.987088

**Resposta.** Comparando as três especificações:

-   **Com tendência:** $\tau_3$ rejeita a 5%, mas usando 13 defasagens.
-   **Só com constante:** $\tau_2$ não rejeita.
-   **Sem determinísticos:** $\tau_1$ é positivo, o sintoma de ter
    omitido a tendência.

Ou seja, a especificação muda a conclusão, e as versões sem tendência
estão erradas para esta série.

## (c) Série diferenciada e diferença sazonal

``` r
summary(ur.df(dy, type = "drift", lags = 16, selectlags = "AIC"))@teststat
```

    #>                tau2    phi1
    #> statistic -6.933138 24.0342

``` r
kpss.test(dy)                          # H0: estacionária
```

    #> 
    #>  KPSS Test for Level Stationarity
    #> 
    #> data:  dy
    #> KPSS Level = 0.34882, Truncation lag parameter = 5, p-value = 0.09922

``` r
ndiffs(y)                              # d sugerido (KPSS sequencial)
```

    #> [1] 1

``` r
nsdiffs(y, test = "ocsb")              # D sugerido pelo OCSB (H0: precisa de 1 - B^12)
```

    #> [1] 0

**Resposta.** Em $\Delta y$, o ADF rejeita com folga e o KPSS não
rejeita: **$d = 1$**. O teste OCSB não pede diferença sazonal:
**$D = 0$**, e a sazonalidade é determinística.

## (d) DS ou TS?

No nível, os testes discordam: o ADF com AIC rejeita, mas o PP não
rejeita e o KPSS rejeita a estacionariedade em tendência. **Adota-se DS
($d = 1$).** As razões:

1.  A rejeição do ADF depende de 13 defasagens.
2.  O PP e o KPSS apontam raiz unitária.
3.  Sob metas de inflação, o nível de preços não volta a uma trajetória
    fixa.
4.  A Q5 mostra que $\Delta y$ não tem MA unitário, que seria o sinal de
    diferenciação em excesso. \# Questão 3 — FAC, FACP e candidatos

``` r
tsdisplay(dy, lag.max = 48, main = "Δy: FAC e FACP com 48 defasagens (4 ciclos sazonais)")
```

![](laboratorio_lista01_files/figure-markdown_strict/q3-1.png)

``` r
round(cbind(FAC = acf(dy, 13, plot = FALSE)$acf[-1], FACP = pacf(dy, 13, plot = FALSE)$acf), 3)
```

    #>         FAC   FACP
    #>  [1,] 0.628  0.628
    #>  [2,] 0.417  0.038
    #>  [3,] 0.252 -0.039
    #>  [4,] 0.168  0.022
    #>  [5,] 0.081 -0.046
    #>  [6,] 0.015 -0.039
    #>  [7,] 0.000  0.026
    #>  [8,] 0.061  0.113
    #>  [9,] 0.123  0.082
    #> [10,] 0.169  0.063
    #> [11,] 0.162 -0.006
    #> [12,] 0.212  0.114
    #> [13,] 0.123 -0.131

**Resposta (b).**

-   **Parte regular:** a FACP **trunca** em 1, e a FAC decai
    exponencialmente: é um AR(1).
-   **Defasagem sazonal:** há um pico em 12 na FAC e na FACP. Ele cabe
    tanto num SAR(1) (decaimento em 12, 24, …) quanto num SMA(1) (corte
    em 12).
-   **Vizinhança:** a FACP negativa em 13 sugere estrutura
    multiplicativa.

**(c) Candidatos**, todos com $d = 1$, $D = 0$ e drift (a inflação
média):

-   **C1:** SARIMA(1,1,0)(1,0,0)$_{12}$;
-   **C2:** SARIMA(1,1,0)(0,0,1)$_{12}$;
-   **C3:** SARIMA(1,1,0)(1,0,1)$_{12}$. \# Questão 4 — Estimação e
    seleção

``` r
C1 <- Arima(y, order = c(1, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
C2 <- Arima(y, order = c(1, 1, 0), seasonal = c(0, 0, 1), include.drift = TRUE, method = "ML")
C3 <- Arima(y, order = c(1, 1, 0), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML")
coeftest(C1); coeftest(C2); coeftest(C3)
```

    #> 
    #> z test of coefficients:
    #> 
    #>       Estimate Std. Error z value  Pr(>|z|)    
    #> ar1   0.624731   0.043563 14.3409 < 2.2e-16 ***
    #> sar1  0.199712   0.056251  3.5504 0.0003847 ***
    #> drift 0.495851   0.061540  8.0574 7.795e-16 ***
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    #> 
    #> z test of coefficients:
    #> 
    #>       Estimate Std. Error z value  Pr(>|z|)    
    #> ar1   0.623567   0.043667 14.2801 < 2.2e-16 ***
    #> sma1  0.165036   0.050379  3.2759  0.001053 ** 
    #> drift 0.496429   0.057633  8.6137 < 2.2e-16 ***
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

    #> 
    #> z test of coefficients:
    #> 
    #>        Estimate Std. Error z value  Pr(>|z|)    
    #> ar1    0.633479   0.043219 14.6573 < 2.2e-16 ***
    #> sar1   0.821720   0.154129  5.3314 9.748e-08 ***
    #> sma1  -0.677042   0.195067 -3.4708 0.0005189 ***
    #> drift  0.502491   0.084240  5.9650 2.446e-09 ***
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
tab <- rbind(C1 = c(C1$nobs, C1$sigma2, C1$loglik, C1$aic, C1$bic),
             C2 = c(C2$nobs, C2$sigma2, C2$loglik, C2$aic, C2$bic),
             C3 = c(C3$nobs, C3$sigma2, C3$loglik, C3$aic, C3$bic))
colnames(tab) <- c("n efetivo", "sigma2", "logLik", "AIC", "BIC")
round(tab, 3)
```

    #>    n efetivo sigma2   logLik     AIC     BIC
    #> C1       320  0.115 -104.949 217.899 232.972
    #> C2       320  0.116 -106.017 220.034 235.107
    #> C3       320  0.114 -103.268 216.537 235.378

**(b)** $n = T - d - sD = 321 - 1 = 320$ nos três modelos.

**(c)** A comparação é **válida**: os três modelos têm a mesma variável,
o mesmo $d$ e o mesmo $D$, logo a mesma amostra efetiva. Com $d$
diferente, a verossimilhança seria de outra série, e o AIC deixaria de
ser comparável.

**(d)** O R conta $\widehat\sigma^2$ em $k$, como mostra a conta à mão:

``` r
k <- length(coef(C3)) + 1                    # coeficientes + sigma2
c(AIC_manual = -2 * C3$loglik + 2 * k, AIC_R = C3$aic)
```

    #> AIC_manual      AIC_R 
    #>   216.5367   216.5367

**(e)** O AIC escolhe **C3** e o BIC escolhe **C1**: o BIC pune mais
cada parâmetro ($\ln n \approx 5{,}8$ contra 2).

-   O BIC é **consistente**: escolhe o modelo verdadeiro, se ele estiver
    entre os candidatos, com probabilidade que tende a 1.
-   O AIC é **eficiente** para prever.

Como o objetivo aqui é prever (Q7), fica o **C3**.

**(f)** Raízes inversas dentro do círculo unitário: o modelo é
estacionário e invertível.

``` r
plot(C3)
```

![](laboratorio_lista01_files/figure-markdown_strict/q4f-1.png)

No C3, as raízes sazonais do AR e do MA ficam quase sobrepostas e perto
do círculo (quase-cancelamento). O par SAR-SMA aproxima uma sazonalidade
fixa. \# Questão 5 — Diagnóstico

**(a)** O painel abaixo mostra os resíduos no tempo, a FAC e o
histograma. O `checkresiduals` já roda o Ljung-Box com os graus de
liberdade corrigidos. O QQ-plot vem em seguida.

``` r
checkresiduals(C3, lag = 24)
```

![](laboratorio_lista01_files/figure-markdown_strict/q5a-1.png)

    #> 
    #>  Ljung-Box test
    #> 
    #> data:  Residuals from ARIMA(1,1,0)(1,0,1)[12] with drift
    #> Q* = 14.046, df = 21, p-value = 0.8676
    #> 
    #> Model df: 3.   Total lags used: 24

``` r
qqnorm(residuals(C3)); qqline(residuals(C3))
```

![](laboratorio_lista01_files/figure-markdown_strict/q5a-2.png)

**(b) e (c)** Os testes. No Ljung-Box,
$\nu = K - (p + q + P + Q) = 24 - 3 = 21$.

``` r
Box.test(residuals(C3), lag = 24, type = "Ljung-Box", fitdf = 3)
```

    #> 
    #>  Box-Ljung test
    #> 
    #> data:  residuals(C3)
    #> X-squared = 14.046, df = 21, p-value = 0.8676

``` r
jarque.bera.test(residuals(C3))
```

    #> 
    #>  Jarque Bera Test
    #> 
    #> data:  residuals(C3)
    #> X-squared = 402.51, df = 2, p-value < 2.2e-16

``` r
ArchTest(residuals(C3), lags = 12)
```

    #> 
    #>  ARCH LM-test; Null hypothesis: no ARCH effects
    #> 
    #> data:  residuals(C3)
    #> Chi-squared = 11.005, df = 12, p-value = 0.5285

**Resposta.**

-   **Ljung-Box:** não rejeita; os resíduos são ruído branco.
-   **ARCH-LM:** não rejeita; não há heterocedasticidade condicional.
-   **Jarque-Bera:** **rejeita** a normalidade, por caudas pesadas.

**(d)** O diagnóstico de autocorrelação não falhou. A não normalidade
vem de choques pontuais (crise de 2002, greve de 2018, corte de tributos
de 2022, bônus de Itaipu em 2025). Ela afeta os intervalos de previsão,
mas não a consistência do estimador. Modelos sem o AR(1) foram
descartados, porque deixam autocorrelação nos resíduos (Ljung-Box
rejeita).

**(e) Sobreajuste:** um AR e um MA a mais.

``` r
coeftest(Arima(y, order = c(2, 1, 0), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML"))["ar2", ]
```

    #>   Estimate Std. Error    z value   Pr(>|z|) 
    #> 0.03946019 0.05717955 0.69011008 0.49012496

``` r
coeftest(Arima(y, order = c(1, 1, 1), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML"))["ma1", ]
```

    #>    Estimate  Std. Error     z value    Pr(>|z|) 
    #> -0.05792055  0.08740719 -0.66265194  0.50755350

**Resposta.** Nenhum dos coeficientes extras é significativo, então a
especificação está adequada. O MA extra fica longe de $-1$, o que
confirma que $\Delta y$ não foi sobrediferenciada. \# Questão 6 —
Sobrediferenciação ($d^* + 1 = 2$)

``` r
D2  <- Arima(y, order = c(1, 2, 0), seasonal = c(1, 0, 1), method = "ML")   # mesmas ordens
D2m <- Arima(y, order = c(1, 2, 1), seasonal = c(1, 0, 1), method = "ML")   # com um MA a mais
coeftest(D2m)
```

    #> 
    #> z test of coefficients:
    #> 
    #>       Estimate Std. Error  z value  Pr(>|z|)    
    #> ar1   0.638615   0.043613  14.6428 < 2.2e-16 ***
    #> ma1  -0.999998   0.012991 -76.9775 < 2.2e-16 ***
    #> sar1  0.846426   0.124644   6.7908 1.115e-11 ***
    #> sma1 -0.702038   0.161296  -4.3525 1.346e-05 ***
    #> ---
    #> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

``` r
abs(polyroot(c(1, coef(D2m)["ma1"])))                  # raiz do MA
```

    #> [1] 1.000002

``` r
c(sigma2_d1 = C3$sigma2, sigma2_d2 = D2$sigma2, sigma2_d2_MA = D2m$sigma2)
```

    #>    sigma2_d1    sigma2_d2 sigma2_d2_MA 
    #>    0.1141193    0.1341048    0.1161261

``` r
c(rho1_d1 = acf(residuals(C3), plot = FALSE)$acf[2], rho1_d2 = acf(residuals(D2), plot = FALSE)$acf[2],
  rho1_serie_d2 = acf(diff(dy), plot = FALSE)$acf[2])
```

    #>       rho1_d1       rho1_d2 rho1_serie_d2 
    #>   -0.02886445   -0.03568588   -0.20952800

**Resposta.**

-   **(a)** $\widehat\theta \approx -1$ (na convenção da lista,
    $\theta = 1$). A raiz do MA é 1, **sobre o círculo unitário**: o
    modelo fica não invertível.
-   **(b)** $\widehat\sigma^2$ aumenta com a diferença extra, cerca de
    17% sem o MA.
-   **(c)** A série $\Delta^2 y$ tem $\rho_1$ negativo, perto de
    $-(1-\phi)/2$. No modelo, o AR troca de sinal para absorver esse
    $\rho_1$.
-   **(d)** Os sinais práticos de sobrediferenciação: MA perto de $-1$,
    AR que troca de sinal, $\rho_1 \approx -0{,}5$ e $\sigma^2$ que
    sobe. \# Questão 7 — Previsão fora da amostra

O treino vai até $T_0 = T - 24$, e os 24 meses finais são a validação.
As métricas são calculadas no índice $P = e^{y/100}$.

``` r
T0 <- length(y) - 24
y_treino <- window(y, end = time(y)[T0])
P_treino <- window(P, end = time(P)[T0])
P_teste  <- window(P, start = time(P)[T0 + 1])
fit <- Arima(y_treino, order = c(1, 1, 0), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML")

# Esquema 1: origem fixa, h = 1..24, com IC de 95%
prev1 <- forecast(fit, h = 24, level = 95)
plot(prev1, include = 48, main = "Esquema 1: previsão de 24 meses (em 100 log P)")
lines(window(y, start = time(y)[T0 + 1]), col = "red")
```

![](laboratorio_lista01_files/figure-markdown_strict/q7-1.png)

``` r
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
```

    #>                                   RMSE       MAE      MAPE
    #> SARIMA, esquema 1            120.09897  94.02267 1.2237213
    #> SARIMA, esquema 2             30.75668  22.08010 0.2917285
    #> Passeio aleatório, esquema 1 425.13541 379.63083 4.9583361
    #> Passeio aleatório, esquema 2  40.88458  32.23250 0.4259191
    #> Sazonal ingênuo, esquema 1   525.33598 501.93250 6.5949984
    #> Sazonal ingênuo, esquema 2   328.65202 326.97292 4.3288906

``` r
# (g) cobertura do IC de 95% do esquema 1
mean(P_teste >= exp(prev1$lower / 100) & P_teste <= exp(prev1$upper / 100))
```

    #> [1] 1

**Resposta.**

-   **(f)** O SARIMA supera o passeio aleatório e o sazonal ingênuo nos
    dois esquemas e nas três métricas. O sazonal ingênuo vai muito mal
    porque, no índice, ele repete o nível de 12 meses antes, sem a
    inflação do ano. O modelo não foi alterado em função desses
    resultados.
-   **(g)** Todas as 24 observações caíram dentro do IC de 95% do
    esquema 1: a cobertura empírica (100%) é maior que a nominal. O
    intervalo de um modelo integrado se abre com $h$, e os 24 erros de
    uma única origem são correlacionados entre si.

**Versões do software** (exigidas na entrega):

``` r
sessionInfo()
```

    #> R version 4.3.3 (2024-02-29)
    #> Platform: x86_64-pc-linux-gnu (64-bit)
    #> Running under: Ubuntu 24.04.5 LTS
    #> 
    #> Matrix products: default
    #> BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.12.0 
    #> LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.12.0
    #> 
    #> locale:
    #>  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
    #>  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
    #>  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
    #> [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
    #> 
    #> time zone: Etc/UTC
    #> tzcode source: system (glibc)
    #> 
    #> attached base packages:
    #> [1] stats     graphics  grDevices utils     datasets  methods   base     
    #> 
    #> other attached packages:
    #> [1] FinTS_0.4-9     lmtest_0.9-40   zoo_1.8-12      urca_1.3-3     
    #> [5] tseries_0.10-55 forecast_8.21.1
    #> 
    #> loaded via a namespace (and not attached):
    #>  [1] gtable_0.3.4      highr_0.10        dplyr_1.1.4       compiler_4.3.3   
    #>  [5] tinytex_0.49      tidyselect_1.2.0  Rcpp_1.0.12       parallel_4.3.3   
    #>  [9] scales_1.3.0      yaml_2.3.8        fastmap_1.1.1     lattice_0.22-5   
    #> [13] ggplot2_3.4.4     R6_2.5.1          labeling_0.4.3    generics_0.1.3   
    #> [17] curl_5.2.0        knitr_1.45        tibble_3.2.1      munsell_0.5.0    
    #> [21] nnet_7.3-19       timeDate_4032.109 pillar_1.9.0      rlang_1.1.3      
    #> [25] quantmod_0.4.26   utf8_1.2.4        xfun_0.41         quadprog_1.5-8   
    #> [29] cli_3.6.2         withr_2.5.0       magrittr_2.0.3    xts_0.13.2       
    #> [33] digest_0.6.34     grid_4.3.3        nlme_3.1-164      lifecycle_1.0.4  
    #> [37] fracdiff_1.5-3    vctrs_0.6.5       evaluate_0.23     glue_1.7.0       
    #> [41] farver_2.1.1      fansi_1.0.5       colorspace_2.1-0  TTR_0.24.4       
    #> [45] rmarkdown_2.25    tools_4.3.3       pkgconfig_2.0.3   htmltools_0.5.7

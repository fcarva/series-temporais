# =====================================================================================
# Lista 01 — Modelagem Box-Jenkins do INPC (Econometria II, PPGEco/UFES)
#
# Script único: roda em qualquer pasta, em qualquer máquina com R e internet.
#   1. instala/carrega os pacotes;
#   2. baixa o INPC da API do IBGE (SIDRA, tabela 1736) e salva a base usada;
#   3. roda os testes da lista, Questões 1 a 7, na ordem.
#
# Rodar:  Rscript lista01_inpc.R      (ou abrir no RStudio e executar bloco a bloco)
# Saídas na pasta atual: inpc_lista01.csv (a base), graficos_lista01.pdf e
#                        sessionInfo_lista01.txt (versões, exigidas na entrega).
# =====================================================================================

# ---- Pacotes ------------------------------------------------------------------------
pacotes <- c("jsonlite", "forecast", "tseries", "urca", "lmtest", "FinTS")
novos <- pacotes[!pacotes %in% rownames(installed.packages())]
if (length(novos)) install.packages(novos, repos = "https://cloud.r-project.org")
library(forecast)   # Arima, forecast, accuracy, checkresiduals, ndiffs, nsdiffs
library(tseries)    # jarque.bera.test, kpss.test
library(urca)       # ur.df, ur.pp, ur.kpss
library(lmtest)     # coeftest
library(FinTS)      # ArchTest

# ---- Dados: INPC, número-índice (dez/1993 = 100), jan/2000 a set/2026 ----------------
# Período fixo para que os resultados sejam sempre os mesmos.
url <- "https://apisidra.ibge.gov.br/values/t/1736/n1/all/v/2289/p/200001-202609"
sidra <- jsonlite::fromJSON(url)[-1, ]                 # a 1ª linha é o cabeçalho
dados <- data.frame(mes = sidra$D3C, indice = as.numeric(sidra$V))
dados <- dados[order(dados$mes), ]
write.csv(dados, "inpc_lista01.csv", row.names = FALSE)   # a base efetivamente usada

P  <- ts(dados$indice, start = c(2000, 1), frequency = 12)  # índice em nível
y  <- 100 * log(P)                                           # série modelada
dy <- diff(y)                                                # inflação mensal (%)
length(y)                                                    # 321 observações (>= 120)

pdf("graficos_lista01.pdf", width = 10, height = 6)          # todos os gráficos vão aqui

# =====================================================================================
# Q1. Inspeção gráfica e transformação
# =====================================================================================
par(mfrow = c(3, 1))
plot(P,  main = "INPC em nível")
plot(y,  main = "100 x log(INPC)")
plot(dy, main = "Inflação mensal (diferença de y)"); abline(h = mean(dy), lty = 2)
par(mfrow = c(1, 1))
monthplot(dy, main = "Inflação por mês do ano")
BoxCox.lambda(P)        # lambda de Box-Cox perto de 0 => usar log
# Resposta: tendência exponencial no nível (reta em log); inclinação maior em 2000-03;
# sazonalidade visível na inflação (jan e dez altos, ago baixo); outliers em nov/2002,
# jun/2018, jul/2022 e fev/2025; dispersão cresce com o nível => transformação log.

# =====================================================================================
# Q2. Ordem de integração (H0 do ADF e do PP: raiz unitária; H0 do KPSS: estacionária)
# =====================================================================================
# (a) Nível, com constante e tendência. Defasagens do ADF por AIC até 16 (Schwert).
summary(ur.df(y, type = "trend", lags = 16, selectlags = "AIC"))
summary(ur.pp(y, type = "Z-tau", model = "trend", lags = "long"))
summary(ur.kpss(y, type = "tau", lags = "long"))

# (b) As outras especificações do ADF: só constante e sem termos determinísticos
summary(ur.df(y, type = "drift", lags = 16, selectlags = "AIC"))
summary(ur.df(y, type = "none",  lags = 16, selectlags = "AIC"))
# Resposta: a série tem tendência, então o caso certo é com constante e tendência
# (phi3 significativo). Com tendência, tau3 rejeita a 5% usando 13 defasagens; só com
# constante, não rejeita; sem termos, tau1 > 0 (sintoma de tendência omitida).

# (c) Série diferenciada e diferença sazonal
summary(ur.df(dy, type = "drift", lags = 16, selectlags = "AIC"))
kpss.test(dy)
ndiffs(y)                    # d sugerido
nsdiffs(y, test = "ocsb")    # D sugerido (OCSB)
# Resposta: em dy o ADF rejeita e o KPSS não => d = 1. O OCSB não pede 1 - B^12 => D = 0.

# (d) DS ou TS? No nível os testes discordam (ADF rejeita; PP não rejeita; KPSS rejeita
# a estacionariedade). Adota-se DS (d = 1): a rejeição do ADF depende de 13 defasagens,
# PP e KPSS apontam raiz unitária e, sob metas de inflação, o nível de preços não volta
# a uma trajetória fixa.

# =====================================================================================
# Q3. FAC, FACP e candidatos
# =====================================================================================
tsdisplay(dy, lag.max = 48, main = "Inflação mensal: FAC e FACP (48 defasagens)")
round(cbind(FAC = acf(dy, 13, plot = FALSE)$acf[-1], FACP = pacf(dy, 13, plot = FALSE)$acf), 3)
# Resposta: FACP corta em 1 e FAC decai => AR(1). Pico em 12 na FAC e na FACP =>
# termo sazonal (SAR ou SMA). FACP negativa em 13 => estrutura multiplicativa.
# Candidatos (d = 1, D = 0, com drift):
#   C1 = SARIMA(1,1,0)(1,0,0)12   C2 = SARIMA(1,1,0)(0,0,1)12   C3 = SARIMA(1,1,0)(1,0,1)12

# =====================================================================================
# Q4. Estimação por máxima verossimilhança e seleção
# =====================================================================================
C1 <- Arima(y, order = c(1, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
C2 <- Arima(y, order = c(1, 1, 0), seasonal = c(0, 0, 1), include.drift = TRUE, method = "ML")
C3 <- Arima(y, order = c(1, 1, 0), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML")
coeftest(C1); coeftest(C2); coeftest(C3)

tabela <- rbind(C1 = c(C1$nobs, C1$sigma2, C1$loglik, C1$aic, C1$bic),
                C2 = c(C2$nobs, C2$sigma2, C2$loglik, C2$aic, C2$bic),
                C3 = c(C3$nobs, C3$sigma2, C3$loglik, C3$aic, C3$bic))
colnames(tabela) <- c("n_efetivo", "sigma2", "logLik", "AIC", "BIC")
round(tabela, 3)

# (d) O R conta sigma2 em k: AIC = -2 logL + 2 (coeficientes + 1)
c(AIC_manual = -2 * C3$loglik + 2 * (length(coef(C3)) + 1), AIC_R = C3$aic)

# (f) Raízes inversas dentro do círculo unitário => estacionário e invertível
plot(C3)
# Resposta: n = T - d - sD = 320 nos três (mesma variável e mesmo d, D => AIC/BIC
# comparáveis). O AIC escolhe C3 e o BIC escolhe C1: o BIC pune mais cada parâmetro
# (consistente) e o AIC é eficiente para prever. Como o objetivo é prever, fica o C3.

# =====================================================================================
# Q5. Diagnóstico dos resíduos do modelo escolhido (C3)
# =====================================================================================
checkresiduals(C3, lag = 24)                         # resíduos, FAC, histograma, Ljung-Box
qqnorm(residuals(C3)); qqline(residuals(C3))
Box.test(residuals(C3), lag = 24, type = "Ljung-Box", fitdf = 3)   # gl = 24 - (p+q+P+Q)
jarque.bera.test(residuals(C3))
ArchTest(residuals(C3), lags = 12)
# Resposta: Ljung-Box e ARCH-LM não rejeitam (ruído branco, sem ARCH). O Jarque-Bera
# rejeita a normalidade por causa de choques pontuais (caudas pesadas).

# (e) Sobreajuste: um AR e um MA a mais
coeftest(Arima(y, order = c(2, 1, 0), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML"))
coeftest(Arima(y, order = c(1, 1, 1), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML"))
# Resposta: ar2 e ma1 não são significativos => a especificação escolhida é adequada.

# =====================================================================================
# Q6. Sobrediferenciação: d* + 1 = 2
# =====================================================================================
D2  <- Arima(y, order = c(1, 2, 0), seasonal = c(1, 0, 1), method = "ML")   # mesmas ordens
D2m <- Arima(y, order = c(1, 2, 1), seasonal = c(1, 0, 1), method = "ML")   # com um MA a mais
coeftest(D2m)
abs(polyroot(c(1, coef(D2m)["ma1"])))            # raiz do MA
c(sigma2_d1 = C3$sigma2, sigma2_d2 = D2$sigma2, sigma2_d2_MA = D2m$sigma2)
acf(residuals(D2), main = "FAC dos resíduos com d = 2")
acf(diff(dy), plot = FALSE)$acf[2]               # rho1 da série diferenciada duas vezes
# Resposta: theta ~ -1 e raiz do MA = 1 (não invertível); sigma2 sobe com a diferença
# extra; rho1 negativo na série sobrediferenciada. Sinais práticos: MA perto de -1,
# AR que troca de sinal, rho1 perto de -0,5 e variância residual maior.

# =====================================================================================
# Q7. Previsão fora da amostra: últimos 24 meses
# =====================================================================================
T0 <- length(y) - 24
y_treino <- window(y, end = time(y)[T0])
P_treino <- window(P, end = time(P)[T0])
P_teste  <- window(P, start = time(P)[T0 + 1])
fit <- Arima(y_treino, order = c(1, 1, 0), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML")

# (b) Esquema 1: origem fixa, h = 1..24, com IC de 95%
prev1 <- forecast(fit, h = 24, level = 95)
plot(prev1, include = 48, main = "Esquema 1: previsão de 24 meses")
lines(window(y, start = time(y)[T0 + 1]), col = "red")

# (c) Esquema 2: um passo à frente com os coeficientes do treino (sem reestimar)
prev2 <- window(fitted(Arima(y, model = fit)), start = time(y)[T0 + 1])

# (d)(e) Métricas no índice, contra passeio aleatório e sazonal ingênuo
rw1 <- naive(P_treino, h = 24)$mean
sn1 <- snaive(P_treino, h = 24)$mean
rw2 <- window(stats::lag(P, -1),  start = start(P_teste), end = end(P_teste))
sn2 <- window(stats::lag(P, -12), start = start(P_teste), end = end(P_teste))
m <- c("RMSE", "MAE", "MAPE")
round(rbind("SARIMA, esquema 1"            = accuracy(exp(prev1$mean / 100), P_teste)[, m],
            "SARIMA, esquema 2"            = accuracy(exp(prev2 / 100), P_teste)[, m],
            "Passeio aleatório, esquema 1" = accuracy(rw1, P_teste)[, m],
            "Passeio aleatório, esquema 2" = accuracy(rw2, P_teste)[, m],
            "Sazonal ingênuo, esquema 1"   = accuracy(sn1, P_teste)[, m],
            "Sazonal ingênuo, esquema 2"   = accuracy(sn2, P_teste)[, m]), 3)

# (g) Cobertura do IC de 95% do esquema 1
mean(P_teste >= exp(prev1$lower / 100) & P_teste <= exp(prev1$upper / 100))
# Resposta: o SARIMA supera os dois benchmarks nos dois esquemas (o modelo não foi
# alterado para isso). A cobertura empírica (100%) fica acima da nominal: o intervalo
# de um modelo integrado se abre com h e os 24 erros de uma só origem são correlacionados.

dev.off()
writeLines(capture.output(sessionInfo()), "sessionInfo_lista01.txt")

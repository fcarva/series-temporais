# Números citados no guia de estudo da Lista 01 (lista01/guia_estudo.md).
#
# Refaz, com a base local lista01/dados/inpc_lista01.csv, os mesmos passos do
# lista01_inpc.R e registra os valores com registrar(). O check_numbers.R confere
# cada número do guia contra resultados/l01.csv.
#
# Rodar: Rscript lista01/guia_numeros.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

suppressPackageStartupMessages({
  library(forecast); library(tseries); library(urca); library(lmtest); library(FinTS)
})

dados <- read.csv(caminho_repo("lista01", "dados", "inpc_lista01.csv"))
P  <- ts(dados$indice, start = c(2000, 1), frequency = 12)
y  <- 100 * log(P)
dy <- diff(y)
registrar("l01_T", length(y))
registrar("l01_lambda", BoxCox.lambda(P))

# Q2: raiz unitária
adf_ct <- ur.df(y, type = "trend", lags = 16, selectlags = "AIC")
adf_bic <- ur.df(y, type = "trend", lags = 16, selectlags = "BIC")
adf_c  <- ur.df(y, type = "drift", lags = 16, selectlags = "AIC")
adf_n  <- ur.df(y, type = "none",  lags = 16, selectlags = "AIC")
pp_ct  <- ur.pp(y, type = "Z-tau", model = "trend", lags = "long")
kpss_ct <- ur.kpss(y, type = "tau", lags = "long")
adf_d  <- ur.df(dy, type = "drift", lags = 16, selectlags = "AIC")
registrar_varios(c(
  l01_adf_tau3 = adf_ct@teststat[1, "tau3"],
  l01_adf_phi3 = adf_ct@teststat[1, "phi3"],
  l01_adf_k    = sum(grepl("z.diff.lag", rownames(adf_ct@testreg$coefficients))),
  l01_adf_bic_tau3 = adf_bic@teststat[1, "tau3"],
  l01_adf_bic_k    = sum(grepl("z.diff.lag", rownames(adf_bic@testreg$coefficients))),
  l01_adf_rho  = 1 + adf_ct@testreg$coefficients["z.lag.1", 1],
  l01_adf_tau2 = adf_c@teststat[1, "tau2"],
  l01_adf_phi1 = adf_c@teststat[1, "phi1"],
  l01_adf_tau1 = adf_n@teststat[1, "tau1"],
  l01_pp       = unname(pp_ct@teststat[1]),
  l01_kpss     = unname(kpss_ct@teststat[1]),
  l01_adf_dy   = adf_d@teststat[1, "tau2"],
  l01_kpss_dy  = unname(ur.kpss(dy, type = "mu", lags = "long")@teststat[1]),
  l01_ndiffs   = ndiffs(y),
  l01_nsdiffs  = nsdiffs(y, test = "ocsb")
))

# Q3: FAC e FACP de dy
fac  <- acf(dy, lag.max = 48, plot = FALSE)$acf[-1]
facp <- pacf(dy, lag.max = 48, plot = FALSE)$acf
registrar_varios(c(l01_fac1 = fac[1], l01_fac2 = fac[2], l01_fac3 = fac[3], l01_fac12 = fac[12],
                   l01_fac24 = fac[24], l01_facp1 = facp[1], l01_facp2 = facp[2],
                   l01_facp12 = facp[12], l01_facp13 = facp[13], l01_banda = 1.96 / sqrt(length(dy))))

# Q4: candidatos
C1 <- Arima(y, order = c(1, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
C2 <- Arima(y, order = c(1, 1, 0), seasonal = c(0, 0, 1), include.drift = TRUE, method = "ML")
C3 <- Arima(y, order = c(1, 1, 0), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML")
registrar_varios(c(
  l01_c1_aic = C1$aic, l01_c2_aic = C2$aic, l01_c3_aic = C3$aic,
  l01_c1_bic = C1$bic, l01_c2_bic = C2$bic, l01_c3_bic = C3$bic,
  l01_c3_loglik = C3$loglik, l01_c3_n = C3$nobs, l01_c3_sigma2 = C3$sigma2,
  l01_c3_ar1 = coef(C3)[["ar1"]], l01_c3_sar1 = coef(C3)[["sar1"]],
  l01_c3_sma1 = coef(C3)[["sma1"]], l01_c3_drift = coef(C3)[["drift"]],
  l01_c1_sar1 = coef(C1)[["sar1"]],
  l01_c3_sma1_p = coeftest(C3)["sma1", 4]
))
# teste LR de C1 (restrito, Theta = 0) contra C3
registrar("l01_lr", 2 * (C3$loglik - C1$loglik))
registrar("l01_lr_p", pchisq(2 * (C3$loglik - C1$loglik), df = 1, lower.tail = FALSE))

# Q5: diagnóstico
e  <- residuals(C3)
lb <- Box.test(e, lag = 24, type = "Ljung-Box", fitdf = 3)
jb <- jarque.bera.test(e)
arch <- ArchTest(e, lags = 12)
ec <- as.numeric(e) - mean(e)
sobre_ar <- Arima(y, order = c(2, 1, 0), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML")
sobre_ma <- Arima(y, order = c(1, 1, 1), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML")
sem_ar <- Arima(y, order = c(0, 1, 0), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML")
registrar_varios(c(
  l01_lb_q = lb$statistic[[1]], l01_lb_p = unname(lb$p.value),
  l01_jb = jb$statistic[[1]], l01_curtose = mean(ec^4) / mean(ec^2)^2,
  l01_arch = arch$statistic[[1]], l01_arch_p = unname(arch$p.value),
  l01_sobre_ar2_p = coeftest(sobre_ar)["ar2", 4], l01_sobre_ma1_p = coeftest(sobre_ma)["ma1", 4],
  l01_sobre_ma1 = coef(sobre_ma)[["ma1"]],
  l01_semar_lb_p = unname(Box.test(residuals(sem_ar), lag = 24, type = "Ljung-Box", fitdf = 2)$p.value)
))

# Q6: sobrediferenciação
D2  <- Arima(y, order = c(1, 2, 0), seasonal = c(1, 0, 1), method = "ML")
D2m <- Arima(y, order = c(1, 2, 1), seasonal = c(1, 0, 1), method = "ML")
registrar_varios(c(
  l01_d2m_ma1 = coef(D2m)[["ma1"]], l01_d2_sigma2 = D2$sigma2, l01_d2m_sigma2 = D2m$sigma2,
  l01_d2_aumento = 100 * (D2$sigma2 / C3$sigma2 - 1), l01_d2_ar1 = coef(D2)[["ar1"]],
  l01_d2_rho1 = acf(diff(dy), plot = FALSE)$acf[2], l01_d2_rho1_teo = -(1 - coef(C3)[["ar1"]]) / 2
))

# Q7: previsão fora da amostra
T0 <- length(y) - 24
y_treino <- window(y, end = time(y)[T0])
P_treino <- window(P, end = time(P)[T0])
P_teste  <- window(P, start = time(P)[T0 + 1])
fit <- Arima(y_treino, order = c(1, 1, 0), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML")
prev1 <- forecast(fit, h = 24, level = 95)
prev2 <- window(fitted(Arima(y, model = fit)), start = time(y)[T0 + 1])
rw2 <- window(stats::lag(P, -1),  start = start(P_teste), end = end(P_teste))
sn2 <- window(stats::lag(P, -12), start = start(P_teste), end = end(P_teste))
ac <- function(prev) accuracy(prev, P_teste)[1, ]
s1 <- ac(exp(prev1$mean / 100)); s2 <- ac(exp(prev2 / 100))
r1 <- ac(naive(P_treino, h = 24)$mean); r2 <- ac(rw2)
n1 <- ac(snaive(P_treino, h = 24)$mean); n2 <- ac(sn2)
li <- exp(prev1$lower / 100); ls <- exp(prev1$upper / 100)
registrar_varios(c(
  l01_q7_rmse_s1 = s1[["RMSE"]], l01_q7_rmse_s2 = s2[["RMSE"]],
  l01_q7_rmse_rw1 = r1[["RMSE"]], l01_q7_rmse_rw2 = r2[["RMSE"]],
  l01_q7_rmse_sn1 = n1[["RMSE"]], l01_q7_rmse_sn2 = n2[["RMSE"]],
  l01_q7_mape_s1 = s1[["MAPE"]], l01_q7_mape_s2 = s2[["MAPE"]],
  l01_q7_mape_rw1 = r1[["MAPE"]], l01_q7_mape_rw2 = r2[["MAPE"]],
  l01_q7_mape_sn1 = n1[["MAPE"]], l01_q7_mape_sn2 = n2[["MAPE"]],
  l01_q7_cobertura = 100 * mean(P_teste >= li & P_teste <= ls)
))

gravar_resultados("l01")

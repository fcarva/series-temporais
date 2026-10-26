# Números citados no guia de estudo da Lista 01 (lista01/guia_estudo.md).
#
# Refaz, com a base local lista01/dados/inpc_lista01.csv (jan/2013 a set/2026), os
# mesmos passos do lista01_inpc.R e registra os valores com registrar(). Registra
# também alguns números da série longa (dados/inpc_2000_2026.csv), usados na seção
# que compara as duas janelas. O check_numbers.R confere cada número do guia contra
# resultados/l01.csv.
#
# Rodar: Rscript lista01/guia_numeros.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

suppressPackageStartupMessages({
  library(forecast); library(tseries); library(urca); library(lmtest); library(FinTS)
})

dados <- read.csv(caminho_repo("lista01", "dados", "inpc_lista01.csv"))
P  <- ts(dados$indice, start = c(2013, 1), frequency = 12)
y  <- 100 * log(P)
dy <- diff(y)
kmax <- floor(12 * (length(y) / 100)^(1 / 4))
registrar_varios(c(l01_T = length(y), l01_kmax = kmax,
                   l01_lambda_g = BoxCox.lambda(P, method = "guerrero"),
                   l01_lambda_mv = BoxCox.lambda(P, method = "loglik"),
                   l01_p_ini = P[1], l01_p_fim = P[length(P)], l01_infl_media = mean(dy)))

# Q2: raiz unitária
adf_ct  <- ur.df(y, type = "trend", lags = kmax, selectlags = "AIC")
adf_bic <- ur.df(y, type = "trend", lags = kmax, selectlags = "BIC")
adf_c   <- ur.df(y, type = "drift", lags = kmax, selectlags = "AIC")
adf_n   <- ur.df(y, type = "none",  lags = kmax, selectlags = "AIC")
pp_ct   <- ur.pp(y, type = "Z-tau", model = "trend", lags = "long")
kpss_ct <- ur.kpss(y, type = "tau", lags = "long")
adf_d   <- ur.df(dy, type = "drift", lags = kmax, selectlags = "AIC")
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

# Q4: candidatos e escolha
C1 <- Arima(y, order = c(1, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
C2 <- Arima(y, order = c(1, 1, 0), seasonal = c(0, 0, 1), include.drift = TRUE, method = "ML")
C3 <- Arima(y, order = c(2, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
pesos <- exp(-(c(C1$aic, C2$aic, C3$aic) - min(C1$aic, C2$aic, C3$aic)) / 2)
pesos <- pesos / sum(pesos)
registrar_varios(c(
  l01_c1_aic = C1$aic, l01_c2_aic = C2$aic, l01_c3_aic = C3$aic,
  l01_c1_bic = C1$bic, l01_c2_bic = C2$bic, l01_c3_bic = C3$bic,
  l01_dAIC = C1$aic - C3$aic, l01_peso_c1 = pesos[1], l01_peso_c3 = pesos[3],
  l01_c1_n = C1$nobs, l01_c1_sigma2 = C1$sigma2,
  l01_c1_ar1 = coef(C1)[["ar1"]], l01_c1_sar1 = coef(C1)[["sar1"]], l01_c1_drift = coef(C1)[["drift"]],
  l01_c1_sar1_p = coeftest(C1)["sar1", 4], l01_c1_raiz_saz = coef(C1)[["sar1"]]^(1 / 12),
  l01_c3_ar2 = coef(C3)[["ar2"]], l01_c3_ar2_p = coeftest(C3)["ar2", 4]
))
registrar("l01_lr", 2 * (C3$loglik - C1$loglik))
registrar("l01_lr_p", pchisq(2 * (C3$loglik - C1$loglik), df = 1, lower.tail = FALSE))

# Q5: diagnóstico do C1
e  <- residuals(C1)
lb <- Box.test(e, lag = 24, type = "Ljung-Box", fitdf = 2)
jb <- jarque.bera.test(e)
arch <- ArchTest(e, lags = 12)
ec <- as.numeric(e) - mean(e)
sobre_ar <- Arima(y, order = c(2, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
sobre_ma <- Arima(y, order = c(1, 1, 1), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
sem_ar <- Arima(y, order = c(0, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
registrar_varios(c(
  l01_lb_q = lb$statistic[[1]], l01_lb_p = unname(lb$p.value),
  l01_jb = jb$statistic[[1]], l01_curtose = mean(ec^4) / mean(ec^2)^2,
  l01_arch = arch$statistic[[1]], l01_arch_p = unname(arch$p.value),
  l01_sobre_ar2_p = coeftest(sobre_ar)["ar2", 4], l01_sobre_ma1_p = coeftest(sobre_ma)["ma1", 4],
  l01_sobre_ma1 = coef(sobre_ma)[["ma1"]],
  l01_semar_lb_p = unname(Box.test(residuals(sem_ar), lag = 24, type = "Ljung-Box", fitdf = 1)$p.value)
))

# Q6: sobrediferenciação
D2  <- Arima(y, order = c(1, 2, 0), seasonal = c(1, 0, 0), method = "ML")
D2m <- Arima(y, order = c(1, 2, 1), seasonal = c(1, 0, 0), method = "ML")
registrar_varios(c(
  l01_d2m_ma1 = coef(D2m)[["ma1"]], l01_d2_sigma2 = D2$sigma2, l01_d2m_sigma2 = D2m$sigma2,
  l01_d2_aumento = 100 * (D2$sigma2 / C1$sigma2 - 1), l01_d2_ar1 = coef(D2)[["ar1"]],
  l01_d2_rho1 = acf(diff(dy), plot = FALSE)$acf[2], l01_d2_rho1_teo = -(1 - coef(C1)[["ar1"]]) / 2
))

# Q7: previsão fora da amostra com o C1
T0 <- length(y) - 24
y_treino <- window(y, end = time(y)[T0])
P_treino <- window(P, end = time(P)[T0])
P_teste  <- window(P, start = time(P)[T0 + 1])
fit <- Arima(y_treino, order = c(1, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
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

# Comparação com a série longa (jan/2000 a set/2026), mesma bateria
longa <- read.csv(caminho_repo("lista01", "dados", "inpc_2000_2026.csv"))
PL <- ts(longa$indice, start = c(2000, 1), frequency = 12)
yl <- 100 * log(PL); dyl <- diff(yl)
kl <- floor(12 * (length(yl) / 100)^(1 / 4))
L1 <- Arima(yl, order = c(1, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
el <- residuals(L1)
T0l <- length(yl) - 24
fitl <- Arima(window(yl, end = time(yl)[T0l]), order = c(1, 1, 0), seasonal = c(1, 0, 0),
              include.drift = TRUE, method = "ML")
sl1 <- ac(exp(forecast(fitl, h = 24)$mean / 100))
registrar_varios(c(
  l01_longa_T = length(yl), l01_longa_infl_media = mean(dyl),
  l01_longa_adf = ur.df(yl, type = "trend", lags = kl, selectlags = "AIC")@teststat[1, "tau3"],
  l01_longa_kpss = unname(ur.kpss(yl, type = "tau", lags = "long")@teststat[1]),
  l01_longa_ar1 = coef(L1)[["ar1"]], l01_longa_sar1 = coef(L1)[["sar1"]],
  l01_longa_ar1_ep = sqrt(L1$var.coef["ar1", "ar1"]), l01_c1_ar1_ep = sqrt(C1$var.coef["ar1", "ar1"]),
  l01_longa_jb = jarque.bera.test(el)$statistic[[1]],
  l01_longa_rmse_s1 = sl1[["RMSE"]]
))

# Revisão do .qmd da dupla (lista01/dupla/): a variação mensal publicada pelo IBGE
vd <- read.csv(caminho_repo("lista01", "dupla", "inpc_13_a_26.csv"))
xv <- ts(vd$variacao, start = c(2013, 1), frequency = 12)
mv1 <- arima(xv, order = c(1, 0, 0), seasonal = list(order = c(1, 0, 0), period = 12), method = "ML")
mv3 <- arima(xv, order = c(1, 0, 0), seasonal = list(order = c(1, 0, 1), period = 12), method = "ML")
av <- anova(lm(as.numeric(xv) ~ factor(cycle(xv))))
T0v <- length(xv) - 24; trv <- window(xv, end = time(xv)[T0v]); tev <- window(xv, start = time(xv)[T0v + 1])
fv <- Arima(trv, order = c(1, 0, 0), seasonal = c(1, 0, 0), method = "ML")
pv1 <- forecast(fv, h = 24, level = 95); pv2 <- window(fitted(Arima(xv, model = fv)), start = time(xv)[T0v + 1])
sv1 <- snaive(trv, h = 24)$mean; sv2 <- window(stats::lag(xv, -12), start = start(tev), end = end(tev))
rmse <- function(p) sqrt(mean((as.numeric(tev) - as.numeric(p))^2))
registrar_varios(c(
  l01_dupla_dfgls12 = ur.ers(xv, type = "DF-GLS", model = "constant", lag.max = 12)@teststat,
  l01_dupla_dfgls1 = ur.ers(xv, type = "DF-GLS", model = "constant", lag.max = 1)@teststat,
  l01_dupla_tau3 = ur.df(xv, type = "trend", lags = 12, selectlags = "BIC")@teststat[1, "tau3"],
  l01_dupla_aic1 = AIC(mv1), l01_dupla_ll1 = mv1$loglik, l01_dupla_k1 = (AIC(mv1) + 2 * mv1$loglik) / 2,
  l01_dupla_ncoef1 = length(coef(mv1)),
  l01_dupla_F = av[["F value"]][1], l01_dupla_pF = av[["Pr(>F)"]][1],
  l01_dupla_mu = coef(mv1)[["intercept"]],
  l01_dupla_c = coef(mv1)[["intercept"]] * (1 - coef(mv1)[["ar1"]]) * (1 - coef(mv1)[["sar1"]]),
  l01_dupla_t_sar3 = coef(mv3)[["sar1"]] / sqrt(mv3$var.coef["sar1", "sar1"]),
  l01_dupla_t_sma3 = coef(mv3)[["sma1"]] / sqrt(mv3$var.coef["sma1", "sma1"]),
  l01_dupla_rmse_m1 = rmse(pv1$mean), l01_dupla_rmse_sn1 = rmse(sv1),
  l01_dupla_rmse_m2 = rmse(pv2), l01_dupla_rmse_sn2 = rmse(sv2),
  l01_dupla_cob = 100 * mean(tev >= pv1$lower & tev <= pv1$upper),
  l01_dupla_zeros = sum(tev == 0)
))

# ADF com dummies sazonais centradas (Dickey e Miller; MAT, seção 2.6), defasagens por BIC
adf_saz <- function(x, opcao, pmax = 13) {
  dx <- diff(x); n <- length(dx); cyc <- cycle(dx)
  DC <- sapply(1:11, function(s) ifelse(cyc == s, 1 - 1/12, -1/12))
  idx <- (pmax + 1):n
  ajuste <- function(p) {
    X <- cbind(nivel = as.numeric(x)[idx], DC[idx, , drop = FALSE])
    if (p > 0) X <- cbind(X, sapply(1:p, function(j) as.numeric(dx)[idx - j]))
    if (opcao == 3) X <- cbind(X, tt = idx)
    lm(as.numeric(dx)[idx] ~ X)
  }
  p <- which.min(sapply(0:pmax, function(k) BIC(ajuste(k)))) - 1
  summary(ajuste(p))$coefficients["Xnivel", "t value"]
}
registrar_varios(c(l01_adfsaz_y = adf_saz(y, 3), l01_adfsaz_dy = adf_saz(dy, 2),
                   l01_adfsaz_var = adf_saz(ts(read.csv(caminho_repo("lista01", "dupla", "inpc_13_a_26.csv"))$variacao,
                                                start = c(2013, 1), frequency = 12), 2)))

gravar_resultados("l01")

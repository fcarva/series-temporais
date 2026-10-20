# Trabalho em dupla: modelagem Box-Jenkins do INPC mensal (IBGE).
#
# Ciclo completo das aulas 01–03: identificação (gráficos, FAC/FACP, raiz unitária,
# sazonalidade), estimação (grade de SARIMA por AIC/BIC), diagnóstico dos resíduos
# (Jarque-Bera, Ljung-Box, ARCH), estabilidade (Chow, CUSUM, estimativas recursivas)
# e avaliação de previsão (janela recursiva, RMSE/MAD/MAPE/MASE, Diebold-Mariano,
# Winkler), terminando com a previsão de out/2026 a set/2027.
#
# Dados: dados/inpc.csv (SIDRA, tabela 1736), atualizado por scripts/baixar_inpc.R.
# Saídas: resultados/inpc.csv (números citados no relatório) e trabalho_inpc/figuras/.
# Rodar: Rscript trabalho_inpc/inpc.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

suppressPackageStartupMessages({
  library(forecast); library(tseries); library(urca); library(lmtest); library(strucchange)
})

FIG <- caminho_repo("trabalho_inpc", "figuras")
FONTE <- "IBGE, SIDRA, tabela 1736. Elaboração própria"

## ---- 1. Dados e amostra -------------------------------------------------------
# A amostra começa em jan/2000: depois do Real (1994), da flutuação cambial e do
# regime de metas (1999). Antes disso a série mistura regimes inflacionários
# incompatíveis com um único ARMA estacionário.
d <- read.csv(caminho_repo("dados", "inpc.csv"), stringsAsFactors = FALSE)
y_all <- ts(d$var_mensal, start = c(1979, 3), frequency = 12)
i_all <- ts(d$indice, start = c(1979, 3), frequency = 12)

INICIO <- c(2000, 1)
y <- window(y_all, start = INICIO)                 # variação mensal, % a.m.
li <- window(log(i_all), start = INICIO)           # log do número-índice
fim <- tail(time(y), 1)
T_ <- length(y)

registrar("inpc_T", T_)
registrar("inpc_ano_fim", floor(fim + 1e-9))
registrar("inpc_mes_fim", round((fim - floor(fim + 1e-9)) * 12) + 1)
registrar("inpc_media", mean(y))
registrar("inpc_dp", sd(y))
registrar("inpc_min", min(y))
registrar("inpc_max", max(y))
registrar("inpc_ultimo", tail(y, 1))
registrar("inpc_acum12", 100 * (prod(1 + tail(y, 12) / 100) - 1))

# média por mês do ano (sazonalidade)
media_mes <- tapply(y, cycle(y), mean)
for (m in 1:12) registrar(sprintf("inpc_media_mes%02d", m), media_mes[[m]])

## ---- 2. Figuras de identificação -----------------------------------------------
salvar_figura(file.path(FIG, "inpc_01_series"), function() {
  graphics::par(mfrow = c(2, 1), mar = c(3, 4.4, 4.2, 1.6))
  plot(li, type = "n", xlab = "", ylab = "log do índice")
  grade_h(); graphics::lines(li, col = CORES$neutra, lwd = 1.6)
  titulo_editorial("O nível do índice sobe sem voltar: tendência",
                   "log do INPC (dez/1993 = 100), jan/2000 a set/2026")
  plot(y, type = "n", xlab = "", ylab = "% a.m.")
  grade_h(); graphics::abline(h = mean(y), col = CORES$compara, lty = 2)
  graphics::lines(y, col = CORES$principal, lwd = 1.3)
  titulo_editorial("A variação mensal oscila em torno de uma média fixa",
                   "INPC, variação mensal (%); tracejado = média amostral", fonte = FONTE)
}, altura = 7)

salvar_figura(file.path(FIG, "inpc_02_sazonalidade"), function() {
  graphics::par(mar = c(4.2, 4.4, 4.8, 1.6))
  graphics::boxplot(as.numeric(y) ~ cycle(y), names = month.abb, col = CORES$painel,
                    border = CORES$eixo, xlab = "", ylab = "% a.m.", outline = TRUE)
  graphics::points(1:12, media_mes, pch = 19, col = CORES$compara)
  titulo_editorial("Inflação maior no início e no fim do ano, menor no meio",
                   "INPC mensal por mês do ano, jan/2000 a set/2026; ponto = média",
                   fonte = FONTE)
})

fac_facp <- function(x, titulo, lag.max = 36) {
  a <- stats::acf(x, lag.max = lag.max, plot = FALSE)$acf[-1]
  p <- stats::pacf(x, lag.max = lag.max, plot = FALSE)$acf
  banda <- 1.96 / sqrt(length(x))
  graphics::par(mfrow = c(1, 2), mar = c(4.2, 4.4, 4.8, 1.2))
  for (k in 1:2) {
    v <- if (k == 1) a else p
    plot(1:lag.max, v, type = "h", xlim = c(0.5, lag.max + 0.5), lwd = 3, ylim = c(-0.4, 1), xlab = "defasagem (meses)",
         ylab = if (k == 1) "FAC" else "FACP",
         col = ifelse((1:lag.max) %% 12 == 0, CORES$compara, CORES$principal))
    graphics::abline(h = 0, col = CORES$eixo); graphics::abline(h = c(-1, 1) * banda, lty = 2, col = CORES$neutra)
    if (k == 1) titulo_editorial(titulo, "laranja = defasagens sazonais (12, 24, 36); tracejado = ±1,96/√T")
  }
}
salvar_figura(file.path(FIG, "inpc_03_fac_facp"), function() {
  fac_facp(y, "FAC decai e volta nas defasagens 12 e 24; FACP corta após 1")
}, largura = 9)

ac <- stats::acf(y, lag.max = 36, plot = FALSE)$acf[-1]
pc <- stats::pacf(y, lag.max = 36, plot = FALSE)$acf
registrar("inpc_fac1", ac[1]); registrar("inpc_fac2", ac[2]); registrar("inpc_fac12", ac[12])
registrar("inpc_fac24", ac[24]); registrar("inpc_facp1", pc[1]); registrar("inpc_facp2", pc[2])
registrar("inpc_facp12", pc[12]); registrar("inpc_banda", 1.96 / sqrt(T_))
registrar("inpc_lb24_serie", Box.test(y, 24, "Ljung-Box")$statistic)

## ---- 3. Raiz unitária ---------------------------------------------------------
# ADF (urca::ur.df) com defasagens escolhidas por AIC até 12, e KPSS (H0: estacionária).
adf <- function(x, tipo) {
  r <- ur.df(x, type = tipo, lags = 12, selectlags = "AIC")
  list(tau = r@teststat[1], c5 = r@cval[1, "5pct"])
}
a_li <- adf(li, "trend"); a_dli <- adf(diff(li), "drift"); a_y <- adf(y, "drift")
registrar("inpc_adf_li_tau", a_li$tau); registrar("inpc_adf_li_c5", a_li$c5)
registrar("inpc_adf_dli_tau", a_dli$tau); registrar("inpc_adf_y_tau", a_y$tau)
registrar("inpc_adf_y_c5", a_y$c5)
k_li <- ur.kpss(li, type = "tau", lags = "short"); k_y <- ur.kpss(y, type = "mu", lags = "short")
registrar("inpc_kpss_li", k_li@teststat); registrar("inpc_kpss_li_c5", k_li@cval[1, "5pct"])
registrar("inpc_kpss_y", k_y@teststat); registrar("inpc_kpss_y_c5", k_y@cval[1, "5pct"])
# Δlog(índice) ≈ variação mensal: a correlação entre as duas mostra que modelar a
# variação mensal é modelar o log do índice como ARIMA(p,1,q).
registrar("inpc_cor_dli_y", cor(100 * diff(li), window(y, start = time(li)[2])))
registrar("inpc_ndiffs", ndiffs(y)); registrar("inpc_nsdiffs", nsdiffs(y))

## ---- 4. Estimação: grade de SARIMA(p,0,q)(P,0,Q)_12 com média ----------------
grade <- expand.grid(p = 0:3, q = 0:3, P = 0:1, Q = 0:1)
grade$aic <- grade$bic <- grade$loglik <- NA_real_
for (i in seq_len(nrow(grade))) {
  g <- grade[i, ]
  f <- tryCatch(Arima(y, order = c(g$p, 0, g$q), seasonal = list(order = c(g$P, 0, g$Q), period = 12),
                      include.mean = TRUE, method = "ML"), error = function(e) NULL)
  if (!is.null(f)) { grade$aic[i] <- f$aic; grade$bic[i] <- f$bic; grade$loglik[i] <- f$loglik }
}
grade <- grade[is.finite(grade$aic), ]
grade$nome <- sprintf("SARIMA(%d,0,%d)(%d,0,%d)", grade$p, grade$q, grade$P, grade$Q)
top_aic <- grade[order(grade$aic), ][1:6, ]
top_bic <- grade[order(grade$bic), ][1:6, ]
write.csv(grade[order(grade$aic), c("nome", "loglik", "aic", "bic")],
          caminho_repo("trabalho_inpc", "grade_sarima.csv"), row.names = FALSE)
registrar("inpc_grade_n", nrow(grade))

# Modelos que seguem para diagnóstico e previsão:
#   M1 = SARIMA(1,0,0)(1,0,1)_12 — menor AIC
#   M2 = SARIMA(1,0,0)(1,0,0)_12 — menor BIC
#   M3 = AR(1) com 11 dummies sazonais (sazonalidade determinística), sugerido
#        por Phi_1 de M1 perto de 1 e Theta_1 quase cancelando (ver relatório)
ajusta <- function(x, modelo) {
  switch(modelo,
    M1 = Arima(x, order = c(1, 0, 0), seasonal = list(order = c(1, 0, 1), period = 12), include.mean = TRUE, method = "ML"),
    M2 = Arima(x, order = c(1, 0, 0), seasonal = list(order = c(1, 0, 0), period = 12), include.mean = TRUE, method = "ML"),
    M3 = Arima(x, order = c(1, 0, 0), xreg = seasonaldummy(x), include.mean = TRUE, method = "ML"))
}
prever <- function(fit, modelo, h, x) {
  if (modelo == "M3") forecast(fit, h = h, xreg = seasonaldummy(x, h = h), level = 95)
  else forecast(fit, h = h, level = 95)
}
MOD <- c("M1", "M2", "M3")
fits <- lapply(setNames(MOD, MOD), function(m) ajusta(y, m))

stopifnot(grade$nome[which.min(grade$aic)] == "SARIMA(1,0,0)(1,0,1)",
          grade$nome[which.min(grade$bic)] == "SARIMA(1,0,0)(1,0,0)")

for (m in MOD) {
  f <- fits[[m]]; tc <- tabela_coef(f)
  for (j in seq_len(nrow(tc))) {
    nm <- gsub("[^a-z0-9]", "", tolower(tc$termo[j]))
    registrar(sprintf("inpc_%s_%s", tolower(m), nm), tc$coef[j])
    registrar(sprintf("inpc_%s_%s_ep", tolower(m), nm), tc$ep[j])
    registrar(sprintf("inpc_%s_%s_p", tolower(m), nm), tc$p[j])
  }
  k <- length(coef(f)) + 1          # + variância do erro
  registrar(sprintf("inpc_%s_loglik", tolower(m)), f$loglik)
  registrar(sprintf("inpc_%s_aic", tolower(m)), f$aic)
  registrar(sprintf("inpc_%s_bic", tolower(m)), f$bic)
  registrar(sprintf("inpc_%s_aic_t", tolower(m)), (-2 * f$loglik + 2 * k) / T_)      # versão por T dos slides
  registrar(sprintf("inpc_%s_bic_t", tolower(m)), (-2 * f$loglik + k * log(T_)) / T_)
  registrar(sprintf("inpc_%s_sigma2", tolower(m)), f$sigma2)
  registrar(sprintf("inpc_%s_k", tolower(m)), k)
}
# raízes (estacionariedade e invertibilidade) de M1: polinômio AR completo (1-phi B)(1-Phi B^12)
cf1 <- coef(fits$M1)
registrar("inpc_m1_raiz_ar", 1 / cf1[["ar1"]])
registrar("inpc_m1_raiz_sar", (1 / cf1[["sar1"]])^(1 / 12))
registrar("inpc_m1_raiz_sma", (1 / abs(cf1[["sma1"]]))^(1 / 12))
# M1 como AR(13) restrito: coeficiente de y_{t-13} = -phi*Phi
registrar("inpc_m1_ar13", -cf1[["ar1"]] * cf1[["sar1"]])
# média implícita (intercepto do Arima já é a média mu)
registrar("inpc_m1_mu_anual", 100 * ((1 + cf1[["intercept"]] / 100)^12 - 1))

## ---- 5. Diagnóstico dos resíduos ---------------------------------------------
diag_res <- function(f, m, fitdf) {
  e <- residuals(f)
  jb <- jarque.bera.test(e)
  lb12 <- Box.test(e, 12, "Ljung-Box", fitdf = fitdf)
  lb24 <- Box.test(e, 24, "Ljung-Box", fitdf = fitdf)
  # ARCH-LM: regressão de e^2 em 12 defasagens de e^2, estatística nR^2 ~ chi2(12)
  e2 <- as.numeric(e)^2; L <- stats::embed(e2, 13)
  aux <- summary(stats::lm(L[, 1] ~ L[, -1]))
  arch <- nrow(L) * aux$r.squared
  mm <- tolower(m)
  registrar(sprintf("inpc_%s_jb", mm), jb$statistic); registrar(sprintf("inpc_%s_jb_p", mm), jb$p.value)
  registrar(sprintf("inpc_%s_lb12", mm), lb12$statistic); registrar(sprintf("inpc_%s_lb12_p", mm), lb12$p.value)
  registrar(sprintf("inpc_%s_lb24", mm), lb24$statistic); registrar(sprintf("inpc_%s_lb24_p", mm), lb24$p.value)
  registrar(sprintf("inpc_%s_arch12", mm), arch)
  registrar(sprintf("inpc_%s_arch12_p", mm), stats::pchisq(arch, 12, lower.tail = FALSE))
  registrar(sprintf("inpc_%s_assim", mm), mean((e - mean(e))^3) / mean((e - mean(e))^2)^1.5)
  registrar(sprintf("inpc_%s_curt", mm), mean((e - mean(e))^4) / mean((e - mean(e))^2)^2)
  invisible(e)
}
diag_res(fits$M1, "M1", 3); diag_res(fits$M2, "M2", 2); diag_res(fits$M3, "M3", 1)
registrar("inpc_lb12_c5_m1", qchisq(0.95, 12 - 3)); registrar("inpc_lb24_c5_m1", qchisq(0.95, 24 - 3))
registrar("inpc_chi2_2_c5", qchisq(0.95, 2)); registrar("inpc_chi2_12_c5", qchisq(0.95, 12))

# maiores resíduos padronizados de M1 (datas dos choques)
e1 <- residuals(fits$M1); z1 <- e1 / sqrt(fits$M1$sigma2)
ord <- order(-abs(z1))[1:3]
for (j in 1:3) {
  registrar(sprintf("inpc_m1_out%d_z", j), z1[ord[j]])
  tt <- time(z1)[ord[j]]
  registrar(sprintf("inpc_m1_out%d_ano", j), floor(tt + 1e-9))
  registrar(sprintf("inpc_m1_out%d_mes", j), round((tt - floor(tt + 1e-9)) * 12) + 1)
}

salvar_figura(file.path(FIG, "inpc_04_residuos_m1"), function() {
  graphics::par(mfrow = c(2, 2), mar = c(4, 4.2, 4.4, 1.2))
  plot(z1, type = "n", xlab = "", ylab = "resíduo padronizado"); grade_h()
  graphics::abline(h = c(-1.96, 1.96), lty = 2, col = CORES$neutra)
  graphics::lines(z1, col = CORES$principal)
  titulo_editorial("(a) Resíduos padronizados", "M1 = SARIMA(1,0,0)(1,0,1)[12]")
  graphics::hist(z1, breaks = 30, freq = FALSE, col = CORES$painel, border = CORES$eixo,
                 main = "", xlab = "resíduo padronizado", ylab = "densidade")
  graphics::curve(stats::dnorm(x), add = TRUE, col = CORES$compara, lwd = 2)
  titulo_editorial("(b) Caudas mais pesadas que a normal", "histograma vs. N(0,1)")
  stats::qqnorm(as.numeric(z1), main = "", pch = 19, cex = 0.5, col = CORES$principal,
                xlab = "quantis teóricos", ylab = "quantis amostrais")
  stats::qqline(as.numeric(z1), col = CORES$compara, lwd = 2)
  titulo_editorial("(c) QQ-plot", "caudas fora da reta: choques de nov/2002, jul/2022 e fev/2025")
  a <- stats::acf(e1, lag.max = 36, plot = FALSE)$acf[-1]
  graphics::par(mar = c(5.2, 4.2, 4.4, 1.2))
  plot(1:36, a, type = "h", xlim = c(0.5, 36.5), lwd = 3, ylim = c(-0.3, 0.3), col = CORES$principal,
       xlab = "defasagem", ylab = "FAC")
  graphics::abline(h = 0, col = CORES$eixo); graphics::abline(h = c(-1, 1) * 1.96 / sqrt(T_), lty = 2, col = CORES$neutra)
  titulo_editorial("(d) FAC dos resíduos dentro da banda", "sem estrutura linear remanescente",
                   fonte = FONTE)
}, largura = 10, altura = 7.5)

## ---- 6. Estabilidade ---------------------------------------------------------
# M3 é estimável por MQO (AR(1) com dummies), o que permite Chow e CUSUM clássicos.
df_ols <- data.frame(y = as.numeric(y)[-1], y1 = as.numeric(y)[-T_],
                     seasonaldummy(y)[-1, ])
tempo_ols <- time(y)[-1]
ols <- stats::lm(y ~ ., data = df_ols)
registrar("inpc_ols_phi", coef(ols)[["y1"]])
# Chow break-point em mar/2020 (pandemia: data escolhida a priori, não pelos dados)
TB <- which(abs(tempo_ols - (2020 + 2 / 12)) < 1e-6)
ch <- sctest(y ~ ., data = df_ols, type = "Chow", point = TB - 1)
registrar("inpc_chow_f", ch$statistic); registrar("inpc_chow_p", ch$p.value)
registrar("inpc_chow_q", ncol(df_ols))    # número de restrições = número de coeficientes
# CUSUM de resíduos recursivos (Brown, Durbin e Evans, 1975)
cus <- efp(y ~ ., data = df_ols, type = "Rec-CUSUM")
sc <- sctest(cus)
registrar("inpc_cusum_stat", sc$statistic); registrar("inpc_cusum_p", sc$p.value)
# estimativas recursivas de phi_1 (janela expansiva a partir de 60 meses)
rec <- vapply(60:nrow(df_ols), function(n) coef(stats::lm(y ~ ., data = df_ols[1:n, ]))[["y1"]], 0)
registrar("inpc_rec_phi_min", min(rec)); registrar("inpc_rec_phi_max", max(rec))

salvar_figura(file.path(FIG, "inpc_05_estabilidade"), function() {
  graphics::par(mfrow = c(1, 2), mar = c(4.2, 4.4, 4.8, 1.2))
  cs <- as.numeric(cus$process); tc <- seq(0, 1, length.out = length(cs))
  lim <- 0.948 * (1 + 2 * tc)   # bandas de 5% do Rec-CUSUM
  tt <- seq(tempo_ols[ncol(df_ols)], tail(tempo_ols, 1), length.out = length(cs))
  plot(tt, cs, type = "n", ylim = range(c(cs, lim, -lim)), xlab = "", ylab = "CUSUM padronizado")
  grade_h(); graphics::lines(tt, lim, lty = 2, col = CORES$negativa); graphics::lines(tt, -lim, lty = 2, col = CORES$negativa)
  graphics::lines(tt, cs, col = CORES$principal, lwd = 1.6)
  titulo_editorial("CUSUM dentro das bandas de 5%", "resíduos recursivos de M3 (MQO)")
  plot(tempo_ols[60:nrow(df_ols)], rec, type = "n", xlab = "", ylab = expression(hat(phi)[1]))
  grade_h(); graphics::lines(tempo_ols[60:nrow(df_ols)], rec, col = CORES$compara, lwd = 1.6)
  titulo_editorial("A persistência cai ao longo da amostra", "AR(1) com dummies: janela expansiva a partir de 60 meses",
                   fonte = FONTE)
}, largura = 10)

## ---- 7. Avaliação de previsão: janela recursiva ------------------------------
# Treino até set/2023; teste = últimos 36 meses (out/2023 a set/2026).
# Em cada origem o modelo é reestimado com todos os dados até ela (janela expansiva)
# e se preveem h = 1, ..., 12 passos de forma iterada.
N_TESTE <- 36; H <- 12
origens <- (T_ - N_TESTE):(T_ - 1)
bench <- c("SN", "MED")    # ingênuo sazonal (y_{t+h-12}) e média histórica
todos <- c(MOD, bench)
erros <- lapply(setNames(todos, todos), function(m) matrix(NA_real_, length(origens), H))
li95 <- ls95 <- lapply(setNames(MOD, MOD), function(m) rep(NA_real_, length(origens)))
yv <- as.numeric(y)
for (k in seq_along(origens)) {
  o <- origens[k]
  x <- ts(yv[1:o], start = INICIO, frequency = 12)
  hh <- min(H, T_ - o)
  real <- yv[(o + 1):(o + hh)]
  for (m in MOD) {
    fc <- prever(ajusta(x, m), m, H, x)
    erros[[m]][k, 1:hh] <- real - as.numeric(fc$mean)[1:hh]
    li95[[m]][k] <- fc$lower[1, 1]; ls95[[m]][k] <- fc$upper[1, 1]
  }
  sn <- yv[o + (1:H) - 12 * ceiling((1:H) / 12)]
  erros$SN[k, 1:hh] <- real - sn[1:hh]
  erros$MED[k, 1:hh] <- real - mean(yv[1:o])
}
y_teste <- yv[(T_ - N_TESTE + 1):T_]
treino <- yv[1:(T_ - N_TESTE)]
Q_mase <- mean(abs(diff(treino, lag = 12)))         # escala do MASE: ingênuo sazonal no treino
met <- function(e, h) {
  e <- e[, h]; ok <- is.finite(e)
  c(rmse = sqrt(mean(e[ok]^2)), mad = mean(abs(e[ok])),
    mase = mean(abs(e[ok])) / Q_mase, n = sum(ok))
}
for (m in todos) for (h in c(1, 3, 12)) {
  r <- met(erros[[m]], h)
  for (nm in c("rmse", "mad", "mase"))
    registrar(sprintf("inpc_%s_h%d_%s", tolower(m), h, nm), r[[nm]])
  if (m == "M1") registrar(sprintf("inpc_n_h%d", h), r[["n"]])
}
registrar("inpc_q_mase", Q_mase)
# MAPE não é calculado: o teste tem meses com variação exatamente zero (divisão por zero)
registrar("inpc_n_zero_teste", sum(y_teste == 0))
registrar("inpc_n_perto_zero_teste", sum(abs(y_teste) <= 0.1))

# Diebold-Mariano, perda quadrática, h = 1 (H0: mesma acurácia)
dm <- function(a, b, h = 1) {
  e_a <- erros[[a]][, h]; e_b <- erros[[b]][, h]; ok <- is.finite(e_a) & is.finite(e_b)
  dm.test(e_a[ok], e_b[ok], h = h, power = 2, alternative = "two.sided")
}
pares <- list(c("M1", "M2"), c("M1", "M3"), c("M2", "M3"), c("M1", "SN"), c("M1", "MED"))
for (pr in pares) {
  t1 <- dm(pr[1], pr[2])
  base <- sprintf("inpc_dm_%s_%s", tolower(pr[1]), tolower(pr[2]))
  registrar(base, t1$statistic); registrar(paste0(base, "_p"), t1$p.value)
}
# Winkler (95%) e cobertura dos intervalos de 1 passo
for (m in MOD) {
  w <- winkler(y_teste, li95[[m]], ls95[[m]], 0.05)
  registrar(sprintf("inpc_%s_winkler", tolower(m)), mean(w))
  registrar(sprintf("inpc_%s_cobertura", tolower(m)), 100 * mean(y_teste >= li95[[m]] & y_teste <= ls95[[m]]))
}

## ---- 8. Previsão final: out/2026 a set/2027 ----------------------------------
fc_final <- lapply(setNames(MOD, MOD), function(m) prever(fits[[m]], m, 12, y))
for (m in MOD) {
  p <- as.numeric(fc_final[[m]]$mean)
  registrar(sprintf("inpc_%s_prev1", tolower(m)), p[1])
  registrar(sprintf("inpc_%s_prev1_li", tolower(m)), fc_final[[m]]$lower[1, 1])
  registrar(sprintf("inpc_%s_prev1_ls", tolower(m)), fc_final[[m]]$upper[1, 1])
  registrar(sprintf("inpc_%s_prev12_acum", tolower(m)), 100 * (prod(1 + p / 100) - 1))
}
p1 <- fc_final$M1
tab_prev <- data.frame(mes = format(seq(as.Date(sprintf("%d-%02d-01", floor(fim + 1e-9), round((fim - floor(fim + 1e-9)) * 12) + 1)),
                                        by = "month", length.out = 13)[-1], "%Y-%m"),
                       prev = as.numeric(p1$mean), li95 = as.numeric(p1$lower), ls95 = as.numeric(p1$upper))
write.csv(tab_prev, caminho_repo("trabalho_inpc", "previsao_m1.csv"), row.names = FALSE)
for (j in 1:12) registrar(sprintf("inpc_m1_prev_h%02d", j), tab_prev$prev[j])

salvar_figura(file.path(FIG, "inpc_06_previsao"), function() {
  xh <- window(y, start = c(2022, 1))
  tf <- as.numeric(time(p1$mean))
  plot(c(time(xh), tf), c(xh, p1$mean), type = "n", ylim = range(c(xh, p1$lower, p1$upper)),
       xlab = "", ylab = "% a.m.")
  grade_h()
  graphics::polygon(c(tf, rev(tf)), c(p1$lower, rev(p1$upper)), col = cor_alpha(CORES$principal, 0.25), border = NA)
  graphics::lines(as.numeric(time(xh)), as.numeric(xh), col = CORES$texto, lwd = 1.5)
  graphics::lines(c(tail(as.numeric(time(xh)), 1), tf), c(tail(as.numeric(xh), 1), p1$mean),
                  col = CORES$principal, lwd = 2)
  titulo_editorial("A previsão volta à média e repete o desenho sazonal",
                   "INPC mensal observado e previsto por M1 (out/2026 a set/2027), faixa = IC 95%",
                   fonte = FONTE)
}, largura = 9)

gravar_resultados("inpc")

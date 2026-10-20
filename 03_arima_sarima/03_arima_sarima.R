# Módulo 03 — Processos integrados, ARIMA e SARIMA (lista, Q9–Q12).
# Sobrediferenciação (Q9 e Q10d), expansão do ARIMA(1,1,1) (Q10b), SAR(1) de
# período 4 e o AR(5) restrito (Q11) e as equações de previsão do
# SARIMA(1,1,0)(0,1,1)_4 conferidas contra o predict() do R (Q12).
# Rodar: Rscript 03_arima_sarima/03_arima_sarima.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

FIG <- caminho_repo("03_arima_sarima", "figuras")
set.seed(2026)

## ---- Q9: diferenciar um AR(1) estacionário ---------------------------------------
phi <- 0.6; s2 <- 1
# w = (1-B) y  =>  (1 - phi B) w = (1 - B) eps: ARMA(1,1) com theta_BJ = 1
gw <- acvf_arma(phi, 1, s2, lag.max = 2)            # theta = 1 na convenção BJ
registrar("m03_q9_var_w", gw[1]); registrar("m03_q9_var_w_formula", 2 * s2 / (1 + phi))
registrar("m03_q9_var_y", s2 / (1 - phi^2))
registrar("m03_q9_rho1_w", gw[2] / gw[1]); registrar("m03_q9_rho1_w_formula", -(1 - phi) / 2)
registrar("m03_q9_raiz_ma", modulo_raizes_ma(1))
# pi_j de w: (1 - phi B)/(1 - B) = 1 - (1 - phi)(B + B^2 + ...): pesos constantes, não somáveis
registrar("m03_q9_pi_j", pesos_pi(phi, 1, 50)[50])
# Monte Carlo: MV do MA de w empilha na fronteira theta = 1 ("pile-up")
R <- 500; TT <- 100; th_hat <- numeric(R)
for (r in 1:R) {
  y <- stats::arima.sim(list(ar = phi), n = TT)
  f <- tryCatch(suppressWarnings(stats::arima(diff(y), order = c(1, 0, 1), include.mean = FALSE, method = "ML")),
                error = function(e) NULL)
  th_hat[r] <- if (is.null(f)) NA else -stats::coef(f)[["ma1"]]   # de volta à convenção BJ
}
th_hat <- th_hat[is.finite(th_hat)]
registrar("m03_q9_mc_n", length(th_hat))
registrar("m03_q9_mc_frac_099", mean(th_hat > 0.99))
registrar("m03_q9_mc_media_theta", mean(th_hat))

salvar_figura(file.path(FIG, "m03_q9_pileup"), function() {
  graphics::par(mar = c(4.2, 4.4, 4.8, 1.6))
  graphics::hist(th_hat, breaks = seq(min(0, min(th_hat)), 1.0001, length.out = 41), col = CORES$painel,
                 border = CORES$eixo, main = "", xlab = expression(hat(theta) ~ "(convenção da lista)"), ylab = "frequência")
  graphics::abline(v = 1, col = CORES$negativa, lwd = 2, lty = 2)
  titulo_editorial("Diferenciar o que já é estacionário empurra θ para 1",
                   "MV de ARMA(1,1) em Δy, com y ~ AR(1), φ = 0,6, T = 100; 500 réplicas",
                   fonte = "simulação", obs = "tracejado = raiz unitária no MA (não invertível)")
})

## ---- Q10: ARIMA(1,1,1) e tendência determinística diferenciada ----------------------
phi <- 0.5
pol <- c(1, -(1 + phi), phi)                                      # (1 - phi B)(1 - B)
registrar("m03_q10_coef_b1", -pol[2]); registrar("m03_q10_coef_b2", -pol[3])
# y = a + b t + u (u ruído branco)  =>  Delta y = b + u_t - u_{t-1}: rho1 = -0,5
TTd <- 20000
yd <- 2 + 0.05 * (1:TTd) + stats::rnorm(TTd)
registrar("m03_q10_rho1_dif_sim", stats::acf(diff(yd), lag.max = 1, plot = FALSE)$acf[2])

## ---- Q11: SAR(1) com s = 4 ---------------------------------------------------
Phi <- 0.6
ar4 <- c(0, 0, 0, Phi)
fac <- stats::ARMAacf(ar = ar4, lag.max = 12)[-1]
facp <- stats::ARMAacf(ar = ar4, lag.max = 12, pacf = TRUE)
registrar("m03_q11_g0", acvf_arma(ar4, lag.max = 0)); registrar("m03_q11_g0_formula", 1 / (1 - Phi^2))
registrar("m03_q11_rho4", fac[4]); registrar("m03_q11_rho8", fac[8]); registrar("m03_q11_rho12", fac[12])
registrar("m03_q11_rho_nao_mult", max(abs(fac[-c(4, 8, 12)])))
registrar("m03_q11_facp4", facp[4]); registrar("m03_q11_facp_outros", max(abs(facp[-4])))
# (1 - phi B)(1 - Phi B^4) = AR(5) restrito
ph <- 0.5
pol5 <- stats::convolve(c(1, -ph), rev(c(1, 0, 0, 0, -Phi)), type = "open")
ar5 <- -pol5[-1]
for (j in 1:5) registrar(sprintf("m03_q11_ar5_c%d", j), ar5[j])
registrar("m03_q11_ar5_c5_formula", -ph * Phi)

salvar_figura(file.path(FIG, "m03_q11_sar4"), function() {
  graphics::par(mfrow = c(1, 2), mar = c(4.2, 4.4, 4.8, 1.2))
  plot(1:12, fac, type = "h", xlim = c(0.5, 12 + 0.5), lwd = 4, ylim = c(-0.1, 1), xlab = "defasagem", ylab = "FAC", col = CORES$principal)
  graphics::abline(h = 0, col = CORES$eixo)
  titulo_editorial("SAR(1)₄: FAC só nas defasagens 4, 8, 12", "Φ = 0,6; decai como Φ^m em k = 4m")
  plot(1:12, facp, type = "h", xlim = c(0.5, 12 + 0.5), lwd = 4, ylim = c(-0.1, 1), xlab = "defasagem", ylab = "FACP", col = CORES$compara)
  graphics::abline(h = 0, col = CORES$eixo)
  titulo_editorial("FACP: um único pico, em 4", "corte após a defasagem sazonal", fonte = "valores teóricos (ARMAacf)")
}, largura = 10)

## ---- Q12: SARIMA(1,1,0)(0,1,1)_4 -----------------------------------------------
phi <- 0.4; Th <- 0.6     # convenção BJ: (1 - Th B^4)
pol12 <- stats::convolve(c(1, -phi), rev(stats::convolve(c(1, -1), rev(c(1, 0, 0, 0, -1)), type = "open")), type = "open")
for (j in 1:6) registrar(sprintf("m03_q12_c%d", j), -pol12[j + 1])   # y_t = sum c_j y_{t-j} + ...
# simula, estima com parâmetros fixos e compara a recursão manual com predict()
n <- 400
a <- stats::rnorm(n + 50)
w <- stats::filter(a - c(rep(0, 4), Th * a[1:(n + 46)]), phi, method = "recursive")
y <- stats::diffinv(stats::diffinv(as.numeric(w), lag = 4), lag = 1)
y <- ts(y[-(1:50)], frequency = 4)
registrar("m03_q12_perda", length(y) - length(diff(diff(y, lag = 4))))
fit <- stats::arima(y, order = c(1, 1, 0), seasonal = list(order = c(0, 1, 1), period = 4),
                    fixed = c(phi, -Th), transform.pars = FALSE)
pr <- stats::predict(fit, n.ahead = 5)$pred
e <- as.numeric(stats::residuals(fit)); yv <- as.numeric(y); TT <- length(yv)
c_ <- -pol12[-1]
yy <- c(yv, rep(NA, 5)); ee <- c(e, rep(0, 5))
for (h in 1:5) {
  i <- TT + h
  yy[i] <- sum(c_ * yy[i - (1:6)]) - Th * ee[i - 4]
}
registrar("m03_q12_dif_max_predict", max(abs(yy[TT + 1:5] - as.numeric(pr))))
registrar("m03_q12_n_par", 2 + 1)   # phi, Theta e sigma2

## ---- D03.3: distribuição de Dickey-Fuller e poder (Monte Carlo) -----------------
# tau = gamma_hat / ep na regressão Δy_t = [a + b t] + gamma y_{t-1} + e_t (DF simples).
tau_df <- function(y, tipo) {
  n <- length(y); dy <- diff(y); y1 <- y[-n]
  X <- switch(tipo, nc = cbind(y1), c = cbind(1, y1), ct = cbind(1, seq_len(n - 1), y1))
  f <- stats::lm.fit(X, dy); k <- ncol(X)
  s2 <- sum(f$residuals^2) / (n - 1 - k)
  f$coefficients[k] / sqrt(s2 * solve(crossprod(X))[k, k])
}
R_df <- 10000; T_df <- 100
for (tp in c("nc", "c", "ct")) {
  tt <- replicate(R_df, tau_df(cumsum(stats::rnorm(T_df)), tp))
  registrar(sprintf("m03_df_q05_%s", tp), unname(stats::quantile(tt, 0.05)))
  registrar(sprintf("m03_df_media_%s", tp), mean(tt))
  registrar(sprintf("m03_df_rej_normal_%s", tp), 100 * mean(tt < stats::qnorm(0.05)))   # usar -1,645 por engano
  if (tp == "c") tau_c <- tt
}
registrar("m03_df_R", R_df); registrar("m03_df_T", T_df)
# poder do DF com constante, crítico de 5% da própria simulação, para phi perto de 1
c5 <- unname(stats::quantile(tau_c, 0.05))
for (n in c(100, 400)) for (ph in c(0.80, 0.90, 0.95, 0.99)) {
  rej <- mean(replicate(2000, tau_df(as.numeric(stats::arima.sim(list(ar = ph), n)), "c") < c5))
  registrar(sprintf("m03_df_poder_t%d_phi%d", n, round(100 * ph)), 100 * rej)
}

gravar_resultados("m03")

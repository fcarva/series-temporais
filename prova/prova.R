# Prova de 05/11/2026 — números dos três simulados e do banco de variações.
# Cada valor citado em prova/*.md sai daqui (id "pv") e é conferido pelo
# scripts/check_numbers.R. O MA está na convenção Box-Jenkins (sinal_ma = "bj"),
# salvo onde o comentário diz "sinal positivo" (sinal_ma = "r").
# Rodar: Rscript prova/prova.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

set.seed(2026)

# Critérios de informação na versão do R (sem dividir por T), k inclui sigma^2
aic <- function(ll, k) -2 * ll + 2 * k
bic <- function(ll, k, n) -2 * ll + k * log(n)

# Previsão recursiva de um modelo escrito como
# y_t = sum_i a_i y_{t-i} + e_t - sum_j m_j e_{t-j}   (MA Box-Jenkins)
# y: valores observados até T (o último é y_T); e: resíduos até T (o último é a_T)
prever_recursivo <- function(a, m = numeric(0), y, e, h) {
  yy <- y; ee <- c(e, rep(0, h)); n <- length(y); ne <- length(e)
  for (k in 1:h) {
    t <- n + k; te <- ne + k
    ar <- sum(a * yy[t - seq_along(a)])
    ma <- if (length(m)) sum(m * ee[te - seq_along(m)]) else 0
    yy[t] <- ar - ma
  }
  yy[(n + 1):(n + h)]
}

## ===================================================================================
## SIMULADO 01 — próximo da lista
## ===================================================================================

## Q1: passeio aleatório sem drift e soma de processos -------------------------------
registrar("pv_s1_q1_corr_t100_k1", sqrt((100 - 1) / 100))
registrar("pv_s1_q1_corr_t100_k10", sqrt((100 - 10) / 100))
# y = 2x + w, x e w não correlacionados
gx <- c(1.0, 0.4, 0); gw <- c(1.5, -0.6, 0.1)
gy <- 4 * gx + gw
registrar("pv_s1_q1_g0", gy[1]); registrar("pv_s1_q1_g1", gy[2]); registrar("pv_s1_q1_g2", gy[3])
registrar("pv_s1_q1_rho1", gy[2] / gy[1]); registrar("pv_s1_q1_rho2", gy[3] / gy[1])

## Q2: ARMA(1,1) com phi = 0,6, theta = 0,3, sigma^2 = 1 -----------------------------
phi <- 0.6; th <- 0.3
g <- acvf_arma(phi, th, 1, lag.max = 2)
registrar("pv_s1_q2_g0", g[1]); registrar("pv_s1_q2_g0_formula", (1 + th^2 - 2 * phi * th) / (1 - phi^2))
registrar("pv_s1_q2_g1", g[2]); registrar("pv_s1_q2_g2", g[3])
registrar("pv_s1_q2_rho1", g[2] / g[1]); registrar("pv_s1_q2_rho2", g[3] / g[1])
registrar("pv_s1_q2_rho1_formula", (1 - phi * th) * (phi - th) / (1 + th^2 - 2 * phi * th))
psi <- pesos_psi(phi, th, 3); pis <- pesos_pi(phi, th, 3)
registrar("pv_s1_q2_psi1", psi[2]); registrar("pv_s1_q2_psi2", psi[3]); registrar("pv_s1_q2_psi3", psi[4])
registrar("pv_s1_q2_pi1", pis[1]); registrar("pv_s1_q2_pi2", pis[2]); registrar("pv_s1_q2_pi3", pis[3])
registrar("pv_s1_q2_raiz_ar", modulo_raizes_ar(phi)); registrar("pv_s1_q2_raiz_ma", modulo_raizes_ma(th))

## Q3: diferenciar o AR(1) com phi = 0,5 ------------------------------------------------
phi <- 0.5
gw <- acvf_arma(phi, 1, 1, lag.max = 2)               # w = Delta y: (1 - 0,5B) w = (1 - B) eps
registrar("pv_s1_q3_var_y", 1 / (1 - phi^2))
registrar("pv_s1_q3_var_w", gw[1]); registrar("pv_s1_q3_var_w_formula", 2 / (1 + phi))
registrar("pv_s1_q3_rho1_w", gw[2] / gw[1]); registrar("pv_s1_q3_rho1_w_formula", -(1 - phi) / 2)
registrar("pv_s1_q3_rho2_w", gw[3] / gw[1])
registrar("pv_s1_q3_raiz_ma", modulo_raizes_ma(1))

## Q4: AIC e BIC com T = 200 e MV condicional do AR(1) ----------------------------------
ll <- c(ar1 = -301.2, arma11 = -299.8, ar2 = -298.9, ar3 = -297.0); k <- c(2, 3, 3, 4); n <- 200
a <- aic(ll, k); b <- bic(ll, k, n)
for (i in seq_along(ll)) {
  registrar(paste0("pv_s1_q4_aic_", names(ll)[i]), a[i])
  registrar(paste0("pv_s1_q4_bic_", names(ll)[i]), b[i])
  registrar(paste0("pv_s1_q4_aict_", names(ll)[i]), a[i] / n)
}
registrar("pv_s1_q4_ln200", log(n))
registrar("pv_s1_q4_escolha_aic", which.min(a)); registrar("pv_s1_q4_escolha_bic", which.min(b))
# MV condicional: somas de t = 2..T com T = 101
sxy <- 84; sxx <- 120; syy <- 130
phi_hat <- sxy / sxx; sqr <- syy - phi_hat * sxy
registrar("pv_s1_q4_phi", phi_hat); registrar("pv_s1_q4_sqr", sqr); registrar("pv_s1_q4_s2", sqr / 100)
# conferência: o MQO sem intercepto numa série qualquer coincide com o argmax da log-verossimilhança condicional
y <- stats::arima.sim(list(ar = 0.7), n = 101)
llc <- function(p) { e <- y[-1] - p * y[-101]; s2 <- mean(e^2); -50 * log(2 * pi * s2) - 50 }
registrar("pv_s1_q4_dif_mqo_mv", abs(stats::optimize(llc, c(-0.99, 0.99), maximum = TRUE)$maximum -
                                       sum(y[-1] * y[-101]) / sum(y[-101]^2)))

## Q5: previsão do AR(1) com média ------------------------------------------------------
mu <- 10; phi <- 0.8; s2 <- 4; yT <- 12
f <- mu + phi^(1:3) * (yT - mu)
v <- s2 * cumsum(phi^(2 * (0:2)))
registrar("pv_s1_q5_f1", f[1]); registrar("pv_s1_q5_f2", f[2]); registrar("pv_s1_q5_f3", f[3])
registrar("pv_s1_q5_v1", v[1]); registrar("pv_s1_q5_v2", v[2]); registrar("pv_s1_q5_v3", v[3])
registrar("pv_s1_q5_li1", f[1] - 1.96 * sqrt(v[1])); registrar("pv_s1_q5_ls1", f[1] + 1.96 * sqrt(v[1]))
registrar("pv_s1_q5_li2", f[2] - 1.96 * sqrt(v[2])); registrar("pv_s1_q5_ls2", f[2] + 1.96 * sqrt(v[2]))
registrar("pv_s1_q5_meia2", 1.96 * sqrt(v[2]))
registrar("pv_s1_q5_vinf", s2 / (1 - phi^2))
# conferência contra o predict() do R com os parâmetros fixados
yy <- mu + stats::arima.sim(list(ar = phi), n = 500, sd = 2); yy[500] <- yT
fit <- stats::arima(yy, order = c(1, 0, 0), fixed = c(phi, mu), transform.pars = FALSE)
pr <- stats::predict(fit, n.ahead = 3)
registrar("pv_s1_q5_dif_predict", max(abs(pr$pred - f)))

## Q6: modelo das companhias aéreas, theta = 0,4, Theta = 0,6 ---------------------------
th <- 0.4; Th <- 0.6
gw <- acvf_arma(numeric(0), c(th, rep(0, 10), Th, -th * Th), 1, lag.max = 13)
r <- gw / gw[1]
registrar("pv_s1_q6_rho1", r[2]); registrar("pv_s1_q6_rho11", r[12]); registrar("pv_s1_q6_rho12", r[13])
registrar("pv_s1_q6_rho13", r[14]); registrar("pv_s1_q6_rho2", r[3])
registrar("pv_s1_q6_rho1_formula", -th / (1 + th^2)); registrar("pv_s1_q6_rho12_formula", -Th / (1 + Th^2))
registrar("pv_s1_q6_rho11_formula", th * Th / ((1 + th^2) * (1 + Th^2)))
registrar("pv_s1_q6_perda", 1 + 12); registrar("pv_s1_q6_efetivas", 180 - 13)

## ===================================================================================
## SIMULADO 02 — torções (sinal positivo, AR(2), sazonal trimestral)
## ===================================================================================

## Q1: MA(1) com sinal positivo e o par não invertível ----------------------------------
g <- acvf_arma(numeric(0), 0.5, 2, lag.max = 1, sinal_ma = "r")
registrar("pv_s2_q1_g0", g[1]); registrar("pv_s2_q1_g1", g[2]); registrar("pv_s2_q1_rho1", g[2] / g[1])
g2 <- acvf_arma(numeric(0), 2, 0.5, lag.max = 1, sinal_ma = "r")
registrar("pv_s2_q1_g0_nao_inv", g2[1]); registrar("pv_s2_q1_g1_nao_inv", g2[2])
registrar("pv_s2_q1_rho1_nao_inv", g2[2] / g2[1])
registrar("pv_s2_q1_raiz_inv", modulo_raizes_ma(0.5, "r")); registrar("pv_s2_q1_raiz_nao_inv", modulo_raizes_ma(2, "r"))
# processo harmônico: Cov(z_t, z_{t-k}) = sigma^2 cos(omega k); com omega = pi/2 e sigma^2 = 1
registrar("pv_s2_q1_harm_k1", cos(pi / 2 * 1)); registrar("pv_s2_q1_harm_k2", cos(pi / 2 * 2))
# Monte Carlo: média de z_t z_{t-2} entre réplicas fica perto de -1, sem depender de t
A <- stats::rnorm(20000); B <- stats::rnorm(20000)
z <- function(t) A * cos(pi / 2 * t) + B * sin(pi / 2 * t)
registrar("pv_s2_q1_harm_mc", mean(z(7) * z(5)))

## Q2: AR(2) com phi1 = 0,5, phi2 = 0,3, sigma^2 = 1 ------------------------------------
p1 <- 0.5; p2 <- 0.3
g <- acvf_arma(c(p1, p2), numeric(0), 1, lag.max = 3); r <- g / g[1]
registrar("pv_s2_q2_rho1", r[2]); registrar("pv_s2_q2_rho2", r[3]); registrar("pv_s2_q2_rho3", r[4])
registrar("pv_s2_q2_g0", g[1])
registrar("pv_s2_q2_g0_formula", (1 - p2) / ((1 + p2) * ((1 - p2)^2 - p1^2)))
registrar("pv_s2_q2_phi22", (r[3] - r[2]^2) / (1 - r[2]^2))
registrar("pv_s2_q2_phi33", stats::ARMAacf(ar = c(p1, p2), lag.max = 3, pacf = TRUE)[3])
psi <- pesos_psi(c(p1, p2), numeric(0), 3)
registrar("pv_s2_q2_psi1", psi[2]); registrar("pv_s2_q2_psi2", psi[3]); registrar("pv_s2_q2_psi3", psi[4])
rz <- polyroot(c(1, -p1, -p2))
registrar("pv_s2_q2_raiz_pos", max(Re(rz))); registrar("pv_s2_q2_raiz_neg", min(Re(rz)))
registrar("pv_s2_q2_soma", p1 + p2); registrar("pv_s2_q2_dif", p2 - p1)

## Q3: SAR(1)_4, multiplicativo e ARIMA(1,1,1) -----------------------------------------
Phi <- 0.6
g <- acvf_arma(c(0, 0, 0, Phi), numeric(0), 1, lag.max = 8); r <- g / g[1]
registrar("pv_s2_q3_g0", g[1]); registrar("pv_s2_q3_rho4", r[5]); registrar("pv_s2_q3_rho8", r[9])
registrar("pv_s2_q3_rho1", r[2]); registrar("pv_s2_q3_rho3", r[4])
# (1 - 0,5B)(1 - 0,6B^4) = 1 - 0,5B - 0,6B^4 + 0,3B^5
pr <- stats::convolve(c(1, -0.5), rev(c(1, 0, 0, 0, -0.6)), type = "open")
registrar("pv_s2_q3_c1", -pr[2]); registrar("pv_s2_q3_c4", -pr[5]); registrar("pv_s2_q3_c5", -pr[6])
# ARIMA(1,1,1): (1 - 0,4B)(1 - B) y = (1 - 0,7B) a  =>  y_t = 1,4 y_{t-1} - 0,4 y_{t-2} + a_t - 0,7 a_{t-1}
pr <- stats::convolve(c(1, -0.4), rev(c(1, -1)), type = "open")
registrar("pv_s2_q3_arima_c1", -pr[2]); registrar("pv_s2_q3_arima_c2", -pr[3])

## Q4: AIC e BIC com T = 120, versão por T da AU02, e teste LR --------------------------
ll <- c(arma11 = -170.4, ar2 = -171.9, arma21 = -169.8); k <- c(3, 3, 4); n <- 120
a <- aic(ll, k); b <- bic(ll, k, n)
for (i in seq_along(ll)) {
  registrar(paste0("pv_s2_q4_aic_", names(ll)[i]), a[i])
  registrar(paste0("pv_s2_q4_bic_", names(ll)[i]), b[i])
  registrar(paste0("pv_s2_q4_aict_", names(ll)[i]), a[i] / n)
  registrar(paste0("pv_s2_q4_bict_", names(ll)[i]), b[i] / n)
}
registrar("pv_s2_q4_ln120", log(n))
registrar("pv_s2_q4_lr", 2 * (ll[["arma21"]] - ll[["arma11"]]))
registrar("pv_s2_q4_lr_p", stats::pchisq(2 * (ll[["arma21"]] - ll[["arma11"]]), 1, lower.tail = FALSE))
registrar("pv_s2_q4_chi2_1", stats::qchisq(0.95, 1))

## Q5: previsão do ARMA(1,1) com sinal positivo e do ARIMA(0,1,1) -----------------------
phi <- 0.5; th_r <- 0.4; zT <- 2; aT <- 1
f1 <- phi * zT + th_r * aT; f2 <- phi * f1; f3 <- phi * f2
psi <- pesos_psi(phi, th_r, 3, sinal_ma = "r"); v <- cumsum(psi^2)
registrar("pv_s2_q5_f1", f1); registrar("pv_s2_q5_f2", f2); registrar("pv_s2_q5_f3", f3)
registrar("pv_s2_q5_psi1", psi[2]); registrar("pv_s2_q5_psi2", psi[3])
registrar("pv_s2_q5_v1", v[1]); registrar("pv_s2_q5_v2", v[2]); registrar("pv_s2_q5_v3", v[3])
registrar("pv_s2_q5_meia2", 1.96 * sqrt(v[2]))
registrar("pv_s2_q5_li2", f2 - 1.96 * sqrt(v[2])); registrar("pv_s2_q5_ls2", f2 + 1.96 * sqrt(v[2]))
# conferência contra o predict() do R: fixa os parâmetros e força z_T e a_T
zz <- stats::arima.sim(list(ar = phi, ma = th_r), n = 400)
fit <- stats::arima(zz, order = c(1, 0, 1), include.mean = FALSE, fixed = c(phi, th_r), transform.pars = FALSE)
eT <- tail(as.numeric(stats::residuals(fit)), 1); zTr <- tail(as.numeric(zz), 1)
registrar("pv_s2_q5_dif_predict", abs(stats::predict(fit, n.ahead = 1)$pred[1] - (phi * zTr + th_r * eT)))
# ARIMA(0,1,1) BJ com theta = 0,7: previsão = y_T - theta a_T para todo h; alpha = 1 - theta
yT <- 50; aT <- 2; th <- 0.7
registrar("pv_s2_q5_ses_nivel", yT - th * aT); registrar("pv_s2_q5_ses_alfa", 1 - th)
registrar("pv_s2_q5_ses_peso2", (1 - th) * th)

## Q6: SARIMA(1,0,0)(0,1,1)_12 e Ljung-Box ---------------------------------------------
registrar("pv_s2_q6_perda", 12); registrar("pv_s2_q6_efetivas", 144 - 12)
registrar("pv_s2_q6_gl", 24 - 2)
registrar("pv_s2_q6_lb_crit", stats::qchisq(0.95, 22))
registrar("pv_s2_q6_lb_p", stats::pchisq(28.5, 22, lower.tail = FALSE))

## ===================================================================================
## SIMULADO 03 — integrador (V ou F, previsão numérica de SARIMA, identificação)
## ===================================================================================

## Q1: tendência determinística x estocástica -------------------------------------------
registrar("pv_s3_q1_var_u", 1 / (1 - 0.6^2))
registrar("pv_s3_q1_e_y10", 2 + 0.5 * 10)
registrar("pv_s3_q1_var_z10", 10)
registrar("pv_s3_q1_resposta_k5", 0.6^5)
gw <- acvf_arma(0.6, 1, 1, lag.max = 1)               # Delta u: (1 - 0,6B) Delta u = (1 - B) eps
registrar("pv_s3_q1_rho1_dy", gw[2] / gw[1])

## Q2: V ou F sobre o ARMA(1,1) com sinal positivo, alpha = 0,5, beta = 0,5 -------------
al <- 0.5; be <- 0.5
g <- acvf_arma(al, be, 1, lag.max = 2, sinal_ma = "r"); r <- g / g[1]
registrar("pv_s3_q2_g0", g[1]); registrar("pv_s3_q2_g1", g[2])
registrar("pv_s3_q2_g0_formula", (1 + 2 * al * be + be^2) / (1 - al^2))
registrar("pv_s3_q2_g1_formula", (1 + al * be) * (al + be) / (1 - al^2))
registrar("pv_s3_q2_rho1", r[2]); registrar("pv_s3_q2_rho2", r[3])
registrar("pv_s3_q2_rho1_formula", (al + be) * (1 + al * be) / (1 + 2 * al * be + be^2))
registrar("pv_s3_q2_g0_errado", 1 / (1 - al^2))
pis <- pesos_pi(al, be, 3, sinal_ma = "r")
registrar("pv_s3_q2_pi1", pis[1]); registrar("pv_s3_q2_pi2", pis[2]); registrar("pv_s3_q2_pi3", pis[3])
psi <- pesos_psi(al, be, 2, sinal_ma = "r")
registrar("pv_s3_q2_psi1", psi[2]); registrar("pv_s3_q2_psi2", psi[3])

## Q3: SARIMA(1,1,0)(0,1,1)_4 com números ------------------------------------------------
phi <- 0.5; Th <- 0.6
lado_ar <- stats::convolve(stats::convolve(c(1, -phi), rev(c(1, -1)), type = "open"),
                           rev(c(1, 0, 0, 0, -1)), type = "open")      # 1 - 1,5B + 0,5B^2 - B^4 + 1,5B^5 - 0,5B^6
coef_ar <- -lado_ar[-1]
for (i in seq_along(coef_ar)) registrar(paste0("pv_s3_q3_c", i), coef_ar[i])
y <- c(100, 104, 98, 101, 107, 103)                    # y_{T-5}, ..., y_T
e <- c(1.0, -0.5, 0.8, 0.4)                            # a_{T-3}, ..., a_T
f <- prever_recursivo(coef_ar, c(0, 0, 0, Th), y, e, 5)
for (h in 1:5) registrar(paste0("pv_s3_q3_f", h), f[h])
registrar("pv_s3_q3_perda", 5)
# conferência com a fórmula de y(1) escrita à mão
f1_mao <- 1.5 * 103 - 0.5 * 107 + 98 - 1.5 * 104 + 0.5 * 100 - Th * 1.0
registrar("pv_s3_q3_dif_f1", abs(f1_mao - f[1]))

## Q4: MV, AIC, BIC e LR entre dois SARIMA mensais --------------------------------------
ll <- c(m1 = -412.6, m2 = -411.9); k <- c(4, 5); n <- 240 - 13
a <- aic(ll, k); b <- bic(ll, k, n)
registrar("pv_s3_q4_aic_m1", a[1]); registrar("pv_s3_q4_aic_m2", a[2])
registrar("pv_s3_q4_bic_m1", b[1]); registrar("pv_s3_q4_bic_m2", b[2])
registrar("pv_s3_q4_ln227", log(n)); registrar("pv_s3_q4_n", n)
registrar("pv_s3_q4_lr", 2 * (ll[2] - ll[1]))
registrar("pv_s3_q4_lr_p", stats::pchisq(2 * (ll[2] - ll[1]), 1, lower.tail = FALSE))

## Q5: previsão do MA(2) com média ------------------------------------------------------
mu <- 3; t1 <- 0.5; t2 <- -0.2; aT <- 1; aT1 <- -2      # BJ: y = mu + (1 - 0,5B + 0,2B^2) a
f1 <- mu - t1 * aT - t2 * aT1; f2 <- mu - t2 * aT; f3 <- mu
psi <- pesos_psi(numeric(0), c(t1, t2), 3); v <- cumsum(psi^2)
registrar("pv_s3_q5_raiz_mod", min(modulo_raizes_ma(c(t1, t2))))
registrar("pv_s3_q5_f1", f1); registrar("pv_s3_q5_f2", f2); registrar("pv_s3_q5_f3", f3)
registrar("pv_s3_q5_v1", v[1]); registrar("pv_s3_q5_v2", v[2]); registrar("pv_s3_q5_v3", v[3])
registrar("pv_s3_q5_g0", acvf_arma(numeric(0), c(t1, t2), 1, lag.max = 0))
registrar("pv_s3_q5_meia3", 1.96 * sqrt(v[3]))

## Q6: identificação do modelo das companhias aéreas com theta = Theta = 0,5 ------------
th <- 0.5; Th <- 0.5
gw <- acvf_arma(numeric(0), c(th, rep(0, 10), Th, -th * Th), 1, lag.max = 13); r <- gw / gw[1]
registrar("pv_s3_q6_rho1", r[2]); registrar("pv_s3_q6_rho11", r[12]); registrar("pv_s3_q6_rho12", r[13])
registrar("pv_s3_q6_rho13", r[14])
registrar("pv_s3_q6_banda", 2 / sqrt(227)); registrar("pv_s3_q6_banda196", 1.96 / sqrt(227))
registrar("pv_s3_q6_lb_p", stats::pchisq(30.1, 22, lower.tail = FALSE))
registrar("pv_s3_q6_lb_crit", stats::qchisq(0.95, 22))

## ===================================================================================
## BANCO DE VARIAÇÕES (b01 ... b16 = questão da lista)
## ===================================================================================

# Q2: c = 1, delta = 0,2, y_0 = 0: E(y_t) = ct + delta t(t+1)/2
registrar("pv_b02_e_y10", 1 * 10 + 0.2 * 10 * 11 / 2)
# Q3: z1 - z2 e 3 z1 + z2 com as FAC da lista
g1 <- c(0.5, 0.2, 0); g2 <- c(2.30, -1.43, 0.30)
d <- g1 + g2; s <- 9 * g1 + g2
registrar("pv_b03_dif_g0", d[1]); registrar("pv_b03_dif_g1", d[2]); registrar("pv_b03_dif_g2", d[3])
registrar("pv_b03_tri_g0", s[1]); registrar("pv_b03_tri_g1", s[2]); registrar("pv_b03_tri_g2", s[3])
# Q4: MA(1) BJ com theta = 0,5: pi_j = -theta^j
pis <- pesos_pi(numeric(0), 0.5, 3)
registrar("pv_b04_pi1", pis[1]); registrar("pv_b04_pi2", pis[2]); registrar("pv_b04_pi3", pis[3])
# Q5: três polinômios
registrar("pv_b05_v1_raiz_a", max(modulo_raizes_ar(c(0.8, -0.15))))
registrar("pv_b05_v1_raiz_b", min(modulo_raizes_ar(c(0.8, -0.15))))
registrar("pv_b05_v2_raiz_a", max(modulo_raizes_ma(c(2.5, -1))))
registrar("pv_b05_v2_raiz_b", min(modulo_raizes_ma(c(2.5, -1))))
registrar("pv_b05_v3_raiz_a", max(modulo_raizes_ar(c(1.2, -0.2))))
registrar("pv_b05_v3_raiz_b", min(modulo_raizes_ar(c(1.2, -0.2))))
# Q6: phi = 0,9, theta = 0,5 e o caso phi = theta
g <- acvf_arma(0.9, 0.5, 1, lag.max = 2)
registrar("pv_b06_rho1", g[2] / g[1]); registrar("pv_b06_rho2", g[3] / g[1])
registrar("pv_b06_rho1_igual", acvf_arma(0.4, 0.4, 1, lag.max = 1)[2])
# Q7: phi1 = 1, phi2 = -0,5 (raízes complexas)
g <- acvf_arma(c(1, -0.5), numeric(0), 1, lag.max = 2)
registrar("pv_b07_rho1", g[2] / g[1]); registrar("pv_b07_rho2", g[3] / g[1]); registrar("pv_b07_g0", g[1])
w <- acos(1 / (2 * sqrt(0.5)))
registrar("pv_b07_periodo", 2 * pi / w); registrar("pv_b07_modulo", Mod(polyroot(c(1, -1, 0.5)))[1])
# Q8: modelo (II) com c = 1, theta = 0,5, Z_0 = 0: E(Z_t) = ct + theta t(t+1)/2
registrar("pv_b08_e_z4", 1 * 4 + 0.5 * 4 * 5 / 2)
registrar("pv_b08_e_z4_errado", 1 * 4 + 0.5 / 2 * 16)
# Q9: ruído branco e AR(1) com phi = 0,9 diferenciados
registrar("pv_b09_rho1_rb", acvf_arma(numeric(0), 1, 1, lag.max = 1)[2] / acvf_arma(numeric(0), 1, 1, lag.max = 0))
g <- acvf_arma(0.9, 1, 1, lag.max = 1)
registrar("pv_b09_rho1_ar09", g[2] / g[1])
# Q11: SAR(1)_12 com Phi = 0,5
g <- acvf_arma(c(rep(0, 11), 0.5), numeric(0), 1, lag.max = 24)
registrar("pv_b11_g0", g[1]); registrar("pv_b11_rho12", g[13] / g[1]); registrar("pv_b11_rho24", g[25] / g[1])
# Q14: T = 100
ll <- c(ar1 = -140.2, arma11 = -138.9, ar2 = -138.7); k <- c(2, 3, 3); n <- 100
a <- aic(ll, k); b <- bic(ll, k, n)
for (i in seq_along(ll)) {
  registrar(paste0("pv_b14_aic_", names(ll)[i]), a[i]); registrar(paste0("pv_b14_bic_", names(ll)[i]), b[i])
}
# Q15: AR(2) com phi = (0,6; 0,2), y_T = 2, y_{T-1} = 1
f1 <- 0.6 * 2 + 0.2 * 1; f2 <- 0.6 * f1 + 0.2 * 2
registrar("pv_b15_f1", f1); registrar("pv_b15_f2", f2)
registrar("pv_b15_v2", sum(pesos_psi(c(0.6, 0.2), numeric(0), 1)^2))
# Q16: SARIMA(2,1,1)(1,1,1)_12 com T = 240
registrar("pv_b16_npar", 2 + 1 + 1 + 1 + 1); registrar("pv_b16_efetivas", 240 - 13)

gravar_resultados("pv")

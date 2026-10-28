# Lista comentada (Q1–Q16) na notação dos slides — todos os números citados em
# lista_comentada/*.md (id "lc"). Aqui o MA está SEMPRE na convenção dos slides,
# theta(L) = 1 + theta_1 L + ... (sinal_ma = "r"); a tradução da lista é
# theta_slides = -theta_lista. Cada número é conferido por dois caminhos (fórmula
# fechada e função do R) e a diferença também é registrada.
# Rodar: Rscript lista_comentada/lista_comentada.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

set.seed(2026)

# Bhaskara para a z^2 + b z + c = 0: devolve delta e as duas raízes (complexas se delta < 0)
bhaskara <- function(a, b, c) {
  delta <- b^2 - 4 * a * c
  r <- sqrt(as.complex(delta))
  list(delta = delta, z1 = (-b + r) / (2 * a), z2 = (-b - r) / (2 * a))
}

## ---- Q1 e Q2: passeio aleatório com drift (e tendência) — conferência por simulação
R <- 20000; TT <- 30; c0 <- 1; s2 <- 1
sim <- matrix(stats::rnorm(R * TT, sd = sqrt(s2)), R, TT)
y <- 10 + t(apply(sim, 1, cumsum)) + matrix(c0 * (1:TT), R, TT, byrow = TRUE)
registrar("lc_q1_media_t30", mean(y[, 30])); registrar("lc_q1_var_t30", stats::var(y[, 30]))
registrar("lc_q1_cov_t30_k10", stats::cov(y[, 30], y[, 20]))
d2 <- 0.2
yq <- t(apply(sim + matrix(c0 + d2 * (1:TT), R, TT, byrow = TRUE), 1, cumsum))
registrar("lc_q2_media_t30", mean(yq[, 30])); registrar("lc_q2_media_t30_formula", c0 * 30 + d2 * 30 * 31 / 2)
registrar("lc_q2_soma_gauss_t10", sum(1:10))

## ---- Q3: z3 = z1 + 2 z2 --------------------------------------------------------------
g1 <- c(0.5, 0.2, 0, 0); g2 <- c(2.30, -1.43, 0.30, 0)
g3 <- g1 + 4 * g2
registrar("lc_q3_g0", g3[1]); registrar("lc_q3_g1", g3[2]); registrar("lc_q3_g2", g3[3]); registrar("lc_q3_g3", g3[4])
registrar("lc_q3_rho1", g3[2] / g3[1]); registrar("lc_q3_rho2", g3[3] / g3[1])
registrar("lc_q3_4x230", 4 * 2.30); registrar("lc_q3_4x143", 4 * 1.43); registrar("lc_q3_4x030", 4 * 0.30)

## ---- Q4: Wold do AR(1) ---------------------------------------------------------------
phi <- 0.5
registrar("lc_q4_soma_psi2", sum(phi^(2 * (0:5000)))); registrar("lc_q4_soma_psi2_formula", 1 / (1 - phi^2))
registrar("lc_q4_psi3", pesos_psi(phi, numeric(0), 3)[4])

## ---- Q5: três modelos (na notação dos slides) --------------------------------------
# (1) (1 - 0,5L) z = eps
psi <- pesos_psi(0.5, numeric(0), 4, sinal_ma = "r")
for (j in 1:4) registrar(paste0("lc_q5_m1_psi", j), psi[j + 1])
registrar("lc_q5_m1_raiz", modulo_raizes_ar(0.5))
# (2) z = (1 + theta1 L + theta2 L^2) eps, com theta1 = -1,3 e theta2 = 0,4 (slides)
bh <- bhaskara(0.4, -1.3, 1)
registrar("lc_q5_m2_delta", bh$delta); registrar("lc_q5_m2_raizdelta", sqrt(bh$delta))
registrar("lc_q5_m2_z1", Re(bh$z1)); registrar("lc_q5_m2_z2", Re(bh$z2))
registrar("lc_q5_m2_z1_polyroot", max(modulo_raizes_ma(c(-1.3, 0.4), "r")))
registrar("lc_q5_m2_z2_polyroot", min(modulo_raizes_ma(c(-1.3, 0.4), "r")))
pis <- pesos_pi(numeric(0), c(-1.3, 0.4), 4, sinal_ma = "r")
for (j in 1:4) registrar(paste0("lc_q5_m2_pi", j), pis[j])
# recursão c_j = 1,3 c_{j-1} - 0,4 c_{j-2}
cc <- c(1, 1.3); for (j in 3:5) cc[j] <- 1.3 * cc[j - 1] - 0.4 * cc[j - 2]
registrar("lc_q5_m2_dif_recursao", max(abs(-cc[2:5] - pis)))
registrar("lc_q5_m2_13x13", 1.3 * 1.3); registrar("lc_q5_m2_13x129", 1.3 * 1.29); registrar("lc_q5_m2_04x13", 0.4 * 1.3)
registrar("lc_q5_m2_13x1157", 1.3 * 1.157); registrar("lc_q5_m2_04x129", 0.4 * 1.29)
# (3) depois do cancelamento: z = (1 - 0,8L) eps
pis <- pesos_pi(numeric(0), -0.8, 4, sinal_ma = "r")
for (j in 1:4) registrar(paste0("lc_q5_m3_pi", j), pis[j])
registrar("lc_q5_m3_raiz", modulo_raizes_ma(-0.8, "r"))
registrar("lc_q5_m3_dif_cancelamento", max(abs(
  pesos_psi(0.5, c(-1.3, 0.4), 20, sinal_ma = "r") - pesos_psi(numeric(0), -0.8, 20, sinal_ma = "r"))))

## ---- Q6: ARMA(1,1) — ilustração numérica com phi = 0,7 e theta_lista = 0,4 ----------
phi <- 0.7; th_s <- -0.4
g <- acvf_arma(phi, th_s, 1, lag.max = 3, sinal_ma = "r")
registrar("lc_q6_g0", g[1]); registrar("lc_q6_g0_formula", (1 + 2 * phi * th_s + th_s^2) / (1 - phi^2))
registrar("lc_q6_g1", g[2]); registrar("lc_q6_g1_formula", phi * g[1] + th_s)
registrar("lc_q6_rho1", g[2] / g[1]); registrar("lc_q6_rho2", g[3] / g[1]); registrar("lc_q6_rho3", g[4] / g[1])
registrar("lc_q6_rho1_formula", (1 + phi * th_s) * (phi + th_s) / (1 + 2 * phi * th_s + th_s^2))
psi <- pesos_psi(phi, th_s, 3, sinal_ma = "r"); pis <- pesos_pi(phi, th_s, 3, sinal_ma = "r")
registrar("lc_q6_psi1", psi[2]); registrar("lc_q6_psi2", psi[3]); registrar("lc_q6_psi3", psi[4])
registrar("lc_q6_pi1", pis[1]); registrar("lc_q6_pi2", pis[2]); registrar("lc_q6_pi3", pis[3])
# quantos pesos até |psi_j| < 0,01 em dois casos: lento (phi = 0,95) e rápido (phi = 0,3)
n_ate <- function(w) which(abs(w) < 0.01)[1] - 1
registrar("lc_q6_n_psi_lento", n_ate(pesos_psi(0.95, -0.4, 500, "r")))
registrar("lc_q6_n_psi_rapido", n_ate(pesos_psi(0.3, -0.4, 500, "r")))

## ---- Q7: AR(2) — ilustração com phi1 = 0,6 e phi2 = 0,2 ------------------------------
p1 <- 0.6; p2 <- 0.2
g <- acvf_arma(c(p1, p2), numeric(0), 1, lag.max = 2); r <- g / g[1]
registrar("lc_q7_rho1", r[2]); registrar("lc_q7_rho2", r[3]); registrar("lc_q7_g0", g[1])
registrar("lc_q7_g0_formula", (1 - p2) / ((1 + p2) * ((1 - p2)^2 - p1^2)))
registrar("lc_q7_g0_via_rho", 1 / (1 - p1 * r[2] - p2 * r[3]))
bh <- bhaskara(-p2, -p1, 1)          # 1 - 0,6 z - 0,2 z^2 = 0  <=>  -0,2 z^2 - 0,6 z + 1 = 0
registrar("lc_q7_delta", bh$delta); registrar("lc_q7_z1", Re(bh$z1)); registrar("lc_q7_z2", Re(bh$z2))

## ---- Q8: V ou F — modelo (I) com alpha = 0,6, beta = 0,3 ----------------------------
al <- 0.6; be <- 0.3
g <- acvf_arma(al, be, 1, lag.max = 2, sinal_ma = "r")
registrar("lc_q8_g0", g[1]); registrar("lc_q8_g1", g[2]); registrar("lc_q8_g2", g[3])
registrar("lc_q8_item1_lado_dir", al * g[2] + 1 + be * (al + be))
registrar("lc_q8_item2_lado_dir", al * (g[1] + 1) + be)
registrar("lc_q8_rho1", g[2] / g[1]); registrar("lc_q8_rho2", g[3] / g[1])
registrar("lc_q8_item3_formula", (be + al) * (1 + al * be) / (1 + 2 * al * be + be^2))
# modelo (II): c = 1, theta = 0,5, Z0 = 0
registrar("lc_q8_e_z4_certo", 1 * 4 + 0.5 * 4 * 5 / 2); registrar("lc_q8_e_z4_lista", 1 * 4 + 0.5 / 2 * 16)

## ---- Q9: diferenciar o AR(1) com phi = 0,6 ------------------------------------------
phi <- 0.6
gw <- acvf_arma(phi, -1, 1, lag.max = 2, sinal_ma = "r")    # (1 - phi L) w = (1 - L) eps
registrar("lc_q9_var_w", gw[1]); registrar("lc_q9_var_w_formula", 2 / (1 + phi))
registrar("lc_q9_rho1_w", gw[2] / gw[1]); registrar("lc_q9_rho1_w_formula", -(1 - phi) / 2)
registrar("lc_q9_var_y", 1 / (1 - phi^2))
registrar("lc_q9_pi5", pesos_pi(phi, -1, 5, "r")[5])

## ---- Q10: ARIMA(1,1,1) e tendência determinística diferenciada -----------------------
phi <- 0.4; th_l <- 0.7
pr <- stats::convolve(c(1, -phi), rev(c(1, -1)), type = "open")
registrar("lc_q10_c1", -pr[2]); registrar("lc_q10_c2", -pr[3])
registrar("lc_q10_rho1_ts", acvf_arma(numeric(0), -1, 1, lag.max = 1, "r")[2] / 2)

## ---- Q11: SAR(1)_4 e o AR(5) restrito (Phi = 0,7; phi = 0,4) ------------------------
Phi <- 0.7
g <- acvf_arma(c(0, 0, 0, Phi), numeric(0), 1, lag.max = 8); r <- g / g[1]
registrar("lc_q11_g0", g[1]); registrar("lc_q11_rho4", r[5]); registrar("lc_q11_rho8", r[9])
registrar("lc_q11_rho1", r[2]); registrar("lc_q11_rho2", r[3]); registrar("lc_q11_rho3", r[4])
fp <- stats::ARMAacf(ar = c(0, 0, 0, Phi), lag.max = 8, pacf = TRUE)
registrar("lc_q11_phi44", fp[4]); registrar("lc_q11_phi88", fp[8])
pr <- stats::convolve(c(1, -0.4), rev(c(1, 0, 0, 0, -Phi)), type = "open")
for (j in 1:5) registrar(paste0("lc_q11_ar5_c", j), -pr[j + 1])

## ---- Q12: SARIMA(1,1,0)(0,1,1)_4 — fórmulas de previsão contra o predict() ---------
phi <- 0.4; Th_s <- -0.6
lado_ar <- stats::convolve(stats::convolve(c(1, -phi), rev(c(1, -1)), type = "open"),
                           rev(c(1, 0, 0, 0, -1)), type = "open")
for (j in 1:6) registrar(paste0("lc_q12_c", j), -lado_ar[j + 1])
ys <- stats::arima.sim(list(order = c(1, 0, 0), ar = phi), n = 400)
ys <- stats::ts(cumsum(ys), frequency = 4)
fit <- stats::arima(ys, order = c(1, 1, 0), seasonal = list(order = c(0, 1, 1), period = 4),
                    fixed = c(phi, Th_s), transform.pars = FALSE)
e <- as.numeric(stats::residuals(fit)); yv <- as.numeric(ys); n <- length(yv)
a <- -lado_ar[-1]
f <- numeric(5); yy <- yv; ee <- c(e, rep(0, 5))
for (h in 1:5) { t <- n + h; yy[t] <- sum(a * yy[t - 1:6]) + Th_s * ee[t - 4]; f[h] <- yy[t] }
registrar("lc_q12_dif_predict", max(abs(f - stats::predict(fit, n.ahead = 5)$pred)))
registrar("lc_q12_perda", 1 + 4 * 1)

## ---- Q13: MV condicional do AR(1) = MQO ----------------------------------------------
y <- as.numeric(stats::arima.sim(list(ar = 0.6), n = 301))
mqo <- sum(y[-1] * y[-301]) / sum(y[-301]^2)
llc <- function(p) { e <- y[-1] - p * y[-301]; s2 <- mean(e^2); -150 * log(2 * pi * s2) - 150 }
registrar("lc_q13_dif_mqo_mv", abs(stats::optimize(llc, c(-0.99, 0.99), maximum = TRUE, tol = 1e-10)$maximum - mqo))
registrar("lc_q13_dif_lm", abs(stats::coef(stats::lm(y[-1] ~ 0 + y[-301]))[[1]] - mqo))

## ---- Q14: AIC e BIC com T = 150 --------------------------------------------------------
ll <- c(arma11 = -210.3, ar2 = -212.8, ma2 = -214.1); k <- 3; n <- 150
for (m in names(ll)) {
  registrar(paste0("lc_q14_m2ll_", m), -2 * ll[[m]])
  registrar(paste0("lc_q14_aic_", m), -2 * ll[[m]] + 2 * k)
  registrar(paste0("lc_q14_bic_", m), -2 * ll[[m]] + k * log(n))
  registrar(paste0("lc_q14_aict_", m), (-2 * ll[[m]] + 2 * k) / n)
  registrar(paste0("lc_q14_bict_", m), (-2 * ll[[m]] + k * log(n)) / n)
}
registrar("lc_q14_ln150", log(n)); registrar("lc_q14_3ln150", 3 * log(n))

## ---- Q15: ARMA(1,1) com phi = 0,7, theta_lista = 0,4 e o SES --------------------------
phi <- 0.7; th_s <- -0.4
psi <- pesos_psi(phi, th_s, 12, "r"); v <- cumsum(psi^2)
registrar("lc_q15_psi1", psi[2]); registrar("lc_q15_psi2", psi[3])
registrar("lc_q15_v1", v[1]); registrar("lc_q15_v2", v[2]); registrar("lc_q15_v3", v[3])
registrar("lc_q15_vinf", acvf_arma(phi, th_s, 1, lag.max = 0, "r")); registrar("lc_q15_v12", v[12])
zz <- stats::arima.sim(list(ar = phi, ma = th_s), n = 500)
fit <- stats::arima(zz, order = c(1, 0, 1), include.mean = FALSE, fixed = c(phi, th_s), transform.pars = FALSE)
eT <- tail(as.numeric(stats::residuals(fit)), 1); zT <- tail(as.numeric(zz), 1)
pr <- stats::predict(fit, n.ahead = 2)
registrar("lc_q15_dif_f1", abs(pr$pred[1] - (phi * zT + th_s * eT)))
registrar("lc_q15_dif_f2", abs(pr$pred[2] - phi * (phi * zT + th_s * eT)))
registrar("lc_q15_dif_var", max(abs(pr$se^2 - fit$sigma2 * v[1:2])))
# SES: ARIMA(0,1,1) com theta_lista = 0,6 => theta_slides = -0,6, alpha = 1 - 0,6
th_s <- -0.6
yy <- cumsum(stats::arima.sim(list(ma = th_s), n = 300))
fit <- stats::arima(yy, order = c(0, 1, 1), fixed = th_s, transform.pars = FALSE)
ses <- stats::HoltWinters(yy, alpha = 1 + th_s, beta = FALSE, gamma = FALSE, l.start = yy[1])
registrar("lc_q15_alfa", 1 + th_s)
registrar("lc_q15_dif_ses", abs(stats::predict(fit, n.ahead = 1)$pred[1] - stats::predict(ses, n.ahead = 1)[1]))

## ---- Q16: SARIMA(1,1,1)(0,1,1)_12 ------------------------------------------------------
registrar("lc_q16_npar", 1 + 1 + 1 + 1); registrar("lc_q16_perda", 1 + 12); registrar("lc_q16_efetivas", 240 - 13)
phi <- 0.5; th_s <- -0.4; Th_s <- -0.6
ma <- c(th_s, rep(0, 10), Th_s, th_s * Th_s)
g <- acvf_arma(phi, ma, 1, lag.max = 14, "r"); r <- g / g[1]
registrar("lc_q16_rho1", r[2]); registrar("lc_q16_rho2", r[3]); registrar("lc_q16_rho11", r[12])
registrar("lc_q16_rho12", r[13]); registrar("lc_q16_rho13", r[14])
registrar("lc_q16_ma13", th_s * Th_s)

## ---- Exemplos do caderno (03/09 e 02/09), refeitos e corrigidos ----------------------
# AR(2) y_t = 1,5 y_{t-1} - 0,6 y_{t-2} + a_t: polinômio característico l^2 - 1,5 l + 0,6 = 0
bh <- bhaskara(1, -1.5, 0.6)
registrar("lc_cad_delta", bh$delta); registrar("lc_cad_raiz_abs_delta", sqrt(abs(bh$delta)))
registrar("lc_cad_lambda_re", Re(bh$z1)); registrar("lc_cad_lambda_im", Im(bh$z1))
registrar("lc_cad_lambda_mod", Mod(bh$z1)); registrar("lc_cad_lambda_mod2", Mod(bh$z1)^2)
registrar("lc_cad_lambda2_mod", Mod(bh$z2))
registrar("lc_cad_z_mod", min(modulo_raizes_ar(c(1.5, -0.6))))
w <- acos(Re(bh$z1) / Mod(bh$z1))
registrar("lc_cad_omega", w); registrar("lc_cad_periodo", 2 * pi / w)
registrar("lc_cad_auto_F", max(Mod(eigen(matrix(c(1.5, 1, -0.6, 0), 2))$values)))
registrar("lc_cad_errado_lambda2", sqrt(0.75 - 0.19^2))
registrar("lc_cad_075q", 0.75^2); registrar("lc_cad_im_q", Im(bh$z1)^2)
# ARMA(1,1) com phi = 0,7 e theta_slides = -0,4: gamma_0 certo x o do caderno (sem o quadrado)
phi <- 0.7; th_s <- -0.4
registrar("lc_cad_g0_certo", (1 + th_s^2 + 2 * phi * th_s) / (1 - phi^2))
registrar("lc_cad_g0_caderno", (1 + th_s + 2 * phi * th_s) / (1 - phi^2))

## ---- Demonstrações à mão (Q2 e Q6) ----------------------------------------------------
# Q2: Y_t = a1 + Y_{t-1} + a2 t + eps_t, Y_0 = 0; recursão direta x fórmula fechada
a1 <- 1; a2 <- 0.2
media_rec <- numeric(3); m <- 0
for (t in 1:3) { m <- a1 + m + a2 * t; media_rec[t] <- m }
registrar("lc_am_q2_ey1", media_rec[1]); registrar("lc_am_q2_ey2", media_rec[2]); registrar("lc_am_q2_ey3", media_rec[3])
registrar("lc_am_q2_dif_formula", max(abs(media_rec - (a1 * (1:3) + a2 * (1:3) * (2:4) / 2))))
set.seed(11)
eps <- matrix(stats::rnorm(50000 * 3), 50000, 3)
Y <- t(apply(eps, 1, function(e) { y <- numeric(3); yy <- 0; for (t in 1:3) { yy <- a1 + yy + a2 * t + e[t]; y[t] <- yy }; y }))
registrar("lc_am_q2_var3", stats::var(Y[, 3])); registrar("lc_am_q2_cov31", stats::cov(Y[, 3], Y[, 1]))
registrar("lc_am_q2_corr31", stats::cor(Y[, 3], Y[, 1])); registrar("lc_am_q2_corr31_formula", sqrt(1 / 3))
# Q6: meia-vida dos pesos, h = ln 0,5 / ln |phi|
for (f in c(0.5, 0.9, 0.99)) registrar(sprintf("lc_am_q6_meiavida_%s", sub("\\.", "", format(f))), log(0.5) / log(f))
# Q6: psi_j por substituição recursiva (resolvendo y_t a partir de choques) = fórmula fechada
phi <- 0.7; th <- -0.4
psi_rec <- c(1, phi + th); for (j in 3:6) psi_rec[j] <- phi * psi_rec[j - 1]
registrar("lc_am_q6_dif_psi", max(abs(psi_rec - pesos_psi(phi, th, 5, "r"))))
registrar("lc_am_q6_dif_pi", max(abs((phi + th) * (-th)^(0:4) - pesos_pi(phi, th, 5, "r"))))

gravar_resultados("lc")

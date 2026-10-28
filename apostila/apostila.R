# Apostila da P1 (lista teórica Q1–Q16) — todos os números citados em apostila/*.md (id "ap").
# MA sempre na convenção dos slides, theta(L) = 1 + theta_1 L + ... (sinal_ma = "r").
# Cada número é conferido por dois caminhos (fórmula fechada e função do R) quando possível.
# Rodar: Rscript apostila/apostila.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

set.seed(2026)

## ---- Capítulo 1: processos e momentos ----------------------------------------------------
# Q1: passeio com drift, y0 = 10, c = 0,5, sigma2 = 1, em t = 20 e k = 5 (fórmula e simulação)
y0 <- 10; cc <- 0.5; tt <- 20; kk <- 5
registrar("ap_c1_rw_media", y0 + cc * tt); registrar("ap_c1_rw_var", tt)
registrar("ap_c1_rw_cov", tt - kk); registrar("ap_c1_rw_corr", sqrt((tt - kk) / tt))
e <- matrix(stats::rnorm(40000 * tt), 40000, tt)
Y <- y0 + t(apply(e + cc, 1, cumsum))
registrar("ap_c1_rw_media_sim", mean(Y[, tt])); registrar("ap_c1_rw_var_sim", stats::var(Y[, tt]))
registrar("ap_c1_rw_cov_sim", stats::cov(Y[, tt], Y[, tt - kk]))
# Q3: z3 = z1 + 2 z2, com z1 e z2 não correlacionados
g1 <- c(0.5, 0.2, 0, 0); g2 <- c(2.30, -1.43, 0.30, 0); g3 <- g1 + 4 * g2
registrar("ap_c1_z3_g0", g3[1]); registrar("ap_c1_z3_g1", g3[2]); registrar("ap_c1_z3_g2", g3[3]); registrar("ap_c1_z3_g3", g3[4])
registrar("ap_c1_z3_rho1", g3[2] / g3[1]); registrar("ap_c1_z3_rho2", g3[3] / g3[1])
# processo linear: gamma_k = sigma2 * soma psi_j psi_{j+k}, conferido no MA(2) com psi = (1; 0,7; 0,6)
ps <- c(1, 0.7, 0.6)
registrar("ap_c1_pl_g1", sum(ps[1:2] * ps[2:3])); registrar("ap_c1_pl_g2", ps[1] * ps[3])
registrar("ap_c1_pl_rho1_r", stats::ARMAacf(ma = c(0.7, 0.6), lag.max = 1)[2])
registrar("ap_c1_pl_rho1", sum(ps[1:2] * ps[2:3]) / sum(ps^2))
# Wold do AR(1) com phi = 0,5
ps <- 0.5^(0:4)
registrar("ap_c1_wold_psi1", ps[2]); registrar("ap_c1_wold_psi4", ps[5])
registrar("ap_c1_wold_soma2", 1 / (1 - 0.5^2)); registrar("ap_c1_wold_soma2_r", sum(0.5^(2 * (0:200))))
# estacionário mas não ergódico: y_t = Z + e_t, Z sorteado uma vez por trajetória
set.seed(7)
Z <- stats::rnorm(3); Tn <- 5000
medias <- sapply(Z, function(z) mean(z + stats::rnorm(Tn)))
registrar("ap_c1_erg_z1", Z[1]); registrar("ap_c1_erg_m1", medias[1])
registrar("ap_c1_erg_z2", Z[2]); registrar("ap_c1_erg_m2", medias[2])
registrar("ap_c1_erg_z3", Z[3]); registrar("ap_c1_erg_m3", medias[3])
registrar("ap_c1_erg_ensemble", mean(stats::rnorm(20000) + stats::rnorm(20000)))

## ---- Capítulo 3: integrados, ARIMA e SARIMA ----------------------------------------------
# sobrediferenciação de um AR(1): w = (1 - L) y, com (1 - phi L) w = (1 - L) e
rho1_w <- function(phi) -(1 - phi) / 2
var_y <- function(phi) 1 / (1 - phi^2); var_w <- function(phi) 2 / (1 + phi)
registrar("ap_c3_rb_rho1", stats::ARMAacf(ma = -1, lag.max = 1)[2])
for (f in c(0.2, 0.5, 0.9)) {
  k <- sub("\\.", "", format(f))
  registrar(sprintf("ap_c3_w_rho1_%s", k), rho1_w(f))
  registrar(sprintf("ap_c3_vary_%s", k), var_y(f)); registrar(sprintf("ap_c3_varw_%s", k), var_w(f))
}
registrar("ap_c3_w_rho1_05_r", stats::ARMAacf(ar = 0.5, ma = -1, lag.max = 1)[2])
# SAR(1)_4 com Phi = 0,6
PH <- 0.6; g0 <- 1 / (1 - PH^2)
registrar("ap_c3_sar_g0", g0); registrar("ap_c3_sar_g4", PH * g0); registrar("ap_c3_sar_g8", PH^2 * g0)
ac <- stats::ARMAacf(ar = c(0, 0, 0, PH), lag.max = 8)
registrar("ap_c3_sar_rho1_r", ac[2]); registrar("ap_c3_sar_rho4_r", ac[5]); registrar("ap_c3_sar_rho8_r", ac[9])
# SARIMA(1,0,0)(1,0,0)_4 com phi = 0,5 e Phi = 0,6: AR(5) restrito
pr <- c(1, -0.5) %o% c(1, 0, 0, 0, -PH)
coef <- c(pr[1, 1], 0, 0, 0, 0, 0); coef[2] <- pr[2, 1]; coef[5] <- pr[1, 5]; coef[6] <- pr[2, 5]
registrar("ap_c3_mult_phi1", -coef[2]); registrar("ap_c3_mult_phi4", -coef[5]); registrar("ap_c3_mult_phi5", -coef[6])
# observações perdidas: d + s D
registrar("ap_c3_perda_trim", 1 + 4 * 1); registrar("ap_c3_perda_mensal", 1 + 12 * 1)

## ---- Capítulo 4: estimação e seleção -------------------------------------------------------
# um AR(1) simulado: MQO (= MV condicional), Yule-Walker e MV exata
set.seed(13)
y <- as.numeric(stats::arima.sim(list(ar = 0.6), n = 200))
yt <- y[-1]; y1 <- y[-200]
registrar("ap_c4_phi_mqo", sum(yt * y1) / sum(y1^2))
registrar("ap_c4_phi_mqo_lm", unname(stats::coef(stats::lm(yt ~ 0 + y1))))
registrar("ap_c4_phi_yw", sum(yt * y1) / sum(y^2))
registrar("ap_c4_phi_yw_r", stats::ar.yw(y, aic = FALSE, order.max = 1, demean = FALSE)$ar)
registrar("ap_c4_phi_exata", unname(stats::coef(stats::arima(y, order = c(1, 0, 0), include.mean = FALSE, method = "ML"))))
registrar("ap_c4_s2_mqo", sum((yt - sum(yt * y1) / sum(y1^2) * y1)^2) / 199)
# Q14: T = 150, k = 3 nos três modelos (p + q + variância)
TT <- 150; ll <- c(-210.3, -212.8, -214.1); k <- c(3, 3, 3)
aic_s <- (-2 * ll + 2 * k) / TT; bic_s <- (-2 * ll + k * log(TT)) / TT
for (i in 1:3) {
  registrar(sprintf("ap_c4_q14_aic%d", i), aic_s[i]); registrar(sprintf("ap_c4_q14_bic%d", i), bic_s[i])
  registrar(sprintf("ap_c4_q14_aicR%d", i), -2 * ll[i] + 2 * k[i]); registrar(sprintf("ap_c4_q14_bicR%d", i), -2 * ll[i] + k[i] * log(TT))
}
registrar("ap_c4_lnT", log(TT))
# com quanta frequência AIC e BIC escolhem um AR(2) quando o verdadeiro é AR(1) (phi = 0,5)?
sobreajuste <- function(n, R = 1000) {
  lr <- replicate(R, {
    x <- as.numeric(stats::arima.sim(list(ar = 0.5), n = n + 50))[-(1:50)]
    Y <- x[3:n]; X1 <- x[2:(n - 1)]; X2 <- x[1:(n - 2)]
    s1 <- mean(stats::resid(stats::lm(Y ~ 0 + X1))^2); s2 <- mean(stats::resid(stats::lm(Y ~ 0 + X1 + X2))^2)
    (n - 2) * log(s1 / s2)
  })
  c(aic = mean(lr > 2), bic = mean(lr > log(n - 2)))
}
set.seed(14)
a150 <- sobreajuste(150); a2000 <- sobreajuste(2000)
registrar("ap_c4_sob_aic_150", a150[["aic"]]); registrar("ap_c4_sob_bic_150", a150[["bic"]])
registrar("ap_c4_sob_aic_2000", a2000[["aic"]]); registrar("ap_c4_sob_bic_2000", a2000[["bic"]])
registrar("ap_c4_sob_aic_teorico", 1 - stats::pchisq(2, 1))

## ---- Capítulo 5: previsão -----------------------------------------------------------------
# AR(1) com mu = 10, phi = 0,8, sigma2 = 1, y_T = 14
mu <- 10; ph <- 0.8; yT <- 14
prev <- mu + ph^(1:3) * (yT - mu); vh <- cumsum(ph^(2 * (0:2)))
registrar("ap_c5_ar_prev1", prev[1]); registrar("ap_c5_ar_prev2", prev[2]); registrar("ap_c5_ar_prev3", prev[3])
registrar("ap_c5_ar_var1", vh[1]); registrar("ap_c5_ar_var2", vh[2]); registrar("ap_c5_ar_var3", vh[3])
registrar("ap_c5_ar_varinf", 1 / (1 - ph^2))
registrar("ap_c5_ar_ic1_inf", prev[1] - 1.96); registrar("ap_c5_ar_ic1_sup", prev[1] + 1.96)
registrar("ap_c5_ar_icinf_meia", 1.96 * sqrt(1 / (1 - ph^2)))
registrar("ap_c5_ar_meiavida", log(0.5) / log(ph))
# ARMA(1,1) da AU02, p. 86: phi = 0,8, theta = 0,6; y_T = 2, eps_T = 0,5, mu = 0
p1 <- 0.8 * 2 + 0.6 * 0.5; p2 <- 0.8 * p1
registrar("ap_c5_arma_prev1", p1); registrar("ap_c5_arma_prev2", p2)
ps <- c(1, stats::ARMAtoMA(ar = 0.8, ma = 0.6, lag.max = 2))
registrar("ap_c5_arma_var2", sum(ps[1:2]^2)); registrar("ap_c5_arma_var3", sum(ps[1:3]^2))
# ARIMA(0,1,1) = suavização exponencial: lista theta = 0,6 -> alpha = 1 - theta = 0,4
th <- 0.6; al <- 1 - th
registrar("ap_c5_ses_alpha", al)
registrar("ap_c5_ses_w0", al); registrar("ap_c5_ses_w1", al * (1 - al)); registrar("ap_c5_ses_w2", al * (1 - al)^2)
set.seed(15)
x <- cumsum(as.numeric(stats::arima.sim(list(ma = -th), n = 300)))
ses <- x[1]; for (t in 2:length(x)) ses <- al * x[t] + (1 - al) * ses
fit <- stats::arima(x, order = c(0, 1, 1), fixed = -th, transform.pars = FALSE)
pr <- stats::predict(fit, n.ahead = 3)$pred
registrar("ap_c5_ses_dif", abs(ses - pr[1])); registrar("ap_c5_ses_plano", abs(pr[3] - pr[1]))

## ---- Capítulo 6: aplicação (SARIMA mensal da Q16) ------------------------------------------
# modelo das companhias aéreas (phi = 0): FAC de w = (1 + th L)(1 + TH L^12) e, na lista, th = -0,4, TH = -0,6
th <- -0.4; TH <- -0.6
registrar("ap_c6_air_rho1", th / (1 + th^2)); registrar("ap_c6_air_rho12", TH / (1 + TH^2))
registrar("ap_c6_air_rho11", th * TH / ((1 + th^2) * (1 + TH^2)))
ma13 <- c(th, rep(0, 10), TH, th * TH)
ac <- stats::ARMAacf(ma = ma13, lag.max = 14)
registrar("ap_c6_air_rho1_r", ac[2]); registrar("ap_c6_air_rho11_r", ac[12]); registrar("ap_c6_air_rho12_r", ac[13])
registrar("ap_c6_air_rho13_r", ac[14]); registrar("ap_c6_air_rho2_r", ac[3])
# com o AR (phi = 0,5): a FAC de w da Q16
ac2 <- stats::ARMAacf(ar = 0.5, ma = ma13, lag.max = 14)
registrar("ap_c6_q16_rho1", ac2[2]); registrar("ap_c6_q16_rho12", ac2[13])
# contagens
registrar("ap_c6_npar", 4); registrar("ap_c6_efetivas", 240 - 13); registrar("ap_c6_ln227", log(227))
registrar("ap_c6_lb_gl", 24 - 3); registrar("ap_c6_lb_crit", stats::qchisq(0.95, 21)); registrar("ap_c6_lr_crit", stats::qchisq(0.95, 1))
# Box-Jenkins de ponta a ponta numa série simulada com o modelo verdadeiro
set.seed(16)
n <- 240 + 60
e <- stats::rnorm(n)
w <- numeric(n)
for (t in 14:n) w[t] <- 0.5 * w[t - 1] + e[t] + th * e[t - 1] + TH * e[t - 12] + th * TH * e[t - 13]
y <- numeric(n); for (t in 14:n) y[t] <- y[t - 1] + y[t - 12] - y[t - 13] + w[t]
y <- stats::ts(y[(n - 239):n], frequency = 12)
fit <- stats::arima(y, order = c(1, 1, 1), seasonal = list(order = c(0, 1, 1), period = 12))
cf <- stats::coef(fit)
registrar("ap_c6_est_phi", cf[["ar1"]]); registrar("ap_c6_est_th", cf[["ma1"]]); registrar("ap_c6_est_TH", cf[["sma1"]])
se <- sqrt(diag(fit$var.coef))
registrar("ap_c6_se_phi", se[["ar1"]]); registrar("ap_c6_se_th", se[["ma1"]]); registrar("ap_c6_se_TH", se[["sma1"]])
registrar("ap_c6_est_s2", fit$sigma2); registrar("ap_c6_est_nobs", fit$nobs)
lb <- stats::Box.test(stats::resid(fit), lag = 24, type = "Ljung-Box", fitdf = 3)
registrar("ap_c6_lb_stat", unname(lb$statistic)); registrar("ap_c6_lb_p", lb$p.value)
fit2 <- stats::arima(y, order = c(2, 1, 1), seasonal = list(order = c(0, 1, 1), period = 12))
registrar("ap_c6_lr", 2 * (fit2$loglik - fit$loglik))
registrar("ap_c6_bic1", stats::BIC(fit)); registrar("ap_c6_bic2", stats::BIC(fit2))

## ---- Capítulo 2: AR, MA e ARMA -----------------------------------------------------------
# MA(1): o par theta = 0,5 (sigma2 = 4) e theta = 2 (sigma2 = 1) da AU02, p. 34
ma1 <- function(th, s2) c(g0 = (1 + th^2) * s2, g1 = th * s2, rho1 = th / (1 + th^2))
a <- ma1(0.5, 4); b <- ma1(2, 1)
registrar("ap_c2_ma_a_g0", a[["g0"]]); registrar("ap_c2_ma_a_g1", a[["g1"]]); registrar("ap_c2_ma_a_rho1", a[["rho1"]])
registrar("ap_c2_ma_b_g0", b[["g0"]]); registrar("ap_c2_ma_b_g1", b[["g1"]]); registrar("ap_c2_ma_b_rho1", b[["rho1"]])
registrar("ap_c2_ma_dif_acf", max(abs(stats::ARMAacf(ma = 0.5, lag.max = 5) - stats::ARMAacf(ma = 2, lag.max = 5))))
registrar("ap_c2_ma_rho1_max", max(sapply(seq(-5, 5, by = 0.001), function(t) t / (1 + t^2))))
# pesos de y_{t-j} na reconstrução de epsilon_t: (-theta)^j
registrar("ap_c2_ma_pi4_05", (-0.5)^4); registrar("ap_c2_ma_pi4_2", (-2)^4)

# AR(1) com phi = 0,8
phi <- 0.8
registrar("ap_c2_ar1_g0", 1 / (1 - phi^2))
registrar("ap_c2_ar1_g0_r", acvf_arma(phi, numeric(0), 1, 0)[1])
registrar("ap_c2_ar1_rho5", phi^5)
registrar("ap_c2_ar1_meiavida", log(0.5) / log(phi))

# AR(2) do caderno (03/09): y_t = 1,5 y_{t-1} - 0,6 y_{t-2} + e_t
p1 <- 1.5; p2 <- -0.6
# phi(z) = 1 - 1,5 z + 0,6 z^2 = 0  ->  a = 0,6; b = -1,5; c = 1
delta <- (-p1)^2 - 4 * (-p2) * 1
z1 <- (p1 + sqrt(as.complex(delta))) / (2 * (-p2))
registrar("ap_c2_ar2_delta", delta)
registrar("ap_c2_ar2_re", Re(z1)); registrar("ap_c2_ar2_im", abs(Im(z1)))
registrar("ap_c2_ar2_mod", Mod(z1)); registrar("ap_c2_ar2_mod_r", min(modulo_raizes_ar(c(p1, p2))))
registrar("ap_c2_ar2_lambda", 1 / Mod(z1))
registrar("ap_c2_ar2_soma", p1 + p2); registrar("ap_c2_ar2_dif", p2 - p1)
registrar("ap_c2_ar2_rho1", p1 / (1 - p2)); registrar("ap_c2_ar2_rho2", p1 * p1 / (1 - p2) + p2)
registrar("ap_c2_ar2_rho1_r", stats::ARMAacf(ar = c(p1, p2), lag.max = 2)[2])
registrar("ap_c2_ar2_cosw", p1 / (2 * sqrt(-p2)))
registrar("ap_c2_ar2_periodo", 2 * pi / acos(p1 / (2 * sqrt(-p2))))

# ARMA(1,1) da AU02, p. 86: phi = 0,8, theta = 0,6
ps <- pesos_psi(0.8, 0.6, 3, "r")
registrar("ap_c2_arma_psi1", ps[2]); registrar("ap_c2_arma_psi2", ps[3]); registrar("ap_c2_arma_psi3", ps[4])
registrar("ap_c2_arma_rho1", (1 + 0.8 * 0.6) * (0.8 + 0.6) / (1 + 2 * 0.8 * 0.6 + 0.6^2))
registrar("ap_c2_arma_rho1_r", stats::ARMAacf(ar = 0.8, ma = 0.6, lag.max = 1)[2])

## ---- Folha à mão do capítulo 2 (Q5, Q7 e Q8) ---------------------------------------------
# Q5 (1): AR(1) com phi = 0,5
registrar("ap_am2_q5m1_z", 1 / 0.5)
ps <- pesos_psi(0.5, numeric(0), 4, "r")
for (j in 1:4) registrar(sprintf("ap_am2_q5m1_psi%d", j), ps[j + 1])
# Q5 (2): MA(2) com theta(z) = 1 - 1,3 z + 0,4 z^2 (slides: theta_1 = -1,3, theta_2 = 0,4)
a <- 0.4; b <- -1.3; c0 <- 1
de <- b^2 - 4 * a * c0
registrar("ap_am2_q5m2_delta", de); registrar("ap_am2_q5m2_z1", (-b + sqrt(de)) / (2 * a)); registrar("ap_am2_q5m2_z2", (-b - sqrt(de)) / (2 * a))
registrar("ap_am2_q5m2_zmin_r", min(modulo_raizes_ma(c(-1.3, 0.4), "r")))
cc <- numeric(5); cc[1] <- 1
for (j in 2:5) cc[j] <- 1.3 * cc[j - 1] - 0.4 * (if (j >= 3) cc[j - 2] else 0)
pis <- pesos_pi(numeric(0), c(-1.3, 0.4), 4, "r")
for (j in 1:4) registrar(sprintf("ap_am2_q5m2_pi%d", j), -cc[j + 1])
registrar("ap_am2_q5m2_dif", max(abs(-cc[2:5] - pis)))
# Q5 (3): fator comum -> MA(1) com theta_1 = -0,8
ps3 <- pesos_psi(0.5, c(-1.3, 0.4), 20, "r"); ps1 <- pesos_psi(numeric(0), -0.8, 20, "r")
registrar("ap_am2_q5m3_psi1", ps3[2]); registrar("ap_am2_q5m3_psi2", ps3[3])
registrar("ap_am2_q5m3_dif", max(abs(ps3 - ps1)))
for (j in 1:4) registrar(sprintf("ap_am2_q5m3_pi%d", j), -(0.8)^j)
# Q7: AR(2) do caderno, phi_1 = 1,5 e phi_2 = -0,6, sigma2 = 1
p1 <- 1.5; p2 <- -0.6
r1 <- p1 / (1 - p2); r2 <- p1 * r1 + p2
registrar("ap_am2_q7_rho1", r1); registrar("ap_am2_q7_rho2", r2)
registrar("ap_am2_q7_rho2_formula", (p1^2 + p2 - p2^2) / (1 - p2))
registrar("ap_am2_q7_g0_rho", 1 / (1 - p1 * r1 - p2 * r2))
registrar("ap_am2_q7_g0_formula", (1 - p2) / ((1 + p2) * ((1 - p2)^2 - p1^2)))
registrar("ap_am2_q7_g0_r", acvf_arma(c(p1, p2), numeric(0), 1, 0)[1])
registrar("ap_am2_q7_f1", 1 + p2); registrar("ap_am2_q7_f2", 1 - p2 - p1); registrar("ap_am2_q7_f3", 1 - p2 + p1)
# Q8 (I): alpha = 0,6, beta = 0,3, sigma2 = 1
al <- 0.6; be <- 0.3
g0 <- (1 + 2 * al * be + be^2) / (1 - al^2); g1 <- al * g0 + be
registrar("ap_am2_q8_g0", g0); registrar("ap_am2_q8_g1", g1)
registrar("ap_am2_q8_g0_r", acvf_arma(al, be, 1, 1, "r")[1]); registrar("ap_am2_q8_g1_r", acvf_arma(al, be, 1, 1, "r")[2])
registrar("ap_am2_q8_item1", al * g1 + 1 + be * (al + be))
registrar("ap_am2_q8_item2", al * (g0 + 1) + be)
registrar("ap_am2_q8_rho1", g1 / g0); registrar("ap_am2_q8_rho2", al * g1 / g0)
# Q8 (II): c = 1, theta = 0,5, Z0 = 0, t = 4
registrar("ap_am2_q8_ez4", 1 * 4 + 0.5 * 4 * 5 / 2); registrar("ap_am2_q8_ez4_item", 1 * 4 + 0.5 / 2 * 16)
registrar("ap_am2_q8_vz4", 4); registrar("ap_am2_q8_vz4_item", 1 + 0.5 * 4)

gravar_resultados("ap")

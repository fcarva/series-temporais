# Módulo 02 — Processos AR, MA e ARMA (lista, Q5–Q8).
# Pesos psi e pi dos três modelos da Q5 (e o fator comum do modelo 3), FAC do
# ARMA(1,1) da Q6, Yule-Walker do AR(2) da Q7 e as cinco afirmativas da Q8.
# Convenção: a lista usa theta(B) = 1 - theta_1 B - ...; ver R/series.R.
# Rodar: Rscript 02_arma/02_arma.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

FIG <- caminho_repo("02_arma", "figuras")
set.seed(2026)

## ---- Q5 -----------------------------------------------------------------------
reg_pesos <- function(id, phi, theta) {
  psi <- pesos_psi(phi, theta, n = 4); pi_ <- pesos_pi(phi, theta, n = 4)
  for (j in 1:4) {
    registrar(sprintf("m02_q5_%s_psi%d", id, j), psi[j + 1])
    registrar(sprintf("m02_q5_%s_pi%d", id, j), pi_[j])
  }
}
# (1) (1 - 0,5B) z = a
reg_pesos("m1", 0.5, numeric(0))
registrar("m02_q5_m1_raiz", modulo_raizes_ar(0.5))
# (2) z = (1 - 1,3B + 0,4B^2) a  -> theta_1 = 1,3, theta_2 = -0,4 na convenção BJ
th2 <- c(1.3, -0.4)
reg_pesos("m2", numeric(0), th2)
rz <- sort(modulo_raizes_ma(th2))
registrar("m02_q5_m2_raiz1", rz[1]); registrar("m02_q5_m2_raiz2", rz[2])
# (3) (1 - 0,5B) z = (1 - 1,3B + 0,4B^2) a = (1 - 0,5B)(1 - 0,8B) a  => MA(1) com theta = 0,8
reg_pesos("m3", 0.5, th2)
stopifnot(isTRUE(all.equal(pesos_psi(0.5, th2, 10), pesos_psi(numeric(0), 0.8, 10))))
registrar("m02_q5_m3_fator", 0.5 * 0.8)    # produto das raízes inversas: 0,4

## ---- Q6: ARMA(1,1), z_t - phi z_{t-1} = a_t - theta a_{t-1} --------------------
phi <- 0.8; th <- 0.4; s2 <- 1
g0 <- (1 + th^2 - 2 * phi * th) * s2 / (1 - phi^2)
g1 <- (1 - phi * th) * (phi - th) * s2 / (1 - phi^2)
gt <- acvf_arma(phi, th, s2, lag.max = 3)
stopifnot(abs(gt[1] - g0) < 1e-8, abs(gt[2] - g1) < 1e-8, abs(gt[3] - phi * g1) < 1e-8)
registrar("m02_q6_g0", g0); registrar("m02_q6_g1", g1); registrar("m02_q6_g2", phi * g1)
registrar("m02_q6_rho1", g1 / g0)
registrar("m02_q6_rho3_formula", phi^2 * g1 / g0)
registrar("m02_q6_rho3_armaacf", stats::ARMAacf(ar = phi, ma = -th, lag.max = 3)[4])
# psi_j = (phi - theta) phi^(j-1);  pi_j = (phi - theta) theta^(j-1)
registrar("m02_q6_psi3", pesos_psi(phi, th, 3)[4]); registrar("m02_q6_psi3_formula", (phi - th) * phi^2)
registrar("m02_q6_pi3", pesos_pi(phi, th, 3)[3]); registrar("m02_q6_pi3_formula", (phi - th) * th^2)
# quantos pesos até |peso| < 0,01: lento quando |phi| (psi) ou |theta| (pi) perto de 1
n_ate <- function(v) which(abs(v) < 0.01)[1] - 1
registrar("m02_q6_n_psi_phi08", n_ate(pesos_psi(0.8, 0.4, 200)[-1]))
registrar("m02_q6_n_psi_phi095", n_ate(pesos_psi(0.95, 0.4, 500)[-1]))
registrar("m02_q6_n_pi_th04", n_ate(pesos_pi(0.8, 0.4, 200)))
registrar("m02_q6_n_pi_th095", n_ate(pesos_pi(0.8, 0.95, 500)))

## ---- Q7: AR(2), Yule-Walker ----------------------------------------------------
p1 <- 0.5; p2 <- 0.3; s2 <- 1
rho1 <- p1 / (1 - p2); rho2 <- p1^2 / (1 - p2) + p2
g0_7 <- (1 - p2) * s2 / ((1 + p2) * ((1 - p2)^2 - p1^2))
ac <- stats::ARMAacf(ar = c(p1, p2), lag.max = 2)
stopifnot(abs(ac[2] - rho1) < 1e-10, abs(ac[3] - rho2) < 1e-10)
stopifnot(abs(acvf_arma(c(p1, p2), lag.max = 0) - g0_7) < 1e-8)
registrar("m02_q7_rho1", rho1); registrar("m02_q7_rho2", rho2); registrar("m02_q7_g0", g0_7)
registrar("m02_q7_g0_alt", s2 / (1 - p1 * rho1 - p2 * rho2))
# inversão de Yule-Walker em amostra grande: recupera phi
y7 <- stats::arima.sim(list(ar = c(p1, p2)), n = 20000)
yw <- stats::ar.yw(y7, order.max = 2, aic = FALSE)$ar
registrar("m02_q7_yw_phi1", yw[1]); registrar("m02_q7_yw_phi2", yw[2])

## ---- Q8: modelos (I) e (II) ----------------------------------------------------
# (I) Y_t = alpha Y_{t-1} + u_t + beta u_{t-1}  (MA com sinal positivo: conv. R)
al <- 0.6; be <- 0.3; s2 <- 1
g <- acvf_arma(al, be, s2, lag.max = 3, sinal_ma = "r")
af1 <- al * g[2] + s2 + be * (al + be) * s2      # afirmativa 1
af2 <- al * (g[1] + s2) + be * s2                # afirmativa 2
corr2 <- al * g[1] + be * s2                     # gamma_1 correto
af3 <- (be + al) * (1 + al * be) / (1 + 2 * al * be + be^2)
registrar("m02_q8_g0", g[1]); registrar("m02_q8_af1", af1)
registrar("m02_q8_g1", g[2]); registrar("m02_q8_af2", af2); registrar("m02_q8_g1_correto", corr2)
registrar("m02_q8_rho1", g[2] / g[1]); registrar("m02_q8_af3", af3); registrar("m02_q8_rho2", g[3] / g[1])
# (II) Z_t = c + Z_{t-1} + theta t + eps_t, Z_0 = 0
cc <- 0.5; tt <- 0.1; TT <- 40; R <- 20000
E <- matrix(rnorm(R * TT), R, TT)
Z <- matrix(cc * (1:TT) + tt * (1:TT) * ((1:TT) + 1) / 2, R, TT, byrow = TRUE) + t(apply(E, 1, cumsum))
registrar("m02_q8_z_media_sim", mean(Z[, TT]))
registrar("m02_q8_z_media_correta", cc * TT + tt * TT * (TT + 1) / 2)
registrar("m02_q8_z_media_af4", cc * TT + tt / 2 * TT^2)
registrar("m02_q8_z_var_sim", var(Z[, TT]))
registrar("m02_q8_z_var_af5", (cc + tt * TT) * 1)

## ---- figura: assinaturas FAC/FACP ---------------------------------------------
salvar_figura(file.path(FIG, "m02_assinaturas"), function() {
  graphics::par(mfrow = c(2, 3), mar = c(3.8, 4, 4.4, 1))
  casos <- list(list(nome = "AR(1), φ = 0,7", ar = 0.7, ma = numeric(0)),
                list(nome = "MA(1), θ = 0,7 (conv. R)", ar = numeric(0), ma = 0.7),
                list(nome = "ARMA(1,1), φ = 0,8, θ = 0,4 (BJ)", ar = 0.8, ma = -0.4))
  for (lin in 1:2) for (c in casos) {
    v <- if (lin == 1) stats::ARMAacf(c$ar, c$ma, lag.max = 12)[-1]
         else stats::ARMAacf(c$ar, c$ma, lag.max = 12, pacf = TRUE)
    plot(1:12, v, type = "h", xlim = c(0.5, 12 + 0.5), lwd = 4, ylim = c(-0.6, 1), xlab = "defasagem",
         ylab = if (lin == 1) "FAC" else "FACP", col = if (lin == 1) CORES$principal else CORES$compara)
    graphics::abline(h = 0, col = CORES$eixo)
    titulo_editorial(c$nome, if (lin == 1) "FAC teórica" else "FACP teórica")
  }
}, largura = 11, altura = 6.5)

## ---- EQD: equações de diferenças (revisão, Chiang e Wainwright, caps. 17-18) ----
# 1ª ordem: y_{t+1} - 0,5 y_t = 3, y_0 = 10  ->  y_t = A b^t + y_p
a1 <- -0.5; c1 <- 3; y0 <- 10
yp1 <- c1 / (1 + a1); A1 <- y0 - yp1; b1 <- -a1
it <- numeric(6); it[1] <- y0
for (t in 1:5) it[t + 1] <- c1 - a1 * it[t]                 # solução iterativa
stopifnot(isTRUE(all.equal(it, A1 * b1^(0:5) + yp1)))       # bate com a fechada
registrar("m02_eqd1_yp", yp1); registrar("m02_eqd1_A", A1); registrar("m02_eqd1_b", b1)
registrar("m02_eqd1_y3", it[4])
# 2ª ordem ligada ao AR(2): y_t = 1,0 y_{t-1} - 0,5 y_{t-2}  <=>  y_{t+2} - y_{t+1} + 0,5 y_t = 0
ph <- c(1.0, -0.5)
b2 <- polyroot(c(-ph[2], -ph[1], 1))                         # b^2 - phi1 b - phi2 = 0
registrar("m02_eqd2_mod", Mod(b2[1])); registrar("m02_eqd2_ang", abs(Arg(b2[1])))
registrar("m02_eqd2_periodo", 2 * pi / abs(Arg(b2[1])))
registrar("m02_eqd2_mod_z", min(modulo_raizes_ar(ph)))       # raízes de phi(z): inversas das de b
stopifnot(abs(Mod(b2[1]) * min(modulo_raizes_ar(ph)) - 1) < 1e-10)
registrar("m02_eqd2_disc", ph[1]^2 + 4 * ph[2])              # discriminante: < 0 -> raízes complexas
# 2ª ordem com termo constante: y_{t+2} - y_{t+1} + 0,5 y_t = 2  ->  y_p = 2/(1 - 1 + 0,5)
registrar("m02_eqd2_yp", 2 / (1 - ph[1] - ph[2]))

## ---- D02.5: a banda da FAC amostral (Bartlett) ---------------------------------
# Ruído branco: Var(rho_hat_k) ~ 1/T. MA(q): para k > q, Var ~ (1 + 2 sum_{j<=q} rho_j^2)/T.
set.seed(2026)
T_b <- 200; R_b <- 5000
r_wn <- replicate(R_b, stats::acf(stats::rnorm(T_b), lag.max = 2, plot = FALSE)$acf[2:3])
registrar("m02_bart_dp_wn", stats::sd(r_wn[1, ])); registrar("m02_bart_dp_wn_teo", 1 / sqrt(T_b))
registrar("m02_bart_rej_wn", 100 * mean(abs(r_wn[1, ]) > 1.96 / sqrt(T_b)))
th_b <- 0.5; rho1_b <- th_b / (1 + th_b^2)                     # MA(1), sinal do R: y = e + 0,5 e_{t-1}
r_ma <- replicate(R_b, stats::acf(stats::arima.sim(list(ma = th_b), T_b), lag.max = 2, plot = FALSE)$acf[3])
registrar("m02_bart_rho1_ma", rho1_b)
registrar("m02_bart_dp_ma2", stats::sd(r_ma)); registrar("m02_bart_dp_ma2_teo", sqrt((1 + 2 * rho1_b^2) / T_b))
registrar("m02_bart_rej_ma2_ingenua", 100 * mean(abs(r_ma) > 1.96 / sqrt(T_b)))
registrar("m02_bart_rej_ma2_bartlett", 100 * mean(abs(r_ma) > 1.96 * sqrt((1 + 2 * rho1_b^2) / T_b)))
registrar("m02_bart_T", T_b); registrar("m02_bart_R", R_b)

gravar_resultados("m02")

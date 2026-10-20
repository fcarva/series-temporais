# Módulo 01 — Processos estocásticos, estacionariedade e momentos (lista, Q1–Q4).
# Confere por simulação os momentos do passeio aleatório com drift (Q1) e com
# drift e tendência (Q2), calcula a FAC da soma de processos (Q3) e os pesos de
# Wold do AR(1) (Q4). Gera duas figuras.
# Rodar: Rscript 01_processos_estacionariedade/01_processos.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

FIG <- caminho_repo("01_processos_estacionariedade", "figuras")
set.seed(2026)

## ---- Q1: passeio aleatório com drift, y0 = 10 ---------------------------------
# y_t = 10 + c t + sum u_i  =>  E = 10 + c t, Var = t sigma2, Cov(y_t, y_{t-k}) = (t-k) sigma2
R <- 20000; TT <- 100; cc <- 0.3; s2 <- 1
U <- matrix(rnorm(R * TT, 0, sqrt(s2)), R, TT)
Y <- 10 + matrix(cc * (1:TT), R, TT, byrow = TRUE) + t(apply(U, 1, cumsum))
registrar("m01_q1_media_t50_sim", mean(Y[, 50]))
registrar("m01_q1_media_t50_teo", 10 + cc * 50)
registrar("m01_q1_var_t50_sim", var(Y[, 50]))
registrar("m01_q1_cov_50_40_sim", cov(Y[, 50], Y[, 40]))
registrar("m01_q1_rho_100_10", sqrt((100 - 10) / 100))   # FAC depende de t: sqrt((t-k)/t)

## ---- Q2: passeio com drift e tendência, y0 = 0 -------------------------------
# y_t = c t + delta t(t+1)/2 + sum u_i
dl <- 0.02
Y2 <- matrix(cc * (1:TT) + dl * (1:TT) * ((1:TT) + 1) / 2, R, TT, byrow = TRUE) + t(apply(U, 1, cumsum))
registrar("m01_q2_media_t50_sim", mean(Y2[, 50]))
registrar("m01_q2_media_t50_teo", cc * 50 + dl * 50 * 51 / 2)
registrar("m01_q2_var_t50_sim", var(Y2[, 50]))
# a primeira diferença ainda tem tendência linear: Delta y_t = c + delta t + u_t
d2 <- Y2[, 50] - Y2[, 49]
registrar("m01_q2_media_dif_t50_sim", mean(d2))
registrar("m01_q2_media_dif_t50_teo", cc + dl * 50)

salvar_figura(file.path(FIG, "m01_q1_q2_trajetorias"), function() {
  graphics::par(mfrow = c(1, 2), mar = c(4.2, 4.4, 4.8, 1.2))
  for (k in 1:2) {
    M <- if (k == 1) Y else Y2
    q <- apply(M, 2, stats::quantile, c(0.05, 0.95))
    plot(1:TT, colMeans(M), type = "n", ylim = range(q, M[1:5, ]), xlab = "t", ylab = expression(y[t]))
    grade_h()
    graphics::polygon(c(1:TT, TT:1), c(q[1, ], rev(q[2, ])), col = cor_alpha(CORES$principal, 0.2), border = NA)
    for (r in 1:5) graphics::lines(1:TT, M[r, ], col = cor_alpha(CORES$eixo, 0.7))
    graphics::lines(1:TT, colMeans(M), col = CORES$compara, lwd = 2)
    if (k == 1) titulo_editorial("Q1: média reta, leque que abre", "y_t = c + y_{t-1} + u_t; c = 0,3; faixa = 90% das trajetórias")
    else titulo_editorial("Q2: média curva, mesmo leque", "y_t = c + δt + y_{t-1} + u_t; δ = 0,02",
                          fonte = "simulação, 20.000 réplicas")
  }
}, largura = 10)

## ---- Q3: z3 = z1 + 2 z2, z1 e z2 não correlacionados -------------------------
g1 <- c(0.5, 0.2, 0, 0); g2 <- c(2.30, -1.43, 0.30, 0)
g3 <- g1 + 4 * g2
registrar("m01_q3_g0", g3[1]); registrar("m01_q3_g1", g3[2]); registrar("m01_q3_g2", g3[3])
registrar("m01_q3_rho1", g3[2] / g3[1]); registrar("m01_q3_rho2", g3[3] / g3[1])
# densidade espectral (sem 1/2pi) não negativa => função de autocovariância válida
espec <- function(g, w) g[1] + 2 * g[2] * cos(w) + 2 * g[3] * cos(2 * w)
w <- seq(0, pi, length.out = 2001)
registrar("m01_q3_espec_min", min(espec(g3, w)))
registrar("m01_q3_espec_min_z2", min(espec(g2, w)))
# z1 e z2 como MA invertíveis:
#   z1: rho1 = theta/(1+theta^2) = 0,4  =>  theta_R = 0,5 (z1 = a_t + 0,5 a_{t-1}), sigma2 = 0,2/0,5 = 0,4
#   z2: (1 - 1,1B + 0,3B^2) a_t com sigma2 = 1 (conv. Box-Jenkins: theta_1 = 1,1, theta_2 = -0,3)
registrar("m01_q3_z1_sigma2", g1[2] / 0.5)
chk_z2 <- acvf_arma(theta = c(1.1, -0.3), sigma2 = 1, lag.max = 3)
registrar("m01_q3_z2_check_g1", chk_z2[2])
# fatoração espectral de z3: MA(2) invertível com mesma FAC (solução numérica)
obj <- function(p) {
  th <- p[1:2]; s2 <- exp(p[3])
  sum((acvf_arma(theta = th, sigma2 = s2, lag.max = 2, sinal_ma = "r") - g3[1:3])^2)
}
op <- stats::optim(c(-0.5, 0.1, log(5)), obj, control = list(reltol = 1e-14, maxit = 5000))
op <- stats::optim(op$par, obj, method = "BFGS", control = list(reltol = 1e-16, maxit = 1000))
th3 <- op$par[1:2]; s23 <- exp(op$par[3])
stopifnot(invertivel(th3, "r"), op$value < 1e-10)
registrar("m01_q3_ma_theta1_r", th3[1]); registrar("m01_q3_ma_theta2_r", th3[2])
registrar("m01_q3_ma_sigma2", s23)

## ---- Q4: Wold do AR(1) ---------------------------------------------------------
phi <- 0.7
psi <- pesos_psi(phi = phi, n = 5)
registrar("m01_q4_psi3", psi[4])
registrar("m01_q4_soma_psi2", sum(pesos_psi(phi = phi, n = 5000)^2))
registrar("m01_q4_soma_psi2_teo", 1 / (1 - phi^2))
# resto da substituição recursiva: E(phi^k y_{t-k})^2 = phi^(2k) gamma0 -> 0
registrar("m01_q4_resto_k20", phi^(2 * 20) / (1 - phi^2))

# FAC: passeio aleatório vs. AR(1) (aula 01, "diagnóstico prático")
rw <- cumsum(rnorm(500)); ar <- stats::arima.sim(list(ar = 0.7), 500)
salvar_figura(file.path(FIG, "m01_fac_rw_ar1"), function() {
  graphics::par(mfrow = c(1, 2), mar = c(4.2, 4.4, 4.8, 1.2))
  for (k in 1:2) {
    a <- stats::acf(if (k == 1) rw else ar, lag.max = 40, plot = FALSE)$acf[-1]
    plot(1:40, a, type = "h", xlim = c(0.5, 40 + 0.5), lwd = 3, ylim = c(-0.2, 1), xlab = "defasagem", ylab = "FAC",
         col = if (k == 1) CORES$compara else CORES$principal)
    graphics::abline(h = 0, col = CORES$eixo); graphics::abline(h = c(-1, 1) * 1.96 / sqrt(500), lty = 2, col = CORES$neutra)
    if (k == 1) titulo_editorial("Passeio aleatório: a FAC não morre", "T = 500")
    else titulo_editorial("AR(1), φ = 0,7: decai geometricamente", "T = 500", fonte = "simulação")
  }
}, largura = 10)

## ---- D01.4: fraca x estrita e ergodicidade (simulação) -------------------------
# (a) fraca sem ser estrita: t par ~ N(0,1), t ímpar ~ U(-sqrt 3, sqrt 3), independentes.
#     Média 0, variância 1, gamma_k = 0: estacionário de 2ª ordem; a distribuição muda com t.
n_a <- 200000
z_par <- stats::rnorm(n_a); z_imp <- stats::runif(n_a, -sqrt(3), sqrt(3))
curt <- function(x) mean((x - mean(x))^4) / mean((x - mean(x))^2)^2
registrar("m01_d4_var_par", stats::var(z_par)); registrar("m01_d4_var_imp", stats::var(z_imp))
registrar("m01_d4_curt_par", curt(z_par)); registrar("m01_d4_curt_imp", curt(z_imp))
# (b) estacionário mas não ergódico: y_t = Z + e_t, Z ~ N(0,1) sorteado uma vez por realização.
#     ybar -> Z, não mu = 0: o dp de ybar entre realizações não cai com T.
# (c) AR(1) com phi = 0,8: ergódico para a média, Var(ybar) ~ gamma_0 (1+phi)/((1-phi) T).
R_d4 <- 2000; phi_d4 <- 0.8
for (n in c(100, 1000)) {
  yb_z <- replicate(R_d4, stats::rnorm(1) + mean(stats::rnorm(n)))
  yb_ar <- replicate(R_d4, mean(stats::arima.sim(list(ar = phi_d4), n)))
  registrar(sprintf("m01_d4_dp_z_t%d", n), stats::sd(yb_z))
  registrar(sprintf("m01_d4_dp_ar_t%d", n), stats::sd(yb_ar))
  registrar(sprintf("m01_d4_dp_ar_teo_t%d", n), sqrt((1 / (1 - phi_d4^2)) * (1 + phi_d4) / ((1 - phi_d4) * n)))
}
registrar("m01_d4_R", R_d4)

gravar_resultados("m01")

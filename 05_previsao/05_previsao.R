# Módulo 05 — Previsão (lista, Q15).
# Previsões do ARMA(1,1) pelas fórmulas da Q15b conferidas contra predict(),
# variância do erro de previsão via pesos psi (Q15c) e a equivalência entre
# ARIMA(0,1,1) e suavização exponencial simples (Q15e).
# Rodar: Rscript 05_previsao/05_previsao.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

FIG <- caminho_repo("05_previsao", "figuras")
set.seed(2026)

## ---- Q15b–d: ARMA(1,1), z_t - phi z_{t-1} = a_t - theta a_{t-1} -----------------
phi <- 0.7; th <- 0.4; s2 <- 1
y <- stats::arima.sim(list(ar = phi, ma = -th), n = 3000, sd = sqrt(s2))
fit <- stats::arima(y, order = c(1, 0, 1), include.mean = FALSE, fixed = c(phi, -th), transform.pars = FALSE)
aT <- tail(as.numeric(stats::residuals(fit)), 1); yT <- tail(as.numeric(y), 1)
pr <- stats::predict(fit, n.ahead = 12)
f1 <- phi * yT - th * aT; f2 <- phi * f1
registrar("m05_q15_dif_h1", abs(f1 - pr$pred[1])); registrar("m05_q15_dif_h2", abs(f2 - pr$pred[2]))
psi <- pesos_psi(phi, th, 12)
v_h <- s2 * cumsum(psi^2)[1:12]
registrar("m05_q15_dif_var", max(abs(fit$sigma2 * v_h / s2 - pr$se^2)))
registrar("m05_q15_var_h1", v_h[1]); registrar("m05_q15_var_h2", v_h[2]); registrar("m05_q15_var_h12", v_h[12])
registrar("m05_q15_gamma0", acvf_arma(phi, th, s2, lag.max = 0))
registrar("m05_q15_psi1", psi[2])
registrar("m05_q15_ic_h1_meia", 1.96 * sqrt(v_h[1])); registrar("m05_q15_ic_h2_meia", 1.96 * sqrt(v_h[2]))
# Q15e: ARIMA(0,1,1) = SES com alpha = 1 - theta
th_s <- 0.6
x <- cumsum(stats::arima.sim(list(ma = -th_s), n = 2000))
f011 <- stats::arima(x, order = c(0, 1, 1), fixed = -th_s, transform.pars = FALSE)
p011 <- stats::predict(f011, n.ahead = 5)$pred
hw <- stats::HoltWinters(x, alpha = 1 - th_s, beta = FALSE, gamma = FALSE)
p_ses <- stats::predict(hw, n.ahead = 5)
registrar("m05_q15_alpha", 1 - th_s)
registrar("m05_q15_ses_dif", max(abs(as.numeric(p011) - as.numeric(p_ses))))
registrar("m05_q15_ses_const", max(abs(diff(as.numeric(p011)))))
# pesos da média móvel exponencial: (1 - theta) theta^j
registrar("m05_q15_peso0", 1 - th_s); registrar("m05_q15_peso3", (1 - th_s) * th_s^3)

salvar_figura(file.path(FIG, "m05_q15_leque"), function() {
  graphics::par(mar = c(4.2, 4.4, 4.8, 1.6))
  hh <- 0:12; m <- c(yT, as.numeric(pr$pred)); se <- c(0, sqrt(v_h))
  plot(hh, m, type = "n", ylim = range(m - 2 * se, m + 2 * se), xlab = "horizonte h", ylab = "previsão")
  grade_h()
  graphics::polygon(c(hh, rev(hh)), c(m - 1.96 * se, rev(m + 1.96 * se)), col = cor_alpha(CORES$principal, 0.25), border = NA)
  graphics::lines(hh, m, col = CORES$principal, lwd = 2); graphics::abline(h = 0, lty = 2, col = CORES$compara)
  graphics::abline(h = c(-1, 1) * 1.96 * sqrt(acvf_arma(phi, th, s2, lag.max = 0)), lty = 3, col = CORES$eixo)
  titulo_editorial("A previsão volta à média; o intervalo se abre até ±1,96√γ₀",
                   "ARMA(1,1), φ = 0,7, θ = 0,4 (conv. da lista); faixa = IC 95%",
                   fonte = "cálculo teórico", obs = "pontilhado = limite de longo prazo do intervalo")
})

## ---- D05.x: CRPS e testes de Christoffersen (AU03, p. 56-60) ----------------------
set.seed(2026)
# CRPS de uma previsão N(mu, sigma^2) para o observado y: forma fechada (Gneiting e Raftery)
crps_normal <- function(mu, sigma, y) {
  z <- (y - mu) / sigma
  sigma * (z * (2 * stats::pnorm(z) - 1) + 2 * stats::dnorm(z) - 1 / sqrt(pi))
}
crps_integral <- function(mu, sigma, y) {
  f <- function(x) (stats::pnorm(x, mu, sigma) - (x >= y))^2
  stats::integrate(f, -Inf, y)$value + stats::integrate(f, y, Inf)$value
}
casos <- list(larga = c(1, 2), deslocada = c(3, 1), calibrada = c(1, 0.5))
for (nm in names(casos)) {
  m <- casos[[nm]][1]; s <- casos[[nm]][2]
  registrar(sprintf("m05_crps_%s", nm), crps_normal(m, s, 1))
  stopifnot(abs(crps_normal(m, s, 1) - crps_integral(m, s, 1)) < 1e-6)
}
# previsão pontual perfeita (sigma -> 0): CRPS vira o erro absoluto
registrar("m05_crps_pontual", crps_normal(1.4, 1e-8, 1))

# Christoffersen (1998): violações I_t = 1{y_t fora do IC}; p = 0,05 nominal
christoffersen <- function(I, p = 0.05) {
  n1 <- sum(I); n0 <- length(I) - n1; pih <- n1 / length(I)
  lr_uc <- -2 * ((n0 * log(1 - p) + n1 * log(p)) - (n0 * log(1 - pih) + n1 * log(pih)))
  a <- I[-length(I)]; b <- I[-1]
  n00 <- sum(a == 0 & b == 0); n01 <- sum(a == 0 & b == 1); n10 <- sum(a == 1 & b == 0); n11 <- sum(a == 1 & b == 1)
  p01 <- n01 / (n00 + n01); p11 <- n11 / (n10 + n11); p2 <- (n01 + n11) / (n00 + n01 + n10 + n11)
  ll <- function(x, k) if (k == 0) 0 else k * log(x)
  l_ind <- ll(1 - p01, n00) + ll(p01, n01) + ll(1 - p11, n10) + ll(p11, n11)
  l_res <- ll(1 - p2, n00 + n10) + ll(p2, n01 + n11)
  lr_ind <- -2 * (l_res - l_ind)
  c(taxa = 100 * pih, uc = lr_uc, ind = lr_ind, cc = lr_uc + lr_ind, p11 = p11,
    p_uc = stats::pchisq(lr_uc, 1, lower.tail = FALSE), p_ind = stats::pchisq(lr_ind, 1, lower.tail = FALSE),
    p_cc = stats::pchisq(lr_uc + lr_ind, 2, lower.tail = FALSE))
}
n_c <- 500
I_iid <- stats::rbinom(n_c, 1, 0.05)                         # intervalo calibrado: violações i.i.d.
# intervalo com violações em blocos: cadeia de Markov com P(1|0) = 0,03 e P(1|1) = 0,40
I_mk <- numeric(n_c); for (t in 2:n_c) I_mk[t] <- stats::rbinom(1, 1, if (I_mk[t - 1] == 1) 0.40 else 0.03)
for (nm in c("iid", "mk")) {
  r <- christoffersen(if (nm == "iid") I_iid else I_mk)
  for (k in names(r)) registrar(sprintf("m05_chr_%s_%s", nm, k), r[[k]])
}
registrar("m05_chr_n", n_c); registrar("m05_chr_mk_estac", 100 * 0.03 / (0.03 + 0.60))   # taxa estacionária da cadeia

gravar_resultados("m05")

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

gravar_resultados("m05")

# Módulo 04 — Identificação, estimação e seleção (lista, Q13–Q14).
# Q13: MV condicional do AR(1) = MQO, conferido numericamente.
# Q14: AIC e BIC dos três ARMA com as log-verossimilhanças do enunciado.
# Rodar: Rscript 04_estimacao_selecao/04_estimacao.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

set.seed(2026)

## ---- Q13: AR(1) — MV condicional em y_1 ---------------------------------------
TT <- 500; phi <- 0.7
y <- as.numeric(stats::arima.sim(list(ar = phi), n = TT))
phi_mqo <- sum(y[-1] * y[-TT]) / sum(y[-TT]^2)
loglik_c <- function(p) {
  e <- y[-1] - p[1] * y[-TT]; s2 <- exp(p[2])
  -(TT - 1) / 2 * log(2 * pi) - (TT - 1) / 2 * log(s2) - sum(e^2) / (2 * s2)
}
mv <- stats::optim(c(0, 0), function(p) -loglik_c(p), method = "BFGS", control = list(reltol = 1e-14))
registrar("m04_q13_phi_mqo", phi_mqo)
registrar("m04_q13_phi_mv", mv$par[1])
registrar("m04_q13_dif", abs(phi_mqo - mv$par[1]))
s2_mqo <- sum((y[-1] - phi_mqo * y[-TT])^2) / (TT - 1)
registrar("m04_q13_s2_mqo", s2_mqo); registrar("m04_q13_s2_mv", exp(mv$par[2]))
registrar("m04_q13_ep_assint", sqrt((1 - phi_mqo^2) / TT))
registrar("m04_q13_phi_lm", stats::coef(stats::lm(y[-1] ~ 0 + y[-TT]))[[1]])

## ---- Q14: AIC e BIC -------------------------------------------------------------
TT <- 150
ll <- c(arma11 = -210.3, arma20 = -212.8, arma02 = -214.1)
k <- c(arma11 = 3, arma20 = 3, arma02 = 3)      # parâmetros ARMA + variância (média zero)
aic <- -2 * ll + 2 * k; bic <- -2 * ll + k * log(TT)
for (m in names(ll)) {
  registrar(sprintf("m04_q14_aic_%s", m), aic[[m]]); registrar(sprintf("m04_q14_bic_%s", m), bic[[m]])
  registrar(sprintf("m04_q14_aic_t_%s", m), aic[[m]] / TT); registrar(sprintf("m04_q14_bic_t_%s", m), bic[[m]] / TT)
}
registrar("m04_q14_ln_t", log(TT))
registrar("m04_q14_pen_bic", 3 * log(TT))
# T a partir do qual o BIC penaliza mais que o AIC: ln T > 2
registrar("m04_q14_t_cruza", ceiling(exp(2)))

# consistência vs. eficiência: frequência com que cada critério escolhe a ordem certa
# de um AR(1) entre AR(1)...AR(4), para T crescente
freq <- function(TT, R = 300) {
  ok <- c(aic = 0, bic = 0)
  for (r in 1:R) {
    x <- stats::arima.sim(list(ar = 0.5), n = TT)
    crit <- sapply(1:4, function(p) {
      f <- stats::arima(x, order = c(p, 0, 0), include.mean = FALSE, method = "CSS-ML")
      c(stats::AIC(f), stats::BIC(f))
    })
    ok["aic"] <- ok["aic"] + (which.min(crit[1, ]) == 1)
    ok["bic"] <- ok["bic"] + (which.min(crit[2, ]) == 1)
  }
  ok / R
}
f1 <- freq(100); f2 <- freq(1000)
registrar("m04_q14_mc_aic_t100", f1[["aic"]]); registrar("m04_q14_mc_bic_t100", f1[["bic"]])
registrar("m04_q14_mc_aic_t1000", f2[["aic"]]); registrar("m04_q14_mc_bic_t1000", f2[["bic"]])

gravar_resultados("m04")

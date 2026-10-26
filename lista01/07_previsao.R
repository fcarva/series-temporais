# =====================================================================================
# 07_previsao.R — Questão 7: avaliação preditiva contra benchmarks
#
# (a) Validação = últimas H = 24 observações; treino até T0 = T - H.
# (b) Esquema 1 — origem fixa, múltiplos passos: estima só com 1..T0 e prevê h = 1..H,
#     com intervalos de 95%.
# (c) Esquema 2 — origem móvel, um passo, SEM reestimar: os coeficientes de (b) ficam
#     fixos (Arima(y, model = ajuste_treino)) e o filtro de Kalman só atualiza o estado;
#     a previsão de um passo em t+1 é o valor ajustado de t+1 dado o passado até t.
# (d)(e) RMSE, MAE e MAPE do modelo e dos benchmarks (passeio aleatório e sazonal
#     ingênuo), nos dois esquemas, numa única tabela.
# (f)(g) Comparação honesta e cobertura empírica do intervalo de 95% do Esquema 1.
# Extras de pós-graduação: Diebold-Mariano (com a correção de Harvey, Leybourne e
# Newbold, 1997), teste de cobertura de Kupiec (1995) e regressão de Mincer-Zarnowitz
# com erros-padrão HAC de Newey-West.
#
# Escala: o modelo é para y = 100 log(INPC); as métricas são calculadas no ÍNDICE em
# nível, P = exp(y/100), que é a "série em nível" da Q1. A previsão exp(ŷ/100) é a
# mediana de P; a correção para a média (exp(σ²_h/2)) é desprezível aqui (σ_h ≪ 100).
# =====================================================================================
# localiza 00_configuracao.R ao lado deste script (funciona de qualquer diretório)
source(file.path(local({ a <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))
  if (length(a)) dirname(normalizePath(a)) else if (file.exists("00_configuracao.R")) "." else "lista01" }),
  "00_configuracao.R"))
q1 <- ler("q1"); q4 <- ler("q4"); y <- q1$y; P <- q1$P; T_ <- q1$T
fit_full <- q4$fits[[q4$SELECIONADO]]; o <- fit_full$arma
T0 <- T_ - H
y_tr <- window(y, end = time(y)[T0])
nivel <- function(v) exp(as.numeric(v) / 100)

## ---- 7.1 (b) Esquema 1: origem fixa ----------------------------------------------------
fit_tr <- Arima(y_tr, order = c(o[1], 1, o[2]), seasonal = list(order = c(o[3], 0, o[4]), period = S),
                include.drift = TRUE, method = "ML")
fc1 <- forecast(fit_tr, h = H, level = NIVEL_IC)
real <- as.numeric(P[(T0 + 1):T_])
prev1 <- nivel(fc1$mean); li1 <- nivel(fc1$lower[, 1]); ls1 <- nivel(fc1$upper[, 1])

## ---- 7.2 (c) Esquema 2: origem móvel, um passo, coeficientes fixos ----------------------
fit_fix <- Arima(y, model = fit_tr)              # mesmos coeficientes, toda a amostra
stopifnot(isTRUE(all.equal(coef(fit_fix), coef(fit_tr))))
um_passo <- as.numeric(fitted(fit_fix))[(T0 + 1):T_]   # ŷ_{t+1|t}, t = T0..T-1
prev2 <- nivel(um_passo)
li2 <- nivel(um_passo - qnorm(0.975) * sqrt(fit_tr$sigma2)); ls2 <- nivel(um_passo + qnorm(0.975) * sqrt(fit_tr$sigma2))

## ---- 7.3 Benchmarks -------------------------------------------------------------------
Pv <- as.numeric(P); h <- 1:H
rw1 <- rep(Pv[T0], H)                                   # ŷ_{T0+h} = y_{T0}
sn1 <- Pv[T0 + h - S * ceiling(h / S)]                  # ŷ_{T0+h} = y_{T0+h-s·ceil(h/s)}
rw2 <- Pv[T0:(T_ - 1)]                                  # ŷ_{t+1} = y_t
sn2 <- Pv[(T0 + 1):T_ - S]                              # ŷ_{t+1} = y_{t+1-s}
# Extra (fora do pedido): passeio com drift em log, o benchmark "justo" de uma série com tendência
drift_tr <- mean(diff(as.numeric(y_tr)))
rwd1 <- nivel(as.numeric(y_tr)[T0] + drift_tr * h)
rwd2 <- nivel(as.numeric(y)[T0:(T_ - 1)] + drift_tr)

## ---- 7.4 (d)(e) Métricas -------------------------------------------------------------------
metricas <- function(prev) {
  e <- real - prev
  c(RMSE = sqrt(mean(e^2)), MAE = mean(abs(e)), MAPE = 100 * mean(abs(e / real)))
}
modelos <- list(
  "SARIMA selecionado" = list(prev1, prev2),
  "Passeio aleatório" = list(rw1, rw2),
  "Sazonal ingênuo" = list(sn1, sn2),
  "Extra: passeio com drift" = list(rwd1, rwd2))
tab7 <- do.call(rbind, lapply(names(modelos), function(m) {
  a <- metricas(modelos[[m]][[1]]); b <- metricas(modelos[[m]][[2]])
  data.frame(modelo = m, E1_RMSE = a[["RMSE"]], E1_MAE = a[["MAE"]], E1_MAPE = a[["MAPE"]],
             E2_RMSE = b[["RMSE"]], E2_MAE = b[["MAE"]], E2_MAPE = b[["MAPE"]])
}))
# Razões (Theil-U) do modelo em relação a cada benchmark: < 1 => o modelo é melhor
razoes <- data.frame(
  benchmark = c("Passeio aleatório", "Sazonal ingênuo", "Extra: passeio com drift"),
  U_E1 = tab7$E1_RMSE[1] / tab7$E1_RMSE[2:4], U_E2 = tab7$E2_RMSE[1] / tab7$E2_RMSE[2:4])

## ---- 7.5 Testes formais (extras) -------------------------------------------------------
# Diebold-Mariano no Esquema 2 (um passo, perda quadrática); H0: mesma acurácia.
dm <- function(a, b) {
  t <- dm.test(real - a, real - b, h = 1, power = 2, alternative = "two.sided")
  c(DM = unname(t$statistic), p = t$p.value)
}
tab_dm <- rbind("vs passeio aleatório" = dm(prev2, rw2), "vs sazonal ingênuo" = dm(prev2, sn2),
                "vs passeio com drift" = dm(prev2, rwd2))
# Cobertura (g): proporção dos 24 valores dentro do IC de 95%
dentro1 <- real >= li1 & real <= ls1; dentro2 <- real >= li2 & real <= ls2
kupiec <- function(dentro, alfa = 0.05) {
  n <- length(dentro); x <- sum(!dentro); pi_hat <- x / n
  ll0 <- (n - x) * log(1 - alfa) + x * log(alfa)
  ll1 <- if (x %in% c(0, n)) 0 else (n - x) * log(1 - pi_hat) + x * log(pi_hat)
  lr <- -2 * (ll0 - ll1)
  c(violacoes = x, cobertura = 100 * mean(dentro), LR_uc = lr, p = pchisq(lr, 1, lower.tail = FALSE),
    p_binomial = binom.test(x, n, alfa)$p.value)
}
cob <- rbind("Esquema 1" = kupiec(dentro1), "Esquema 2" = kupiec(dentro2))
# Mincer-Zarnowitz no Esquema 2, em inflação mensal: π_t = a + b π̂_{t|t-1} + u, H0: a = 0, b = 1
pi_real <- diff(as.numeric(y))[T0:(T_ - 1)]                         # Δy em T0+1..T
pi_prev <- um_passo - as.numeric(y)[T0:(T_ - 1)]
mz <- lm(pi_real ~ pi_prev)
V <- NeweyWest(mz, lag = 2, prewhite = FALSE)
R <- diag(2); r <- c(0, 1); dif <- coef(mz) - r
W_mz <- as.numeric(t(dif) %*% solve(V) %*% dif); p_mz <- pchisq(W_mz, 2, lower.tail = FALSE)

## ---- 7.6 Figuras ---------------------------------------------------------------------
tt <- as.numeric(time(P)); janela <- (T0 - 48):T_
figura("q7_esquema1", {
  plot(tt[janela], Pv[janela], type = "n", ylim = range(c(Pv[janela], li1, ls1, sn1)), xlab = "",
       ylab = "INPC (dez/1993 = 100)", main = "Esquema 1: origem fixa em T0, h = 1, …, 24")
  grade()
  polygon(c(tt[(T0 + 1):T_], rev(tt[(T0 + 1):T_])), c(li1, rev(ls1)), col = transp(COR[["ciano"]], 0.25), border = NA)
  lines(tt[janela], Pv[janela], col = COR[["texto"]], lwd = 1.6)
  lines(tt[(T0 + 1):T_], prev1, col = COR[["ciano"]], lwd = 2)
  lines(tt[(T0 + 1):T_], rw1, col = COR[["vermelho"]], lty = 2)
  lines(tt[(T0 + 1):T_], sn1, col = COR[["amarelo"]], lty = 2)
  abline(v = tt[T0], col = COR[["eixo"]], lty = 3)
  legend("topleft", c("observado", "SARIMA (IC 95%)", "passeio aleatório", "sazonal ingênuo"),
         col = c(COR[["texto"]], COR[["ciano"]], COR[["vermelho"]], COR[["amarelo"]]), lty = c(1, 1, 2, 2),
         lwd = c(1.6, 2, 1, 1), bty = "n", cex = 0.8)
})
figura("q7_esquema2", {
  op <- par(mfrow = c(1, 2))
  plot(tt[(T0 + 1):T_], real, type = "n", ylim = range(c(real, li2, ls2, rw2)), xlab = "", ylab = "INPC",
       main = "(a) Esquema 2: um passo, coeficientes fixos")
  grade()
  polygon(c(tt[(T0 + 1):T_], rev(tt[(T0 + 1):T_])), c(li2, rev(ls2)), col = transp(COR[["ciano"]], 0.25), border = NA)
  lines(tt[(T0 + 1):T_], real, col = COR[["texto"]], lwd = 1.6); points(tt[(T0 + 1):T_], prev2, pch = 19, cex = 0.6, col = COR[["ciano"]])
  lines(tt[(T0 + 1):T_], rw2, col = COR[["vermelho"]], lty = 2)
  plot(tt[(T0 + 1):T_], pi_real, type = "h", lwd = 3, col = COR[["eixo"]], xlab = "", ylab = "% a.m.",
       main = "(b) Inflação mensal: observada (barras) e prevista (pontos)")
  points(tt[(T0 + 1):T_], pi_prev, pch = 19, col = COR[["ciano"]]); abline(h = 0, col = COR[["eixo"]])
  par(op)
}, largura = 10, altura = 4.4)

## ---- 7.7 Saídas -----------------------------------------------------------------------
tab_prev <- data.frame(data = sprintf("%d-%02d", floor(tt[(T0 + 1):T_] + 1e-9), round((tt[(T0 + 1):T_] %% 1) * 12) + 1),
                       h = h, real = real, E1_prev = prev1, E1_li = li1, E1_ls = ls1, E1_dentro = dentro1,
                       E2_prev = prev2, RW_E1 = rw1, SN_E1 = sn1, RW_E2 = rw2, SN_E2 = sn2)
salvar_tabela(tab7, "q7_metricas"); salvar_tabela(tab_prev, "q7_previsoes")
salvar(list(T0 = T0, data_T0 = sprintf("%d-%02d", floor(tt[T0] + 1e-9), round((tt[T0] %% 1) * 12) + 1),
            data_val_ini = tab_prev$data[1], data_fim = tail(tab_prev$data, 1), coef_tr = tabela_coef(fit_tr),
            modelo = nome_modelo(fit_tr), tab7 = tab7, razoes = razoes, tab_dm = tab_dm, cob = cob,
            mz = c(a = unname(coef(mz)[1]), b = unname(coef(mz)[2]), W = W_mz, p = p_mz),
            dentro1 = dentro1, sigma2_tr = fit_tr$sigma2), "q7")
message("Q7 ok: RMSE E1 = ", round(tab7$E1_RMSE[1], 2), " (RW ", round(tab7$E1_RMSE[2], 2), ", SN ", round(tab7$E1_RMSE[3], 2),
        "); E2 = ", round(tab7$E2_RMSE[1], 2), " (RW ", round(tab7$E2_RMSE[2], 2), "); cobertura E1 = ", round(cob[1, "cobertura"], 1), "%")

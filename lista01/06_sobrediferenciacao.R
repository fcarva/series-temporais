# =====================================================================================
# 06_sobrediferenciacao.R — Questão 6: o custo de diferenciar em excesso
#
# d* = 1 (Q2). Reestima-se o modelo selecionado com d* + 1 = 2:
#   (A) mesmas ordens ARMA, só com a diferença extra: SARIMA(p,2,q)(P,0,Q)
#   (B) a especificação que a teoria prevê para Δ²y: um MA(1) regular a mais,
#       SARIMA(p,2,q+1)(P,0,Q). Se y ~ ARIMA(p,1,q), então Δ²y tem o fator (1 - B) no MA,
#       e θ̂ deve ir para -1 na convenção do R (θ = 1 na de Box-Jenkins): raiz MA unitária.
# Obs.: com d = 2 o Arima não aceita drift (a constante viraria tendência quadrática).
# =====================================================================================
# localiza 00_configuracao.R ao lado deste script (funciona de qualquer diretório)
source(file.path(local({ a <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))
  if (length(a)) dirname(normalizePath(a)) else if (file.exists("00_configuracao.R")) "." else "lista01" }),
  "00_configuracao.R"))
q1 <- ler("q1"); q4 <- ler("q4"); y <- q1$y; dy <- q1$dy
fit1 <- q4$fits[[q4$SELECIONADO]]; o <- fit1$arma
fitA <- Arima(y, order = c(o[1], 2, o[2]), seasonal = list(order = c(o[3], 0, o[4]), period = S), method = "ML")
fitB <- Arima(y, order = c(o[1], 2, o[2] + 1), seasonal = list(order = c(o[3], 0, o[4]), period = S), method = "ML")

## ---- 6.1 (a) Coeficiente MA e raiz ------------------------------------------------
tcB <- tabela_coef(fitB)
ma_nome <- paste0("ma", o[2] + 1)
thetaB <- tcB$coef[tcB$termo == ma_nome]; epB <- tcB$ep[tcB$termo == ma_nome]
soma_ma <- sum(tcB$coef[grepl("^ma", tcB$termo)])
raiz_ma_regular <- if (o[2] == 0) -1 / thetaB else NA        # raiz de 1 + θ z = 0
raizes_ma_B <- polyroot(c(1, tcB$coef[grepl("^ma", tcB$termo)]))
# teste t de H0: θ = -1 (raiz unitária no MA) — sob H0 a distribuição não é a normal
# (o estimador acumula na fronteira), por isso é só indicativo
t_unit <- (thetaB - (-1)) / epB

## ---- 6.2 (b) Variância residual ----------------------------------------------------
s2 <- c(d1 = fit1$sigma2, d2_A = fitA$sigma2, d2_B = fitB$sigma2)
aum_A <- 100 * (s2["d2_A"] / s2["d1"] - 1); aum_B <- 100 * (s2["d2_B"] / s2["d1"] - 1)
# Variância das próprias séries (Tintner, "variate difference"): diferenciar uma série
# já estacionária costuma AUMENTAR a variância. Var(Δ²y) vs Var(Δy):
var_dy <- var(dy); var_d2y <- var(diff(dy)); rho1_d2y <- acf(diff(dy), plot = FALSE)$acf[2]

## ---- 6.3 (c) FAC dos resíduos ------------------------------------------------------
r1 <- acf(residuals(fit1), lag.max = 24, plot = FALSE)$acf[-1]
rA <- acf(residuals(fitA), lag.max = 24, plot = FALSE)$acf[-1]
rB <- acf(residuals(fitB), lag.max = 24, plot = FALSE)$acf[-1]
lbA <- Box.test(residuals(fitA), lag = 24, type = "Ljung-Box", fitdf = o[1] + o[2] + o[3] + o[4])
figura("q6_sobrediferenciacao", {
  op <- par(mfrow = c(2, 2), mar = c(4, 4.2, 3, 1))
  correlograma(residuals(fit1), 24, "FAC", sprintf("(a) resíduos com d = 1: %s", nome_modelo(fit1)))
  correlograma(diff(dy), 24, "FAC", "(b) a série Δ²y: ρ1 negativo")
  correlograma(residuals(fitA), 24, "FAC", sprintf("(c) resíduos com d = 2, mesmas ordens: %s", nome_modelo(fitA)))
  correlograma(residuals(fitB), 24, "FAC", sprintf("(d) resíduos com d = 2 + MA(1): θ = %s", f(thetaB, 4)))
  par(op)
}, largura = 10, altura = 7)
tcA <- tabela_coef(fitA)
# ρ1 teórico de Δ²y se Δy fosse um AR(1) com o φ estimado: -(1 - φ)/2 (lista teórica, Q9)
phi1 <- coef(fit1)[["ar1"]]; rho1_teorico <- -(1 - phi1) / 2

## ---- 6.4 Saídas ----------------------------------------------------------------------
tab6 <- data.frame(
  modelo = c(nome_modelo(fit1), nome_modelo(fitA), nome_modelo(fitB)),
  d = c(1, 2, 2), sigma2 = unname(s2), loglik = c(fit1$loglik, fitA$loglik, fitB$loglik),
  n_efetivo = c(fit1$nobs, fitA$nobs, fitB$nobs), rho1_residuos = c(r1[1], rA[1], rB[1]))
salvar_tabela(tab6, "q6_comparacao"); salvar_tabela(tcB, "q6_coef_d2_ma")
salvar(list(tab6 = tab6, tcB = tcB, thetaB = thetaB, epB = epB, soma_ma = soma_ma, t_unit = t_unit,
            raiz_ma_regular = raiz_ma_regular, mod_raizes_ma_B = Mod(raizes_ma_B),
            aum_A = unname(aum_A), aum_B = unname(aum_B), var_dy = var_dy, var_d2y = var_d2y,
            rho1_d2y = rho1_d2y, lbA = c(stat = unname(lbA$statistic), p = lbA$p.value),
            nomeA = nome_modelo(fitA), nomeB = nome_modelo(fitB), tcA = tcA, rho1_teorico = rho1_teorico,
            rA = rA[1:3], r1 = r1[1:3], rB = rB[1:3]), "q6")
message("Q6 ok: θ̂ = ", round(thetaB, 4), " (ep ", round(epB, 4), "); σ² d1 = ", round(s2[1], 4),
        ", A = ", round(s2[2], 4), ", B = ", round(s2[3], 4), "; ρ1 A = ", round(rA[1], 3))

# =====================================================================================
# 05_diagnostico.R — Questão 5: verificação dos resíduos
#
# (a) Gráficos dos resíduos do modelo selecionado: tempo, FAC, FACP, histograma e QQ.
# (b) Ljung-Box com graus de liberdade corrigidos: ν = K - (p + q + P + Q).
#     Os coeficientes de regressão (drift) não entram na correção: ela vem de estimar
#     a parte ARMA, que é o que reduz os graus de liberdade da estatística Q.
# (c) Jarque-Bera (normalidade) e ARCH-LM de Engle (heterocedasticidade condicional),
#     mais o McLeod-Li (Ljung-Box dos resíduos ao quadrado) como confirmação.
# (d) Caminho percorrido: modelos descartados e por quê; a falha da normalidade leva a
#     um modelo com intervenções nos outliers da Q1 (Chen-Liu), como robustez.
# (e) Sobreajuste deliberado: +1 AR e +1 MA ao modelo selecionado; teste t e LR.
# =====================================================================================
# localiza 00_configuracao.R ao lado deste script (funciona de qualquer diretório)
source(file.path(local({ a <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))
  if (length(a)) dirname(normalizePath(a)) else if (file.exists("00_configuracao.R")) "." else "lista01" }),
  "00_configuracao.R"))
q1 <- ler("q1"); q4 <- ler("q4"); y <- q1$y
fit <- q4$fits[[q4$SELECIONADO]]
ordem <- fit$arma; n_arma <- ordem[1] + ordem[2] + ordem[3] + ordem[4]
e <- residuals(fit); z <- e / sqrt(fit$sigma2)

## ---- 5.1 (a) Painel gráfico --------------------------------------------------------
figura("q5_residuos", {
  op <- par(mfrow = c(3, 2), mar = c(4, 4.2, 2.6, 1))
  plot(z, type = "n", xlab = "", ylab = "resíduo padronizado", main = "(a) Resíduos padronizados no tempo")
  grade(); abline(h = c(-1.96, 1.96), lty = 2, col = COR[["azul"]]); lines(z, col = COR[["ciano"]])
  hist(z, breaks = 30, freq = FALSE, col = COR[["grade"]], border = COR[["eixo"]], main = "(b) Histograma e N(0,1)",
       xlab = "resíduo padronizado", ylab = "densidade")
  curve(dnorm(x), add = TRUE, col = COR[["laranja"]], lwd = 2)
  correlograma(e, 36, "FAC", "(c) FAC dos resíduos")
  correlograma(e, 36, "FACP", "(d) FACP dos resíduos")
  qqnorm(as.numeric(z), pch = 19, cex = 0.5, col = COR[["ciano"]], main = "(e) QQ-plot normal",
         xlab = "quantis teóricos", ylab = "quantis amostrais")
  qqline(as.numeric(z), col = COR[["laranja"]], lwd = 2)
  correlograma(e^2, 36, "FAC", "(f) FAC dos resíduos ao quadrado (efeito ARCH?)", bartlett = FALSE)
  par(op)
}, largura = 10, altura = 10)

## ---- 5.2 (b)(c) Testes -------------------------------------------------------------
lb <- do.call(rbind, lapply(c(12, 24, 36), function(K) {
  b <- Box.test(e, lag = K, type = "Ljung-Box", fitdf = n_arma)
  data.frame(teste = "Ljung-Box", K = K, gl = K - n_arma, estatistica = unname(b$statistic),
             critico_5 = qchisq(0.95, K - n_arma), p = b$p.value)
}))
jb <- jarque.bera.test(e)
arch <- ArchTest(e, lags = 12)
ml <- Box.test(e^2, lag = 24, type = "Ljung-Box")
assim <- mean((e - mean(e))^3) / mean((e - mean(e))^2)^1.5
curt  <- mean((e - mean(e))^4) / mean((e - mean(e))^2)^2
testes <- rbind(lb,
  data.frame(teste = "Jarque-Bera", K = NA, gl = 2, estatistica = unname(jb$statistic), critico_5 = qchisq(0.95, 2), p = jb$p.value),
  data.frame(teste = "ARCH-LM (12 defasagens)", K = 12, gl = 12, estatistica = unname(arch$statistic), critico_5 = qchisq(0.95, 12), p = arch$p.value),
  data.frame(teste = "McLeod-Li (Q de e², 24)", K = 24, gl = 24, estatistica = unname(ml$statistic), critico_5 = qchisq(0.95, 24), p = ml$p.value))
testes$decisao <- ifelse(testes$p < 0.05, "rejeita H0", "não rejeita H0")
# resíduos padronizados acima de 3 em módulo (as datas dos choques)
grandes <- data.frame(data = format_data <- sprintf("%d-%02d", floor(time(z)[abs(z) > 3] + 1e-9),
                                                    round((time(z)[abs(z) > 3] %% 1) * 12) + 1),
                      z = as.numeric(z[abs(z) > 3]))

## ---- 5.3 (d) Caminho percorrido -----------------------------------------------------
g <- q4$grade
g$motivo <- ifelse(is.na(g$aic), "não convergiu",
             ifelse(g$lb24_p < 0.05, "autocorrelação residual (Ljung-Box 24, 5%)",
             ifelse(g$max_inv_ma > 0.99, "raiz MA na fronteira (não invertível)",
             ifelse(g$modelo == sub("\\[12\\]", "", nome_modelo(fit)), "SELECIONADO",
                    "adequado, mas dominado em AIC e BIC"))))
resumo_caminho <- as.data.frame(table(g$motivo), stringsAsFactors = FALSE)
names(resumo_caminho) <- c("motivo", "n_modelos")
# exemplos concretos de descarte por autocorrelação (os mais parcimoniosos)
desc_lb <- head(g[g$motivo == "autocorrelação residual (Ljung-Box 24, 5%)", c("modelo", "aic", "bic", "lb24_p")], 6)

# Robustez à não normalidade: intervenções nos outliers detectados na Q1.
# outliers.effects() devolve o padrão de cada outlier em Δy (AO = pulso, TC = pulso que
# decai com δ = 0,7, LS = degrau); como o modelo é para y com d = 1, o regressor entra
# acumulado (a primeira diferença do regressor reproduz o efeito em Δy).
mo <- q1$outliers_raw
fit_int <- NULL; jb_int <- NULL
if (!is.null(mo) && nrow(mo)) {
  ef <- outliers.effects(mo, n = length(q1$dy), weights = FALSE, delta = 0.7, freq = S)
  X <- apply(rbind(0, ef), 2, cumsum)
  colnames(X) <- paste0(mo$type, "_", gsub(":", "_", mo$time))
  fit_int <- Arima(y, order = c(ordem[1], 1, ordem[2]), seasonal = list(order = c(ordem[3], 0, ordem[4]), period = S),
                   xreg = X, include.drift = TRUE, method = "ML")
  jb_int <- jarque.bera.test(residuals(fit_int))
  lb_int <- Box.test(residuals(fit_int), lag = 24, type = "Ljung-Box", fitdf = n_arma)
}

## ---- 5.4 (e) Sobreajuste deliberado ---------------------------------------------------
sobre <- function(dp, dq) {
  f2 <- Arima(y, order = c(ordem[1] + dp, 1, ordem[2] + dq), seasonal = list(order = c(ordem[3], 0, ordem[4]), period = S),
              include.drift = TRUE, method = "ML")
  termo <- if (dp) paste0("ar", ordem[1] + 1) else paste0("ma", ordem[2] + 1)
  tc <- tabela_coef(f2); ex <- tc[tc$termo == termo, ]
  lr <- 2 * (f2$loglik - fit$loglik)
  data.frame(modelo = nome_modelo(f2), termo_extra = termo, coef = ex$coef, ep = ex$ep, t = ex$t, p = ex$p,
             LR = lr, p_LR = pchisq(lr, 1, lower.tail = FALSE), AIC = f2$aic, BIC = f2$bic,
             dAIC = f2$aic - fit$aic,
             outros_mudam = max(abs(coef(f2)[names(coef(fit))] - coef(fit)) / sqrt(diag(fit$var.coef))))
}
tab_sobre <- rbind(sobre(1, 0), sobre(0, 1))

## ---- 5.5 Saídas ----------------------------------------------------------------------
salvar_tabela(testes, "q5_testes"); salvar_tabela(g, "q5_caminho"); salvar_tabela(tab_sobre, "q5_sobreajuste")
salvar(list(modelo = nome_modelo(fit), n_arma = n_arma, testes = testes, assim = assim, curt = curt,
            grandes = grandes, resumo_caminho = resumo_caminho, desc_lb = desc_lb,
            fit_int = fit_int, jb_int = if (!is.null(jb_int)) c(stat = unname(jb_int$statistic), p = jb_int$p.value),
            lb_int = if (!is.null(fit_int)) c(stat = unname(lb_int$statistic), p = lb_int$p.value),
            coef_int = if (!is.null(fit_int)) tabela_coef(fit_int), tab_sobre = tab_sobre), "q5")
message("Q5 ok: LB24 p = ", round(lb$p[2], 3), "; JB = ", round(jb$statistic, 1), "; ARCH p = ",
        round(arch$p.value, 3), "; JB com intervenções = ", if (!is.null(jb_int)) round(jb_int$statistic, 1) else NA)

# =====================================================================================
# 05_diagnostico.R — Questão 5: verificação dos resíduos
#
# (a) Gráficos dos resíduos do modelo selecionado: tempo, FAC, FACP, histograma e QQ.
# (b) Ljung-Box com graus de liberdade corrigidos: ν = K - (p + q + P + Q).
#     Os coeficientes de regressão (drift) não entram na correção: ela vem de estimar
#     a parte ARMA, que é o que reduz os graus de liberdade da estatística Q.
# (c) Jarque-Bera (normalidade) e ARCH-LM de Engle (heterocedasticidade condicional),
#     mais o McLeod-Li (Ljung-Box dos resíduos ao quadrado) como confirmação.
# (d) Caminho percorrido: modelos descartados e por quê.
# (e) Sobreajuste deliberado: +1 AR e +1 MA ao modelo selecionado; teste t.
# Estabilidade (aula 03): Chow break-point numa data escolhida a priori e CUSUM/CUSUM-Q
#     com resíduos recursivos.
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
  correlograma(e^2, 36, "FAC", "(f) FAC dos resíduos ao quadrado (efeito ARCH?)")
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

## ---- 5.4 (e) Sobreajuste deliberado ---------------------------------------------------
sobre <- function(dp, dq) {
  f2 <- Arima(y, order = c(ordem[1] + dp, 1, ordem[2] + dq), seasonal = list(order = c(ordem[3], 0, ordem[4]), period = S),
              include.drift = TRUE, method = "ML")
  termo <- if (dp) paste0("ar", ordem[1] + 1) else paste0("ma", ordem[2] + 1)
  tc <- tabela_coef(f2); ex <- tc[tc$termo == termo, ]
  data.frame(modelo = nome_modelo(f2), termo_extra = termo, coef = ex$coef, ep = ex$ep, t = ex$t, p = ex$p,
             AIC = f2$aic, BIC = f2$bic,
             dAIC = f2$aic - fit$aic,
             outros_mudam = max(abs(coef(f2)[names(coef(fit))] - coef(fit)) / sqrt(diag(fit$var.coef))))
}
tab_sobre <- rbind(sobre(1, 0), sobre(0, 1))

## ---- 5.5 Estabilidade (aula 03): Chow e CUSUM --------------------------------------------
# Chow e CUSUM pedem um modelo de regressão estimado por MQO. Usa-se a forma
# autorregressiva da inflação com a estrutura do modelo selecionado: Δy_t em Δy_{t-1},
# Δy_{t-12} e Δy_{t-13} (o produto (1 - φB)(1 - ΦB^12) gera essas três defasagens).
dyv <- as.numeric(q1$dy); nn <- length(dyv)
df_ols <- data.frame(dy = dyv[14:nn], l1 = dyv[13:(nn - 1)], l12 = dyv[2:(nn - 12)], l13 = dyv[1:(nn - 13)])
tempo_ols <- time(q1$dy)[14:nn]
ols <- lm(dy ~ ., data = df_ols)
# Chow break-point: data escolhida A PRIORI (mar/2020, início da pandemia), como a aula
# exige; escolhida pelos dados, os valores críticos usuais deixariam de valer.
TB <- which(abs(tempo_ols - (2020 + 2 / 12)) < 1e-6)
chow <- sctest(dy ~ ., data = df_ols, type = "Chow", point = TB - 1)
# CUSUM (resíduos recursivos padronizados acumulados) e CUSUM-Q (soma acumulada dos
# quadrados, normalizada). Sob H0, E(CUSUM) = 0 e E(CUSUM-Q_t) = (t - k)/(T - k).
cus <- efp(dy ~ ., data = df_ols, type = "Rec-CUSUM")
sc_cus <- sctest(cus)
w <- recresid(ols); kq <- length(coef(ols)); nw <- length(w)
cusumq <- cumsum(w^2) / sum(w^2)
esperado_q <- seq_len(nw) / nw
# banda de 5% do CUSUM-Q: aproximação de Durbin para amostras grandes, c0 ≈ 1,36/√(n/2)
c0 <- 1.36 / sqrt(nw / 2)
fora_q <- any(abs(cusumq - esperado_q) > c0)
figura("q5_estabilidade", {
  op <- par(mfrow = c(1, 2))
  cs <- as.numeric(cus$process); tc <- seq(0, 1, length.out = length(cs))
  lim <- 0.948 * (1 + 2 * tc)                       # bandas de 5% do CUSUM recursivo
  tt <- seq(tempo_ols[kq], tail(tempo_ols, 1), length.out = length(cs))
  plot(tt, cs, type = "n", ylim = range(c(cs, lim, -lim)), xlab = "", ylab = "CUSUM", main = "(a) CUSUM")
  grade(); lines(tt, lim, lty = 2, col = COR[["vermelho"]]); lines(tt, -lim, lty = 2, col = COR[["vermelho"]])
  lines(tt, cs, col = COR[["azul"]], lwd = 1.6)
  tq <- tail(tempo_ols, nw)
  plot(tq, cusumq, type = "n", ylim = c(-0.1, 1.1), xlab = "", ylab = "CUSUM-Q", main = "(b) CUSUM-Q")
  grade(); lines(tq, esperado_q + c0, lty = 2, col = COR[["vermelho"]]); lines(tq, esperado_q - c0, lty = 2, col = COR[["vermelho"]])
  lines(tq, esperado_q, col = COR[["eixo"]]); lines(tq, cusumq, col = COR[["azul"]], lwd = 1.6)
  par(op)
}, largura = 10, altura = 4.2)
estab <- list(chow_F = unname(chow$statistic), chow_p = chow$p.value, TB = "2020-03",
              cusum_stat = unname(sc_cus$statistic), cusum_p = sc_cus$p.value,
              cusumq_maxdesvio = max(abs(cusumq - esperado_q)), cusumq_c0 = c0, cusumq_fora = fora_q,
              coef_ols = coef(ols))

## ---- 5.5 Saídas ----------------------------------------------------------------------
salvar_tabela(testes, "q5_testes"); salvar_tabela(g, "q5_caminho"); salvar_tabela(tab_sobre, "q5_sobreajuste")
salvar(list(modelo = nome_modelo(fit), n_arma = n_arma, testes = testes, assim = assim, curt = curt,
            grandes = grandes, resumo_caminho = resumo_caminho, desc_lb = desc_lb,
            tab_sobre = tab_sobre, estab = estab), "q5")
message("Q5 ok: LB24 p = ", round(lb$p[2], 3), "; JB = ", round(jb$statistic, 1), "; ARCH p = ",
        round(arch$p.value, 3), "; Chow p = ", round(chow$p.value, 3), "; CUSUM p = ", round(sc_cus$p.value, 3))

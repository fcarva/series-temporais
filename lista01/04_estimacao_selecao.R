# =====================================================================================
# 04_estimacao_selecao.R — Questão 4: estimação por MV e critérios de informação
#
# (a)(b) Estima C1–C3 por máxima verossimilhança EXATA (forecast::Arima, method = "ML":
#        filtro de Kalman, sem condicionar nos valores iniciais) e reporta coeficientes,
#        erros-padrão, t, σ²_a, log-verossimilhança, AIC, BIC e a amostra efetiva.
# (c)    Verifica se a comparação por AIC/BIC é válida (mesma variável e mesma amostra).
# (d)    Confere numericamente a convenção de contagem de parâmetros do software.
# (e)    AIC × BIC.
# (f)    Raízes dos polinômios AR e MA (regular × sazonal) e o gráfico no círculo unitário.
# Extra: C4 = AR(1) com sazonalidade DETERMINÍSTICA (11 dummies), sugerido pelo HEGY e
#        pelo Canova-Hansen na Q2; e uma grade completa usada para documentar o caminho (Q5d).
# =====================================================================================
# localiza 00_configuracao.R ao lado deste script (funciona de qualquer diretório)
source(file.path(local({ a <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))
  if (length(a)) dirname(normalizePath(a)) else if (file.exists("00_configuracao.R")) "." else "lista01" }),
  "00_configuracao.R"))
q1 <- ler("q1"); q3 <- ler("q3"); y <- q1$y; T_ <- q1$T

## ---- 4.1 Estimação dos candidatos ---------------------------------------------------
ajusta <- function(order, seasonal, xreg = NULL, dados = y) {
  Arima(dados, order = order, seasonal = list(order = seasonal, period = S), xreg = xreg,
        include.drift = TRUE, method = "ML")
}
# Dummies sazonais para o modelo com d = 1: o Arima diferencia também os regressores,
# então entram as SOMAS ACUMULADAS das dummies — assim Δ(regressor) = dummy, e o efeito
# fixo de cada mês incide sobre a inflação Δy (e não sobre o nível do log do índice).
dummies_acum <- function(serie) {
  D <- seasonaldummy(serie)                       # 11 colunas (dezembro é a base)
  apply(D, 2, cumsum)
}
fits <- lapply(q3$candidatos, function(cd) ajusta(cd$order, cd$seasonal))
fits$C4 <- ajusta(c(1, 1, 0), c(0, 0, 0), xreg = dummies_acum(y))

## ---- 4.2 (a)(b) Tabela única ---------------------------------------------------------
resumo_fit <- function(fit, rotulo) {
  tc <- tabela_coef(fit)
  tc$modelo <- rotulo
  tc$especificacao <- if (rotulo == "C4") "SARIMA(1,1,0) + 11 dummies sazonais" else nome_modelo(fit)
  tc
}
coefs <- do.call(rbind, Map(resumo_fit, fits, names(fits)))
gerais <- do.call(rbind, lapply(names(fits), function(m) {
  fit <- fits[[m]]
  data.frame(modelo = m, especificacao = if (m == "C4") "SARIMA(1,1,0) + 11 dummies sazonais" else nome_modelo(fit),
             n_total = T_, n_efetivo = fit$nobs, k = k_aic(fit), sigma2 = fit$sigma2,
             loglik = fit$loglik, AIC = fit$aic, AICc = fit$aicc, BIC = fit$bic)
}))

## ---- 4.3 (c) Validade da comparação --------------------------------------------------
# Todos: mesma variável dependente (y = 100 log INPC), mesmo d = 1 e D = 0 => mesma
# amostra efetiva n = T - d - sD. A log-verossimilhança é a de Δy nos quatro casos.
comparavel <- length(unique(gerais$n_efetivo)) == 1
# Contraexemplo didático: com d = 2 a verossimilhança passa a ser a de Δ²y (outra
# variável) e n cai em 1 — o AIC deixa de ser comparável.
fit_d2 <- Arima(y, order = c(1, 2, 0), seasonal = list(order = c(1, 0, 0), period = S), method = "ML")

## ---- 4.4 (d) Convenção de contagem: σ² entra em k? -----------------------------------
# Documentação: ?stats::arima diz que o AIC só vale para method = "ML"; o código do
# forecast::Arima define npar <- length(coef[mask]) + 1, o "+1" sendo σ². Confere:
conv <- do.call(rbind, lapply(names(fits), function(m) {
  fit <- fits[[m]]; kc <- sum(fit$mask)
  data.frame(modelo = m, coef_livres = kc,
             aic_sem_sigma = -2 * fit$loglik + 2 * kc,
             aic_com_sigma = -2 * fit$loglik + 2 * (kc + 1),
             aic_software = fit$aic,
             bic_com_sigma = -2 * fit$loglik + log(fit$nobs) * (kc + 1),
             bic_software = fit$bic,
             df_logLik = attr(logLik(fit), "df"))
}))
convencao_inclui_sigma <- isTRUE(all.equal(conv$aic_com_sigma, conv$aic_software)) &&
  isTRUE(all.equal(conv$bic_com_sigma, conv$bic_software))

## ---- 4.5 (e) Seleção --------------------------------------------------------------------
cand <- gerais[gerais$modelo %in% c("C1", "C2", "C3"), ]
sel_aic <- cand$modelo[which.min(cand$AIC)]; sel_bic <- cand$modelo[which.min(cand$BIC)]
# Diferenças de AIC em relação ao melhor e pesos de Akaike (Burnham e Anderson, 2002)
cand$dAIC <- cand$AIC - min(cand$AIC); cand$peso_akaike <- exp(-cand$dAIC / 2) / sum(exp(-cand$dAIC / 2))
cand$dBIC <- cand$BIC - min(cand$BIC)
# C1 está aninhado em C3 (φ2 = 0): teste da razão de verossimilhança
lr_c1_c3 <- 2 * (fits$C3$loglik - fits$C1$loglik)
p_lr_c1_c3 <- pchisq(lr_c1_c3, df = 1, lower.tail = FALSE)
# Regra fixada antes da Q7: o objetivo é prever, então vale o AIC (eficiente). Mas uma
# diferença de AIC menor que 2 não discrimina os modelos (Burnham e Anderson, 2002);
# nesse caso fica o mais parcimonioso, que é o do BIC.
SELECIONADO <- if (cand$dAIC[cand$modelo == sel_bic] < 2) sel_bic else sel_aic

## ---- 4.6 (f) Raízes -------------------------------------------------------------------
raizes <- do.call(rbind, lapply(names(fits), function(m) {
  pl <- polinomios(fits[[m]])
  ra <- raizes_inversas(pl$ar); rm <- raizes_inversas(pl$ma)
  data.frame(modelo = m,
             n_raizes_ar = length(ra), max_mod_inv_ar = if (length(ra)) max(Mod(ra)) else NA,
             n_raizes_ma = length(rm), max_mod_inv_ma = if (length(rm)) max(Mod(rm)) else NA)
}))
figura("q4_raizes", {
  op <- par(mfrow = c(1, 3), mar = c(4, 4, 3, 1))
  for (m in c("C1", "C2", "C3")) {
    pl <- polinomios(fits[[m]]); ra <- raizes_inversas(pl$ar); rm <- raizes_inversas(pl$ma)
    plot(NA, xlim = c(-1.1, 1.1), ylim = c(-1.1, 1.1), asp = 1, xlab = "Re", ylab = "Im",
         main = paste0(m, ": ", nome_modelo(fits[[m]])), cex.main = 0.85, font.main = 1)
    th <- seq(0, 2 * pi, length.out = 400); lines(cos(th), sin(th), col = COR[["eixo"]])
    abline(h = 0, v = 0, col = COR[["grade"]])
    if (length(ra)) points(Re(ra), Im(ra), pch = 19, col = COR[["azul"]])
    if (length(rm)) points(Re(rm), Im(rm), pch = 4, lwd = 2, col = COR[["laranja"]])
    legend("bottomleft", c("AR (inversas)", "MA (inversas)"), pch = c(19, 4), col = c(COR[["azul"]], COR[["laranja"]]),
           bty = "n", cex = 0.8)
  }
  par(op)
}, largura = 11, altura = 4.2)

## ---- 4.7 Grade auxiliar (documenta o caminho na Q5d) ---------------------------------
grade <- expand.grid(p = 0:3, q = 0:3, P = 0:1, Q = 0:1)
grade$aic <- grade$bic <- grade$lb24_p <- grade$max_inv_ma <- NA_real_
for (i in seq_len(nrow(grade))) {
  g <- grade[i, ]
  fit <- tryCatch(ajusta(c(g$p, 1, g$q), c(g$P, 0, g$Q)), error = function(e) NULL)
  if (is.null(fit)) next
  grade$aic[i] <- fit$aic; grade$bic[i] <- fit$bic
  grade$lb24_p[i] <- Box.test(residuals(fit), lag = 24, type = "Ljung-Box", fitdf = g$p + g$q + g$P + g$Q)$p.value
  rm <- raizes_inversas(polinomios(fit)$ma); grade$max_inv_ma[i] <- if (length(rm)) max(Mod(rm)) else 0
}
grade$modelo <- sprintf("SARIMA(%d,1,%d)(%d,0,%d)", grade$p, grade$q, grade$P, grade$Q)
grade <- grade[order(grade$aic), ]

## ---- 4.8 Saídas ------------------------------------------------------------------------
salvar_tabela(coefs, "q4_coeficientes"); salvar_tabela(gerais, "q4_ajuste"); salvar_tabela(conv, "q4_convencao")
salvar_tabela(raizes, "q4_raizes"); salvar_tabela(grade, "q4_grade")
salvar(list(fits = fits, coefs = coefs, gerais = gerais, cand = cand, conv = conv,
            convencao_inclui_sigma = convencao_inclui_sigma, comparavel = comparavel,
            n_d2 = fit_d2$nobs, sel_aic = sel_aic, sel_bic = sel_bic, SELECIONADO = SELECIONADO,
            lr_c1_c3 = lr_c1_c3, p_lr_c1_c3 = p_lr_c1_c3, raizes = raizes, grade = grade), "q4")
message("Q4 ok: AIC escolhe ", sel_aic, ", BIC escolhe ", sel_bic, "; σ² em k: ", convencao_inclui_sigma)

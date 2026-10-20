# Módulo 06 — Aplicação: SARIMA(1,1,1)(0,1,1)_12 com 240 meses (lista, Q16).
# FAC e FACP teóricas da série duplamente diferenciada, contagem de parâmetros,
# observações perdidas e a comparação com SARIMA(2,1,1)(0,1,1)_12 por AIC, BIC e
# razão de verossimilhança, numa série simulada do modelo da Q16.
# Rodar: Rscript 06_aplicacao_sarima/06_aplicacao.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

suppressPackageStartupMessages(library(forecast))
FIG <- caminho_repo("06_aplicacao_sarima", "figuras")
set.seed(2026)

phi <- 0.3; th <- 0.5; Th <- 0.6    # convenção da lista: (1 - th B)(1 - Th B^12)
ma_r <- c(-th, rep(0, 10), -Th, th * Th)   # (1 - th B)(1 - Th B^12) na convenção do R
fac <- stats::ARMAacf(ar = phi, ma = ma_r, lag.max = 36)[-1]
facp <- stats::ARMAacf(ar = phi, ma = ma_r, lag.max = 36, pacf = TRUE)
for (k in c(1, 2, 11, 12, 13, 24)) registrar(sprintf("m06_q16_fac%d", k), fac[k])
for (k in c(1, 2, 12, 24)) registrar(sprintf("m06_q16_facp%d", k), facp[k])

salvar_figura(file.path(FIG, "m06_q16_fac_facp"), function() {
  graphics::par(mfrow = c(1, 2), mar = c(4.2, 4.4, 4.8, 1.2))
  cor_k <- ifelse((1:36) %% 12 %in% c(0, 1, 11), CORES$compara, CORES$principal)
  plot(1:36, fac, type = "h", xlim = c(0.5, 36 + 0.5), lwd = 3, ylim = c(-0.5, 0.5), xlab = "defasagem", ylab = "FAC", col = cor_k)
  graphics::abline(h = 0, col = CORES$eixo)
  titulo_editorial("FAC: decaimento curto + grupo 11-12-13", "w = (1-B)(1-B¹²)y; φ = 0,3, θ = 0,5, Θ = 0,6")
  plot(1:36, facp, type = "h", xlim = c(0.5, 36 + 0.5), lwd = 3, ylim = c(-0.5, 0.5), xlab = "defasagem", ylab = "FACP", col = cor_k)
  graphics::abline(h = 0, col = CORES$eixo)
  titulo_editorial("FACP: picos em 12, 24, 36 que decaem", "assinatura do MA sazonal", fonte = "valores teóricos")
}, largura = 10)

# série simulada de 240 meses do modelo da Q16
n <- 240; burn <- 60
w <- stats::arima.sim(list(ar = phi, ma = ma_r), n = n + burn - 13)
y <- stats::diffinv(stats::diffinv(as.numeric(w), lag = 12), lag = 1)
y <- ts(tail(y, n), frequency = 12)
registrar("m06_q16_t_efetivo", length(diff(diff(y, lag = 12))))
f1 <- Arima(y, order = c(1, 1, 1), seasonal = c(0, 1, 1), method = "ML")
f2 <- Arima(y, order = c(2, 1, 1), seasonal = c(0, 1, 1), method = "ML")
registrar("m06_q16_k1", length(coef(f1)) + 1); registrar("m06_q16_k2", length(coef(f2)) + 1)
registrar("m06_q16_aic1", f1$aic); registrar("m06_q16_aic2", f2$aic)
registrar("m06_q16_bic1", f1$bic); registrar("m06_q16_bic2", f2$bic)
lr <- 2 * (f2$loglik - f1$loglik)
registrar("m06_q16_lr", lr); registrar("m06_q16_lr_p", stats::pchisq(lr, 1, lower.tail = FALSE))
registrar("m06_q16_chi2_1", stats::qchisq(0.95, 1))
tc <- tabela_coef(f2)
registrar("m06_q16_ar2_z", tc$z[tc$termo == "ar2"]); registrar("m06_q16_ar2_p", tc$p[tc$termo == "ar2"])

gravar_resultados("m06")

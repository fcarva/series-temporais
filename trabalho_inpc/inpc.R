# Lista 01 (avaliação parcial): modelagem Box-Jenkins do INPC mensal (IBGE).
#
# O script segue a ordem das questões do enunciado (materiais/listas/lista_01_2026_empirica.pdf):
#   Q1 inspeção gráfica · Q2 ordem de integração (ADF, PP, KPSS; d e D) · Q3 FAC/FACP e
#   três candidatos · Q4 estimação por MV, AIC/BIC e raízes · Q5 diagnóstico, modelos
#   descartados e sobreajuste · Q6 sobrediferenciação · Q7 previsão fora da amostra
#   (origem fixa e origem móvel contra passeio aleatório e ingênuo sazonal).
# Complementos (AU03, fora do enunciado): estabilidade (Chow, CUSUM) e previsão out/2026–set/2027.
#
# Dados: dados/inpc.csv (SIDRA, tabela 1736), atualizado por scripts/baixar_inpc.R.
# Saídas: resultados/inpc.csv (números citados no relatório), trabalho_inpc/figuras/,
#         trabalho_inpc/dados_utilizados.csv (o banco efetivamente usado) e
#         trabalho_inpc/sessionInfo.txt (versões do R e dos pacotes), exigidos pela entrega.
# Rodar: Rscript trabalho_inpc/inpc.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

suppressPackageStartupMessages({
  library(forecast); library(tseries); library(urca); library(lmtest); library(strucchange)
})

FIG <- caminho_repo("trabalho_inpc", "figuras")
FONTE <- "IBGE, SIDRA, tabela 1736. Elaboração própria"
# rodapé na margem externa, para figuras com rótulo no eixo x (o rodapé de
# titulo_editorial fica na linha do rótulo)
rodape_externo <- function() graphics::mtext(paste0("Fonte: ", FONTE), side = 1, line = 0.2, adj = 0.02,
                                             outer = TRUE, cex = 0.72, col = CORES$eixo_claro)
mes_ano <- function(tt) {
  tt <- as.numeric(tt)
  c(ano = floor(tt + 1e-9), mes = round((tt - floor(tt + 1e-9)) * 12) + 1)
}

## ---- Dados e amostra -----------------------------------------------------------
# A amostra começa em jan/2000: depois do Real (1994), da flutuação cambial e do
# regime de metas (1999). Antes disso a série mistura regimes inflacionários
# incompatíveis com um único ARMA estacionário.
d <- read.csv(caminho_repo("dados", "inpc.csv"), stringsAsFactors = FALSE)
y_all <- ts(d$var_mensal, start = c(1979, 3), frequency = 12)
i_all <- ts(d$indice, start = c(1979, 3), frequency = 12)

INICIO <- c(2000, 1)
y <- window(y_all, start = INICIO)                 # variação mensal, % a.m.: a série modelada
li <- window(log(i_all), start = INICIO)           # log do número-índice
fim <- tail(time(y), 1)
T_ <- length(y)
yv <- as.numeric(y)

# banco efetivamente utilizado (entrega): só a janela da amostra
write.csv(data.frame(mes = format(seq(as.Date("2000-01-01"), by = "month", length.out = T_), "%Y-%m"),
                     indice = as.numeric(window(i_all, start = INICIO)), var_mensal = yv),
          caminho_repo("trabalho_inpc", "dados_utilizados.csv"), row.names = FALSE)

registrar("inpc_T", T_)
registrar("inpc_ano_fim", mes_ano(fim)[["ano"]])
registrar("inpc_mes_fim", mes_ano(fim)[["mes"]])
registrar("inpc_media", mean(y))
registrar("inpc_dp", sd(y))
registrar("inpc_min", min(y))
registrar("inpc_max", max(y))
registrar("inpc_max_ano", mes_ano(time(y)[which.max(y)])[["ano"]])
registrar("inpc_max_mes", mes_ano(time(y)[which.max(y)])[["mes"]])
registrar("inpc_ultimo", tail(y, 1))
registrar("inpc_acum12", 100 * (prod(1 + tail(y, 12) / 100) - 1))
registrar("inpc_n_negativos", sum(y < 0))
# dispersão: 2000–2003 (câmbio e eleição) contra o resto da amostra
registrar("inpc_dp_2000_2003", sd(window(y, end = c(2003, 12))))
registrar("inpc_dp_2004_fim", sd(window(y, start = c(2004, 1))))

## ---- Q1. Inspeção gráfica ------------------------------------------------------
media_mes <- tapply(y, cycle(y), mean)
for (m in 1:12) registrar(sprintf("inpc_media_mes%02d", m), media_mes[[m]])

salvar_figura(file.path(FIG, "inpc_01_series"), function() {
  graphics::par(mfrow = c(2, 1), mar = c(3, 4.4, 4.2, 1.6))
  plot(y, type = "n", xlab = "", ylab = "% a.m.")
  grade_h(); graphics::abline(h = mean(y), col = CORES$compara, lty = 2)
  graphics::lines(y, col = CORES$principal, lwd = 1.3)
  titulo_editorial("A variação mensal oscila em torno de uma média fixa",
                   "INPC, variação mensal (%), jan/2000 a set/2026; tracejado = média amostral")
  plot(li, type = "n", xlab = "", ylab = "log do índice")
  grade_h(); graphics::lines(li, col = CORES$neutra, lwd = 1.6)
  titulo_editorial("O número-índice acumula a variação e sobe sem voltar",
                   "log do INPC (dez/1993 = 100)", fonte = FONTE)
}, altura = 7)

salvar_figura(file.path(FIG, "inpc_02_sazonalidade"), function() {
  graphics::par(mar = c(4.2, 4.4, 4.8, 1.6))
  graphics::boxplot(yv ~ cycle(y), names = month.abb, col = CORES$painel,
                    border = CORES$eixo, xlab = "", ylab = "% a.m.", outline = TRUE)
  graphics::points(1:12, media_mes, pch = 19, col = CORES$compara)
  titulo_editorial("Inflação maior no início e no fim do ano, menor no meio",
                   "INPC mensal por mês do ano, jan/2000 a set/2026; ponto = média",
                   fonte = FONTE)
})

## ---- Q2. Ordem de integração: ADF, PP e KPSS -----------------------------------
# ADF (urca::ur.df): defasagens da diferença até 12, escolhidas por AIC; p-valores de
# MacKinnon (urca::punitroot). PP (urca::ur.pp, Z-tau): janela de Newey-West "short",
# trunc(4 (T/100)^{1/4}). KPSS (urca::ur.kpss): mesma janela; H0 = estacionária.
det_mk <- c(none = "nc", drift = "c", trend = "ct")
adf <- function(x, tipo) {
  r <- ur.df(x, type = tipo, lags = 12, selectlags = "AIC")
  cf <- r@testreg$coefficients
  list(tau = r@teststat[1], c5 = r@cval[1, "5pct"],
       p = punitroot(r@teststat[1], N = length(x), trend = det_mk[[tipo]], statistic = "t"),
       lags = sum(grepl("z.diff.lag", rownames(cf))), r = r, cf = cf)
}
pp <- function(x, modelo) {
  r <- ur.pp(x, type = "Z-tau", model = modelo, lags = "short")
  list(z = r@teststat, c5 = r@cval[1, "5pct"], lag = r@lag,
       p = punitroot(r@teststat, N = length(x), trend = if (modelo == "constant") "c" else "ct", statistic = "t"))
}
kpss <- function(x, tipo) {
  r <- ur.kpss(x, type = tipo, lags = "short")
  list(s = r@teststat, c5 = r@cval[1, "5pct"], lag = r@lag)
}
reg_adf <- function(nome, a) {
  registrar(paste0(nome, "_tau"), a$tau); registrar(paste0(nome, "_c5"), a$c5)
  registrar(paste0(nome, "_p"), a$p); registrar(paste0(nome, "_lags"), a$lags)
}
reg_pp <- function(nome, a) {
  registrar(paste0(nome, "_z"), a$z); registrar(paste0(nome, "_c5"), a$c5)
  registrar(paste0(nome, "_p"), a$p); registrar(paste0(nome, "_lag"), a$lag)
}
reg_kpss <- function(nome, a) {
  registrar(paste0(nome, "_s"), a$s); registrar(paste0(nome, "_c5"), a$c5); registrar(paste0(nome, "_lag"), a$lag)
}

# (a) e (b): a série em nível, nas três especificações determinísticas do ADF
a_y_n <- adf(y, "none"); a_y_c <- adf(y, "drift"); a_y_t <- adf(y, "trend")
reg_adf("inpc_adf_y_n", a_y_n); reg_adf("inpc_adf_y_c", a_y_c); reg_adf("inpc_adf_y_t", a_y_t)
p_y_c <- pp(y, "constant"); p_y_t <- pp(y, "trend")
reg_pp("inpc_pp_y_c", p_y_c); reg_pp("inpc_pp_y_t", p_y_t)
k_y_c <- kpss(y, "mu"); k_y_t <- kpss(y, "tau")
reg_kpss("inpc_kpss_y_c", k_y_c); reg_kpss("inpc_kpss_y_t", k_y_t)
# termos determinísticos na regressão auxiliar: a constante é significativa, a tendência não
registrar("inpc_adf_y_c_const_t", a_y_c$cf["(Intercept)", "t value"])
registrar("inpc_adf_y_t_tend_t", a_y_t$cf["tt", "t value"])
registrar("inpc_adf_y_t_tend_p", a_y_t$cf["tt", "Pr(>|t|)"])
registrar("inpc_adf_y_c_phi1", a_y_c$r@teststat[1, "phi1"]); registrar("inpc_adf_c5_phi1", a_y_c$r@cval["phi1", "5pct"])
registrar("inpc_adf_y_t_phi3", a_y_t$r@teststat[1, "phi3"]); registrar("inpc_adf_c5_phi3", a_y_t$r@cval["phi3", "5pct"])

# (c): a série diferenciada, e a diferença sazonal
dy <- diff(y)
a_dy <- adf(dy, "drift"); p_dy <- pp(dy, "constant"); k_dy <- kpss(dy, "mu")
reg_adf("inpc_adf_dy_c", a_dy); reg_pp("inpc_pp_dy_c", p_dy); reg_kpss("inpc_kpss_dy_c", k_dy)
registrar("inpc_ndiffs", ndiffs(y)); registrar("inpc_nsdiffs", nsdiffs(y, test = "seas"))
oc <- ocsb.test(y)                                       # H0: raiz unitária sazonal
registrar("inpc_ocsb", oc$statistics); registrar("inpc_ocsb_c5", oc$critical)

# (d) o número-índice: tendência estocástica (DS) e não determinística (TS)
a_li <- adf(li, "trend"); reg_adf("inpc_adf_li_t", a_li)
p_li <- pp(li, "trend"); reg_pp("inpc_pp_li_t", p_li)
k_li <- kpss(li, "tau"); reg_kpss("inpc_kpss_li_t", k_li)
# Δlog(índice) ≈ variação mensal: modelar π_t com d = 0 é modelar o log do índice com d = 1
registrar("inpc_cor_dli_y", cor(100 * diff(li), window(y, start = time(li)[2])))

## ---- Q3. FAC, FACP e candidatos -------------------------------------------------
LAGS <- 36                                               # três ciclos sazonais completos
fac_facp <- function(x, titulo, lag.max = LAGS, sub = "laranja = defasagens sazonais (12, 24, 36); tracejado = ±1,96/√T") {
  a <- stats::acf(x, lag.max = lag.max, plot = FALSE)$acf[-1]
  p <- stats::pacf(x, lag.max = lag.max, plot = FALSE)$acf
  banda <- 1.96 / sqrt(length(x))
  graphics::par(mfrow = c(1, 2), mar = c(4.2, 4.4, 4.8, 1.2))
  for (k in 1:2) {
    v <- if (k == 1) a else p
    plot(1:lag.max, v, type = "h", xlim = c(0.5, lag.max + 0.5), lwd = 3, ylim = c(-0.4, 1), xlab = "defasagem (meses)",
         ylab = if (k == 1) "FAC" else "FACP",
         col = ifelse((1:lag.max) %% 12 == 0, CORES$compara, CORES$principal))
    graphics::abline(h = 0, col = CORES$eixo); graphics::abline(h = c(-1, 1) * banda, lty = 2, col = CORES$neutra)
    if (k == 1) titulo_editorial(titulo, sub)
  }
}
salvar_figura(file.path(FIG, "inpc_03_fac_facp"), function() {
  fac_facp(y, "FAC decai e volta em 12; FACP corta após 1")
}, largura = 9)

ac <- stats::acf(y, lag.max = LAGS, plot = FALSE)$acf[-1]
pc <- stats::pacf(y, lag.max = LAGS, plot = FALSE)$acf
for (k in c(1, 2, 11, 12, 13, 24, 36)) registrar(sprintf("inpc_fac%d", k), ac[k])
for (k in c(1, 2, 11, 12, 13, 24)) registrar(sprintf("inpc_facp%d", k), pc[k])
registrar("inpc_banda", 1.96 / sqrt(T_))
registrar("inpc_lb24_serie", Box.test(y, 24, "Ljung-Box")$statistic)

# Candidatos, todos com d = D = 0 e média (mesma variável dependente, mesma amostra):
#   M1 = SARIMA(1,0,0)(1,0,1)_12 — FACP corta em 1; picos em 11-12-13 pedem estrutura multiplicativa
#   M2 = SARIMA(1,0,0)(1,0,0)_12 — pico da FACP em 12: AR sazonal
#   M3 = SARIMA(1,0,0)(0,0,1)_12 — pico isolado da FAC em 12, pequeno em 24: MA sazonal
ESPEC <- list(M1 = list(c(1, 0, 0), c(1, 0, 1)), M2 = list(c(1, 0, 0), c(1, 0, 0)), M3 = list(c(1, 0, 0), c(0, 0, 1)))
MOD <- names(ESPEC)
arima_ml <- function(x, ordem, sazonal, media = TRUE)
  Arima(x, order = ordem, seasonal = list(order = sazonal, period = 12), include.mean = media, method = "ML")
ajusta <- function(x, m) arima_ml(x, ESPEC[[m]][[1]], ESPEC[[m]][[2]])
n_arma <- function(m) sum(ESPEC[[m]][[1]][c(1, 3)]) + sum(ESPEC[[m]][[2]][c(1, 3)])   # p+q+P+Q

## ---- Q4. Estimação e seleção ----------------------------------------------------
fits <- lapply(setNames(MOD, MOD), function(m) ajusta(y, m))
for (m in MOD) {
  f <- fits[[m]]; mm <- tolower(m); tc <- tabela_coef(f)
  for (j in seq_len(nrow(tc))) {
    nm <- gsub("[^a-z0-9]", "", tolower(tc$termo[j]))
    registrar(sprintf("inpc_%s_%s", mm, nm), tc$coef[j])
    registrar(sprintf("inpc_%s_%s_ep", mm, nm), tc$ep[j])
    registrar(sprintf("inpc_%s_%s_t", mm, nm), tc$z[j])
    registrar(sprintf("inpc_%s_%s_p", mm, nm), tc$p[j])
  }
  k <- length(coef(f)) + 1                                # coeficientes + média + variância do erro
  # (d) convenção do forecast::Arima: AIC = -2 lnL + 2k, com sigma^2 contado em k
  stopifnot(abs(f$aic - (-2 * f$loglik + 2 * k)) < 1e-8)
  registrar(sprintf("inpc_%s_loglik", mm), f$loglik)
  registrar(sprintf("inpc_%s_aic", mm), f$aic)
  registrar(sprintf("inpc_%s_bic", mm), f$bic)
  registrar(sprintf("inpc_%s_sigma2", mm), f$sigma2)
  registrar(sprintf("inpc_%s_k", mm), k)
  registrar(sprintf("inpc_%s_n", mm), f$nobs)          # (b) amostra efetiva
}

# grade completa SARIMA(p,0,q)(P,0,Q)_12: confirma que M1 e M2 são os melhores por AIC e BIC
grade <- expand.grid(p = 0:3, q = 0:3, P = 0:1, Q = 0:1)
grade$aic <- grade$bic <- grade$loglik <- NA_real_
for (i in seq_len(nrow(grade))) {
  g <- grade[i, ]
  f <- tryCatch(arima_ml(y, c(g$p, 0, g$q), c(g$P, 0, g$Q)), error = function(e) NULL)
  if (!is.null(f)) { grade$aic[i] <- f$aic; grade$bic[i] <- f$bic; grade$loglik[i] <- f$loglik }
}
grade <- grade[is.finite(grade$aic), ]
grade$nome <- sprintf("SARIMA(%d,0,%d)(%d,0,%d)", grade$p, grade$q, grade$P, grade$Q)
write.csv(grade[order(grade$aic), c("nome", "loglik", "aic", "bic")],
          caminho_repo("trabalho_inpc", "grade_sarima.csv"), row.names = FALSE)
registrar("inpc_grade_n", nrow(grade))
stopifnot(grade$nome[which.min(grade$aic)] == "SARIMA(1,0,0)(1,0,1)",
          grade$nome[which.min(grade$bic)] == "SARIMA(1,0,0)(1,0,0)")

# (f) raízes dos polinômios de M1, o modelo selecionado. AR: (1 - phi B)(1 - Phi B^12),
# de grau 13; MA: (1 + Theta B^12), de grau 12 (sinal do R).
cf1 <- coef(fits$M1)
pol_ar <- c(1, -cf1[["ar1"]], rep(0, 10), -cf1[["sar1"]], cf1[["ar1"]] * cf1[["sar1"]])
pol_ma <- c(1, rep(0, 11), cf1[["sma1"]])
r_ar <- polyroot(pol_ar); r_ma <- polyroot(pol_ma)
registrar("inpc_m1_raiz_ar", 1 / cf1[["ar1"]])
registrar("inpc_m1_raiz_sar", (1 / cf1[["sar1"]])^(1 / 12))
registrar("inpc_m1_raiz_sma", (1 / abs(cf1[["sma1"]]))^(1 / 12))
registrar("inpc_m1_raiz_ar_min", min(Mod(r_ar))); registrar("inpc_m1_raiz_ma_min", min(Mod(r_ma)))
registrar("inpc_m1_ar13", -cf1[["ar1"]] * cf1[["sar1"]])     # M1 como AR(13) restrito
registrar("inpc_m1_mu_anual", 100 * ((1 + cf1[["intercept"]] / 100)^12 - 1))

salvar_figura(file.path(FIG, "inpc_04_raizes"), function() {
  graphics::par(mar = c(4.2, 4.4, 4.8, 1.6), pty = "s", oma = c(1.2, 0, 0, 0))
  th <- seq(0, 2 * pi, length.out = 400)
  plot(cos(th), sin(th), type = "l", col = CORES$eixo, asp = 1, xlim = c(-1.1, 1.1), ylim = c(-1.1, 1.1),
       xlab = "parte real", ylab = "parte imaginária")
  graphics::abline(h = 0, v = 0, col = CORES$grade)
  graphics::points(Re(1 / r_ar), Im(1 / r_ar), pch = 19, col = CORES$principal)
  graphics::points(Re(1 / r_ma), Im(1 / r_ma), pch = 4, lwd = 2, col = CORES$compara)
  graphics::legend("bottomleft", c("AR (13 raízes)", "MA (12 raízes)"), pch = c(19, 4),
                   col = c(CORES$principal, CORES$compara), bty = "n", cex = 0.85)
  titulo_editorial("Raízes inversas dentro do círculo: estacionário e invertível",
                   "M1 = SARIMA(1,0,0)(1,0,1)[12]; as sazonais ficam rentes à borda")
  rodape_externo()
}, largura = 6.5, altura = 7)

## ---- Q5. Diagnóstico dos resíduos -----------------------------------------------
arch_lm <- function(e, q = 12) {                        # nR^2 de e^2 em q defasagens de e^2
  L <- stats::embed(as.numeric(e)^2, q + 1)
  stat <- nrow(L) * summary(stats::lm(L[, 1] ~ L[, -1]))$r.squared
  c(stat = stat, p = stats::pchisq(stat, q, lower.tail = FALSE))
}
diag_res <- function(f, m, fitdf) {
  e <- residuals(f); mm <- tolower(m)
  jb <- jarque.bera.test(e)
  lb12 <- Box.test(e, 12, "Ljung-Box", fitdf = fitdf); lb24 <- Box.test(e, 24, "Ljung-Box", fitdf = fitdf)
  ar <- arch_lm(e)
  registrar(sprintf("inpc_%s_jb", mm), jb$statistic); registrar(sprintf("inpc_%s_jb_p", mm), jb$p.value)
  registrar(sprintf("inpc_%s_lb12", mm), lb12$statistic); registrar(sprintf("inpc_%s_lb12_p", mm), lb12$p.value)
  registrar(sprintf("inpc_%s_lb12_gl", mm), lb12$parameter)
  registrar(sprintf("inpc_%s_lb24", mm), lb24$statistic); registrar(sprintf("inpc_%s_lb24_p", mm), lb24$p.value)
  registrar(sprintf("inpc_%s_lb24_gl", mm), lb24$parameter)
  registrar(sprintf("inpc_%s_arch12", mm), ar[["stat"]]); registrar(sprintf("inpc_%s_arch12_p", mm), ar[["p"]])
  registrar(sprintf("inpc_%s_assim", mm), mean((e - mean(e))^3) / mean((e - mean(e))^2)^1.5)
  registrar(sprintf("inpc_%s_curt", mm), mean((e - mean(e))^4) / mean((e - mean(e))^2)^2)
}
for (m in MOD) diag_res(fits[[m]], m, n_arma(m))
registrar("inpc_chi2_2_c5", qchisq(0.95, 2)); registrar("inpc_chi2_12_c5", qchisq(0.95, 12))
registrar("inpc_lb12_c5_m1", qchisq(0.95, 12 - n_arma("M1"))); registrar("inpc_lb24_c5_m1", qchisq(0.95, 24 - n_arma("M1")))

# maiores resíduos padronizados de M1 (datas dos choques)
e1 <- residuals(fits$M1); z1 <- e1 / sqrt(fits$M1$sigma2)
ord <- order(-abs(z1))[1:3]
for (j in 1:3) {
  registrar(sprintf("inpc_m1_out%d_z", j), z1[ord[j]])
  ma <- mes_ano(time(z1)[ord[j]])
  registrar(sprintf("inpc_m1_out%d_ano", j), ma[["ano"]]); registrar(sprintf("inpc_m1_out%d_mes", j), ma[["mes"]])
}

salvar_figura(file.path(FIG, "inpc_05_residuos_m1"), function() {
  graphics::par(mfrow = c(2, 3), mar = c(4, 4.2, 4.4, 1.2), oma = c(1.2, 0, 0, 0))
  plot(z1, type = "n", xlab = "", ylab = "resíduo padronizado"); grade_h()
  graphics::abline(h = c(-1.96, 1.96), lty = 2, col = CORES$neutra)
  graphics::lines(z1, col = CORES$principal)
  titulo_editorial("(a) Resíduos no tempo", "M1 = SARIMA(1,0,0)(1,0,1)[12]")
  for (k in 1:2) {
    v <- if (k == 1) stats::acf(e1, lag.max = LAGS, plot = FALSE)$acf[-1] else stats::pacf(e1, lag.max = LAGS, plot = FALSE)$acf
    plot(1:LAGS, v, type = "h", xlim = c(0.5, LAGS + 0.5), lwd = 3, ylim = c(-0.3, 0.3), col = CORES$principal,
         xlab = "defasagem", ylab = if (k == 1) "FAC" else "FACP")
    graphics::abline(h = 0, col = CORES$eixo); graphics::abline(h = c(-1, 1) * 1.96 / sqrt(T_), lty = 2, col = CORES$neutra)
    titulo_editorial(if (k == 1) "(b) FAC dos resíduos" else "(c) FACP dos resíduos", "dentro da banda de 95%")
  }
  graphics::hist(z1, breaks = 30, freq = FALSE, col = CORES$painel, border = CORES$eixo,
                 main = "", xlab = "resíduo padronizado", ylab = "densidade")
  graphics::curve(stats::dnorm(x), add = TRUE, col = CORES$compara, lwd = 2)
  titulo_editorial("(d) Histograma", "caudas mais pesadas que a N(0,1)")
  stats::qqnorm(as.numeric(z1), main = "", pch = 19, cex = 0.5, col = CORES$principal,
                xlab = "quantis teóricos", ylab = "quantis amostrais")
  stats::qqline(as.numeric(z1), col = CORES$compara, lwd = 2)
  titulo_editorial("(e) QQ-plot", "nov/2002, jul/2022 e fev/2025 fora da reta")
  pl <- vapply(4:LAGS, function(k) Box.test(e1, k, "Ljung-Box", fitdf = n_arma("M1"))$p.value, 0)
  plot(4:LAGS, pl, pch = 19, cex = 0.7, ylim = c(0, 1), col = CORES$principal, xlab = "defasagem máxima", ylab = "p-valor")
  graphics::abline(h = 0.05, lty = 2, col = CORES$negativa)
  titulo_editorial("(f) Ljung-Box por defasagem", "gl = k - 3; tracejado = 5%")
  rodape_externo()
}, largura = 12, altura = 7.5)

# (d) caminho percorrido: modelos tentados e descartados (LB(12) rejeita a 5%)
DESCART <- list(ar1 = list(c(1, 0, 0), c(0, 0, 0)), ar2 = list(c(2, 0, 0), c(0, 0, 0)),
                arma11 = list(c(1, 0, 1), c(0, 0, 0)), ma1 = list(c(0, 0, 1), c(0, 0, 0)))
for (nm in names(DESCART)) {
  o <- DESCART[[nm]]; f <- arima_ml(y, o[[1]], o[[2]])
  gl <- sum(o[[1]][c(1, 3)]) + sum(o[[2]][c(1, 3)])
  registrar(sprintf("inpc_desc_%s_aic", nm), f$aic)
  registrar(sprintf("inpc_desc_%s_lb12", nm), Box.test(residuals(f), 12, "Ljung-Box", fitdf = gl)$statistic)
  registrar(sprintf("inpc_desc_%s_lb12_p", nm), Box.test(residuals(f), 12, "Ljung-Box", fitdf = gl)$p.value)
}

# (e) sobreajuste deliberado de M1: + AR(2) e + MA(1)
so <- list(ar2 = arima_ml(y, c(2, 0, 0), c(1, 0, 1)), ma1 = arima_ml(y, c(1, 0, 1), c(1, 0, 1)))
for (nm in names(so)) {
  tc <- tabela_coef(so[[nm]]); l <- tc[tc$termo == nm, ]
  registrar(sprintf("inpc_sobre_%s", nm), l$coef); registrar(sprintf("inpc_sobre_%s_ep", nm), l$ep)
  registrar(sprintf("inpc_sobre_%s_t", nm), l$z); registrar(sprintf("inpc_sobre_%s_p", nm), l$p)
  registrar(sprintf("inpc_sobre_%s_aic", nm), so[[nm]]$aic)
  registrar(sprintf("inpc_sobre_%s_lr_p", nm), stats::pchisq(2 * (so[[nm]]$loglik - fits$M1$loglik), 1, lower.tail = FALSE))
}

## ---- Q6. Sobrediferenciação -----------------------------------------------------
# d* = 0 para a variação mensal. Com d* + 1 = 1, o fator (1 - B) passa para o MA:
# (1 - phi B)(1 - B) pi_t = (1 - B) eps_t. Reestimamos M1 com d = 1 em duas versões:
# O1 com um MA(1) livre, para ver o theta estimado, e O0 só com a diferença extra.
O1 <- arima_ml(y, c(1, 1, 1), c(1, 0, 1), media = FALSE)
O0 <- arima_ml(y, c(1, 1, 0), c(1, 0, 1), media = FALSE)
tc <- tabela_coef(O1); l <- tc[tc$termo == "ma1", ]
registrar("inpc_sd_ma1", l$coef); registrar("inpc_sd_ma1_ep", l$ep)
registrar("inpc_sd_raiz_ma", 1 / abs(l$coef))
registrar("inpc_sd_o1_sigma2", O1$sigma2); registrar("inpc_sd_o0_sigma2", O0$sigma2)
registrar("inpc_sd_o1_var_pct", 100 * (O1$sigma2 / fits$M1$sigma2 - 1))
registrar("inpc_sd_o0_var_pct", 100 * (O0$sigma2 / fits$M1$sigma2 - 1))
registrar("inpc_sd_n", O1$nobs)
registrar("inpc_sd_o1_aic", O1$aic)
fac_res <- function(f, k) stats::acf(residuals(f), lag.max = k, plot = FALSE)$acf[k + 1]
registrar("inpc_sd_fac1_m1", fac_res(fits$M1, 1)); registrar("inpc_sd_fac1_o0", fac_res(O0, 1))
registrar("inpc_sd_fac1_o1", fac_res(O1, 1))
registrar("inpc_sd_fac1_dy", stats::acf(dy, lag.max = 1, plot = FALSE)$acf[2])
registrar("inpc_sd_fac1_dy_teoria", -(1 - ac[1]) / 2)       # rho_1 de (1-B)x para x com rho_1, rho_2 ~ AR(1)
registrar("inpc_sd_var_y", var(yv)); registrar("inpc_sd_var_dy", var(as.numeric(dy)))
registrar("inpc_sd_o0_lb12_p", Box.test(residuals(O0), 12, "Ljung-Box", fitdf = 3)$p.value)

salvar_figura(file.path(FIG, "inpc_06_sobrediferenciacao"), function() {
  graphics::par(mfrow = c(1, 3), mar = c(4.2, 4.4, 4.8, 1.2), oma = c(1.2, 0, 0, 0))
  series <- list(list(stats::acf(dy, lag.max = LAGS, plot = FALSE)$acf[-1], "(a) FAC de Δπ", "a série sobrediferenciada"),
                 list(stats::acf(residuals(fits$M1), lag.max = LAGS, plot = FALSE)$acf[-1], "(b) Resíduos de M1", "d = 0"),
                 list(stats::acf(residuals(O0), lag.max = LAGS, plot = FALSE)$acf[-1], "(c) Resíduos de O0", "d = 1, sem MA(1)"))
  for (s in series) {
    plot(1:LAGS, s[[1]], type = "h", lwd = 3, ylim = c(-0.4, 0.4), xlim = c(0.5, LAGS + 0.5),
         col = ifelse(1:LAGS == 1, CORES$negativa, CORES$principal), xlab = "defasagem", ylab = "FAC")
    graphics::abline(h = 0, col = CORES$eixo); graphics::abline(h = c(-1, 1) * 1.96 / sqrt(T_), lty = 2, col = CORES$neutra)
    titulo_editorial(s[[2]], s[[3]])
  }
  rodape_externo()
}, largura = 12, altura = 4.5)

## ---- Q7. Previsão fora da amostra -------------------------------------------------
# (a) H = 24 últimas observações; T0 = T - H.
H <- 24; T0 <- T_ - H
treino <- ts(yv[1:T0], start = INICIO, frequency = 12)
y_val <- yv[(T0 + 1):T_]
registrar("inpc_H", H); registrar("inpc_T0", T0)
registrar("inpc_t0_ano", mes_ano(time(y)[T0])[["ano"]]); registrar("inpc_t0_mes", mes_ano(time(y)[T0])[["mes"]])
fits0 <- lapply(setNames(MOD, MOD), function(m) ajusta(treino, m))
for (m in MOD) registrar(sprintf("inpc_%s_t0_ar1", tolower(m)), coef(fits0[[m]])[["ar1"]])

# (b) Esquema 1: origem fixa em T0, h = 1, ..., H, com IC de 95%
prev1 <- lapply(fits0, function(f) forecast(f, h = H, level = 95))
# (c) Esquema 2: origem móvel, um passo, coeficientes fixos em T0. Arima(model = ...)
# reaplica os coeficientes sem reestimar; o fitted() é a previsão de um passo y_{t+1|t}.
prev2 <- lapply(fits0, function(f) as.numeric(fitted(Arima(y, model = f)))[(T0 + 1):T_])
# benchmarks: passeio aleatório e ingênuo sazonal, nos dois esquemas
hh <- 1:H
bench1 <- list(RW = rep(yv[T0], H), SN = yv[T0 + hh - 12 * ceiling(hh / 12)])
bench2 <- list(RW = yv[T0:(T_ - 1)], SN = yv[(T0 + 1):T_ - 12])
f1 <- c(lapply(prev1, function(p) as.numeric(p$mean)), bench1)
f2 <- c(prev2, bench2)
TODOS <- c(MOD, "RW", "SN")

# (d) RMSE, MAE e MAPE. O MAPE divide por y_t: o mês com variação exatamente zero o torna
# infinito, então ele é calculado nos meses com y_t != 0 (e o número de meses é registrado).
nz <- y_val != 0
metr <- function(prev) {
  e <- y_val - prev
  c(rmse = sqrt(mean(e^2)), mae = mean(abs(e)), mape = 100 * mean(abs(e[nz] / y_val[nz])))
}
for (m in TODOS) for (s in 1:2) {
  r <- metr(if (s == 1) f1[[m]] else f2[[m]])
  for (nm in names(r)) registrar(sprintf("inpc_e%d_%s_%s", s, tolower(m), nm), r[[nm]])
}
registrar("inpc_val_n_zero", sum(!nz)); registrar("inpc_val_n_mape", sum(nz))
registrar("inpc_val_min_abs_nz", min(abs(y_val[nz])))
# (g) cobertura empírica do IC de 95% do esquema 1
for (m in MOD) {
  dentro <- y_val >= as.numeric(prev1[[m]]$lower) & y_val <= as.numeric(prev1[[m]]$upper)
  registrar(sprintf("inpc_e1_%s_cob", tolower(m)), 100 * mean(dentro))
  registrar(sprintf("inpc_e1_%s_fora", tolower(m)), sum(!dentro))
}
# complemento: Diebold-Mariano no esquema 2 (perda quadrática, h = 1)
for (b in c("SN", "RW", "M2")) {
  t1 <- dm.test(y_val - f2$M1, y_val - f2[[b]], h = 1, power = 2, alternative = "two.sided")
  registrar(sprintf("inpc_dm_m1_%s", tolower(b)), t1$statistic); registrar(sprintf("inpc_dm_m1_%s_p", tolower(b)), t1$p.value)
}

salvar_figura(file.path(FIG, "inpc_07_previsao_validacao"), function() {
  graphics::par(mfrow = c(1, 2), mar = c(4.2, 4.4, 4.8, 1.2))
  tv <- as.numeric(time(y))[(T0 + 1):T_]
  ob <- window(y, start = time(y)[T0 - 23])
  p <- prev1$M1
  lim <- range(c(ob, p$lower, p$upper, bench2$SN)); lim <- lim + c(-0.05, 0.05) * diff(lim)
  for (s in 1:2) {
    plot(as.numeric(time(ob)), as.numeric(ob), type = "n", ylim = lim, xlab = "", ylab = "% a.m.")
    grade_h(); graphics::abline(v = time(y)[T0], col = CORES$eixo, lty = 3)
    if (s == 1) graphics::polygon(c(tv, rev(tv)), c(p$lower, rev(p$upper)), col = cor_alpha(CORES$principal, 0.25), border = NA)
    graphics::lines(as.numeric(time(ob)), as.numeric(ob), col = CORES$texto, lwd = 1.5)
    graphics::lines(tv, if (s == 1) as.numeric(p$mean) else f2$M1, col = CORES$principal, lwd = 2)
    graphics::lines(tv, if (s == 1) bench1$SN else bench2$SN, col = CORES$compara, lwd = 1.3, lty = 2)
    if (s == 1) titulo_editorial("(a) Esquema 1: origem fixa, h = 1 a 24",
                                 "linha cheia = M1, com IC 95%; tracejado = ingênuo sazonal; preto = observado")
    else titulo_editorial("(b) Esquema 2: origem móvel, um passo",
                          "coeficientes fixos em set/2024, sem reestimar", fonte = FONTE)
  }
}, largura = 12, altura = 5)

## ---- Complemento A. Estabilidade (AU03) -------------------------------------------
# AR(1) com 11 dummies sazonais, estimável por MQO: permite Chow e CUSUM clássicos.
df_ols <- data.frame(y = yv[-1], y1 = yv[-T_], seasonaldummy(y)[-1, ])
tempo_ols <- time(y)[-1]
ols <- stats::lm(y ~ ., data = df_ols)
registrar("inpc_ols_phi", coef(ols)[["y1"]])
# Chow break-point em mar/2020 (pandemia: data escolhida a priori, não pelos dados)
TB <- which(abs(tempo_ols - (2020 + 2 / 12)) < 1e-6)
ch <- sctest(y ~ ., data = df_ols, type = "Chow", point = TB - 1)
registrar("inpc_chow_f", ch$statistic); registrar("inpc_chow_p", ch$p.value)
registrar("inpc_chow_q", ncol(df_ols))    # número de restrições = número de coeficientes
cus <- efp(y ~ ., data = df_ols, type = "Rec-CUSUM")
sc <- sctest(cus)
registrar("inpc_cusum_stat", sc$statistic); registrar("inpc_cusum_p", sc$p.value)
rec <- vapply(60:nrow(df_ols), function(n) coef(stats::lm(y ~ ., data = df_ols[1:n, ]))[["y1"]], 0)
registrar("inpc_rec_phi_min", min(rec)); registrar("inpc_rec_phi_max", max(rec))

salvar_figura(file.path(FIG, "inpc_08_estabilidade"), function() {
  graphics::par(mfrow = c(1, 2), mar = c(4.2, 4.4, 4.8, 1.2))
  cs <- as.numeric(cus$process); tc <- seq(0, 1, length.out = length(cs))
  lim <- 0.948 * (1 + 2 * tc)   # bandas de 5% do Rec-CUSUM
  tt <- seq(tempo_ols[ncol(df_ols)], tail(tempo_ols, 1), length.out = length(cs))
  plot(tt, cs, type = "n", ylim = range(c(cs, lim, -lim)), xlab = "", ylab = "CUSUM padronizado")
  grade_h(); graphics::lines(tt, lim, lty = 2, col = CORES$negativa); graphics::lines(tt, -lim, lty = 2, col = CORES$negativa)
  graphics::lines(tt, cs, col = CORES$principal, lwd = 1.6)
  titulo_editorial("CUSUM dentro das bandas de 5%", "resíduos recursivos do AR(1) com dummies (MQO)")
  plot(tempo_ols[60:nrow(df_ols)], rec, type = "n", xlab = "", ylab = expression(hat(phi)[1]))
  grade_h(); graphics::lines(tempo_ols[60:nrow(df_ols)], rec, col = CORES$compara, lwd = 1.6)
  titulo_editorial("A persistência cai ao longo da amostra", "AR(1) com dummies: janela expansiva a partir de 60 meses",
                   fonte = FONTE)
}, largura = 10)

## ---- Complemento B. Previsão out/2026 a set/2027 ----------------------------------
fc_final <- lapply(fits, function(f) forecast(f, h = 12, level = 95))
for (m in MOD) {
  p <- as.numeric(fc_final[[m]]$mean)
  registrar(sprintf("inpc_%s_prev1", tolower(m)), p[1])
  registrar(sprintf("inpc_%s_prev1_li", tolower(m)), fc_final[[m]]$lower[1, 1])
  registrar(sprintf("inpc_%s_prev1_ls", tolower(m)), fc_final[[m]]$upper[1, 1])
  registrar(sprintf("inpc_%s_prev12_acum", tolower(m)), 100 * (prod(1 + p / 100) - 1))
}
p1 <- fc_final$M1
ma_fim <- mes_ano(fim)
tab_prev <- data.frame(mes = format(seq(as.Date(sprintf("%d-%02d-01", ma_fim[["ano"]], ma_fim[["mes"]])),
                                        by = "month", length.out = 13)[-1], "%Y-%m"),
                       prev = as.numeric(p1$mean), li95 = as.numeric(p1$lower), ls95 = as.numeric(p1$upper))
write.csv(tab_prev, caminho_repo("trabalho_inpc", "previsao_m1.csv"), row.names = FALSE)
for (j in 1:12) registrar(sprintf("inpc_m1_prev_h%02d", j), tab_prev$prev[j])

salvar_figura(file.path(FIG, "inpc_09_previsao"), function() {
  xh <- window(y, start = c(2022, 1))
  tf <- as.numeric(time(p1$mean))
  plot(c(time(xh), tf), c(xh, p1$mean), type = "n", ylim = range(c(xh, p1$lower, p1$upper)),
       xlab = "", ylab = "% a.m.")
  grade_h()
  graphics::polygon(c(tf, rev(tf)), c(p1$lower, rev(p1$upper)), col = cor_alpha(CORES$principal, 0.25), border = NA)
  graphics::lines(as.numeric(time(xh)), as.numeric(xh), col = CORES$texto, lwd = 1.5)
  graphics::lines(c(tail(as.numeric(time(xh)), 1), tf), c(tail(as.numeric(xh), 1), p1$mean),
                  col = CORES$principal, lwd = 2)
  titulo_editorial("A previsão volta à média e repete o desenho sazonal",
                   "INPC mensal observado e previsto por M1 (out/2026 a set/2027), faixa = IC 95%",
                   fonte = FONTE)
}, largura = 9)

## ---- Reprodutibilidade (entrega) -------------------------------------------------
writeLines(utils::capture.output(utils::sessionInfo()), caminho_repo("trabalho_inpc", "sessionInfo.txt"), useBytes = TRUE)

gravar_resultados("inpc")

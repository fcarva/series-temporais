# Módulo 07 — Regressão com séries temporais (AU06): DL, ARDL, ECM e Granger.
# Exercícios próprios (a AU06 não tem lista): multiplicadores do DL (E2) e do
# ARDL(1,1) (E3), forma ECM, viés por omitir y_{t-1} (E4), viés de amostra finita
# do MQO com y defasado (E5), Granger e feedback (E6) e estimação completa de um
# ARDL simulado: seleção por BIC, Breusch-Godfrey, longo prazo com EP delta e ECM (E7).
# Rodar: Rscript 07_regressao_dinamica/07_regressao.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

suppressPackageStartupMessages(library(lmtest))

FIG <- caminho_repo("07_regressao_dinamica", "figuras")
FONTE <- "simulação e cálculo próprios"
set.seed(2026)

# simula y_t = c + phi y_{t-1} + b0 x_t + b1 x_{t-1} + e_t, x_t = rho x_{t-1} + v_t
# (gamma > 0 acrescenta feedback: x_t recebe gamma * y_{t-1})
simula <- function(n, c0 = 0, phi = 0, b0 = 0, b1 = 0, rho = 0, gamma = 0, sd_e = 1, burn = 200) {
  N <- n + burn; e <- stats::rnorm(N, sd = sd_e); v <- stats::rnorm(N)
  x <- y <- numeric(N)
  for (t in 2:N) {
    x[t] <- rho * x[t - 1] + gamma * y[t - 1] + v[t]
    y[t] <- c0 + phi * y[t - 1] + b0 * x[t] + b1 * x[t - 1] + e[t]
  }
  i <- (burn + 1):N
  list(y = y[i], x = x[i], e = e[i])
}

## ---- E2. DL(2): y_t = 1 + 0,4 x_t + 0,25 x_{t-1} + 0,1 x_{t-2} -----------------
b_dl <- c(0.4, 0.25, 0.1)
m_dl <- multiplicadores_ardl(beta = b_dl, n = 4)
for (k in 0:3) registrar(sprintf("m07_e2_m%d", k), m_dl[k + 1])
cum_dl <- cumsum(m_dl)
for (k in 0:2) registrar(sprintf("m07_e2_cum%d", k), cum_dl[k + 1])
registrar("m07_e2_lp", sum(b_dl))
registrar("m07_e2_defas_media", sum((0:2) * b_dl) / sum(b_dl))       # defasagem média

## ---- E3. ARDL(1,1): y_t = 0,2 + 0,7 y_{t-1} + 0,3 x_t + 0,15 x_{t-1} -----------
c3 <- 0.2; phi3 <- 0.7; b3 <- c(0.3, 0.15)
m3 <- multiplicadores_ardl(phi3, b3, n = 40)
for (k in 0:3) registrar(sprintf("m07_e3_m%d", k), m3[k + 1])
cum3 <- cumsum(m3)
for (k in 0:3) registrar(sprintf("m07_e3_cum%d", k), cum3[k + 1])
th3 <- longo_prazo_ardl(phi3, b3)
registrar("m07_e3_lp", th3)
registrar("m07_e3_media_y", c3 / (1 - phi3))                        # intercepto do equilíbrio
registrar("m07_e3_alpha", phi3 - 1)                                  # velocidade de ajuste no ECM
registrar("m07_e3_meia_vida", log(0.5) / log(phi3))                  # períodos para o desvio cair à metade
k90 <- which(cum3 >= 0.9 * th3)[1] - 1
registrar("m07_e3_k90", k90)                                         # 1º k com 90% do efeito de longo prazo
stopifnot(abs(sum(multiplicadores_ardl(phi3, b3, 500)) - th3) < 1e-10)
# ARDL(1,1) com phi = -0,5 e beta = (0,3; 0,3): a resposta alterna de sinal
b3n <- c(0.3, 0.3)
m3n <- multiplicadores_ardl(-0.5, b3n, n = 3)
for (k in 0:3) registrar(sprintf("m07_e3n_m%d", k), m3n[k + 1])
registrar("m07_e3n_lp", longo_prazo_ardl(-0.5, b3n))

## ---- E4. Omitir y_{t-1}: viés do β̂0 da regressão estática ----------------------
# verdadeiro: y_t = 0,6 y_{t-1} + 0,5 x_t + e_t, x_t = 0,8 x_{t-1} + v_t (sem feedback)
phi4 <- 0.6; b4 <- 0.5; rho4 <- 0.8
plim4 <- b4 + phi4 * b4 * rho4 / (1 - phi4 * rho4)                  # D07.3
registrar("m07_e4_razao", b4 * rho4 / (1 - phi4 * rho4))             # Cov(x_t, y_{t-1})/Var(x_t)
registrar("m07_e4_plim", plim4)
registrar("m07_e4_lp", b4 / (1 - phi4))
R4 <- 2000; T4 <- 200
est4 <- t(replicate(R4, {
  s <- simula(T4, phi = phi4, b0 = b4, rho = rho4); t <- 2:T4
  c(estatico = unname(coef(stats::lm(s$y ~ s$x))[2]),
    ardl = unname(coef(stats::lm(s$y[t] ~ s$y[t - 1] + s$x[t]))[3]))
}))
registrar("m07_e4_mc_estatico", mean(est4[, "estatico"]))
registrar("m07_e4_mc_ardl", mean(est4[, "ardl"]))
registrar("m07_e4_R", R4); registrar("m07_e4_T", T4)
# canal (B): mesma conta com feedback y -> x e x sem persistência própria
s4b <- simula(200000, phi = phi4, b0 = b4, rho = 0, gamma = 0.3)
registrar("m07_e4b_estatico", unname(coef(stats::lm(s4b$y ~ s4b$x))[2]))

## ---- E5. Viés de amostra finita do MQO com y_{t-1} --------------------------------
# y_t = 0,6 y_{t-1} + 0,5 x_t + e_t, x_t = 0,8 x_{t-1} + v_t
TS5 <- c(25, 50, 100, 200, 500, 1000); R5 <- 4000
vies5 <- vapply(TS5, function(n) {
  ph <- replicate(R5, {
    s <- simula(n, phi = 0.6, b0 = 0.5, rho = 0.8); t <- 2:n
    coef(stats::lm(s$y[t] ~ s$y[t - 1] + s$x[t]))[[2]]
  })
  mean(ph) - 0.6
}, 0)
for (i in seq_along(TS5)) registrar(sprintf("m07_e5_vies_t%d", TS5[i]), vies5[i])
registrar("m07_e5_R", R5)
registrar("m07_e5_vies_ar1_t25", -(1 + 3 * 0.6) / 25)               # aproximação de Kendall do AR(1) puro

## ---- E6. Granger e feedback --------------------------------------------------------
# x_t = 0,5 x_{t-1} + gamma y_{t-1} + v_t,  y_t = x_t + e_t
T6 <- 300
granger <- function(gamma) {
  s <- simula(T6, b0 = 1, rho = 0.5, gamma = gamma)
  # p escolhido por BIC num VAR-like ARDL de y em defasagens de y e x, até 6
  bic <- vapply(1:6, function(p) {
    Z <- stats::embed(cbind(s$y, s$x), p + 1)[, -(1:2), drop = FALSE]
    yy <- s$y[(p + 1):T6]; ii <- (7 - p):length(yy)      # amostra comum: perde 6 obs. em todos
    stats::BIC(stats::lm(yy[ii] ~ Z[ii, ]))
  }, 0)
  p <- which.min(bic)
  xy <- grangertest(s$y ~ s$x, order = p)                 # H0: x não Granger-causa y
  yx <- grangertest(s$x ~ s$y, order = p)                 # H0: y não Granger-causa x
  c(p = p, f_xy = xy$F[2], p_xy = xy$`Pr(>F)`[2], f_yx = yx$F[2], p_yx = yx$`Pr(>F)`[2])
}
for (g in c(0, 0.3)) {
  r <- granger(g); nm <- if (g == 0) "g0" else "g3"
  for (k in names(r)) registrar(sprintf("m07_e6_%s_%s", nm, k), r[[k]])
}
# a ligação com a exogeneidade estrita: E(e_t x_{t+1}) = gamma sigma^2 (D07.5)
for (g in c(0, 0.3)) {
  s <- simula(200000, b0 = 1, rho = 0.5, gamma = g); n <- length(s$x)
  registrar(sprintf("m07_e6_cov_%s", if (g == 0) "g0" else "g3"), mean(s$e[-n] * s$x[-1]))
  registrar(sprintf("m07_e6_cov0_%s", if (g == 0) "g0" else "g3"), mean(s$e * s$x))
}
registrar("m07_e6_ar_x_g3", 0.5 + 0.3 * 1)                           # x_t = (0,5 + gamma beta) x_{t-1} + ...

## ---- E7. Estimação completa de um ARDL simulado ------------------------------------
# processo de E3, T = 200; seleção de (p, q) por BIC numa amostra comum
T7 <- 200
s7 <- simula(T7, c0 = c3, phi = phi3, b0 = b3[1], b1 = b3[2], rho = 0.5)
y7 <- s7$y; x7 <- s7$x
PMAX <- 3; QMAX <- 3; ini <- max(PMAX, QMAX) + 1; tt <- ini:T7
reg_ardl <- function(p, q) {
  X <- cbind(sapply(seq_len(p), function(i) y7[tt - i]), sapply(0:q, function(j) x7[tt - j]))
  stats::lm(y7[tt] ~ X)
}
grade7 <- expand.grid(p = 1:PMAX, q = 0:QMAX)
grade7$bic <- mapply(function(p, q) stats::BIC(reg_ardl(p, q)), grade7$p, grade7$q)
grade7$aic <- mapply(function(p, q) stats::AIC(reg_ardl(p, q)), grade7$p, grade7$q)
best <- grade7[which.min(grade7$bic), ]
registrar("m07_e7_p_bic", best$p); registrar("m07_e7_q_bic", best$q)
best_aic <- grade7[which.min(grade7$aic), ]
registrar("m07_e7_p_aic", best_aic$p); registrar("m07_e7_q_aic", best_aic$q)
registrar("m07_e7_n_grade", nrow(grade7)); registrar("m07_e7_n_comum", length(tt))

# ARDL(1,1) estimado na amostra toda (perde 1 obs.)
t1 <- 2:T7
fit7 <- stats::lm(y7[t1] ~ y7[t1 - 1] + x7[t1] + x7[t1 - 1])
cf7 <- coef(fit7); V7 <- stats::vcov(fit7)
nm7 <- c("c", "phi", "b0", "b1")
for (i in 1:4) {
  registrar(sprintf("m07_e7_%s", nm7[i]), cf7[[i]])
  registrar(sprintf("m07_e7_%s_ep", nm7[i]), sqrt(V7[i, i]))
}
# Breusch-Godfrey (o DW não vale com y_{t-1} entre os regressores)
bg <- bgtest(fit7, order = 4)
registrar("m07_e7_bg4", bg$statistic); registrar("m07_e7_bg4_p", bg$p.value)
# longo prazo e EP pelo método delta: theta = (b0 + b1)/(1 - phi)
th7 <- (cf7[[3]] + cf7[[4]]) / (1 - cf7[[2]])
grad <- c(0, (cf7[[3]] + cf7[[4]]) / (1 - cf7[[2]])^2, 1 / (1 - cf7[[2]]), 1 / (1 - cf7[[2]]))
ep_th7 <- sqrt(drop(t(grad) %*% V7 %*% grad))
registrar("m07_e7_lp", th7); registrar("m07_e7_lp_ep", ep_th7)
registrar("m07_e7_lp_li", th7 - 1.96 * ep_th7); registrar("m07_e7_lp_ls", th7 + 1.96 * ep_th7)
# ECM: Δy_t = c + b0 Δx_t + alpha y_{t-1} + g x_{t-1}, theta = -g/alpha
ecm7 <- stats::lm(diff(y7) ~ diff(x7) + y7[t1 - 1] + x7[t1 - 1])
ce <- coef(ecm7)
registrar("m07_e7_ecm_alpha", ce[[3]]); registrar("m07_e7_ecm_alpha_ep", sqrt(stats::vcov(ecm7)[3, 3]))
registrar("m07_e7_ecm_b0", ce[[2]]); registrar("m07_e7_ecm_lp", -ce[[4]] / ce[[3]])
stopifnot(isTRUE(all.equal(unname(residuals(ecm7)), unname(residuals(fit7)))))
registrar("m07_e7_ssr_dif", sum(residuals(ecm7)^2) - sum(residuals(fit7)^2))

## ---- Figuras ------------------------------------------------------------------------
salvar_figura(file.path(FIG, "m07_multiplicadores"), function() {
  graphics::par(mfrow = c(1, 2), mar = c(4.2, 4.4, 4.8, 1.2), oma = c(1.2, 0, 0, 0))
  K <- 12; kk <- 0:K
  plot(kk, m3[kk + 1], type = "h", lwd = 4, col = CORES$principal, ylim = c(0, 0.45), xlim = c(-0.5, K + 0.5),
       xlab = "períodos depois do choque (k)", ylab = expression(partialdiff * y[t + k] / partialdiff * x[t]))
  graphics::points(kk + 0.25, c(m_dl, rep(0, K - 4))[kk + 1], type = "h", lwd = 4, col = CORES$compara)
  grade_h()
  graphics::legend("topright", c("ARDL(1,1) de E3", "DL(2) de E2"), col = c(CORES$principal, CORES$compara),
                   lwd = 4, bty = "n", cex = 0.85)
  titulo_editorial("Choque temporário: o DL corta, o ARDL decai", "multiplicadores de impacto")
  plot(kk, cum3[kk + 1], type = "b", pch = 19, col = CORES$principal, ylim = c(0, 1.6), xlim = c(-0.5, K + 0.5),
       xlab = "períodos depois do choque (k)", ylab = "efeito acumulado")
  graphics::lines(kk, c(cum_dl, rep(sum(b_dl), K - 4))[kk + 1], type = "b", pch = 17, col = CORES$compara)
  graphics::abline(h = c(th3, sum(b_dl)), lty = 2, col = c(CORES$principal, CORES$compara))
  grade_h()
  titulo_editorial("Choque permanente: acumula até o longo prazo", "tracejado = beta(1)/lambda(1)")
  graphics::mtext(paste0("Fonte: ", FONTE), side = 1, line = 0.2, adj = 0.02, outer = TRUE, cex = 0.72, col = CORES$eixo_claro)
}, largura = 11, altura = 4.8)

salvar_figura(file.path(FIG, "m07_vies"), function() {
  graphics::par(mfrow = c(1, 2), mar = c(4.2, 4.4, 4.8, 1.2), oma = c(1.2, 0, 0, 0))
  h1 <- graphics::hist(est4[, "estatico"], breaks = 40, plot = FALSE)
  h2 <- graphics::hist(est4[, "ardl"], breaks = 40, plot = FALSE)
  plot(h2, col = cor_alpha(CORES$principal, 0.5), border = NA, xlim = range(c(h1$breaks, h2$breaks)),
       main = "", xlab = expression(hat(beta)[0]), ylab = "réplicas")
  plot(h1, col = cor_alpha(CORES$compara, 0.5), border = NA, add = TRUE)
  graphics::abline(v = c(b4, plim4), lty = 2, col = c(CORES$principal, CORES$compara), lwd = 1.5)
  titulo_editorial("Omitir y[t-1] desloca o estimador de x", "verde: ARDL; laranja: regressão estática; tracejado: 0,5 e o plim")
  plot(TS5, vies5, log = "x", type = "b", pch = 19, col = CORES$principal, ylim = c(min(vies5) * 1.15, 0.01),
       xlim = c(20, 1250), xaxs = "r", xlab = "T (escala log)", ylab = "viés médio de phi")
  graphics::abline(h = 0, col = CORES$eixo); grade_h()
  titulo_editorial("Viesado em amostra finita, consistente", "ARDL com y[t-1]: o viés de phi some com T")
  graphics::mtext(paste0("Fonte: ", FONTE), side = 1, line = 0.2, adj = 0.02, outer = TRUE, cex = 0.72, col = CORES$eixo_claro)
}, largura = 11, altura = 4.8)

gravar_resultados("m07")

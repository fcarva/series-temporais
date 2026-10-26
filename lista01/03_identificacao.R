# =====================================================================================
# 03_identificacao.R — Questão 3: FAC, FACP e modelos candidatos
#
# Série identificada: Δy = (1 - B) y, com d = 1 e D = 0 (Q2).
# Defasagens: 48 = quatro ciclos sazonais completos (o enunciado pede pelo menos dois).
# Bandas: ±1,96/√T (azul, tracejada) para FAC e FACP, como na aula 01.
# =====================================================================================
# localiza 00_configuracao.R ao lado deste script (funciona de qualquer diretório)
source(file.path(local({ a <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))
  if (length(a)) dirname(normalizePath(a)) else if (file.exists("00_configuracao.R")) "." else "lista01" }),
  "00_configuracao.R"))
q1 <- ler("q1"); q2 <- ler("q2"); y <- q1$y; dy <- q1$dy
LAGS <- 4L * S

## ---- 3.1 Correlogramas ----------------------------------------------------------------
figura("q3_fac_facp", {
  op <- par(mfrow = c(2, 2), mar = c(4, 4.2, 2.6, 1))
  correlograma(y,  LAGS, "FAC",  "(a) FAC de y em nível: decaimento lento")
  correlograma(y,  LAGS, "FACP", "(b) FACP de y em nível: um pico perto de 1")
  r_fac  <- correlograma(dy, LAGS, "FAC",  "(c) FAC de Δy")
  r_facp <- correlograma(dy, LAGS, "FACP", "(d) FACP de Δy")
  par(op)
}, largura = 10, altura = 7)

fac  <- stats::acf(dy, lag.max = LAGS, plot = FALSE)$acf[-1]
facp <- stats::pacf(dy, lag.max = LAGS, plot = FALSE)$acf[, 1, 1]
n <- length(dy); banda <- 1.96 / sqrt(n)
chave <- c(1:3, 11:13, 23:25, 35:37, 47:48)
tab_corr <- data.frame(defasagem = chave, FAC = fac[chave], FACP = facp[chave],
                       FAC_signif = abs(fac[chave]) > banda,
                       FACP_signif = abs(facp[chave]) > banda)
lb_dy <- Box.test(dy, lag = 24, type = "Ljung-Box")

## ---- 3.2 Leitura automática dos padrões (apoio à interpretação do relatório) ----------
# corte da FACP: última defasagem não sazonal (1 a 6) fora da banda
corte_facp <- max(c(0, which(abs(facp[1:6]) > banda)))
# decaimento da FAC nas primeiras defasagens: razão ρ_2/ρ_1 ≈ φ num AR(1)
razao_fac <- fac[2] / fac[1]
sazonais <- data.frame(lag = c(S, 2 * S, 3 * S), FAC = fac[c(S, 2 * S, 3 * S)], FACP = facp[c(S, 2 * S, 3 * S)])

## ---- 3.3 Três candidatos -----------------------------------------------------------------
# Todos para y com d = 1, D = 0 e drift (a média de Δy, ≈ inflação média, é não nula).
#   C1: SARIMA(1,1,0)(1,0,0)[12] — FACP corta em 1; FAC sazonal decaindo em 12, 24 (SAR)
#   C2: SARIMA(1,1,0)(0,0,1)[12] — idem, mas lendo a FAC sazonal como pico só em 12 (SMA)
#   C3: SARIMA(2,1,0)(1,0,0)[12] — a FACP em 2 fica no limite da banda: AR(2) regular
candidatos <- list(
  C1 = list(order = c(1, 1, 0), seasonal = c(1, 0, 0)),
  C2 = list(order = c(1, 1, 0), seasonal = c(0, 0, 1)),
  C3 = list(order = c(2, 1, 0), seasonal = c(1, 0, 0)))

salvar_tabela(tab_corr, "q3_correlogramas")
salvar(list(fac = fac, facp = facp, banda = banda, tab_corr = tab_corr,
            lb_dy = c(stat = unname(lb_dy$statistic), p = lb_dy$p.value),
            corte_facp = corte_facp, razao_fac = razao_fac, sazonais = sazonais,
            candidatos = candidatos, LAGS = LAGS), "q3")
message("Q3 ok: ρ1 = ", round(fac[1], 3), ", φ11 = ", round(facp[1], 3), ", ρ12 = ", round(fac[S], 3),
        ", φ12,12 = ", round(facp[S], 3), "; corte FACP = ", corte_facp)

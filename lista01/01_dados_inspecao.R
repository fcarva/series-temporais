# =====================================================================================
# 01_dados_inspecao.R — Questão 1: inspeção gráfica e transformação
#
# Série: INPC/IBGE, número-índice (dez/1993 = 100), mensal, jan/2000 a set/2026.
# Fonte: SIDRA, tabela 1736, variável 2289. O arquivo dados/inpc_lista01.csv é o
# banco efetivamente utilizado (entregue junto com o código).
#
# Roteiro da Q1(a): tendência, sazonalidade, mudanças de nível/inclinação, outliers
# e dispersão. A "transformação" do título da questão é decidida aqui (log), com
# três evidências: gráfico amplitude × média, lambda de Box-Cox e a leitura econômica.
# =====================================================================================
# localiza 00_configuracao.R ao lado deste script (funciona de qualquer diretório)
source(file.path(local({ a <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))
  if (length(a)) dirname(normalizePath(a)) else if (file.exists("00_configuracao.R")) "." else "lista01" }),
  "00_configuracao.R"))

## ---- 1.1 Leitura e construção das séries -------------------------------------------
dados <- read.csv(file.path("dados", "inpc_lista01.csv"), stringsAsFactors = FALSE)
stopifnot(!anyNA(dados$indice), nrow(dados) >= 120)
INICIO <- c(as.integer(substr(dados$data[1], 1, 4)), as.integer(substr(dados$data[1], 6, 7)))
P  <- ts(dados$indice, start = INICIO, frequency = S)   # índice em nível
y  <- 100 * log(P)                                        # série modelada: 100 × log do índice
dy <- diff(y)                                             # ≈ inflação mensal em % (p.p. de log)
T_ <- length(y)

# 100·Δlog(P) e a variação mensal publicada pelo IBGE são praticamente a mesma série
cor_var <- cor(as.numeric(dy), dados$var_mensal[-1])

## ---- 1.2 Dispersão: gráfico amplitude-média (Box e Jenkins) e Box-Cox -------------------
# Se a amplitude (ou o desvio-padrão) dentro de cada ano cresce com a média do ano,
# a variância depende do nível: o log (lambda = 0) estabiliza.
ano <- floor(time(P) + 1e-9)
am <- data.frame(ano = sort(unique(ano)),
                 media = tapply(P, ano, mean),
                 dp = tapply(P, ano, sd),
                 amplitude = tapply(P, ano, function(v) diff(range(v))))
am <- am[tapply(P, ano, length) == 12, ]          # só anos completos
reg_am <- lm(log(amplitude) ~ log(media), data = am)  # inclinação ≈ 1 - lambda
lambda_guerrero <- BoxCox.lambda(P, method = "guerrero", lower = -1, upper = 2)
lambda_loglik   <- BoxCox.lambda(P, method = "loglik",   lower = -1, upper = 2)

## ---- 1.3 Mudanças de inclinação: quebras na média de Δy (Bai-Perron) -------------------
# Inclinação do log do índice = inflação média. Testa-se se a média de Δy mudou.
bp <- breakpoints(dy ~ 1, h = 0.15)                 # trecho mínimo de 15% da amostra
n_quebras <- length(na.omit(bp$breakpoints))
datas_quebra <- if (n_quebras) time(dy)[bp$breakpoints] else numeric(0)
seg <- if (n_quebras) breakfactor(bp) else factor(rep(1, length(dy)))
medias_seg <- tapply(as.numeric(dy), seg, mean)

## ---- 1.4 Outliers (Chen e Liu, 1993) em Δy -------------------------------------------
# tso() procura outliers aditivos (AO), de nível (LS) e transitórios (TC) em torno de
# um modelo ARMA; aqui o AR(1) com AR sazonal, a especificação de partida da Q3.
out <- tryCatch(
  tso(dy, types = c("AO", "LS", "TC"), cval = 3.5, maxit.iloop = 6,
      tsmethod = "arima", args.tsmethod = list(order = c(1, 0, 0), seasonal = list(order = c(1, 0, 0)))),
  error = function(e) NULL)
tab_out <- if (!is.null(out) && nrow(out$outliers)) {
  o <- out$outliers
  data.frame(tipo = o$type, data = o$time, efeito_pp = o$coefhat, t = o$tstat)
} else data.frame(tipo = character(0), data = character(0), efeito_pp = numeric(0), t = numeric(0))

## ---- 1.5 Sazonalidade: média por mês de Δy ---------------------------------------------
media_mes <- tapply(as.numeric(dy), cycle(dy), mean)
# teste F de igualdade das médias mensais (ANOVA de Δy em dummies de mês) — descritivo
anova_mes <- anova(lm(as.numeric(dy) ~ factor(cycle(dy))))
F_mes <- anova_mes$`F value`[1]; p_mes <- anova_mes$`Pr(>F)`[1]

## ---- 1.6 Figuras ------------------------------------------------------------------------
figura("q1_serie_nivel", {
  op <- par(mfrow = c(2, 1), mar = c(2.6, 4.4, 2.6, 1.2))
  plot(P, type = "n", xlab = "", ylab = "índice (dez/1993 = 100)", main = "(a) INPC em nível")
  grade(); lines(P, col = COR[["azul"]], lwd = 1.6)
  plot(y, type = "n", xlab = "", ylab = "100 × log(índice)", main = "(b) 100 × log do INPC: a série modelada")
  grade(); lines(y, col = COR[["ciano"]], lwd = 1.6)
  if (n_quebras) abline(v = datas_quebra, lty = 2, col = COR[["laranja"]])
  par(op)
}, altura = 6.5)

figura("q1_variacao", {
  plot(dy, type = "n", xlab = "", ylab = "% a.m. (100 × Δlog)",
       main = "Inflação mensal: média por regime (Bai-Perron) e outliers (Chen-Liu)")
  grade(); lines(dy, col = COR[["ciano"]])
  lines(ts(medias_seg[as.integer(seg)], start = start(dy), frequency = S), col = COR[["laranja"]], lwd = 2)
  if (nrow(tab_out)) {
    tt <- time(dy)[out$outliers$ind]
    points(tt, dy[out$outliers$ind], pch = 21, bg = COR[["vermelho"]], col = "white", cex = 1.3)
  }
})

figura("q1_amplitude_media", {
  op <- par(mfrow = c(1, 2))
  plot(am$media, am$amplitude, log = "xy", pch = 19, col = COR[["azul"]],
       xlab = "média anual do índice (escala log)", ylab = "amplitude anual (escala log)",
       main = "(a) Amplitude cresce com o nível")
  xm <- seq(min(am$media), max(am$media), length.out = 50)   # reta ajustada em escala log-log
  lines(xm, exp(predict(reg_am, newdata = data.frame(media = xm))), col = COR[["laranja"]], lwd = 2)
  # subséries sazonais (equivalente ao monthplot): cada mês com os seus anos e a média
  mes <- cycle(dy); n_anos <- max(table(mes))
  plot(NA, xlim = c(0.5, 12.5), ylim = range(dy), xaxt = "n", xlab = "", ylab = "% a.m.",
       main = "(b) Δy por mês do ano: subséries sazonais")
  axis(1, at = 1:12, labels = c("J","F","M","A","M","J","J","A","S","O","N","D"))
  grade()
  for (m in 1:12) {
    v <- as.numeric(dy[mes == m]); xx <- m - 0.4 + 0.8 * (seq_along(v) - 1) / (n_anos - 1)
    lines(xx, v, col = COR[["ciano"]]); segments(m - 0.4, mean(v), m + 0.4, mean(v), col = COR[["laranja"]], lwd = 2.5)
  }
  par(op)
}, largura = 10, altura = 4.6)

## ---- 1.7 Saídas ------------------------------------------------------------------------
salvar_tabela(tab_out, "q1_outliers")
salvar_tabela(am, "q1_amplitude_media")
salvar(list(P = P, y = y, dy = dy, T = T_, inicio = INICIO, cor_var = cor_var,
            lambda_guerrero = lambda_guerrero, lambda_loglik = lambda_loglik,
            incl_am = unname(coef(reg_am)[2]), incl_am_ep = unname(sqrt(diag(vcov(reg_am)))[2]),
            n_quebras = n_quebras, datas_quebra = datas_quebra, medias_seg = medias_seg,
            outliers = tab_out, outliers_raw = if (!is.null(out)) out$outliers else NULL, media_mes = media_mes, F_mes = F_mes, p_mes = p_mes,
            resumo = c(min = min(P), max = max(P), dy_media = mean(dy), dy_dp = sd(dy),
                       dy_min = min(dy), dy_max = max(dy))),
       "q1")
message("Q1 ok: T = ", T_, "; lambda Guerrero = ", round(lambda_guerrero, 3),
        "; quebras = ", n_quebras, "; outliers = ", nrow(tab_out))

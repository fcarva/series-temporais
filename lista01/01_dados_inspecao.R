# =====================================================================================
# 01_dados_inspecao.R — Questão 1: inspeção gráfica e transformação
#
# Série: INPC/IBGE, número-índice (dez/1993 = 100), mensal, jan/2013 a set/2026 (165 meses).
# Fonte: SIDRA, tabela 1736, variável 2289. O arquivo dados/inpc_lista01.csv é o
# banco efetivamente utilizado (entregue junto com o código).
#
# Roteiro da Q1(a): tendência, sazonalidade, mudanças de nível/inclinação, outliers
# e dispersão, por inspeção gráfica. A "transformação" do título da questão é decidida
# aqui (log), pelo gráfico amplitude × média e pela leitura econômica.
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

## ---- 1.2 Dispersão: amplitude anual contra a média anual (inspeção gráfica) --------
# Se a amplitude dentro de cada ano cresce com a média do ano, a variância depende do
# nível. É só um gráfico de inspeção, como os da aula 01; a decisão do log vem da
# interpretação (Δ log = taxa de inflação).
ano <- floor(time(P) + 1e-9)
am <- data.frame(ano = sort(unique(ano)),
                 media = tapply(P, ano, mean),
                 dp = tapply(P, ano, sd),
                 amplitude = tapply(P, ano, function(v) diff(range(v))))
am <- am[tapply(P, ano, length) == 12, ]          # só anos completos

## ---- 1.3 Mudanças de inclinação: média da inflação por ano ----------------------------
# A inclinação do log do índice é a inflação. A média anual de Δy mostra os patamares.
# O teste formal de estabilidade (Chow e CUSUM, aula 03) fica na Q5.
media_ano <- tapply(as.numeric(dy), floor(time(dy) + 1e-9), mean)

## ---- 1.4 Valores extremos de Δy (inspeção) ----------------------------------------------
# Os maiores e o menor valor da inflação mensal; os choques que o modelo não explica
# aparecem depois nos resíduos padronizados (Q5).
ord <- order(as.numeric(dy), decreasing = TRUE)
mes_txt <- function(t) sprintf("%d-%02d", floor(t + 1e-9), round((t %% 1) * 12) + 1)
extremos <- data.frame(data = mes_txt(time(dy)[c(ord[1:4], which.min(dy))]),
                       valor = as.numeric(dy)[c(ord[1:4], which.min(dy))])

## ---- 1.5 Sazonalidade: média por mês de Δy ---------------------------------------------
media_mes <- tapply(as.numeric(dy), cycle(dy), mean)

## ---- 1.6 Figuras ------------------------------------------------------------------------
figura("q1_serie_nivel", {
  op <- par(mfrow = c(2, 1), mar = c(2.6, 4.4, 2.6, 1.2))
  plot(P, type = "n", xlab = "", ylab = "índice (dez/1993 = 100)", main = "(a) INPC em nível")
  grade(); lines(P, col = COR[["azul"]], lwd = 1.6)
  plot(y, type = "n", xlab = "", ylab = "100 × log(índice)", main = "(b) 100 × log do INPC: a série modelada")
  grade(); lines(y, col = COR[["ciano"]], lwd = 1.6)
  par(op)
}, altura = 6.5)

figura("q1_variacao", {
  plot(dy, type = "n", xlab = "", ylab = "% a.m. (100 × Δlog)",
       main = "Inflação mensal e sua média em cada ano")
  grade(); lines(dy, col = COR[["ciano"]])
  anos <- as.numeric(names(media_ano))
  segments(anos, media_ano, anos + 11/12, media_ano, col = COR[["laranja"]], lwd = 2.5)
  abline(h = mean(dy), lty = 2, col = COR[["eixo"]])
})

figura("q1_amplitude_media", {
  op <- par(mfrow = c(1, 2))
  plot(am$media, am$amplitude, log = "xy", pch = 19, col = COR[["azul"]],
       xlab = "média anual do índice (escala log)", ylab = "amplitude anual (escala log)",
       main = "(a) Amplitude anual × média anual")
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
salvar_tabela(extremos, "q1_extremos")
salvar_tabela(am, "q1_amplitude_media")
salvar(list(P = P, y = y, dy = dy, T = T_, inicio = INICIO, cor_var = cor_var, am = am,
            media_ano = media_ano, extremos = extremos, media_mes = media_mes,
            resumo = c(min = min(P), max = max(P), dy_media = mean(dy), dy_dp = sd(dy),
                       dy_min = min(dy), dy_max = max(dy))),
       "q1")
message("Q1 ok: T = ", T_, "; inflação média = ", round(mean(dy), 3))

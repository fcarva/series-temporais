# =====================================================================================
# Lista 01 (Avaliação Parcial) — Modelagem Box-Jenkins do INPC
# Econometria II, PPGEco/UFES, 2026
#
# 00_configuracao.R — pacotes, versões, caminhos, semente e funções auxiliares.
#
# Todos os scripts desta pasta começam com source("00_configuracao.R") e rodam na
# ordem numérica: 01 (Q1) → 02 (Q2) → … → 07 (Q7). Cada script grava o que produz
# em saidas/ (objetos .rds, tabelas .csv e figuras .png), e o seguinte lê dali.
# O relatório (relatorio_lista01.Rmd) só lê saidas/: nenhum número é digitado à mão.
#
# Para rodar tudo e gerar o PDF:   Rscript rodar_tudo.R
# =====================================================================================

## ---- 0.1 Localizar a pasta da lista (funciona de qualquer diretório) -----------------
# A pasta é marcada pelo arquivo ".raiz_lista01".
.acha_raiz <- function(d = getwd()) {
  repeat {
    if (file.exists(file.path(d, ".raiz_lista01"))) return(normalizePath(d, winslash = "/"))
    if (file.exists(file.path(d, "lista01", ".raiz_lista01"))) return(normalizePath(file.path(d, "lista01"), winslash = "/"))
    pai <- dirname(d)
    if (identical(pai, d)) stop("Pasta da Lista 01 não encontrada (falta o arquivo .raiz_lista01).")
    d <- pai
  }
}
# começa pela pasta do script em execução (Rscript --file=...), senão pelo diretório atual
.inicio <- local({ a <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))
  if (length(a)) dirname(normalizePath(a)) else getwd() })
RAIZ_L01 <- .acha_raiz(.inicio)
setwd(RAIZ_L01)
DIR_SAIDA <- file.path(RAIZ_L01, "saidas")
DIR_FIG   <- file.path(DIR_SAIDA, "figuras")
DIR_TAB   <- file.path(DIR_SAIDA, "tabelas")
for (d in c(DIR_SAIDA, DIR_FIG, DIR_TAB)) dir.create(d, showWarnings = FALSE, recursive = TRUE)

## ---- 0.2 Pacotes ---------------------------------------------------------------------
# Cada pacote e o que ele faz aqui:
# Só ferramentas vistas nas aulas 01 a 03 e no texto de Mattos (MAT), ou exigidas
# pelo enunciado. Cada pacote e o que ele faz aqui:
#   forecast    Arima() por máxima verossimilhança exata (AU02), forecast(), dm.test()
#               (Diebold-Mariano, AU03)
#   urca        ur.df (ADF), ur.pp (Phillips-Perron), ur.ers (DF-GLS), todos no MAT;
#               ur.kpss (KPSS, exigido pelo enunciado); punitroot() (p-valores de
#               MacKinnon, como nas tabelas do MAT)
#   tseries     jarque.bera.test() (AU03)
#   FinTS       ArchTest() (ARCH-LM, AU03)
#   lmtest      coeftest()
#   strucchange sctest(type = "Chow") e efp(type = "Rec-CUSUM") (Chow e CUSUM, AU03)
#   knitr, kableExtra, rmarkdown   o relatório em PDF
PACOTES <- c("forecast", "urca", "tseries", "FinTS", "lmtest", "strucchange",
             "knitr", "kableExtra", "rmarkdown")
faltam <- PACOTES[!vapply(PACOTES, requireNamespace, logical(1), quietly = TRUE)]
if (length(faltam)) {
  message("Instalando: ", paste(faltam, collapse = ", "))
  install.packages(faltam, repos = "https://cloud.r-project.org")
}
suppressPackageStartupMessages({
  library(forecast); library(urca); library(tseries); library(FinTS)
  library(lmtest); library(strucchange)
})

## ---- 0.3 Opções globais --------------------------------------------------------------
SEMENTE <- 20261026            # para tudo o que é aleatório
set.seed(SEMENTE)
options(digits = 6, scipen = 6, warn = 1)
S  <- 12L                      # período sazonal (série mensal)
H  <- 24L                      # horizonte de validação da Q7
NIVEL_IC <- 95                 # intervalos de previsão

## ---- 0.4 Funções auxiliares ----------------------------------------------------------

# Grava e lê objetos intermediários (o "estado" passado de um script para o outro)
salvar <- function(obj, nome) saveRDS(obj, file.path(DIR_SAIDA, paste0(nome, ".rds")))
ler    <- function(nome) readRDS(file.path(DIR_SAIDA, paste0(nome, ".rds")))

# Grava uma tabela em CSV (vírgula como separador de campo, ponto decimal)
salvar_tabela <- function(df, nome) {
  write.csv(df, file.path(DIR_TAB, paste0(nome, ".csv")), row.names = FALSE)
  invisible(df)
}

# Paleta (Flexoki, a mesma do resto do repositório) e um tema base enxuto
COR <- c(texto = "#100F0F", eixo = "#6F6E69", grade = "#E6E4D9", papel = "#FFFCF0",
         azul = "#205EA6", ciano = "#24837B", laranja = "#BC5215", vermelho = "#AF3029",
         verde = "#66800B", roxo = "#5E409D", amarelo = "#D0A215")
transp <- function(cor, a = 0.3) grDevices::adjustcolor(cor, alpha.f = a)

# Abre um PNG com o tema; uso: figura("q1_serie", { plot(...) }, largura = 9, altura = 5)
figura <- function(nome, expr, largura = 9, altura = 5, res = 200) {
  arq <- file.path(DIR_FIG, paste0(nome, ".png"))
  grDevices::png(arq, width = largura * res, height = altura * res, res = res, bg = "white")
  op <- graphics::par(family = "sans", col.axis = COR[["eixo"]], col.lab = COR[["texto"]],
                      col.main = COR[["texto"]], fg = COR[["eixo"]], las = 1, cex.axis = 0.85,
                      mgp = c(2.4, 0.7, 0), tcl = -0.3, mar = c(4, 4.4, 3.2, 1.2))
  on.exit({ graphics::par(op); grDevices::dev.off() })
  force(expr)
  invisible(arq)
}
grade <- function() graphics::grid(nx = NA, ny = NULL, col = COR[["grade"]], lty = 1)

# Correlograma com a banda de 95% da aula 01: ±1,96/√T
correlograma <- function(x, lag.max, tipo = c("FAC", "FACP"), titulo = "", s = S) {
  tipo <- match.arg(tipo)
  x <- stats::na.omit(as.numeric(x)); n <- length(x)
  r <- if (tipo == "FAC") stats::acf(x, lag.max = lag.max, plot = FALSE)$acf[-1]
       else stats::pacf(x, lag.max = lag.max, plot = FALSE)$acf[, 1, 1]
  k <- seq_along(r)
  cor_k <- ifelse(k %% s == 0, COR[["laranja"]], ifelse(k %% s %in% c(1, s - 1) & k > 1, COR[["amarelo"]], COR[["ciano"]]))
  lim <- max(0.35, 1.15 * max(abs(r)))
  plot(k, r, type = "h", lwd = 3, col = cor_k, ylim = c(-lim, lim), xlim = c(0.5, lag.max + 0.5),
       xlab = "defasagem (meses)", ylab = tipo, main = titulo, font.main = 1, cex.main = 0.95)
  graphics::abline(h = 0, col = COR[["eixo"]])
  graphics::abline(h = c(-1, 1) * 1.96 / sqrt(n), lty = 2, col = COR[["azul"]])
  graphics::abline(v = seq(s, lag.max, by = s), col = transp(COR[["laranja"]], 0.25))
  invisible(r)
}

# Estatística t, p-valor normal e tabela de coeficientes de um Arima
tabela_coef <- function(fit) {
  b <- stats::coef(fit); ep <- sqrt(diag(fit$var.coef))[names(b)]
  data.frame(termo = names(b), coef = unname(b), ep = unname(ep), t = unname(b / ep),
             p = unname(2 * stats::pnorm(-abs(b / ep))), row.names = NULL)
}

# Número de parâmetros como o forecast/stats contam no AIC (coeficientes livres + sigma2)
k_aic <- function(fit) sum(fit$mask) + 1L

# Polinômios AR e MA completos (regular × sazonal) na convenção do R:
#   phi(B) = 1 - phi_1 B - ... ;  theta(B) = 1 + theta_1 B + ...
# Coeficientes em ordem crescente de potência de B: c(1, c_1, c_2, ...).
mult_pol <- function(a, b) {               # produto de polinômios (convolução)
  out <- numeric(length(a) + length(b) - 1)
  for (i in seq_along(a)) out[i:(i + length(b) - 1)] <- out[i:(i + length(b) - 1)] + a[i] * b
  out
}
pol_sazonal <- function(coefs, sinal, s) {  # 1 + sinal*c1 B^s + sinal*c2 B^2s ...
  pol <- 1
  for (j in seq_along(coefs)) pol <- c(pol, rep(0, s - 1), sinal * coefs[j])
  pol
}
polinomios <- function(fit, s = S) {
  cf <- stats::coef(fit); a <- fit$arma   # p, q, P, Q, s, d, D
  pega <- function(pref, n) if (n) unname(cf[paste0(pref, seq_len(n))]) else numeric(0)
  ar <- pega("ar", a[1]); ma <- pega("ma", a[2]); sar <- pega("sar", a[3]); sma <- pega("sma", a[4])
  list(ar = mult_pol(c(1, -ar), pol_sazonal(sar, -1, s)),
       ma = mult_pol(c(1, ma),  pol_sazonal(sma, +1, s)))
}
# Raízes inversas (devem ficar DENTRO do círculo unitário para estacionariedade/invertibilidade)
raizes_inversas <- function(pol) if (length(pol) <= 1) complex(0) else 1 / polyroot(pol)

# Formatação pt-BR para o relatório
f <- function(x, d = 3) formatC(x, format = "f", digits = d, decimal.mark = ",", big.mark = ".")
fp <- function(p) ifelse(p < 0.001, "< 0,001", f(p, 3))

# Nome legível de um modelo SARIMA ajustado
nome_modelo <- function(fit) {
  a <- fit$arma
  sprintf("SARIMA(%d,%d,%d)(%d,%d,%d)[%d]", a[1], a[6], a[2], a[3], a[7], a[4], a[5])
}

message("Configuração carregada: ", R.version.string, " | pasta: ", RAIZ_L01)

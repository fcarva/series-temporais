# =====================================================================================
# 02_raiz_unitaria.R — Questão 2: testes de raiz unitária e determinação de d e D
#
# Segue o texto de Mattos (MAT, "Tendências e raízes unitárias"), a leitura do curso:
# (a) ADF, PP e KPSS na série em nível y = 100·log(INPC): estatística, valor crítico,
#     p-valor (MacKinnon), defasagens (BIC/AIC, máximo de Schwert) e termos determinísticos.
# (b) As três versões do ADF (MAT, seções 2.2.1 a 2.2.3) e o que cada uma testa:
#     sem constante e só constante: H0 = I(1) puro; H1 = estacionária.
#     constante + tendência: H0 = diferença estacionária (DS); H1 = tendência estacionária (TS).
# (c) Os mesmos testes em Δy para fixar d; para D, o ADF com dummies sazonais centradas
#     (MAT, seção 2.6) e a FAC nas defasagens sazonais (Q3).
# (d) DS × TS: DF-GLS (MAT, seção 2.4) e a série longa como checagem.
#
# Hipóteses de cada teste (lembrete para a prova):
#   ADF  H0: raiz unitária (γ = 0 em Δy_t = α + βt + γ y_{t-1} + Σ δ_i Δy_{t-i} + e_t)
#   PP   H0: raiz unitária; corrige a autocorrelação de forma não paramétrica (Newey-West)
#   KPSS H0: estacionária (em nível ou em torno da tendência) — hipóteses INVERTIDAS
# =====================================================================================
# localiza 00_configuracao.R ao lado deste script (funciona de qualquer diretório)
source(file.path(local({ a <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))
  if (length(a)) dirname(normalizePath(a)) else if (file.exists("00_configuracao.R")) "." else "lista01" }),
  "00_configuracao.R"))
q1 <- ler("q1"); y <- q1$y; dy <- q1$dy; T_ <- q1$T

## ---- 2.0 Funções de apoio -------------------------------------------------------------
# Defasagem máxima pela regra de Schwert (1989): floor(12 (T/100)^(1/4))
PMAX <- floor(12 * (T_ / 100)^(1 / 4))
cod_trend <- c(trend = "ct", drift = "c", none = "nc")

# ADF via urca::ur.df com seleção de defasagens; p-valor de MacKinnon (1996) via punitroot
adf <- function(x, tipo, criterio = "AIC", pmax = PMAX) {
  r <- ur.df(x, type = tipo, lags = pmax, selectlags = criterio)
  k <- sum(grepl("z.diff.lag", rownames(r@testreg$coefficients)))   # @testreg é um summary.lm
  nome_tau <- c(trend = "tau3", drift = "tau2", none = "tau1")[[tipo]]
  tau <- r@teststat[1, nome_tau]
  cols <- setdiff(colnames(r@teststat), nome_tau)
  phis <- setNames(as.numeric(r@teststat[1, cols]), cols)
  list(obj = r, tau = tau, cv = r@cval[nome_tau, ], k = k,
       p = punitroot(tau, N = length(x), trend = cod_trend[[tipo]], statistic = "t"),
       phi = phis, cv_phi = r@cval[setdiff(rownames(r@cval), nome_tau), , drop = FALSE],
       n_reg = length(r@res))
}

# PP via urca::ur.pp (Z-tau); janela de Newey-West "long" = 12 (T/100)^(1/4)
pp <- function(x, modelo) {
  r <- ur.pp(x, type = "Z-tau", model = modelo, lags = "long")
  tau <- r@teststat
  list(obj = r, tau = tau, cv = r@cval[1, ], k = r@lag,
       p = punitroot(tau, N = length(x), trend = c(trend = "ct", constant = "c")[[modelo]], statistic = "t"))
}

# KPSS via urca::ur.kpss; p-valor por interpolação na tabela de Kwiatkowski et al. (1992)
kpss <- function(x, tipo) {
  r <- ur.kpss(x, type = tipo, lags = "long")
  cv <- r@cval[1, ]                                   # 10%, 5%, 2,5%, 1%
  st <- r@teststat
  p <- if (st <= cv[1]) 0.10 else if (st >= cv[4]) 0.01 else
    stats::approx(cv, c(0.10, 0.05, 0.025, 0.01), xout = st)$y
  list(obj = r, stat = st, cv = cv, k = r@lag, p = p,
       p_txt = if (st <= cv[1]) "> 0,10" else if (st >= cv[4]) "< 0,01" else f(p, 3))
}

linha <- function(serie, teste, determ, stat, cv5, p_txt, k, criterio, decisao) {
  data.frame(serie, teste, determ, estatistica = stat, critico_5 = cv5, p = p_txt,
             defasagens = k, criterio, decisao, stringsAsFactors = FALSE)
}

## ---- 2.1 (a) Nível: ADF, PP e KPSS com constante e tendência --------------------------
a_ct <- adf(y, "trend"); a_ct_bic <- adf(y, "trend", "BIC")
p_ct <- pp(y, "trend"); k_ct <- kpss(y, "tau")
tab_a <- rbind(
  linha("y (nível)", "ADF", "constante + tendência", a_ct$tau, a_ct$cv["5pct"], fp(a_ct$p), a_ct$k,
        sprintf("AIC, pmax = %d (Schwert)", PMAX), ifelse(a_ct$tau < a_ct$cv["5pct"], "rejeita H0", "não rejeita H0")),
  linha("y (nível)", "ADF", "constante + tendência", a_ct_bic$tau, a_ct_bic$cv["5pct"], fp(a_ct_bic$p), a_ct_bic$k,
        sprintf("BIC, pmax = %d (Schwert)", PMAX), ifelse(a_ct_bic$tau < a_ct_bic$cv["5pct"], "rejeita H0", "não rejeita H0")),
  linha("y (nível)", "PP (Z-tau)", "constante + tendência", p_ct$tau, p_ct$cv["5pct"], fp(p_ct$p), p_ct$k,
        "janela de Newey-West (long)", ifelse(p_ct$tau < p_ct$cv["5pct"], "rejeita H0", "não rejeita H0")),
  linha("y (nível)", "KPSS", "constante + tendência", k_ct$stat, k_ct$cv["5pct"], k_ct$p_txt, k_ct$k,
        "janela de Newey-West (long)", ifelse(k_ct$stat > k_ct$cv["5pct"], "rejeita H0", "não rejeita H0"))
)

## ---- 2.2 (b) As três versões do ADF (MAT, seção 2.2) --------------------------------
# A versão se escolhe pelo gráfico (MAT, 2.2.5): série que cresce -> constante e
# tendência; na dúvida, também, porque ela engloba as outras. As três são reportadas
# para mostrar como a conclusão muda com os termos determinísticos.
a_c <- adf(y, "drift"); a_n <- adf(y, "none")
tab_b <- data.frame(
  versao = c("sem constante", "só constante", "constante + tendência"),
  estatistica = c("tau1", "tau2", "tau3"),
  h0 = c("I(1) puro (só tendência estocástica)", "I(1) puro (só tendência estocástica)",
         "DS (tendência determinística + estocástica)"),
  h1 = c("estacionária, média zero", "estacionária, média não nula",
         "TS (tendência determinística + erro estacionário)"),
  valor = c(a_n$tau, a_c$tau, a_ct$tau),
  critico_5 = c(a_n$cv["5pct"], a_c$cv["5pct"], a_ct$cv["5pct"]),
  defasagens = c(a_n$k, a_c$k, a_ct$k),
  p_mackinnon = c(fp(a_n$p), fp(a_c$p), fp(a_ct$p)),
  stringsAsFactors = FALSE)
tab_b$decisao <- ifelse(tab_b$valor < tab_b$critico_5, "rejeita H0", "não rejeita H0")

## ---- 2.3 (c) Série diferenciada: d -----------------------------------------------------
# Δy oscila em torno de uma média: versão só com constante (MAT, exemplo 2).
d_c <- adf(dy, "drift"); d_n <- adf(dy, "none"); d_pp <- pp(dy, "constant"); d_k <- kpss(dy, "mu")
tab_c <- rbind(
  linha("Δy", "ADF", "constante", d_c$tau, d_c$cv["5pct"], fp(d_c$p), d_c$k, sprintf("AIC, pmax = %d", PMAX),
        ifelse(d_c$tau < d_c$cv["5pct"], "rejeita H0", "não rejeita H0")),
  linha("Δy", "ADF", "nenhum", d_n$tau, d_n$cv["5pct"], fp(d_n$p), d_n$k, sprintf("AIC, pmax = %d", PMAX),
        ifelse(d_n$tau < d_n$cv["5pct"], "rejeita H0", "não rejeita H0")),
  linha("Δy", "PP (Z-tau)", "constante", d_pp$tau, d_pp$cv["5pct"], fp(d_pp$p), d_pp$k, "janela de Newey-West (long)",
        ifelse(d_pp$tau < d_pp$cv["5pct"], "rejeita H0", "não rejeita H0")),
  linha("Δy", "KPSS", "constante", d_k$stat, d_k$cv["5pct"], d_k$p_txt, d_k$k, "janela de Newey-West (long)",
        ifelse(d_k$stat > d_k$cv["5pct"], "rejeita H0", "não rejeita H0"))
)

## ---- 2.4 (c) Sazonalidade: ADF com dummies sazonais centradas (MAT, seção 2.6) ---------
# Dickey e Miller: acrescentar S - 1 = 11 dummies sazonais centradas à equação do ADF
# controla a sazonalidade determinística sem mudar a distribuição de tau (mesmos
# críticos). Defasagens pelo BIC, comparando todas na mesma amostra.
adf_saz <- function(x, opcao, pmax = PMAX) {
  dx <- diff(x); n <- length(dx); cyc <- cycle(dx)
  DC <- sapply(1:(S - 1), function(m) ifelse(cyc == m, 1 - 1 / S, -1 / S))
  colnames(DC) <- paste0("DC", 1:(S - 1))
  idx <- (pmax + 1):n
  ajuste <- function(p) {
    X <- cbind(nivel = as.numeric(x)[idx], DC[idx, , drop = FALSE])
    if (p > 0) X <- cbind(X, sapply(1:p, function(j) as.numeric(dx)[idx - j]))
    if (opcao == 3) X <- cbind(X, tt = idx)
    lm(as.numeric(dx)[idx] ~ X)
  }
  p <- which.min(sapply(0:pmax, function(k) BIC(ajuste(k)))) - 1
  m <- summary(ajuste(p))
  dum <- m$coefficients[grepl("^XDC", rownames(m$coefficients)), , drop = FALSE]
  # como na tabela 5 do MAT: o t de cada dummy (sazonalidade determinística)
  list(tau = m$coefficients["Xnivel", "t value"], k = p,
       n_dummies_sig = sum(dum[, 4] < 0.05), dummies = dum)
}
saz_y  <- adf_saz(y, 3)
saz_dy <- adf_saz(dy, 2)
tab_saz <- data.frame(
  serie = c("y (nível)", "Δy"),
  versao = c("constante + tendência + 11 dummies", "constante + 11 dummies"),
  tau = c(saz_y$tau, saz_dy$tau),
  critico_5 = c(a_ct$cv["5pct"], d_c$cv["5pct"]),
  defasagens = c(saz_y$k, saz_dy$k),
  dummies_signif_5 = c(saz_y$n_dummies_sig, saz_dy$n_dummies_sig),
  stringsAsFactors = FALSE)
tab_saz$decisao <- ifelse(tab_saz$tau < tab_saz$critico_5, "rejeita H0", "não rejeita H0")

## ---- 2.5 (d) DS × TS: DF-GLS (MAT, seção 2.4) ------------------------------------------
# DF-GLS (Elliott, Rothenberg e Stock): tira a tendência por MQG antes do DF e tem mais
# poder contra alternativas persistentes. O número de defasagens é escolhido antes,
# como no ADF (MAT): usa-se o do ADF por BIC.
k_gls <- max(1, a_ct_bic$k)
ers <- ur.ers(y, type = "DF-GLS", model = "trend", lag.max = k_gls)
tab_d <- data.frame(teste = "DF-GLS (constante + tendência)", estatistica = ers@teststat,
                    critico_5 = ers@cval[1, "5pct"], defasagens = k_gls, stringsAsFactors = FALSE)
tab_d$decisao <- ifelse(tab_d$estatistica < tab_d$critico_5, "rejeita H0", "não rejeita H0")

# Amostra longa (jan/2000 a set/2026, dados/inpc_2000_2026.csv): a decisão d = 1 muda
# quando se acrescentam 13 anos, incluindo a crise de 2002-03? Com mais dados o teste
# ganha poder, mas passa a misturar regimes de inflação diferentes.
longa <- read.csv(file.path("dados", "inpc_2000_2026.csv"), stringsAsFactors = FALSE)
y_pos <- ts(100 * log(longa$indice), start = c(2000, 1), frequency = S)
PMAX_LONGA <- floor(12 * (length(y_pos) / 100)^(1 / 4))
s_ct <- adf(y_pos, "trend", pmax = PMAX_LONGA); s_ct_bic <- adf(y_pos, "trend", "BIC", pmax = PMAX_LONGA); s_k <- kpss(y_pos, "tau")
s_pp <- pp(y_pos, "trend")
tab_sub <- rbind(
  linha("y, 2000:01–2026:09", "ADF", "constante + tendência", s_ct$tau, s_ct$cv["5pct"], fp(s_ct$p), s_ct$k, "AIC",
        ifelse(s_ct$tau < s_ct$cv["5pct"], "rejeita H0", "não rejeita H0")),
  linha("y, 2000:01–2026:09", "ADF", "constante + tendência", s_ct_bic$tau, s_ct_bic$cv["5pct"], fp(s_ct_bic$p), s_ct_bic$k, "BIC",
        ifelse(s_ct_bic$tau < s_ct_bic$cv["5pct"], "rejeita H0", "não rejeita H0")),
  linha("y, 2000:01–2026:09", "PP (Z-tau)", "constante + tendência", s_pp$tau, s_pp$cv["5pct"], fp(s_pp$p), s_pp$k, "Newey-West (long)",
        ifelse(s_pp$tau < s_pp$cv["5pct"], "rejeita H0", "não rejeita H0")),
  linha("y, 2000:01–2026:09", "KPSS", "constante + tendência", s_k$stat, s_k$cv["5pct"], s_k$p_txt, s_k$k, "Newey-West (long)",
        ifelse(s_k$stat > s_k$cv["5pct"], "rejeita H0", "não rejeita H0")))

## ---- 2.6 Figura: as regressões auxiliares do ADF ----------------------------------------
figura("q2_nivel_diferenca", {
  op <- par(mfrow = c(1, 2))
  tt <- seq_along(y); tend <- fitted(lm(as.numeric(y) ~ tt))
  plot(as.numeric(time(y)), as.numeric(y) - tend, type = "l", col = COR[["ciano"]], xlab = "",
       ylab = "desvio da tendência linear", main = "(a) y menos a tendência: ciclos longos")
  abline(h = 0, col = COR[["eixo"]])
  plot(dy, xlab = "", ylab = "Δy (% a.m.)", col = COR[["ciano"]], main = "(b) Δy: média estável")
  abline(h = mean(dy), lty = 2, col = COR[["laranja"]])
  par(op)
}, largura = 10, altura = 4.2)

## ---- 2.7 Saídas -----------------------------------------------------------------------
salvar_tabela(tab_a, "q2a_nivel"); salvar_tabela(tab_b, "q2b_versoes")
salvar_tabela(tab_c, "q2c_diferenca"); salvar_tabela(tab_saz, "q2c_sazonal")
salvar_tabela(tab_d, "q2d_dfgls"); salvar_tabela(tab_sub, "q2d_amostra_longa")
salvar(list(PMAX = PMAX, tab_a = tab_a, tab_b = tab_b, tab_c = tab_c, tab_d = tab_d, tab_saz = tab_saz,
            a_ct = a_ct[c("tau", "cv", "k", "p", "n_reg")], a_ct_bic = a_ct_bic[c("tau", "cv", "k", "p")],
            a_c = a_c[c("tau", "cv", "k", "p")], a_n = a_n[c("tau", "cv", "k", "p")],
            d_c = d_c[c("tau", "cv", "k", "p")], d_k = d_k[c("stat", "cv", "k", "p_txt")],
            p_ct = p_ct[c("tau", "cv", "k", "p")], k_ct = k_ct[c("stat", "cv", "k", "p_txt")],
            saz_y = saz_y, saz_dy = saz_dy, tab_sub = tab_sub,
            ers = list(stat = ers@teststat, cv = ers@cval[1, ], k = k_gls), d = 1L, D = 0L), "q2")
message("Q2 ok: tau3 = ", round(a_ct$tau, 3), " (k = ", a_ct$k, "); KPSS = ", round(k_ct$stat, 3),
        "; Δy tau2 = ", round(d_c$tau, 3), "; ADF sazonal y = ", round(saz_y$tau, 3))

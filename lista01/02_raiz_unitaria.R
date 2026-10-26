# =====================================================================================
# 02_raiz_unitaria.R — Questão 2: testes de raiz unitária e determinação de d e D
#
# (a) ADF, PP e KPSS na série em nível y = 100·log(INPC): estatística, valor crítico,
#     p-valor, defasagens (e critério) e termos determinísticos.
# (b) Constante e tendência na regressão auxiliar do ADF: procedimento sequencial de
#     Dolado, Jenkinson e Sosvilla-Rivero (1990), com as estatísticas tau e phi de
#     Dickey e Fuller (1981) — o roteiro de Enders (2014, cap. 4).
# (c) Os mesmos testes em Δy para fixar d; OCSB, Canova-Hansen e HEGY para fixar D.
# (d) DS × TS, com DF-GLS (mais poder) e Zivot-Andrews (quebra endógena) como robustez.
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

## ---- 2.2 (b) Procedimento sequencial: tendência → constante → nenhum ------------------
# Passo 1 (modelo com tendência): tau3 testa γ = 0; phi3 testa (β, γ) = (0, 0);
#   phi2 testa (α, β, γ) = (0, 0, 0). Se phi3 não rejeita, a tendência é dispensável
#   sob a nula e passa-se ao modelo com constante.
# Passo 2 (constante): tau2 testa γ = 0; phi1 testa (α, γ) = (0, 0).
# Passo 3 (nenhum termo): tau1.
a_c <- adf(y, "drift"); a_n <- adf(y, "none")
tab_b <- data.frame(
  especificacao = c("constante + tendência", "constante + tendência", "constante + tendência",
                    "só constante", "só constante", "nenhum"),
  estatistica = c("tau3", "phi3", "phi2", "tau2", "phi1", "tau1"),
  hipotese_nula = c("γ = 0", "β = γ = 0", "α = β = γ = 0", "γ = 0", "α = γ = 0", "γ = 0"),
  valor = c(a_ct$tau, a_ct$phi[["phi3"]], a_ct$phi[["phi2"]], a_c$tau, a_c$phi[["phi1"]], a_n$tau),
  critico_5 = c(a_ct$cv["5pct"], a_ct$cv_phi["phi3", "5pct"], a_ct$cv_phi["phi2", "5pct"],
                a_c$cv["5pct"], a_c$cv_phi["phi1", "5pct"], a_n$cv["5pct"]),
  defasagens = c(a_ct$k, a_ct$k, a_ct$k, a_c$k, a_c$k, a_n$k),
  stringsAsFactors = FALSE)
tab_b$rejeita <- ifelse(substr(tab_b$estatistica, 1, 3) == "tau", tab_b$valor < tab_b$critico_5,
                        tab_b$valor > tab_b$critico_5)
tab_b$p_mackinnon <- c(fp(a_ct$p), "—", "—", fp(a_c$p), "—", fp(a_n$p))

# Significância da tendência e da constante na regressão auxiliar (estatística t usual:
# sob H0 de raiz unitária ela NÃO tem distribuição t, por isso a decisão usa phi3/phi1)
ct_coef <- a_ct$obj@testreg$coefficients
t_tendencia <- ct_coef["tt", "t value"]

## ---- 2.3 (c) Série diferenciada: d -----------------------------------------------------
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
ndiffs_res <- c(kpss = ndiffs(y, test = "kpss"), adf = ndiffs(y, test = "adf"), pp = ndiffs(y, test = "pp"))

## ---- 2.4 (c) Raiz unitária sazonal: D --------------------------------------------------
# OCSB (Osborn et al., 1988): H0 = raiz unitária sazonal (precisa de 1 - B^12)
# Canova-Hansen (1995): H0 = sazonalidade determinística estável (hipóteses invertidas)
# HEGY (Hylleberg et al., 1990): testa a raiz em cada frequência sazonal separadamente.
#   t_1 (frequência zero), t_2 (frequência π) e os F nas frequências π/6, …, 5π/6.
#   Rejeitar em todas as sazonais => sem raiz unitária sazonal => D = 0.
ocsb <- ocsb.test(dy, lag.method = "AIC", maxlag = 12)
ch   <- ch.test(dy, type = "dummy", pvalue = "raw")
hegy <- hegy.test(dy, deterministic = c(1, 0, 1), lag.method = "BIC", maxlag = 12, pvalue = "RS")
nsd <- c(ocsb = nsdiffs(y, test = "ocsb"), ch = nsdiffs(y, test = "ch"), seas = nsdiffs(y, test = "seas"))
hegy_tab <- data.frame(estatistica = names(hegy$statistics), valor = unname(hegy$statistics),
                       p = unname(hegy$pvalues), stringsAsFactors = FALSE)
ch_tab <- data.frame(estatistica = c("conjunta", paste0("frequência ", seq_along(ch$statistics[-length(ch$statistics)]))),
                     valor = c(tail(ch$statistics, 1), head(ch$statistics, -1)),
                     p = c(tail(ch$pvalues, 1), head(ch$pvalues, -1)), stringsAsFactors = FALSE)

## ---- 2.5 (d) DS × TS: DF-GLS e Zivot-Andrews ------------------------------------------
# DF-GLS (Elliott, Rothenberg e Stock, 1996): retira a tendência por GLS antes do DF;
# mais poder contra alternativas persistentes. Mesmas defasagens do ADF por AIC.
ers <- ur.ers(y, type = "DF-GLS", model = "trend", lag.max = max(1, a_ct$k))
# Zivot-Andrews (1992): H0 raiz unitária sem quebra vs. H1 TS com UMA quebra em data
# desconhecida no intercepto e na tendência. Relevante porque a Q1 achou quebra em 2004.
za <- ur.za(y, model = "both", lag = max(1, a_ct$k))
za_data <- time(y)[za@bpoint]
tab_d <- data.frame(
  teste = c("DF-GLS (ERS)", "Zivot-Andrews (quebra em intercepto e tendência)"),
  estatistica = c(ers@teststat, za@teststat),
  critico_5 = c(ers@cval[1, "5pct"], za@cval[2]),
  defasagens = c(max(1, a_ct$k), max(1, a_ct$k)),
  stringsAsFactors = FALSE)
tab_d$decisao <- ifelse(tab_d$estatistica < tab_d$critico_5, "rejeita H0", "não rejeita H0")

# Subamostra posterior à quebra da Q1 (jan/2004 em diante): o ADF ainda rejeita?
# Se a rejeição no nível vier só do episódio 2002-03, ela some aqui.
y_pos <- window(y, start = c(2004, 1))
s_ct <- adf(y_pos, "trend"); s_ct_bic <- adf(y_pos, "trend", "BIC"); s_k <- kpss(y_pos, "tau")
s_pp <- pp(y_pos, "trend")
tab_sub <- rbind(
  linha("y, 2004:01–", "ADF", "constante + tendência", s_ct$tau, s_ct$cv["5pct"], fp(s_ct$p), s_ct$k, "AIC",
        ifelse(s_ct$tau < s_ct$cv["5pct"], "rejeita H0", "não rejeita H0")),
  linha("y, 2004:01–", "ADF", "constante + tendência", s_ct_bic$tau, s_ct_bic$cv["5pct"], fp(s_ct_bic$p), s_ct_bic$k, "BIC",
        ifelse(s_ct_bic$tau < s_ct_bic$cv["5pct"], "rejeita H0", "não rejeita H0")),
  linha("y, 2004:01–", "PP (Z-tau)", "constante + tendência", s_pp$tau, s_pp$cv["5pct"], fp(s_pp$p), s_pp$k, "Newey-West (long)",
        ifelse(s_pp$tau < s_pp$cv["5pct"], "rejeita H0", "não rejeita H0")),
  linha("y, 2004:01–", "KPSS", "constante + tendência", s_k$stat, s_k$cv["5pct"], s_k$p_txt, s_k$k, "Newey-West (long)",
        ifelse(s_k$stat > s_k$cv["5pct"], "rejeita H0", "não rejeita H0")))

## ---- 2.6 Figura: as regressões auxiliares do ADF ----------------------------------------
figura("q2_nivel_diferenca", {
  op <- par(mfrow = c(1, 2))
  tt <- seq_along(y); tend <- fitted(lm(as.numeric(y) ~ tt))
  plot(as.numeric(time(y)), as.numeric(y) - tend, type = "l", col = COR[["ciano"]], xlab = "",
       ylab = "desvio da tendência linear", main = "(a) y menos a tendência: ciclos longos")
  abline(h = 0, col = COR[["eixo"]]); if (length(za_data)) abline(v = za_data, lty = 2, col = COR[["laranja"]])
  plot(dy, xlab = "", ylab = "Δy (% a.m.)", col = COR[["ciano"]], main = "(b) Δy: média estável")
  abline(h = mean(dy), lty = 2, col = COR[["laranja"]])
  par(op)
}, largura = 10, altura = 4.2)

## ---- 2.7 Saídas -----------------------------------------------------------------------
salvar_tabela(tab_a, "q2a_nivel"); salvar_tabela(tab_b, "q2b_sequencial")
salvar_tabela(tab_c, "q2c_diferenca"); salvar_tabela(hegy_tab, "q2c_hegy"); salvar_tabela(tab_d, "q2d_robustez"); salvar_tabela(tab_sub, "q2d_subamostra")
salvar(list(PMAX = PMAX, tab_a = tab_a, tab_b = tab_b, tab_c = tab_c, tab_d = tab_d,
            a_ct = a_ct[c("tau", "cv", "k", "p", "phi", "n_reg")], a_c = a_c[c("tau", "cv", "k", "p", "phi")],
            a_n = a_n[c("tau", "cv", "k", "p")], t_tendencia = t_tendencia,
            d_c = d_c[c("tau", "cv", "k", "p")], d_k = d_k[c("stat", "cv", "k", "p_txt")],
            p_ct = p_ct[c("tau", "cv", "k", "p")], k_ct = k_ct[c("stat", "cv", "k", "p_txt")],
            ndiffs = ndiffs_res, nsdiffs = nsd,
            ocsb = list(stat = unname(ocsb$statistics), cv = unname(ocsb$critical), lag = ocsb$parameter),
            ch = ch_tab, hegy = hegy_tab, hegy_lags = hegy$fitted.model$lag.order,
            za_data = za_data, tab_sub = tab_sub, ers = list(stat = ers@teststat, cv = ers@cval[1, ]),
            za = list(stat = za@teststat, cv = za@cval), d = 1L, D = 0L), "q2")
message("Q2 ok: tau3 = ", round(a_ct$tau, 3), " (k = ", a_ct$k, "); KPSS = ", round(k_ct$stat, 3),
        "; Δy tau2 = ", round(d_c$tau, 3), "; nsdiffs = ", paste(nsd, collapse = "/"))

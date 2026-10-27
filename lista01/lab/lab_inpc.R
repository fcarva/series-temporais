#' ---
#' title: "Laboratório da Lista 01 — Box-Jenkins do INPC em R"
#' subtitle: "Econometria II · PPGEco/UFES · 2026 · dados do SIDRA via sidrar"
#' author: "[nomes da dupla]"
#' lang: pt-BR
#' output:
#'   html_document:
#'     toc: true
#'     toc_float: true
#'   pdf_document:
#'     latex_engine: lualatex
#'     toc: true
#' ---
#'
#' **Como usar.** Abra no RStudio e rode seção por seção (`Ctrl+Alt+T` roda a seção do
#' cursor; o menu de seções fica no canto inferior do editor). Para o relatório, com todos os
#' números escritos pelo próprio código: `rmarkdown::render("lista01/lab/lab_inpc.R")`.
#'
#' **O que você pode mexer** está todo na seção 0: a janela da série, os candidatos da Q3, o
#' modelo escolhido, o horizonte de validação e a data do teste de Chow. Os comentários
#' `#'` explicam o que cada passo procura e como ler a saída. Eles não trazem nenhum número
#' digitado: os números aparecem nas saídas do código.
#'
#' **Ciclo de Box-Jenkins (aula 03).** O roteiro é identificar (Q1–Q3), estimar (Q4) e
#' checar o modelo pelos resíduos e pela estabilidade (Q5). Se algum diagnóstico falhar,
#' volta-se à Q3. Depois vêm o experimento da Q6 e a avaliação preditiva (Q7).
#'
#' **Sinal do MA.** O R escreve o MA como $1+\theta B$; a lista, na convenção de Box-Jenkins,
#' como $1-\theta B$. Um `ma1` de $-0{,}9$ no R é $\theta=0{,}9$ na lista.

#+ setup, include = FALSE
knitr::opts_chunk$set(comment = "#>", fig.width = 9, fig.height = 4.5, dpi = 120,
                      message = FALSE, warning = FALSE)

# ---- 0. Parâmetros: o que você pode mexer ----------------------------------------------

#+ parametros
INICIO  <- "201301"      # primeiro mês (AAAAMM)
FIM     <- "202609"      # último mês (AAAAMM)
S       <- 12            # período sazonal
H       <- 24            # meses reservados para a validação (Q7)
ALFA    <- 0.05          # nível dos testes
ATUALIZAR <- FALSE       # TRUE baixa de novo do SIDRA; FALSE reaproveita o CSV já salvo
DATA_QUEBRA <- c(2020, 3) # Chow: data fixada ANTES de olhar os dados (início da pandemia)
ROBUSTEZ_LONGA <- TRUE   # Q2(d): repete os testes na série desde jan/2000

# Candidatos da Q3: order = (p, d, q), seasonal = (P, D, Q). Edite após ler a FAC e a FACP.
CANDIDATOS <- list(
  C1 = list(order = c(1, 1, 0), seasonal = c(1, 0, 0)),
  C2 = list(order = c(1, 1, 0), seasonal = c(0, 0, 1)),
  C3 = list(order = c(2, 1, 0), seasonal = c(1, 0, 0))
)
# Modelo levado adiante na Q5–Q7. NA aplica a regra da Q4(e), fixada antes da validação:
# se AIC e BIC concordam, fica o escolhido; se divergem, fica o de menos parâmetros.
ESCOLHIDO <- NA

# ---- Pacotes e ferramentas -------------------------------------------------------------

#+ pacotes
pacotes <- c("sidrar", "FinTS", "urca", "tseries", "lmtest", "strucchange", "forecast")   # forecast por último: o FinTS também tem um Acf
faltam <- setdiff(pacotes, rownames(installed.packages()))
if (length(faltam)) install.packages(faltam)
invisible(lapply(pacotes, library, character.only = TRUE))
set.seed(2026)

PASTA <- if (dir.exists("lista01/lab")) "lista01/lab" else "."   # roda da raiz ou da pasta

num <- function(x, d = 2) formatC(x, format = "f", digits = d, decimal.mark = ",", big.mark = ".")
decisao <- function(p) ifelse(p < ALFA, "rejeita H0", "não rejeita H0")

#' Baixa o número-índice do INPC (SIDRA, tabela 1736, variável 2289, Brasil). O CSV salvo é
#' o "banco efetivamente utilizado" que a entrega exige; com `ATUALIZAR <- FALSE`, o script
#' roda sem internet e reproduz exatamente os mesmos números.

#+ ferramentas_dados
baixar_inpc <- function(inicio, fim) {
  bruto <- get_sidra(api = sprintf("/t/1736/n1/all/v/2289/p/%s-%s", inicio, fim))
  # a coluna do período é a única só com códigos AAAAMM (o nome tem acento, e o encoding varia)
  col_mes <- which(vapply(bruto, function(v) all(grepl("^[0-9]{6}$", v)), logical(1)))[1]
  d <- data.frame(mes = as.character(bruto[[col_mes]]), indice = as.numeric(bruto$Valor))
  d[order(d$mes), ]
}

ler_inpc <- function(inicio, fim, atualizar = ATUALIZAR) {
  arquivo <- file.path(PASTA, "dados", sprintf("inpc_%s_%s.csv", inicio, fim))
  if (atualizar || !file.exists(arquivo)) {
    dir.create(dirname(arquivo), showWarnings = FALSE, recursive = TRUE)
    write.csv(baixar_inpc(inicio, fim), arquivo, row.names = FALSE)
  }
  d <- read.csv(arquivo, colClasses = c(mes = "character"))
  esperado <- format(seq(as.Date(paste0(inicio, "01"), "%Y%m%d"),
                         as.Date(paste0(fim, "01"), "%Y%m%d"), by = "month"), "%Y%m")
  stopifnot("meses faltando ou fora de ordem" = identical(d$mes, esperado),
            "índice ausente ou não positivo" = all(is.finite(d$indice) & d$indice > 0))
  d
}

#' Testes de raiz unitária numa linha cada: estatística, crítico de 5%, p-valor, defasagens e
#' critério, como pede a Q2(a). O p-valor do ADF e do PP é o de MacKinnon (1996), via
#' `punitroot`. O do KPSS é interpolado na tabela de Kwiatkowski et al. (1992) e por isso fica
#' limitado a [0,01; 0,10].

#+ ferramentas_raiz
PMAX <- function(x) floor(12 * (length(x) / 100)^(1 / 4))        # regra de Schwert
DET  <- c(none = "nenhum", drift = "constante", trend = "constante e tendência",
          constant = "constante", mu = "constante", tau = "constante e tendência")
MK   <- c(none = "nc", drift = "c", trend = "ct", constant = "c")

teste_adf <- function(x, tipo, criterio = "AIC") {
  r <- ur.df(x, type = tipo, lags = PMAX(x), selectlags = criterio)
  est <- r@teststat[1]
  data.frame(teste = "ADF", termos = DET[[tipo]], estatistica = est, critico_5 = r@cval[1, "5pct"],
             p_valor = punitroot(est, N = length(x), trend = MK[[tipo]], statistic = "t"),
             defasagens = sum(grepl("z.diff.lag", rownames(r@testreg$coefficients))),
             criterio = sprintf("%s, pmax = %d", criterio, PMAX(x)), H0 = "raiz unitária")
}
teste_pp <- function(x, modelo) {
  r <- ur.pp(x, type = "Z-tau", model = modelo, lags = "long")
  data.frame(teste = "PP", termos = DET[[modelo]], estatistica = r@teststat, critico_5 = r@cval[1, "5pct"],
             p_valor = punitroot(r@teststat, N = length(x), trend = MK[[modelo]], statistic = "t"),
             defasagens = r@lag, criterio = "Newey-West, 12(T/100)^0,25", H0 = "raiz unitária")
}
teste_kpss <- function(x, tipo) {
  r <- ur.kpss(x, type = tipo, lags = "long")
  p <- approx(r@cval[1, ], c(0.10, 0.05, 0.025, 0.01), xout = r@teststat, rule = 2)$y
  data.frame(teste = "KPSS", termos = DET[[tipo]], estatistica = r@teststat, critico_5 = r@cval[1, "5pct"],
             p_valor = p, defasagens = r@lag, criterio = "Newey-West, 12(T/100)^0,25",
             H0 = "estacionária")
}
com_decisao <- function(tab) {
  tab$decisao <- decisao(tab$p_valor)
  rownames(tab) <- NULL
  tab
}

#' Estimação por máxima verossimilhança exata. O drift entra só quando $d+D=1$: é a inflação
#' média, a constante de $\Delta y_t$.

#+ ferramentas_modelos
ajustar <- function(esp, x = y) {
  Arima(x, order = esp$order, seasonal = list(order = esp$seasonal, period = S),
        include.drift = sum(esp$order[2], esp$seasonal[2]) == 1, method = "ML")
}
n_arma <- function(m) sum(arimaorder(m)[c("p", "q", "P", "Q")], na.rm = TRUE)
# Módulo da menor raiz dos polinômios AR e MA já multiplicados (regular × sazonal).
# Maior que 1: estacionário (AR) e invertível (MA). Perto de 1: alerta.
menor_raiz <- function(coefs) if (all(coefs == 0)) Inf else min(Mod(polyroot(c(1, coefs))))
raizes <- function(m) c(AR = menor_raiz(-m$model$phi), MA = menor_raiz(m$model$theta))

# ---- Dados -----------------------------------------------------------------------------

#+ dados
dados <- ler_inpc(INICIO, FIM)
P  <- ts(dados$indice, start = c(as.integer(substr(INICIO, 1, 4)), as.integer(substr(INICIO, 5, 6))),
         frequency = S)                      # número-índice, dez/1993 = 100
y  <- 100 * log(P)                           # série modelada
dy <- diff(y)                                # inflação mensal, % a.m. (aprox.)
c(T = length(y), inicio = INICIO, fim = FIM)  # o enunciado pede T >= 120

#' # Questão 1 — Inspeção gráfica e transformação
#'
#' **O que se procura:** tendência, sazonalidade, mudanças de nível ou de inclinação, outliers e
#' se a dispersão cresce com o nível. Este último ponto decide entre modelar $P_t$ ou $\ln P_t$.

#+ q1_graficos, fig.height = 7
op <- par(mfrow = c(3, 1), mar = c(3, 4.5, 2, 1))
plot(P,  main = "INPC em nível (dez/1993 = 100)", ylab = "índice", xlab = "")
plot(y,  main = "y = 100 · ln(INPC)", ylab = "y", xlab = "")
plot(dy, main = "Inflação mensal: dy, a diferença de y", ylab = "% a.m.", xlab = "")
abline(h = mean(dy), lty = 2)
par(op)

#+ q1_sazonalidade
monthplot(dy, main = "Inflação mensal por mês do ano (linha: média do mês)", ylab = "% a.m.")
ano <- floor(time(dy) + 1e-9)
media_ano <- tapply(dy, ano, mean)
dp_ano    <- tapply(P, floor(time(P) + 1e-9), sd)
round(cbind(media_dy = media_ano, dp_indice = dp_ano[names(media_ano)],
            media_indice = tapply(P, floor(time(P) + 1e-9), mean)[names(media_ano)]), 2)

#+ q1_outliers
z <- (dy - mean(dy)) / sd(dy)
extremos <- data.frame(mes = format(as.Date(paste0(dados$mes[-1], "01"), "%Y%m%d"), "%b/%Y"),
                       dy = round(as.numeric(dy), 2), z = round(as.numeric(z), 2))
extremos[abs(extremos$z) > 2.5, ]

#' **Como ler.** Se o desvio-padrão do índice dentro do ano cresce com a média do ano, a
#' variância depende do nível, e o log a estabiliza. Aqui o índice cresce pouco na janela, e o
#' gráfico decide pouco. Quem decide é a interpretação: com $y_t=100\ln P_t$, $\Delta y_t$ é a
#' inflação mensal em %, e o drift do modelo é a inflação média. Os meses com $|z|>2{,}5$ são
#' os candidatos a outlier; eles voltam na Q5, no Jarque-Bera.

#' # Questão 2 — Ordem de integração
#'
#' ## (a) ADF, PP e KPSS no nível
#'
#' Regressão auxiliar do ADF:
#' $\Delta y_t=\alpha+\beta t+\gamma y_{t-1}+\sum_{i=1}^{p}\delta_i\Delta y_{t-i}+e_t$.
#' ADF e PP testam $H_0:\gamma=0$ (raiz unitária). O KPSS inverte as hipóteses
#' ($H_0$: estacionária). As defasagens do ADF vêm do AIC e, como checagem, do BIC, até o
#' $p_{\max}$ de Schwert; todas as regressões usam a mesma amostra, a do $p_{\max}$.

#+ q2a
nivel <- com_decisao(rbind(teste_adf(y, "trend", "AIC"), teste_adf(y, "trend", "BIC"),
                           teste_pp(y, "trend"), teste_kpss(y, "tau")))
nivel

#' ## (b) Constante e tendência na regressão auxiliar
#'
#' Cada versão do ADF contrapõe hipóteses diferentes (Mattos, 2019, seção 2.2):
#'
#' - **constante e tendência** ($\tau_3$): $H_0$ diferença-estacionária (DS) contra $H_1$
#'   tendência-estacionária (TS);
#' - **só constante** ($\tau_2$): $H_0$ I(1) contra $H_1$ estacionária em torno de uma média;
#' - **nenhum termo** ($\tau_1$): $H_0$ I(1) contra $H_1$ estacionária com média zero.
#'
#' A justificativa vem do gráfico (a série cresce, logo a alternativa plausível tem tendência)
#' e dos testes conjuntos $\phi$ de Dickey-Fuller (1981). $\phi_3$ testa
#' $\beta=\gamma=0$ na regressão com tendência, e $\phi_1$ testa $\alpha=\gamma=0$ na regressão
#' com constante. Rejeitar o $\phi$ diz que o termo determinístico não pode ser retirado.

#+ q2b
versoes <- lapply(c("trend", "drift", "none"), function(tp) ur.df(y, type = tp, lags = PMAX(y), selectlags = "AIC"))
tab_versoes <- data.frame(
  versao   = DET[c("trend", "drift", "none")],
  tau      = sapply(versoes, function(r) r@teststat[1]),
  critico_tau = sapply(versoes, function(r) r@cval[1, "5pct"]),
  p_tau    = mapply(function(r, tr) punitroot(r@teststat[1], N = length(y), trend = tr), versoes, c("ct", "c", "nc")),
  phi      = c(versoes[[1]]@teststat[1, "phi3"], versoes[[2]]@teststat[1, "phi1"], NA),
  critico_phi = c(versoes[[1]]@cval["phi3", "5pct"], versoes[[2]]@cval["phi1", "5pct"], NA))
tab_versoes$leitura_tau <- decisao(tab_versoes$p_tau)
tab_versoes

#' **Como ler.** Se nenhuma das três versões rejeita a raiz unitária, a conclusão não depende
#' da especificação. Um $\tau_1$ positivo é o sintoma de ter retirado a tendência de uma série
#' que cresce: o teste confunde o drift omitido com explosividade.
#'
#' ## (c) Série diferenciada: $d$; e a diferença sazonal: $D$

#+ q2c_d
diferenca <- com_decisao(rbind(teste_adf(dy, "drift"), teste_pp(dy, "constant"), teste_kpss(dy, "mu")))
diferenca
c(ndiffs_kpss = ndiffs(y, test = "kpss"), ndiffs_adf = ndiffs(y, test = "adf"), ndiffs_pp = ndiffs(y, test = "pp"))

#' Para $D$, três evidências independentes:
#'
#' 1. **ADF com 11 dummies sazonais centradas** na regressão auxiliar (Mattos, 2019, seção 2.6;
#'    Dickey-Miller). As dummies absorvem a sazonalidade determinística, e $\tau$ mantém os
#'    críticos do ADF. Dummies significativas indicam sazonalidade determinística, que não
#'    pede $\Delta_{12}$.
#' 2. **OCSB e Canova-Hansen**, via `nsdiffs`. O OCSB (Osborn et al., 1988) tem $H_0$ de raiz
#'    unitária sazonal; o Canova-Hansen (1995) tem $H_0$ de sazonalidade estável. São um
#'    complemento à aula.
#' 3. **A FAC sazonal de $\Delta y$**: uma raiz sazonal faria a FAC em 12, 24, 36 decair
#'    devagar.

#+ q2c_D
adf_sazonal <- function(x, tendencia) {
  dx <- as.numeric(diff(x)); pmax <- PMAX(x); idx <- (pmax + 1):length(dx)
  DC <- sapply(1:(S - 1), function(j) ifelse(cycle(diff(x)) == j, 1 - 1 / S, -1 / S))[idx, ]
  colnames(DC) <- paste0("DC", 1:(S - 1))
  regressao <- function(p, dummies = TRUE) {
    X <- cbind(nivel = as.numeric(x)[idx])
    if (p > 0) X <- cbind(X, `colnames<-`(sapply(1:p, function(j) dx[idx - j]), paste0("L", 1:p)))
    if (tendencia) X <- cbind(X, tempo = idx)
    if (dummies) X <- cbind(X, DC)
    lm(dx[idx] ~ X)
  }
  p <- which.min(sapply(0:pmax, function(k) BIC(regressao(k)))) - 1
  completa <- regressao(p)
  c(tau = summary(completa)$coefficients["Xnivel", "t value"], defasagens = p,
    p_F_dummies = anova(regressao(p, dummies = FALSE), completa)$`Pr(>F)`[2])
}
rbind(nivel_com_tendencia = adf_sazonal(y, TRUE), diferenca = adf_sazonal(dy, FALSE))
c(nsdiffs_ocsb = nsdiffs(dy, test = "ocsb"), nsdiffs_ch = nsdiffs(dy, test = "ch"),
  nsdiffs_forca = nsdiffs(dy, test = "seas"))
round(acf(dy, lag.max = 3 * S, plot = FALSE)$acf[1 + S * (1:3)], 3)   # FAC de Δy em 12, 24, 36

#' **Como ler.** Se, em $\Delta y$, ADF e PP rejeitam e o KPSS não rejeita, $d=1$. Se o ADF
#' com dummies continua sem raiz em $\Delta y$, as dummies são conjuntamente significativas
#' (teste $F$), o `nsdiffs` devolve 0 e a FAC sazonal cai logo, então $D=0$: a sazonalidade é
#' fraca e determinística, e uma parte SAR ou SMA estacionária a modela.
#'
#' ## (d) Tendência estocástica (DS) ou determinística (TS)?
#'
#' O DF-GLS (Elliott, Rothenberg e Stock, 1996; Mattos, 2019, seção 2.4) tira a tendência por
#' MQG antes do teste e tem mais poder contra alternativas persistentes. A série longa, desde
#' 2000, dá mais poder ao ADF e ao KPSS, mas inclui a crise de 2002–2003.

#+ q2d
ers <- ur.ers(y, type = "DF-GLS", model = "trend", lag.max = max(1, nivel$defasagens[2]))   # lags do ADF por BIC
data.frame(teste = "DF-GLS", termos = "constante e tendência", estatistica = ers@teststat,
           critico_5 = ers@cval[1, "5pct"], defasagens = ers@lag,
           decisao = ifelse(ers@teststat < ers@cval[1, "5pct"], "rejeita H0", "não rejeita H0"))

#+ q2d_longa, eval = ROBUSTEZ_LONGA
P_longa <- ts(ler_inpc("200001", FIM)$indice, start = c(2000, 1), frequency = S)
com_decisao(rbind(teste_adf(100 * log(P_longa), "trend"), teste_kpss(100 * log(P_longa), "tau")))

#' **Como ler.** Os testes podem não decidir: o KPSS não rejeitar a estacionariedade em torno da
#' tendência ao mesmo tempo que o ADF não rejeita a raiz é sinal de dados pouco informativos
#' (o KPSS tem pouco poder em amostras curtas). Nesse caso, explicite a ambiguidade e decida
#' por argumentos: (i) os testes de raiz unitária, inclusive o DF-GLS; (ii) sob metas de
#' inflação, choques no nível de preços não são revertidos; (iii) a Q5 e a Q6 mostram que
#' $\Delta y$ não tem MA unitário, o sintoma de diferenciar em excesso. Adota-se DS, $d=1$.

# ---- Q3 ---------------------------------------------------------------------------------

#' # Questão 3 — FAC, FACP e candidatos
#'
#' Banda de 95%: $\pm1{,}96/\sqrt T$ (aula 01). São 48 defasagens, quatro ciclos sazonais.

#+ q3, fig.height = 5.5
tsdisplay(dy, lag.max = 4 * S, main = "Inflação mensal (dy): série, FAC e FACP")
banda <- qnorm(1 - ALFA / 2) / sqrt(length(dy))
defs  <- c(1, 2, 3, S - 1, S, S + 1, 2 * S, 3 * S)
fac   <- acf(dy, lag.max = 3 * S, plot = FALSE)$acf[-1]
facp  <- pacf(dy, lag.max = 3 * S, plot = FALSE)$acf
data.frame(defasagem = defs, FAC = round(fac[defs], 3), FACP = round(facp[defs], 3),
           FAC_fora = abs(fac[defs]) > banda, FACP_fora = abs(facp[defs]) > banda)
c(banda = banda)

#' **Como ler (b).** Na parte regular, FACP truncada em $p$ com FAC decaindo sugere AR($p$);
#' FAC truncada em $q$ com FACP decaindo sugere MA($q$). Na parte sazonal, vale o mesmo nas
#' defasagens $s, 2s, 3s$. Picos em $s-1$ e $s+1$ são a marca do modelo **multiplicativo**: o
#' produto $(1-\phi B)(1-\Phi B^{12})$ gera termos em 1, 12 e 13.
#'
#' **(c)** Os três candidatos estão na seção 0 (`CANDIDATOS`), todos com o mesmo $d$ e o mesmo
#' $D$, para que a Q4 possa compará-los. Se a sua leitura for outra, edite a lista e rode de
#' novo.

# ---- Q4 ---------------------------------------------------------------------------------

#' # Questão 4 — Estimação e seleção

#+ q4a
modelos <- lapply(CANDIDATOS, ajustar)

tabela_unica <- function(ms) {
  termos <- unique(unlist(lapply(ms, function(m) names(coef(m)))))
  celula <- function(m, tr) {
    ct <- coeftest(m)
    if (!tr %in% rownames(ct)) return("")
    sprintf("%s (%s) [%s]", num(ct[tr, 1], 3), num(ct[tr, 2], 3), num(ct[tr, 3], 2))
  }
  corpo <- sapply(ms, function(m) sapply(termos, celula, m = m))
  rodape <- sapply(ms, function(m) c(
    sigma2 = num(m$sigma2, 4), logLik = num(m$loglik, 2), AIC = num(m$aic, 2), BIC = num(m$bic, 2),
    n_efetivo = m$nobs, k = length(coef(m)) + 1, d = arimaorder(m)[["d"]], D = arimaorder(m)[["D"]]))
  rbind(matrix(corpo, nrow = length(termos), dimnames = list(termos, names(ms))), rodape)
}
noquote(tabela_unica(modelos))   # célula: coeficiente (erro-padrão) [t]

#' **(b) Amostra efetiva.** Na MV exata do `Arima`, a verossimilhança é a de $\Delta^d\Delta_s^D y$,
#' com $n = T-d-sD$ observações; está na linha `n_efetivo`.
#'
#' **(c) A comparação vale?** Só se os modelos têm a mesma variável dependente e a mesma
#' amostra efetiva, isto é, os mesmos $d$, $D$ e $n$. O código confere:

#+ q4c
mesma_base <- length(unique(sapply(modelos, function(m) paste(arimaorder(m)[c("d", "D")], m$nobs, collapse = "/")))) == 1
mesma_base

#' Se fosse `FALSE`, um candidato estaria explicando outra série ($\Delta^2 y$ em vez de
#' $\Delta y$, por exemplo), e as verossimilhanças não seriam comparáveis. O caminho seria
#' decidir $d$ e $D$ pelos testes da Q2 e comparar por AIC/BIC só dentro do mesmo $(d,D)$, ou
#' comparar pela previsão fora da amostra, na mesma escala.
#'
#' **(d) Convenção de $k$.** A documentação de `stats::arima` e `forecast::Arima` define o AIC
#' como $-2\ln L + 2k$, com $k$ igual ao número de coeficientes **mais um**, o de
#' $\widehat\sigma^2$. A conta à mão confere. A aula 02 divide por $T$, o que não muda a
#' ordenação.

#+ q4d
m1 <- modelos[[1]]
k1 <- length(coef(m1)) + 1
c(AIC_manual = -2 * m1$loglik + 2 * k1, AIC_R = m1$aic,
  BIC_manual = -2 * m1$loglik + k1 * log(m1$nobs), BIC_R = m1$bic,
  AIC_aula02 = (-2 * m1$loglik + 2 * k1) / m1$nobs)

#' **(e) AIC × BIC.** O BIC pune cada parâmetro com $\ln n$, contra 2 do AIC. Ele é
#' **consistente**: se o modelo verdadeiro está entre os candidatos, escolhe-o com
#' probabilidade que tende a 1. O AIC é **eficiente**: minimiza o erro de previsão
#' assintótico, mesmo quando nenhum candidato é o verdadeiro. A regra para o caso de
#' divergência foi fixada **antes** da validação (seção 0).

#+ q4e
por_aic <- names(which.min(sapply(modelos, `[[`, "aic")))
por_bic <- names(which.min(sapply(modelos, `[[`, "bic")))
if (is.na(ESCOLHIDO)) {
  ESCOLHIDO <- if (por_aic == por_bic) por_aic else
    names(which.min(sapply(modelos[c(por_aic, por_bic)], function(m) length(coef(m)))))
}
c(AIC = por_aic, BIC = por_bic, escolhido = ESCOLHIDO)
fit <- modelos[[ESCOLHIDO]]
coeftest(modelos[[por_aic]])   # quando divergem: o parâmetro extra do maior é significativo?
c(dAIC = modelos[[ESCOLHIDO]]$aic - modelos[[por_aic]]$aic)   # < 2: indistinguíveis pelo AIC

#' **Como ler.** Para prever, o critério natural é o AIC. Mas, se a vantagem dele é menor que
#' 2 pontos (Burnham e Anderson, 2002) e vem de um parâmetro não significativo, os dois
#' modelos são indistinguíveis, e a parcimônia (aula 02) desempata. Se o seu caso for outro,
#' troque `ESCOLHIDO` na seção 0 e justifique.

#' **(f) Raízes.** Os polinômios abaixo já são o produto regular × sazonal. Módulo da menor
#' raiz maior que 1: o AR é estacionário e o MA é invertível. No gráfico, as raízes
#' **inversas** devem ficar dentro do círculo unitário.

#+ q4f, fig.height = 4.5
sapply(modelos, raizes)
plot(fit)

# ---- Q5 ---------------------------------------------------------------------------------

#' # Questão 5 — Diagnóstico (aula 03: análise dos resíduos e de estabilidade)
#'
#' ## (a) Gráficos dos resíduos

#+ q5a, fig.height = 6.5
e  <- residuals(fit)
ep <- (e - mean(e)) / sd(e)
op <- par(mfrow = c(2, 3), mar = c(4, 4, 3.5, 1))
plot(ep, main = "Resíduos padronizados", ylab = "", xlab = ""); abline(h = c(-2, 0, 2), lty = c(2, 1, 2))
Acf(e,  lag.max = 3 * S, main = "FAC dos resíduos")
Pacf(e, lag.max = 3 * S, main = "FACP dos resíduos")
hist(ep, breaks = 20, freq = FALSE, main = "Histograma × N(0, 1)", xlab = ""); curve(dnorm, add = TRUE, lwd = 2)
qqnorm(ep, main = "QQ-plot normal"); qqline(ep)
Acf(e^2, lag.max = 3 * S, main = "FAC dos resíduos ao quadrado")
par(op)

#' ## (b) Ljung-Box com graus de liberdade corrigidos
#'
#' $Q(K)=T(T+2)\sum_{i=1}^{K}\widehat\rho_i^2/(T-i)\sim\chi^2_\nu$, com
#' $\nu=K-(p+q+P+Q)$ (aula 03). O drift não conta, porque não é parâmetro da dinâmica.

#+ q5b
lb <- t(sapply(c(S, 2 * S, 3 * S), function(K) {
  b <- Box.test(e, lag = K, type = "Ljung-Box", fitdf = n_arma(fit))
  c(K = K, Q = unname(b$statistic), gl = unname(b$parameter), p_valor = b$p.value)
}))
data.frame(round(lb, 4), decisao = decisao(lb[, "p_valor"]))

#' ## (c) Jarque-Bera e ARCH-LM
#'
#' JB: $H_0$ de normalidade ($S=0$, $K=3$). ARCH-LM: regressão de $\widehat\varepsilon_t^2$
#' em 12 defasagens, $nR^2\sim\chi^2_{12}$, com $H_0$ de ausência de efeito ARCH. O
#' McLeod-Li (Ljung-Box em $\widehat\varepsilon_t^2$, aula 03, slide 21) é a checagem.

#+ q5c
jb   <- jarque.bera.test(e)
arch <- ArchTest(e, lags = S)
ml   <- Box.test(e^2, lag = S, type = "Ljung-Box")
data.frame(teste = c("Jarque-Bera", "ARCH-LM (12)", "McLeod-Li (12)"),
           estatistica = round(c(jb$statistic, arch$statistic, ml$statistic), 3),
           p_valor = round(c(jb$p.value, arch$p.value, ml$p.value), 4),
           decisao = decisao(c(jb$p.value, arch$p.value, ml$p.value)))
data.frame(mes = format(as.Date(paste0(dados$mes, "01"), "%Y%m%d"), "%b/%Y"), residuo_pad = round(as.numeric(ep), 2))[abs(ep) > 3, ]

#' **Como ler.** A não normalidade causada por poucos choques (meses com $|z|>3$) não
#' compromete a consistência da MV gaussiana (quase-MV). Ela afeta os intervalos de previsão,
#' que a Q7(g) avalia.
#'
#' ## Estabilidade (aula 03): Chow e CUSUM
#'
#' Chow e CUSUM pedem uma regressão por MQO. Usa-se a forma autorregressiva de $\Delta y$
#' com as defasagens que o AR do modelo escolhido gera; com $(1-\phi B)(1-\Phi B^{12})$, são
#' 1, 12 e 13. A data da quebra é fixada a priori; escolhida pelos dados, os críticos usuais
#' deixariam de valer.

#+ q5_estabilidade, fig.height = 4
defs_ar <- which(fit$model$phi != 0)
if (!length(defs_ar)) defs_ar <- 1
mq <- as.data.frame(embed(as.numeric(dy), max(defs_ar) + 1)[, c(1, defs_ar + 1)])
names(mq) <- c("dy", paste0("l", defs_ar))
tempo_mq <- time(dy)[-(1:max(defs_ar))]
TB <- which(abs(tempo_mq - (DATA_QUEBRA[1] + (DATA_QUEBRA[2] - 1) / S)) < 1e-6)
chow  <- sctest(dy ~ ., data = mq, type = "Chow", point = TB - 1)
cusum <- efp(dy ~ ., data = mq, type = "Rec-CUSUM")
w  <- recresid(lm(dy ~ ., data = mq))
cq <- cumsum(w^2) / sum(w^2)
c0 <- 1.36 / sqrt(length(w) / 2)                 # banda de 5% aproximada do CUSUM-Q
data.frame(teste = c("Chow (quebra fixada)", "CUSUM", "CUSUM-Q (desvio máximo)"),
           estatistica = round(c(chow$statistic, sctest(cusum)$statistic, max(abs(cq - seq_along(w) / length(w)))), 3),
           critico_ou_p = round(c(chow$p.value, sctest(cusum)$p.value, c0), 3),
           leitura = c(decisao(chow$p.value), decisao(sctest(cusum)$p.value),
                       ifelse(max(abs(cq - seq_along(w) / length(w))) > c0, "rejeita H0", "não rejeita H0")))
op <- par(mfrow = c(1, 2))
plot(cusum, main = "CUSUM dos resíduos recursivos")
plot(seq_along(w) / length(w), cq, type = "l", lwd = 2, ylim = c(-0.1, 1.1), xlab = "fração da amostra",
     ylab = "", main = "CUSUM-Q")
abline(0, 1, col = "grey40"); abline(c0, 1, lty = 2, col = "red"); abline(-c0, 1, lty = 2, col = "red")
par(op)

#' ## (d) O caminho percorrido
#'
#' A entrega pede a lista dos modelos descartados, com o motivo. A grade abaixo estima
#' todos os SARIMA$(p,1,q)(P,0,Q)_{12}$ com $p,q\le2$ e $P,Q\le1$, na mesma amostra, e
#' classifica cada um.

#+ q5d
grade <- expand.grid(p = 0:2, q = 0:2, P = 0:1, Q = 0:1)
grade <- do.call(rbind, lapply(seq_len(nrow(grade)), function(i) {
  g <- grade[i, ]
  m <- tryCatch(ajustar(list(order = c(g$p, 1, g$q), seasonal = c(g$P, 0, g$Q))), error = function(err) NULL)
  if (is.null(m)) return(data.frame(g, AIC = NA, BIC = NA, LB24_p = NA, raiz_min = NA))
  data.frame(g, AIC = m$aic, BIC = m$bic,
             LB24_p = Box.test(residuals(m), lag = 2 * S, type = "Ljung-Box", fitdf = n_arma(m))$p.value,
             raiz_min = min(raizes(m)))
}))
grade$modelo <- with(grade, sprintf("(%d,1,%d)(%d,0,%d)", p, q, P, Q))
esc <- arimaorder(fit)
grade$motivo <- with(grade, ifelse(is.na(AIC), "não convergiu",
  ifelse(LB24_p < ALFA, "descartado: resíduos autocorrelacionados (LB 24)",
  ifelse(raiz_min < 1.02, "descartado: raiz na fronteira do círculo",
  ifelse(p == esc[["p"]] & q == esc[["q"]] & P == esc[["P"]] & Q == esc[["Q"]], "ESCOLHIDO",
         "adequado, mas preterido (AIC/BIC ou parcimônia)")))))
table(grade$motivo)
head(grade[order(grade$AIC), c("modelo", "AIC", "BIC", "LB24_p", "raiz_min", "motivo")], 10)

#' ## (e) Sobreajuste deliberado
#'
#' Um AR e um MA a mais. Coeficiente extra não significativo, e um teste da razão de
#' verossimilhança que não rejeita, dizem que a especificação já captura a dinâmica.

#+ q5e
sobreajuste <- function(dp, dq) {
  o <- arimaorder(fit)
  m2 <- ajustar(list(order = c(o[["p"]] + dp, o[["d"]], o[["q"]] + dq), seasonal = c(o[["P"]], o[["D"]], o[["Q"]])))
  termo <- if (dp) paste0("ar", o[["p"]] + 1) else paste0("ma", o[["q"]] + 1)
  ct <- coeftest(m2)[termo, ]
  LR <- 2 * (m2$loglik - fit$loglik)
  data.frame(termo_extra = termo, coef = ct[1], ep = ct[2], t = ct[3], p_t = ct[4],
             LR = LR, p_LR = pchisq(LR, 1, lower.tail = FALSE), AIC = m2$aic, dAIC = m2$aic - fit$aic)
}
sob <- rbind(sobreajuste(1, 0), sobreajuste(0, 1))
rownames(sob) <- NULL
cbind(round(sob[, -1], 4), termo = sob$termo_extra)

# ---- Q6 ---------------------------------------------------------------------------------

#' # Questão 6 — Sobrediferenciação ($d^*+1$)
#'
#' Se $\Delta y$ já é estacionária, $\Delta^2 y=(1-B)\Delta y$ ganha um MA com raiz unitária.
#' Reestima-se o modelo com $d=2$ de duas formas: com as mesmas ordens e com um MA(1) a mais,
#' o que a diferença extra "pede".

#+ q6ab
o <- arimaorder(fit)
d2      <- ajustar(list(order = c(o[["p"]], o[["d"]] + 1, o[["q"]]),     seasonal = c(o[["P"]], o[["D"]], o[["Q"]])))
d2_ma   <- ajustar(list(order = c(o[["p"]], o[["d"]] + 1, o[["q"]] + 1), seasonal = c(o[["P"]], o[["D"]], o[["Q"]])))
termo_ma <- paste0("ma", o[["q"]] + 1)
coeftest(d2)      # mesmas ordens: o AR muda para absorver a diferença extra
coeftest(d2_ma)   # com o MA extra
theta <- coef(d2_ma)[grepl("^ma", names(coef(d2_ma)))]
c(theta_R = unname(coef(d2_ma)[termo_ma]), theta_lista = -unname(coef(d2_ma)[termo_ma]),
  soma_MA = sum(theta), modulo_raiz_MA = min(Mod(polyroot(c(1, theta)))))
data.frame(modelo = c("escolhido (d*)", "d* + 1, mesmas ordens", "d* + 1, com MA extra"),
           sigma2 = c(fit$sigma2, d2$sigma2, d2_ma$sigma2),
           variacao_pct = 100 * (c(fit$sigma2, d2$sigma2, d2_ma$sigma2) / fit$sigma2 - 1),
           AIC_nao_comparavel = c(fit$aic, d2$aic, d2_ma$aic))

#' O AIC está na tabela só para mostrar que ele **não** pode decidir aqui: com $d$
#' diferente, a variável dependente é outra (Q4c).

#+ q6c, fig.height = 4
op <- par(mfrow = c(1, 2))
Acf(residuals(fit), lag.max = 2 * S, main = "Resíduos com d*", ylim = c(-0.6, 0.6))
Acf(residuals(d2),  lag.max = 2 * S, main = "Resíduos com d* + 1 (mesmas ordens)", ylim = c(-0.6, 0.6))
par(op)
phi1 <- if ("ar1" %in% names(coef(fit))) coef(fit)[["ar1"]] else 0
c(rho1_residuos_d = acf(residuals(fit), plot = FALSE)$acf[2],
  rho1_residuos_d_mais_1 = acf(residuals(d2), plot = FALSE)$acf[2],
  rho1_serie_d2y = acf(diff(dy), plot = FALSE)$acf[2],
  rho1_teorico_se_AR1 = -(1 - phi1) / 2)

#' **(d) Sinais práticos de sobrediferenciação**, visíveis numa saída típica:
#'
#' - um MA estimado perto de $-1$ no R ($\theta\approx1$ na lista), às vezes com erro-padrão
#'   minúsculo ou `NaN`, porque a MV para na fronteira da invertibilidade;
#' - a soma dos coeficientes MA perto de $-1$;
#' - $\widehat\rho_1$ da série diferenciada perto de $-0{,}5$;
#' - $\widehat\sigma^2$ que sobe em vez de cair;
#' - coeficientes AR que trocam de sinal para absorver a autocorrelação negativa criada.

# ---- Q7 ---------------------------------------------------------------------------------

#' # Questão 7 — Previsão fora da amostra
#'
#' ## (a) Divisão
#'
#' A validação são as últimas $H$ observações, e o treino termina em $T_0=T-H$. O modelo é
#' reestimado **só** com o treino: nada da validação entra na estimação.

#+ q7a
Tn <- length(y); T0 <- Tn - H
val <- (T0 + 1):Tn
fit_tr <- ajustar(CANDIDATOS[[ESCOLHIDO]], window(y, end = time(y)[T0]))
c(T0 = T0, fim_treino = format(as.Date(paste0(dados$mes[T0], "01"), "%Y%m%d"), "%b/%Y"),
  inicio_validacao = format(as.Date(paste0(dados$mes[T0 + 1], "01"), "%Y%m%d"), "%b/%Y"))

#' ## (b) Esquema 1: origem fixa, $h=1,\dots,H$
#' ## (c) Esquema 2: origem móvel, um passo, coeficientes fixos
#'
#' No esquema 2, `Arima(y, model = fit_tr)` aplica os coeficientes do treino, sem reestimar,
#' à série inteira. O filtro de Kalman só atualiza o estado, e o valor ajustado em $t+1$ é
#' $\widehat y_{t+1\mid t}$.

#+ q7bc, fig.height = 4.5
fc1 <- forecast(fit_tr, h = H, level = 100 * (1 - ALFA))
um_passo <- as.numeric(fitted(Arima(y, model = fit_tr)))[val]
z_ic <- qnorm(1 - ALFA / 2)

yv <- as.numeric(y); h <- 1:H
prev_y <- list(
  "SARIMA"            = list(E1 = as.numeric(fc1$mean),          E2 = um_passo),
  "Passeio aleatório" = list(E1 = rep(yv[T0], H),                 E2 = yv[val - 1]),
  "Sazonal ingênuo"   = list(E1 = yv[T0 + h - S * ceiling(h / S)], E2 = yv[val - S]))
ic_y <- list(E1 = cbind(as.numeric(fc1$lower), as.numeric(fc1$upper)),
             E2 = cbind(um_passo - z_ic * sqrt(fit_tr$sigma2), um_passo + z_ic * sqrt(fit_tr$sigma2)))
para_P <- function(v) exp(v / 100)              # volta ao índice (a mediana de P)
real_P <- as.numeric(P)[val]

janela <- (T0 - 36):Tn; tt <- as.numeric(time(P))
plot(tt[janela], as.numeric(P)[janela], type = "l", lwd = 1.8, xlab = "", ylab = "INPC",
     ylim = range(as.numeric(P)[janela], para_P(ic_y$E1)),
     main = sprintf("Esquema 1: origem fixa em T0, h = 1 a %d, IC de %d%%", H, 100 * (1 - ALFA)))
polygon(c(tt[val], rev(tt[val])), c(para_P(ic_y$E1[, 1]), rev(para_P(ic_y$E1[, 2]))), col = "#3b82f633", border = NA)
lines(tt[val], para_P(prev_y$SARIMA$E1), col = "#1d4ed8", lwd = 2)
lines(tt[val], para_P(prev_y$`Passeio aleatório`$E1), lty = 2, col = "#b91c1c")
lines(tt[val], para_P(prev_y$`Sazonal ingênuo`$E1), lty = 3, col = "#a16207")
abline(v = tt[T0], lty = 3)
legend("topleft", c("observado", "SARIMA", "passeio aleatório", "sazonal ingênuo"), bty = "n",
       col = c("black", "#1d4ed8", "#b91c1c", "#a16207"), lty = c(1, 1, 2, 3), lwd = c(1.8, 2, 1, 1))

#' ## (d) e (e) Métricas: RMSE, MAE e MAPE, mais o MASE da aula 03
#'
#' As métricas são calculadas no **índice** $P$, a escala original (aula 03: o MAPE não
#' compara escalas diferentes). O MASE divide o MAE pelo erro médio do sazonal ingênuo no
#' treino; abaixo de 1, o modelo é melhor que ele.

#+ q7de
escala_mase <- mean(abs(diff(as.numeric(P)[1:T0], lag = S)))
metricas <- function(prev, real) {
  e <- real - prev
  c(RMSE = sqrt(mean(e^2)), MAE = mean(abs(e)), MAPE = 100 * mean(abs(e / real)), MASE = mean(abs(e)) / escala_mase)
}
tab7 <- do.call(rbind, lapply(names(prev_y), function(nm) {
  c(setNames(metricas(para_P(prev_y[[nm]]$E1), real_P), paste0("E1_", c("RMSE", "MAE", "MAPE", "MASE"))),
    setNames(metricas(para_P(prev_y[[nm]]$E2), real_P), paste0("E2_", c("RMSE", "MAE", "MAPE", "MASE"))))
}))
rownames(tab7) <- names(prev_y)
round(tab7, 3)

#' **Diebold-Mariano** (aula 03, slide 50), no esquema 2, com perda quadrática e a correção de
#' Harvey, Leybourne e Newbold (1997) para amostra pequena, que o `dm.test` aplica.
#' $H_0$: mesma acurácia.

#+ q7_dm
e_mod <- real_P - para_P(prev_y$SARIMA$E2)
dm <- t(sapply(names(prev_y)[-1], function(nm) {
  r <- dm.test(e_mod, real_P - para_P(prev_y[[nm]]$E2), h = 1, power = 2)
  c(DM = unname(r$statistic), p_valor = unname(r$p.value))
}))
data.frame(round(dm, 4), decisao = decisao(dm[, "p_valor"]))

#' ## (f) O modelo superou os benchmarks? E a escala da inflação
#'
#' Atenção ao que os benchmarks significam em $y=100\ln P$. O passeio aleatório em $y$
#' prevê inflação **zero**, e o sazonal ingênuo em $y$ repete o nível de 12 meses antes, ou
#' seja, ignora a inflação de um ano inteiro. São benchmarks fracos para uma série com
#' drift. A comparação exigente é na **inflação mensal** $\Delta y$, a variável que o SARIMA
#' de fato modela, contra os ingênuos definidos em $\Delta y$: o passeio aleatório da
#' inflação ($\widehat\pi_{t+1}=\pi_t$) e o sazonal ingênuo da inflação
#' ($\widehat\pi_{t+1}=\pi_{t+1-12}$).
#'
#' No esquema 2, o erro do SARIMA é **o mesmo** nas duas escalas, porque $y_t$ é conhecido:
#' $y_{t+1}-\widehat y_{t+1\mid t}=\pi_{t+1}-\widehat\pi_{t+1\mid t}$. O que muda é só o
#' benchmark. O MAPE fica de fora: a inflação mensal passa perto de zero e até fica negativa
#' (aula 03, slide 46).

#+ q7f
pi_real <- as.numeric(dy)[val - 1]                      # Δy em T0+1, …, T
piv <- as.numeric(dy)                                   # piv[t-1] = Δy_t
pi_prev <- list(
  "SARIMA" = list(E1 = diff(c(yv[T0], as.numeric(fc1$mean))), E2 = um_passo - yv[val - 1]),
  "Passeio aleatório da inflação" = list(E1 = rep(piv[T0 - 1], H), E2 = piv[val - 2]),
  "Sazonal ingênuo da inflação"   = list(E1 = piv[T0 - 1 + h - S * ceiling(h / S)], E2 = piv[val - 1 - S]))
tab7_pi <- do.call(rbind, lapply(pi_prev, function(pr) {
  c(E1_RMSE = sqrt(mean((pi_real - pr$E1)^2)), E1_MAE = mean(abs(pi_real - pr$E1)),
    E2_RMSE = sqrt(mean((pi_real - pr$E2)^2)), E2_MAE = mean(abs(pi_real - pr$E2)))
}))
round(tab7_pi, 4)
dm_pi <- t(sapply(names(pi_prev)[-1], function(nm) {
  r <- dm.test(pi_real - pi_prev$SARIMA$E2, pi_real - pi_prev[[nm]]$E2, h = 1, power = 2)
  c(DM = unname(r$statistic), p_valor = unname(r$p.value))
}))
data.frame(round(dm_pi, 4), decisao = decisao(dm_pi[, "p_valor"]))

#' **Como ler.** Reporte as duas tabelas, sem mexer no modelo para "ganhar" (o enunciado
#' proíbe). Bater benchmarks que ignoram o drift é pouco. O teste informativo é a
#' comparação na inflação, com o DM dizendo se a diferença sobrevive ao erro amostral.
#'
#' ## (g) Cobertura do intervalo de 95%
#'
#' Cobertura empírica, Winkler score (largura mais penalidade $2/\alpha$ por ponto fora) e os
#' testes de Christoffersen (1998): $LR_{uc}$ (a frequência de violações é a nominal?),
#' $LR_{ind}$ (as violações são independentes?) e $LR_{cc}=LR_{uc}+LR_{ind}$ (aula 03, slides
#' 53–60).

#+ q7g
christoffersen <- function(fora, alfa = ALFA) {
  ll <- function(p, k, n) (if (k > 0) k * log(p) else 0) + (if (n - k > 0) (n - k) * log(1 - p) else 0)
  n <- length(fora); x <- sum(fora)
  LRuc <- -2 * (ll(alfa, x, n) - ll(x / n, x, n))
  a <- fora[-n]; b <- fora[-1]
  n01 <- sum(!a & b); n00 <- sum(!a & !b); n11 <- sum(a & b); n10 <- sum(a & !b)
  LRind <- -2 * (ll((n01 + n11) / (n - 1), n01 + n11, n - 1) -
                 ll(if (n00 + n01) n01 / (n00 + n01) else 0, n01, n00 + n01) -
                 ll(if (n10 + n11) n11 / (n10 + n11) else 0, n11, n10 + n11))
  c(violacoes = x, cobertura_pct = 100 * (1 - x / n), LRuc = LRuc, p_uc = pchisq(LRuc, 1, lower.tail = FALSE),
    LRind = LRind, p_ind = pchisq(LRind, 1, lower.tail = FALSE),
    LRcc = LRuc + LRind, p_cc = pchisq(LRuc + LRind, 2, lower.tail = FALSE))
}
winkler <- function(li, ls, real, alfa = ALFA) {
  mean((ls - li) + (2 / alfa) * (li - real) * (real < li) + (2 / alfa) * (real - ls) * (real > ls))
}
cobertura <- t(sapply(c("E1", "E2"), function(es) {
  li <- para_P(ic_y[[es]][, 1]); ls <- para_P(ic_y[[es]][, 2])
  c(christoffersen(real_P < li | real_P > ls), winkler = winkler(li, ls, real_P))
}))
round(cobertura, 3)

#' **Como ler.** Uma cobertura de 100% com intervalos largos não é um acerto: o Winkler
#' paga a largura. No esquema 1, os 24 erros vêm de uma única origem e são
#' correlacionados entre si, e o intervalo de um modelo integrado se abre com $h$. Por isso,
#' o teste de calibração mais informativo é o do esquema 2. Sem nenhuma violação, o
#' $LR_{ind}$ não tem informação: vale zero.

# ---- Reprodutibilidade -----------------------------------------------------------------

#' # Versões do software
#'
#' A entrega exige o `sessionInfo()`. Ele também é gravado em `lista01/lab/sessionInfo.txt`,
#' ao lado do banco usado (`lista01/lab/dados/`).

#+ sessao
writeLines(capture.output(sessionInfo()), file.path(PASTA, "sessionInfo.txt"))
sessionInfo()

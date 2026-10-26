# =====================================================================================
# Lista 01 — Modelagem Box-Jenkins do INPC (Econometria II, PPGEco/UFES)
#
# Script único: roda em qualquer pasta, em qualquer máquina com R e internet.
# Abra no RStudio e execute bloco a bloco (Ctrl+Enter): cada gráfico aparece na janela
# de plots, já anotado com o que importa, e cada teste imprime a decisão em português.
#
# O roteiro é o de quem investiga a série pela primeira vez. Em cada passo:
#   PERGUNTA   o que queremos saber
#   FÓRMULA    o que o teste ou o modelo calcula, escrito por extenso
#   HIPÓTESES  H0 e H1, e o que cada uma significa para a série
#   ESPERADO   o que veríamos se H0 fosse verdadeira
#   LEITURA    como transformar o número numa conclusão
#
# Saídas gravadas na pasta atual: inpc_lista01.csv (a base efetivamente usada) e
# sessionInfo_lista01.txt (versões do R e dos pacotes), exigidos na entrega.
# =====================================================================================

# ---- Pacotes ------------------------------------------------------------------------
pacotes <- c("jsonlite", "forecast", "tseries", "urca", "lmtest", "FinTS", "strucchange")
novos <- pacotes[!pacotes %in% rownames(installed.packages())]
if (length(novos)) install.packages(novos, repos = "https://cloud.r-project.org")
library(forecast)   # Arima, forecast, accuracy, checkresiduals
library(tseries)    # jarque.bera.test, kpss.test
library(urca)       # ur.df, ur.pp, ur.kpss, ur.ers (mostram a regressão auxiliar inteira)
library(lmtest)     # coeftest
library(FinTS)      # ArchTest
library(strucchange) # Chow e CUSUM (aula 03)

# ---- Dados ----------------------------------------------------------------------------
# INPC/IBGE, número-índice (dez/1993 = 100), mensal, jan/2013 a set/2026 (165 meses).
# O período é fixo para que os resultados sejam sempre os mesmos. Para mudar, troque
# só estas duas linhas (formato AAAAMM).
INICIO <- "201301"
FIM    <- "202609"
url <- paste0("https://apisidra.ibge.gov.br/values/t/1736/n1/all/v/2289/p/", INICIO, "-", FIM)
sidra <- jsonlite::fromJSON(url)[-1, ]                 # a 1ª linha é o cabeçalho
dados <- data.frame(mes = sidra$D3C, indice = as.numeric(sidra$V))
dados <- dados[order(dados$mes), ]
write.csv(dados, "inpc_lista01.csv", row.names = FALSE)

P  <- ts(dados$indice, start = c(as.integer(substr(INICIO, 1, 4)), as.integer(substr(INICIO, 5, 6))),
         frequency = 12)                                  # índice em nível: P_t
y  <- 100 * log(P)                                           # série modelada: y_t = 100 ln P_t
dy <- diff(y)                                                # Δy_t = y_t - y_{t-1}
# Por que 100·ln? Porque Δy_t = 100(ln P_t - ln P_{t-1}) ≈ 100(P_t - P_{t-1})/P_{t-1}:
# a primeira diferença do log é a inflação mensal em %. O modelo fica em "pontos de %".
cat("T =", length(y), "observações (a lista exige pelo menos 120)\n")


# =====================================================================================
# Q1. INSPEÇÃO GRÁFICA E TRANSFORMAÇÃO
# =====================================================================================
# PERGUNTA. Antes de qualquer teste: como é a série? Há tendência, sazonalidade, quebras,
# outliers? A variância muda com o nível? (se mudar, é preciso transformar)

par(mfrow = c(3, 1), mar = c(3, 4, 2.5, 1))
plot(P, main = "INPC em nível: cresce sem voltar (tendência)", ylab = "índice", xlab = "", col = "navy")
plot(y, main = "100 × ln(INPC): o crescimento exponencial vira quase uma reta", ylab = "y", xlab = "", col = "darkgreen")
abline(lm(y ~ time(y)), lty = 2, col = "grey40")
plot(dy, main = "dy = inflação mensal: oscila em torno de uma média", ylab = "% a.m.", xlab = "", col = "darkred")
abline(h = mean(dy), lty = 2)
text(2021.5, 1.6, "pós-pandemia", pos = 4, cex = 0.8)
par(mfrow = c(1, 1))

# Sazonalidade: para cada mês, a trajetória daquele mês ao longo dos anos e sua média.
monthplot(dy, main = "Inflação por mês do ano (linha horizontal = média do mês)", ylab = "% a.m.")

# Mudanças de inclinação: a inclinação de y é a inflação. A média de Δy em cada ano mostra
# os patamares.
round(tapply(as.numeric(dy), floor(time(dy) + 1e-9), mean), 2)
# Outliers: os maiores e o menor valor de Δy.
round(sort(setNames(as.numeric(dy), format(as.Date(paste0(floor(time(dy) + 1e-9), "-", cycle(dy), "-01")), "%Y-%m")), decreasing = TRUE)[c(1:4, length(dy))], 2)

# LEITURA (Q1a).
# - Tendência: forte no nível (o índice dobra em 13 anos); em log, quase linear.
# - Inclinação: a inclinação de y é a inflação, e ela muda: mais alta até 2016 (pico em
#   2015), baixa em 2017–2020, alta no pós-pandemia (2020–2022), menor depois.
#   São mudanças de inclinação, não de nível.
# - Nível: choques no índice nunca são revertidos.
# - Sazonalidade: invisível no índice, visível em Δy (fev, mar e dez altos, ago baixo).
# - Outliers: os maiores Δy são mar/2022, jan/2016, mar/2015 e fev/2025; o menor é jul/2022
#   (corte de impostos sobre combustíveis). Os choques que o modelo não explica (jun/2018,
#   jul/2022, fev/2025) aparecem nos resíduos padronizados da Q5.
# - Transformação: em 13 anos o gráfico não mostra a variância crescendo com o nível
#   (o índice só dobra), e por isso ele não decide sozinho. Decide a interpretação: com log, Δy é a inflação e o drift é uma TAXA média, que pode ser
#   constante; sem log, o drift seria um aumento em pontos de índice, que cresce com o
#   nível (0,5% vale 19 pontos em 2013 e 39 em 2026). Transformação: log.


# =====================================================================================
# Q2. ORDEM DE INTEGRAÇÃO: QUANTAS DIFERENÇAS (d) E DIFERENÇAS SAZONAIS (D)?
# =====================================================================================
# PERGUNTA. A tendência de y é DETERMINÍSTICA (y_t = a + b t + ruído estacionário: choques
# passam) ou ESTOCÁSTICA (raiz unitária: choques são permanentes)? Isso decide se
# diferenciamos (d = 1) ou não.
#
# FÓRMULA do ADF (Dickey-Fuller aumentado) — regressão auxiliar estimada por MQO:
#   Δy_t = α + β·t + γ·y_{t-1} + δ_1 Δy_{t-1} + ... + δ_k Δy_{t-k} + e_t
#   γ = ρ - 1, onde ρ é o coeficiente de um AR(1) em y. Raiz unitária <=> ρ = 1 <=> γ = 0.
#   As defasagens Δy_{t-i} "limpam" a autocorrelação de e_t; k é escolhido por AIC,
#   até k_max = 12·(T/100)^(1/4) = 13 para T = 165 (regra de Schwert).
# HIPÓTESES  H0: γ = 0 (raiz unitária, tendência estocástica)  vs  H1: γ < 0 (estacionária).
# ESTATÍSTICA τ = γ̂ / ep(γ̂). Sob H0 ela NÃO segue a t de Student: segue a distribuição de
#   Dickey-Fuller, mais deslocada para a esquerda. Críticos de 5%: -1,95 (sem α e β),
#   -2,86 (só α), -3,41 (α e β). Rejeita-se H0 se τ < crítico.
# P-VALORES: o urca só dá críticos; os p-valores vêm das superfícies de MacKinnon
#   (urca::punitroot).

# Defasagem máxima pela regra de Schwert: k_max = 12·(T/100)^(1/4)
kmax <- floor(12 * (length(y) / 100)^(1/4))

# (a) Nível, com constante e tendência
adf_ct <- ur.df(y, type = "trend", lags = kmax, selectlags = "AIC")
summary(adf_ct)
cat(sprintf("ADF (tendência): τ3 = %.3f | crítico 5%% = %.2f | defasagens = %d -> %s\n",
            adf_ct@teststat[1, "tau3"], adf_ct@cval["tau3", "5pct"], sum(grepl("z.diff.lag", rownames(adf_ct@testreg$coefficients))),
            ifelse(adf_ct@teststat[1, "tau3"] < adf_ct@cval["tau3", "5pct"], "rejeita H0 (sem raiz unitária)", "não rejeita H0 (raiz unitária)")))

# PHILLIPS-PERRON: mesma regressão, mas SEM as defasagens Δy_{t-i}. A autocorrelação de
#   e_t é corrigida depois, ajustando τ com uma variância de longo prazo de Newey-West.
#   Vantagem: não depende de escolher k. Mesmas hipóteses e mesma tabela do ADF.
pp_ct <- ur.pp(y, type = "Z-tau", model = "trend", lags = "long")
summary(pp_ct)
cat(sprintf("PP (tendência): Z-τ = %.3f | crítico 5%% = %.2f -> %s\n", pp_ct@teststat, pp_ct@cval[1, "5pct"],
            ifelse(pp_ct@teststat < pp_ct@cval[1, "5pct"], "rejeita H0", "não rejeita H0 (raiz unitária)")))

# KPSS: inverte as hipóteses. Decompõe y_t = β·t + r_t + ε_t, com r_t = r_{t-1} + u_t
#   (passeio aleatório). H0: Var(u) = 0, isto é, y é ESTACIONÁRIA em torno da tendência;
#   H1: há raiz unitária. Estatística: KPSS = Σ S_t² / (T² σ̂²_LP), em que S_t é a soma
#   acumulada dos resíduos da regressão em (1, t). Rejeita-se H0 se KPSS > crítico.
#   Usar ADF e KPSS juntos ajuda: se o ADF não rejeita e o KPSS rejeita, é I(1).
kpss_ct <- ur.kpss(y, type = "tau", lags = "long")
summary(kpss_ct)
cat(sprintf("KPSS (tendência): %.3f | crítico 5%% = %.3f -> %s\n", kpss_ct@teststat, kpss_ct@cval[1, "5pct"],
            ifelse(kpss_ct@teststat > kpss_ct@cval[1, "5pct"], "rejeita H0 (não é estacionária em tendência)", "não rejeita H0")))

# (b) Constante e tendência: as três versões testam coisas diferentes (Mattos, 2019, seção 2.2).
#   versão 3 (α e β): H0 DS (tendência determinística + estocástica) vs H1 TS (só a
#                     determinística): as DUAS hipóteses são não estacionárias;
#   versão 2 (só α):  H0 I(1) sem drift vs H1 estacionária em torno de uma média;
#   versão 1 (nada):  H0 I(1) vs H1 estacionária com média zero.
#   A versão se escolhe pelo GRÁFICO: y cresce, então a versão 3.
adf_c <- ur.df(y, type = "drift", lags = kmax, selectlags = "AIC")   # só constante: τ2
adf_n <- ur.df(y, type = "none",  lags = kmax, selectlags = "AIC")   # nada: τ1
tau <- c(adf_ct@teststat[1, "tau3"], adf_c@teststat[1, "tau2"], adf_n@teststat[1, "tau1"])
round(cbind(tau, critico_5 = c(adf_ct@cval["tau3", "5pct"], adf_c@cval["tau2", "5pct"], adf_n@cval["tau1", "5pct"]),
            p_MacKinnon = c(punitroot(tau[1], trend = "ct"), punitroot(tau[2], trend = "c"), punitroot(tau[3], trend = "nc"))), 3)
# LEITURA (Q2b). Nenhum τ rejeita. Na versão 3, não rejeitar quer dizer: a série é DS. Somando
# Δy_t = α + u_t desde o início, y_t = y_0 + α t + Σ u_j: tendência determinística (α t,
# α = inflação média) mais tendência estocástica (Σ u_j). Sem nada, τ1 sai POSITIVO: o teste
# "vê" a tendência omitida como explosividade.

# (c) A série diferenciada Δy: ela ainda tem raiz unitária? Agora sem tendência
#   (Δy oscila em torno de uma média), só com constante, porque a inflação média ≠ 0.
adf_d <- ur.df(dy, type = "drift", lags = kmax, selectlags = "AIC")
kpss_d <- kpss.test(dy)        # H0: Δy é estacionária em nível
cat(sprintf("Δy: ADF τ2 = %.3f (crítico %.2f) | KPSS p = %.3f -> d = 1\n",
            adf_d@teststat[1, "tau2"], adf_d@cval["tau2", "5pct"], kpss_d$p.value))

# Diferença sazonal: é preciso aplicar (1 - B^12)? Procedimento de Dickey-Miller (Mattos,
#   2019, seção 2.6): pôr 11 dummies sazonais CENTRADAS na regressão do ADF. Elas captam a
#   sazonalidade determinística sem mudar a distribuição de τ (mesmos críticos do ADF).
adf_saz <- function(x, tendencia, pmax = kmax) {
  dx <- diff(x); n <- length(dx); m <- cycle(dx)
  DC <- sapply(1:11, function(j) ifelse(m == j, 1 - 1 / 12, -1 / 12))   # dummies centradas
  colnames(DC) <- paste0("DC", 1:11)
  idx <- (pmax + 1):n
  ajuste <- function(p) {
    X <- cbind(nivel = as.numeric(x)[idx], DC[idx, ])
    if (p > 0) X <- cbind(X, sapply(1:p, function(j) as.numeric(dx)[idx - j]))
    if (tendencia) X <- cbind(X, tt = idx)
    lm(as.numeric(dx)[idx] ~ X)
  }
  p <- which.min(sapply(0:pmax, function(k) BIC(ajuste(k)))) - 1        # defasagens por BIC
  cf <- summary(ajuste(p))$coefficients
  c(tau = cf["Xnivel", "t value"], defasagens = p, dummies_signif = sum(cf[grepl("^XDC", rownames(cf)), 4] < 0.05))
}
round(rbind("y, constante + tendência" = adf_saz(y, TRUE), "Δy, constante" = adf_saz(dy, FALSE)), 3)
acf(dy, lag.max = 48, plot = FALSE)$acf[c(13, 25, 37)]   # FAC de Δy em 12, 24 e 36
# LEITURA (Q2c). Em Δy o ADF rejeita com folga e o KPSS não rejeita: d = 1. Com as dummies,
# nada muda: o nível não rejeita, Δy rejeita, e várias dummies são significativas (a
# sazonalidade é DETERMINÍSTICA). A FAC de Δy em 12, 24 e 36 cai logo (0,22; -0,03; 0,02);
# uma raiz unitária sazonal a faria decair devagar. D = 0.

# (d) DS ou TS? No nível, ADF e PP não rejeitam a raiz unitária, mas o KPSS também não
# rejeita a estacionariedade: pela análise confirmatória, "dados pouco informativos".
# DF-GLS (Mattos, 2019, seção 2.4): tira a tendência por MQG antes do DF e tem mais poder
#   quando a série é muito persistente. O número de defasagens é fixado antes: o do ADF por BIC.
k_bic <- sum(grepl("z.diff.lag", rownames(ur.df(y, type = "trend", lags = kmax, selectlags = "BIC")@testreg$coefficients)))
gls <- ur.ers(y, type = "DF-GLS", model = "trend", lag.max = max(1, k_bic))
cat(sprintf("DF-GLS: %.3f | crítico 5%% = %.2f\n", gls@teststat, gls@cval[1, "5pct"]))
# Adota-se tendência estocástica (d = 1):
# (i) todos os testes de raiz unitária (ADF com e sem dummies, PP, DF-GLS) apontam DS;
# (ii) o KPSS tem pouco poder em amostra curta com janela de Newey-West longa;
# (iii) sob metas de inflação o nível de preços não volta a uma trajetória fixa;
# (iv) na Q5 o MA acrescentado a Δy fica longe de -1 — se a série fosse TS, diferenciar
#      criaria um MA com raiz unitária.
# Robustez: com a série longa (2000–2026) o ADF rejeita, mas PP não e o KPSS rejeita a
# estacionariedade; os anos a mais trazem a crise de 2002–03, que os testes confundem
# com tendência. A decisão d = 1 não muda, e a Q5 mostra que, na janela de 13 anos, os
# parâmetros são estáveis (Chow e CUSUM).


# =====================================================================================
# Q3. IDENTIFICAÇÃO: FAC E FACP DE Δy
# =====================================================================================
# PERGUNTA. Que estrutura ARMA está por trás de Δy?
# FÓRMULAS.
#   FAC:  ρ_k = Cov(Δy_t, Δy_{t-k}) / Var(Δy_t)           ("memória total" até k)
#   FACP: φ_kk = último coeficiente de um AR(k) ajustado     ("memória líquida" em k,
#         descontadas as defasagens intermediárias)
#   Banda de 95% sob H0: ρ_k = 0  ->  ±1,96/√T
# PADRÕES (a "assinatura" de cada processo):
#   AR(p): FACP corta após p, FAC decai.   MA(q): FAC corta após q, FACP decai.
#   Sazonais: o mesmo, mas nas defasagens 12, 24, 36...
#   Pico em 11 e 13 junto do pico em 12: termo cruzado de um modelo multiplicativo.
tsdisplay(dy, lag.max = 48, main = "Inflação mensal (dy): FAC e FACP com 48 defasagens")
fac  <- acf(dy, lag.max = 48, plot = FALSE)$acf[-1]
facp <- pacf(dy, lag.max = 48, plot = FALSE)$acf
round(data.frame(defasagem = c(1, 2, 3, 11, 12, 13, 24, 36), FAC = fac[c(1, 2, 3, 11, 12, 13, 24, 36)],
                 FACP = facp[c(1, 2, 3, 11, 12, 13, 24, 36)]), 3)
cat(sprintf("Banda de 95%%: ±%.3f\n", 1.96 / sqrt(length(dy))))
# LEITURA (Q3b).
# - FACP: φ11 = 0,52; φ22 = 0,15 fica NO LIMITE da banda (±0,15); depois tudo dentro.
#   Leitura principal: AR(1) regular; alternativa: AR(2).
# - FAC: 0,52; 0,38; 0,18... decai, mas mais devagar que 0,52^k: reforça o AR(2) como
#   alternativa.
# - Defasagem 12: FAC = 0,22, acima da banda; FACP = 0,11, dentro. Em 24 e 36 some.
#   Sazonalidade fraca (só 13 repetições de cada mês): cabe um SAR(1) ou um SMA(1).
# (c) Três candidatos para y (d = 1, D = 0, com drift = inflação média):
#   C1 = SARIMA(1,1,0)(1,0,0)12   C2 = SARIMA(1,1,0)(0,0,1)12   C3 = SARIMA(2,1,0)(1,0,0)12


# =====================================================================================
# Q4. ESTIMAÇÃO POR MÁXIMA VEROSSIMILHANÇA E SELEÇÃO
# =====================================================================================
# MODELO C1, escrito por extenso:
#   (1 - φ B)(1 - Φ B^12)(Δy_t - μ) = a_t,   a_t ~ RB(0, σ²)
#   B é o operador defasagem (B·y_t = y_{t-1}); μ é a inflação média ("drift" de y).
#   C2 troca o SAR por um SMA: (1 - φ B)(Δy_t - μ) = (1 + Θ B^12) a_t (convenção do R,
#   MA com sinal +). C3 acrescenta φ2 B² ao polinômio AR de C1.
# ESTIMAÇÃO. Máxima verossimilhança EXATA: o filtro de Kalman escreve
#   ln L = -½ Σ_t [ ln(2π F_t) + v_t² / F_t ]
#   com v_t = erro de previsão um passo à frente e F_t = sua variância.
#   Não se condiciona nos valores iniciais.
C1 <- Arima(y, order = c(1, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
C2 <- Arima(y, order = c(1, 1, 0), seasonal = c(0, 0, 1), include.drift = TRUE, method = "ML")
C3 <- Arima(y, order = c(2, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
coeftest(C1); coeftest(C2); coeftest(C3)     # z = coef/ep, p-valor pela normal

# CRITÉRIOS DE INFORMAÇÃO (k = coeficientes + 1, porque σ² também é estimado):
#   AIC = -2 ln L + 2k          (penalidade fixa por parâmetro)
#   BIC = -2 ln L + k ln n      (penalidade cresce com n: ln 164 ≈ 5,1)
#   Menor é melhor. Só são comparáveis com a mesma variável e a mesma amostra efetiva.
tabela <- rbind(C1 = c(C1$nobs, C1$sigma2, C1$loglik, C1$aic, C1$bic),
                C2 = c(C2$nobs, C2$sigma2, C2$loglik, C2$aic, C2$bic),
                C3 = c(C3$nobs, C3$sigma2, C3$loglik, C3$aic, C3$bic))
colnames(tabela) <- c("n_efetivo", "sigma2", "logLik", "AIC", "BIC")
round(tabela, 3)
sel_aic <- rownames(tabela)[which.min(tabela[, "AIC"])]
sel_bic <- rownames(tabela)[which.min(tabela[, "BIC"])]
dAIC <- tabela[sel_bic, "AIC"] - min(tabela[, "AIC"])
cat("AIC escolhe:", sel_aic, "| BIC escolhe:", sel_bic, sprintf("| ΔAIC do modelo do BIC = %.2f\n", dAIC))

# (e) REGRA DE ESCOLHA, fixada antes de olhar a validação (Q7), pelo princípio da parcimônia
#   (aula 02): se AIC e BIC divergem, fica o modelo menor quando o parâmetro extra do maior
#   não é significativo a 5%. Aqui o extra é o φ2 do C3.
p_ar2 <- coeftest(C3)["ar2", 4]
escolhido <- if (sel_aic != sel_bic && p_ar2 > 0.05) sel_bic else sel_aic
modelo <- get(escolhido)
cat(sprintf("p do φ2 no C3 = %.3f | modelo escolhido: %s\n", p_ar2, escolhido))

# (d) Conferência: o R inclui σ² em k?
cat(sprintf("AIC à mão com k = coeficientes + 1: %.4f | AIC do R: %.4f\n",
            -2 * modelo$loglik + 2 * (length(coef(modelo)) + 1), modelo$aic))

# (f) Raízes. Estacionariedade: raízes de (1 - φz)(1 - Φz^12) = 0 fora do círculo
# unitário (|z| > 1). O gráfico mostra as raízes INVERSAS (1/z), que precisam ficar
# DENTRO do círculo.
plot(modelo)
# LEITURA (Q4).
# - (b)(c) n = T - d - s·D = 165 - 1 - 0 = 164 nos três; a mesma variável e o mesmo d, D:
#   a comparação por AIC/BIC é válida.
# - (e) O AIC escolhe C3 e o BIC escolhe C1. O BIC é CONSISTENTE: escolhe o modelo
#   verdadeiro com probabilidade -> 1, se ele estiver entre os candidatos. O AIC é
#   EFICIENTE para previsão. Mas a vantagem de C3 no AIC é de 0,5 ponto e vem de um φ2
#   não significativo (p = 0,11): fica C1, o mais parcimonioso.
# - (f) Todas as raízes inversas estão dentro do círculo: a regular é φ ≈ 0,51, e as 12
#   sazonais têm módulo Φ^(1/12) ≈ 0,87 (um Φ pequeno vira raízes inversas de módulo alto).


# =====================================================================================
# Q5. DIAGNÓSTICO: OS RESÍDUOS SÃO RUÍDO BRANCO?
# =====================================================================================
e <- residuals(modelo)
checkresiduals(modelo, lag = 24)    # resíduos no tempo, FAC, histograma e Ljung-Box
qqnorm(e, main = "QQ-plot dos resíduos: as caudas fogem da reta"); qqline(e, col = "red")

# LJUNG-BOX. FÓRMULA: Q(K) = T(T+2) Σ_{j=1..K} ρ̂_j² / (T - j).
#   H0: ρ_1 = ... = ρ_K = 0 nos resíduos. Sob H0, Q ~ χ² com ν = K - (p+q+P+Q) graus de
#   liberdade: cada parâmetro ARMA estimado "gasta" um grau. No C1, p + P = 2: ν = 24 - 2 = 22.
n_arma <- sum(modelo$arma[1:4])
lb <- Box.test(e, lag = 24, type = "Ljung-Box", fitdf = n_arma)
# JARQUE-BERA. FÓRMULA: JB = (T/6)·[S² + (K-3)²/4], com S = assimetria e K = curtose.
#   H0: normalidade (S = 0 e K = 3). Sob H0, JB ~ χ²(2).
jb <- jarque.bera.test(e)
# ARCH-LM (Engle). Regressão auxiliar: e_t² = α0 + α1 e²_{t-1} + ... + α12 e²_{t-12} + u_t.
#   H0: α1 = ... = α12 = 0 (variância condicional constante). Estatística: T·R² ~ χ²(12).
arch <- ArchTest(e, lags = 12)
cat(sprintf("Ljung-Box(24, gl = %d): Q = %.2f, p = %.3f -> %s\n", 24 - n_arma, lb$statistic, lb$p.value,
            ifelse(lb$p.value < 0.05, "autocorrelação nos resíduos", "resíduos sem autocorrelação")))
cat(sprintf("Jarque-Bera: JB = %.1f, p = %.4f -> %s\n", jb$statistic, jb$p.value,
            ifelse(jb$p.value < 0.05, "rejeita a normalidade", "normalidade não rejeitada")))
cat(sprintf("ARCH-LM(12): LM = %.2f, p = %.3f -> %s\n", arch$statistic, arch$p.value,
            ifelse(arch$p.value < 0.05, "há efeito ARCH", "sem efeito ARCH")))
# LEITURA (Q5). Os resíduos são ruído branco e sem ARCH. A normalidade falha por caudas
# (curtose ≈ 4,4), vindas dos choques de jun/2018, jul/2022 e fev/2025. Isso afeta os
# intervalos de previsão, mas não a consistência dos estimadores.
# (d) Os modelos sem o AR(1) deixam autocorrelação nos resíduos (Ljung-Box rejeita) e foram
# descartados. Exemplo:
sem_ar <- Arima(y, order = c(0, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
cat(sprintf("Sem o AR(1): Ljung-Box(24) p = %.4f -> descartado\n",
            Box.test(residuals(sem_ar), lag = 24, type = "Ljung-Box", fitdf = 1)$p.value))

# ESTABILIDADE (aula 03). Chow e CUSUM pedem MQO: usa-se a forma autorregressiva do C1,
#   Δy_t em Δy_{t-1}, Δy_{t-12} e Δy_{t-13} (o produto (1 - φB)(1 - ΦB^12)).
#   Chow: data de quebra escolhida ANTES de olhar os dados (mar/2020, a pandemia).
#   CUSUM: soma acumulada dos resíduos recursivos; sai das bandas se os coeficientes mudam.
#   CUSUM-Q: soma acumulada dos quadrados; sai das bandas se a variância muda.
dyv <- as.numeric(dy); nn <- length(dyv)
df_ols <- data.frame(dy = dyv[14:nn], l1 = dyv[13:(nn - 1)], l12 = dyv[2:(nn - 12)], l13 = dyv[1:(nn - 13)])
TB <- which(abs(time(dy)[14:nn] - (2020 + 2 / 12)) < 1e-6)
sctest(dy ~ ., data = df_ols, type = "Chow", point = TB - 1)
cusum <- efp(dy ~ ., data = df_ols, type = "Rec-CUSUM")
sctest(cusum)
w <- recresid(lm(dy ~ ., data = df_ols))
desvio_q <- max(abs(cumsum(w^2) / sum(w^2) - seq_along(w) / length(w)))
cat(sprintf("CUSUM-Q: maior desvio = %.3f | crítico 5%% ≈ %.3f\n", desvio_q, 1.36 / sqrt(length(w) / 2)))
plot(cusum, main = "CUSUM dos resíduos recursivos (bandas de 5%)")
# LEITURA. Chow p = 0,77, CUSUM p = 0,37 e o CUSUM-Q fica dentro da banda: os parâmetros são
# estáveis na janela de 13 anos.

# (e) SOBREAJUSTE. Se o modelo está certo, um parâmetro a mais deve sair não significativo.
sobre_ar <- Arima(y, order = c(2, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
sobre_ma <- Arima(y, order = c(1, 1, 1), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
rbind("ar2 extra" = coeftest(sobre_ar)["ar2", ], "ma1 extra" = coeftest(sobre_ma)["ma1", ])
# LEITURA. Nenhum dos dois é significativo (p = 0,11 e 0,17): não falta dinâmica, e C1 é
# adequado. O MA extra (-0,17) fica longe de -1: Δy não foi sobrediferenciada (volta à Q2d).


# =====================================================================================
# Q6. SOBREDIFERENCIAÇÃO: E SE TIVÉSSEMOS USADO d = 2?
# =====================================================================================
# TEORIA. Se y é I(1) com φ(B)Δy_t = θ(B)a_t, diferenciar de novo dá
#   φ(B) Δ²y_t = (1 - B) θ(B) a_t:
# o fator (1 - B) aparece no MA. É uma raiz MA em z = 1, sobre o círculo: o modelo deixa
# de ser invertível. No R, isso aparece como θ̂ ≈ -1.
D2  <- Arima(y, order = c(1, 2, 0), seasonal = c(1, 0, 0), method = "ML")   # mesmas ordens
D2m <- Arima(y, order = c(1, 2, 1), seasonal = c(1, 0, 0), method = "ML")   # com um MA(1) a mais
coeftest(D2m)
raiz_ma <- abs(polyroot(c(1, coef(D2m)["ma1"])))
cat(sprintf("θ̂ = %.4f | raiz do MA = %.4f (sobre o círculo se ≈ 1)\n", coef(D2m)["ma1"], raiz_ma))
cat(sprintf("σ² com d = 1: %.4f | d = 2: %.4f (+%.1f%%) | d = 2 com MA: %.4f\n",
            modelo$sigma2, D2$sigma2, 100 * (D2$sigma2 / modelo$sigma2 - 1), D2m$sigma2))
cat(sprintf("ρ1 de Δ²y = %.3f | teórico -(1-φ)/2 = %.3f | AR com d = 2: %.3f\n",
            acf(diff(dy), plot = FALSE)$acf[2], -(1 - coef(modelo)["ar1"]) / 2, coef(D2)["ar1"]))
par(mfrow = c(1, 2))
acf(as.numeric(residuals(modelo)), lag.max = 24, main = "FAC dos resíduos, d = 1", xlab = "defasagem (meses)")
acf(as.numeric(residuals(D2)), lag.max = 24, main = "FAC dos resíduos, d = 2", xlab = "defasagem (meses)")
par(mfrow = c(1, 1))
# LEITURA (Q6).
# - (a) θ̂ ≈ -1, com raiz MA = 1: não invertível.
# - (b) σ² sobe com a diferença extra.
# - (c) A série Δ²y tem ρ1 negativo (-0,34), na ordem do teórico (-0,25); no modelo, o AR
#   troca de sinal (+0,51 -> -0,35) para absorvê-lo, e sobram correlações negativas em 2 e 3.
# - (d) Sinais práticos de sobrediferenciação: MA ≈ -1, AR que troca de sinal,
#   ρ1 ≈ -0,5 na série diferenciada, variância residual maior.


# =====================================================================================
# Q7. PREVISÃO FORA DA AMOSTRA: O MODELO PREVÊ MELHOR QUE REGRAS INGÊNUAS?
# =====================================================================================
# DESENHO. Treino: até T0 = T - 24. Validação: os 24 últimos meses (H = 24). As métricas
# são calculadas no índice P = exp(y/100), com e_t = P_t - P̂_t:
#   RMSE = √(média de e²)   MAE = média de |e|   MAPE = 100 × média de |e / P|
T0 <- length(y) - 24
y_treino <- window(y, end = time(y)[T0])
P_treino <- window(P, end = time(P)[T0])
P_teste  <- window(P, start = time(P)[T0 + 1])
fit <- Arima(y_treino, order = modelo$arma[c(1, 6, 2)], seasonal = modelo$arma[c(3, 7, 4)],
             include.drift = TRUE, method = "ML")       # o modelo escolhido, só com o treino

# ESQUEMA 1 (origem fixa): de T0, prever h = 1, ..., 24 de uma vez.
#   Previsão = E(y_{T0+h} | dados até T0). IC de 95% = previsão ± 1,96 √Var(erro_h), com
#   Var(erro_h) = σ² (1 + ψ1² + ... + ψ²_{h-1}): o intervalo se abre com h.
prev1 <- forecast(fit, h = 24, level = 95)
# ESQUEMA 2 (origem móvel, um passo): a cada mês, prever só o próximo com os coeficientes
#   do treino (sem reestimar), usando o dado observado até ali.
prev2 <- window(fitted(Arima(y, model = fit)), start = time(y)[T0 + 1])

# BENCHMARKS: passeio aleatório (P̂_{t+h} = P_t) e sazonal ingênuo (P̂_{t+h} = P_{t+h-12})
rw1 <- naive(P_treino, h = 24)$mean
sn1 <- snaive(P_treino, h = 24)$mean
rw2 <- window(stats::lag(P, -1),  start = start(P_teste), end = end(P_teste))
sn2 <- window(stats::lag(P, -12), start = start(P_teste), end = end(P_teste))

m <- c("RMSE", "MAE", "MAPE")
round(rbind("SARIMA, esquema 1"            = accuracy(exp(prev1$mean / 100), P_teste)[, m],
            "SARIMA, esquema 2"            = accuracy(exp(prev2 / 100), P_teste)[, m],
            "Passeio aleatório, esquema 1" = accuracy(rw1, P_teste)[, m],
            "Passeio aleatório, esquema 2" = accuracy(rw2, P_teste)[, m],
            "Sazonal ingênuo, esquema 1"   = accuracy(sn1, P_teste)[, m],
            "Sazonal ingênuo, esquema 2"   = accuracy(sn2, P_teste)[, m]), 3)

# (g) Cobertura: que fração dos 24 valores caiu dentro do IC de 95% do esquema 1?
li <- exp(prev1$lower / 100); ls <- exp(prev1$upper / 100)
cobertura <- mean(P_teste >= li & P_teste <= ls)

# Gráfico do esquema 1 no índice, com os benchmarks e a cobertura no título
janela <- window(P, start = c(2022, 1))
plot(janela, xlim = range(time(janela)), ylim = range(janela, li, ls, sn1), lwd = 2, xlab = "", ylab = "INPC",
     main = sprintf("Esquema 1: previsão de 24 meses com IC de 95%% (cobertura = %.0f%%)", 100 * cobertura))
polygon(c(time(li), rev(time(li))), c(li, rev(ls)), col = rgb(0, 0.5, 0.5, 0.2), border = NA)
lines(exp(prev1$mean / 100), col = "darkcyan", lwd = 2)
lines(rw1, col = "red", lty = 2); lines(sn1, col = "orange", lty = 2)
lines(exp(prev2 / 100), type = "p", pch = 19, cex = 0.6, col = "darkgreen")
abline(v = time(P)[T0], lty = 3)
legend("topleft", c("observado", "SARIMA esquema 1 (IC 95%)", "SARIMA esquema 2", "passeio aleatório", "sazonal ingênuo"),
       col = c("black", "darkcyan", "darkgreen", "red", "orange"), lty = c(1, 1, NA, 2, 2), pch = c(NA, NA, 19, NA, NA),
       lwd = 2, bty = "n", cex = 0.8)
cat(sprintf("Cobertura empírica do IC de 95%%: %.0f%% (%d de 24)\n", 100 * cobertura, sum(P_teste >= li & P_teste <= ls)))
# LEITURA (Q7).
# - (f) O SARIMA supera os dois benchmarks nos dois esquemas. O sazonal ingênuo vai mal no
#   índice porque repete o nível de 12 meses antes, sem a inflação do ano. O modelo não
#   foi alterado em função do resultado (a regra de escolha da Q4e veio antes).
# - (g) A cobertura (100%) fica acima da nominal: o IC de um modelo integrado se abre com h,
#   e os 24 erros de uma única origem são correlacionados entre si.

writeLines(capture.output(sessionInfo()), "sessionInfo_lista01.txt")

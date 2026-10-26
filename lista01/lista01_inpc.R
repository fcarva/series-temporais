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
pacotes <- c("jsonlite", "forecast", "tseries", "urca", "lmtest", "FinTS")
novos <- pacotes[!pacotes %in% rownames(installed.packages())]
if (length(novos)) install.packages(novos, repos = "https://cloud.r-project.org")
library(forecast)   # Arima, forecast, accuracy, checkresiduals, ndiffs, nsdiffs
library(tseries)    # jarque.bera.test, kpss.test
library(urca)       # ur.df, ur.pp, ur.kpss (mostram a regressão auxiliar inteira)
library(lmtest)     # coeftest
library(FinTS)      # ArchTest

# ---- Dados ----------------------------------------------------------------------------
# INPC/IBGE, número-índice (dez/1993 = 100), mensal, jan/2000 a set/2026.
# O período é fixo para que os resultados sejam sempre os mesmos.
url <- "https://apisidra.ibge.gov.br/values/t/1736/n1/all/v/2289/p/200001-202609"
sidra <- jsonlite::fromJSON(url)[-1, ]                 # a 1ª linha é o cabeçalho
dados <- data.frame(mes = sidra$D3C, indice = as.numeric(sidra$V))
dados <- dados[order(dados$mes), ]
write.csv(dados, "inpc_lista01.csv", row.names = FALSE)

P  <- ts(dados$indice, start = c(2000, 1), frequency = 12)  # índice em nível: P_t
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
plot(dy, main = "dy = inflação mensal: oscila em torno de uma média fixa", ylab = "% a.m.", xlab = "", col = "darkred")
abline(h = mean(dy), lty = 2)
text(2003, 3, "crise de 2002", pos = 4, cex = 0.8)
par(mfrow = c(1, 1))

# Sazonalidade: para cada mês, a trajetória daquele mês ao longo dos anos e sua média.
monthplot(dy, main = "Inflação por mês do ano (linha horizontal = média do mês)", ylab = "% a.m.")

# Transformação de Box-Cox:
#   FÓRMULA   y(λ) = (P^λ - 1)/λ  se λ ≠ 0;   y(0) = ln P.
#   IDEIA     escolher λ de modo que a variância deixe de depender do nível.
#             λ = 1 é não transformar; λ = 0 é o log.
#   ESTIMADOR Guerrero (1993): o λ que torna constante o coeficiente de variação
#             (desvio-padrão / média) entre subperíodos.
lambda <- BoxCox.lambda(P)
cat(sprintf("λ de Box-Cox (Guerrero) = %.2f -> %s\n", lambda,
            ifelse(abs(lambda) < abs(lambda - 1), "mais perto de 0: usar log", "mais perto de 1: não transformar")))

# LEITURA (Q1a).
# - Tendência: forte e exponencial no nível; em log, quase linear.
# - Inclinação: a inclinação de y é a inflação; é maior em 2000–2003 (crise cambial)
#   do que depois. É uma mudança de inclinação, não de nível.
# - Nível: choques no índice nunca são revertidos.
# - Sazonalidade: invisível no índice, clara em Δy (jan e dez altos, ago baixo).
# - Outliers: picos de Δy em nov/2002, jun/2018 (greve dos caminhoneiros),
#   jul/2022 (corte de impostos) e fev/2025 (fim do bônus de Itaipu).
# - Dispersão: cresce com o nível. O λ fica perto de 0, e o log também dá à diferença
#   o sentido de taxa de inflação. Transformação: log.


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
#   até k_max = 12·(T/100)^(1/4) = 16 (regra de Schwert).
# HIPÓTESES  H0: γ = 0 (raiz unitária, tendência estocástica)  vs  H1: γ < 0 (estacionária).
# ESTATÍSTICA τ = γ̂ / ep(γ̂). Sob H0 ela NÃO segue a t de Student: segue a distribuição de
#   Dickey-Fuller, mais deslocada para a esquerda. Críticos de 5%: -1,95 (sem α e β),
#   -2,86 (só α), -3,41 (α e β). Rejeita-se H0 se τ < crítico.
# TESTES CONJUNTOS (estatísticas F com tabelas próprias):
#   φ3: H0: β = γ = 0 (sem tendência e com raiz unitária)
#   φ2: H0: α = β = γ = 0;   φ1 (modelo só com constante): H0: α = γ = 0

# (a) Nível, com constante e tendência
adf_ct <- ur.df(y, type = "trend", lags = 16, selectlags = "AIC")
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

# (b) Constante e tendência: por que incluir? Sob H1 (estacionária), uma série que sobe
#   por 26 anos só pode ser estacionária EM TORNO DE UMA TENDÊNCIA; sem β, o teste
#   confunde a tendência com a raiz unitária e perde poder. O φ3 diz se a tendência
#   importa. Vejamos como a conclusão muda nas outras duas especificações:
adf_c <- ur.df(y, type = "drift", lags = 16, selectlags = "AIC")   # só constante: τ2, φ1
adf_n <- ur.df(y, type = "none",  lags = 16, selectlags = "AIC")   # nada: τ1
round(rbind("constante + tendência" = c(tau = adf_ct@teststat[1, "tau3"], critico = adf_ct@cval["tau3", "5pct"], phi = adf_ct@teststat[1, "phi3"], critico_phi = adf_ct@cval["phi3", "5pct"]),
            "só constante"          = c(adf_c@teststat[1, "tau2"], adf_c@cval["tau2", "5pct"], adf_c@teststat[1, "phi1"], adf_c@cval["phi1", "5pct"]),
            "nenhum"                = c(adf_n@teststat[1, "tau1"], adf_n@cval["tau1", "5pct"], NA, NA)), 3)
# LEITURA (Q2b). φ3 > crítico: a tendência importa, e o caso certo é o com constante e
# tendência. Só com constante, τ2 não rejeita; sem nada, τ1 sai POSITIVO — o teste "vê" a
# tendência omitida como explosividade. A especificação muda a conclusão.

# (c) A série diferenciada Δy: ela ainda tem raiz unitária? Agora sem tendência
#   (Δy oscila em torno de uma média), só com constante, porque a inflação média ≠ 0.
adf_d <- ur.df(dy, type = "drift", lags = 16, selectlags = "AIC")
kpss_d <- kpss.test(dy)        # H0: Δy é estacionária em nível
cat(sprintf("Δy: ADF τ2 = %.3f (crítico %.2f) | KPSS p = %.3f -> d = 1\n",
            adf_d@teststat[1, "tau2"], adf_d@cval["tau2", "5pct"], kpss_d$p.value))
cat("ndiffs (quantas diferenças o KPSS sequencial pede):", ndiffs(y), "\n")

# Diferença sazonal: é preciso aplicar (1 - B^12)?
#   OCSB (Osborn-Chui-Smith-Birchenhall): regressão de Δ12 Δy em defasagens; H0: raiz
#   unitária sazonal (precisa de 1 - B^12). nsdiffs devolve 1 se rejeitar a estacionariedade
#   sazonal, 0 caso contrário.
cat("nsdiffs (OCSB): D =", nsdiffs(y, test = "ocsb"), "\n")
# LEITURA (Q2c). Em Δy o ADF rejeita com folga e o KPSS não rejeita: d = 1. O OCSB não pede
# diferença sazonal: D = 0. A sazonalidade é DETERMINÍSTICA (médias mensais fixas), e não um
# passeio aleatório sazonal.

# (d) DS ou TS? No nível, os testes discordam: o ADF com 13 defasagens rejeita, mas o PP
# não rejeita e o KPSS rejeita a estacionariedade. Adota-se tendência estocástica (d = 1):
# (i) a rejeição do ADF depende do número de defasagens; (ii) PP e KPSS apontam raiz
# unitária; (iii) sob metas de inflação o nível de preços não volta a uma trajetória fixa;
# (iv) na Q5 o MA acrescentado a Δy fica longe de -1 — se a série fosse TS, diferenciar
# criaria um MA com raiz unitária.


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
# - FACP: φ11 = 0,63 e depois tudo dentro da banda -> corta em 1: AR(1) regular.
# - FAC: 0,63; 0,42; 0,25... decai geometricamente (≈ 0,63^k), como num AR(1).
# - Defasagem 12: pico na FAC e na FACP; em 24 e 36 já some. Cabe um SAR(1) (decaimento
#   rápido) ou um SMA(1) (corte em 12). FACP negativa em 13: estrutura multiplicativa.
# (c) Três candidatos para y (d = 1, D = 0, com drift = inflação média):
#   C1 = SARIMA(1,1,0)(1,0,0)12   C2 = SARIMA(1,1,0)(0,0,1)12   C3 = SARIMA(1,1,0)(1,0,1)12


# =====================================================================================
# Q4. ESTIMAÇÃO POR MÁXIMA VEROSSIMILHANÇA E SELEÇÃO
# =====================================================================================
# MODELO C3, escrito por extenso (convenção do R, MA com sinal +):
#   (1 - φ B)(1 - Φ B^12)(Δy_t - μ) = (1 + Θ B^12) a_t,   a_t ~ RB(0, σ²)
#   B é o operador defasagem (B·y_t = y_{t-1}); μ é a inflação média ("drift" de y).
# ESTIMAÇÃO. Máxima verossimilhança EXATA: o filtro de Kalman escreve
#   ln L = -½ Σ_t [ ln(2π F_t) + v_t² / F_t ]
#   com v_t = erro de previsão um passo à frente e F_t = sua variância.
#   Não se condiciona nos valores iniciais.
C1 <- Arima(y, order = c(1, 1, 0), seasonal = c(1, 0, 0), include.drift = TRUE, method = "ML")
C2 <- Arima(y, order = c(1, 1, 0), seasonal = c(0, 0, 1), include.drift = TRUE, method = "ML")
C3 <- Arima(y, order = c(1, 1, 0), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML")
coeftest(C1); coeftest(C2); coeftest(C3)     # z = coef/ep, p-valor pela normal

# CRITÉRIOS DE INFORMAÇÃO (k = coeficientes + 1, porque σ² também é estimado):
#   AIC = -2 ln L + 2k          (penalidade fixa por parâmetro)
#   BIC = -2 ln L + k ln n      (penalidade cresce com n: ln 320 ≈ 5,8)
#   Menor é melhor. Só são comparáveis com a mesma variável e a mesma amostra efetiva.
tabela <- rbind(C1 = c(C1$nobs, C1$sigma2, C1$loglik, C1$aic, C1$bic),
                C2 = c(C2$nobs, C2$sigma2, C2$loglik, C2$aic, C2$bic),
                C3 = c(C3$nobs, C3$sigma2, C3$loglik, C3$aic, C3$bic))
colnames(tabela) <- c("n_efetivo", "sigma2", "logLik", "AIC", "BIC")
round(tabela, 3)
cat("AIC escolhe:", rownames(tabela)[which.min(tabela[, "AIC"])],
    "| BIC escolhe:", rownames(tabela)[which.min(tabela[, "BIC"])], "\n")

# (d) Conferência: o R inclui σ² em k?
cat(sprintf("AIC à mão com k = coeficientes + 1: %.4f | AIC do R: %.4f\n",
            -2 * C3$loglik + 2 * (length(coef(C3)) + 1), C3$aic))

# (f) Raízes. Estacionariedade: raízes de (1 - φz)(1 - Φz^12) = 0 fora do círculo
# unitário (|z| > 1). Invertibilidade: raízes de (1 + Θz^12) = 0 fora também. O gráfico
# mostra as raízes INVERSAS (1/z), que precisam ficar DENTRO do círculo.
plot(C3)
# LEITURA (Q4).
# - (b)(c) n = T - d - s·D = 321 - 1 - 0 = 320 nos três; a mesma variável e o mesmo d, D:
#   a comparação por AIC/BIC é válida.
# - (e) O AIC escolhe C3 e o BIC escolhe C1. O BIC é CONSISTENTE: escolhe o modelo
#   verdadeiro com probabilidade -> 1, se ele estiver entre os candidatos. O AIC é
#   EFICIENTE para previsão. O objetivo da Q7 é prever, então fica C3.
# - (f) Todas as raízes inversas estão dentro do círculo. As sazonais do AR e do MA quase
#   se sobrepõem perto da borda (Φ ≈ 0,82 e Θ ≈ -0,68): o par aproxima uma sazonalidade fixa.


# =====================================================================================
# Q5. DIAGNÓSTICO: OS RESÍDUOS SÃO RUÍDO BRANCO?
# =====================================================================================
e <- residuals(C3)
checkresiduals(C3, lag = 24)    # resíduos no tempo, FAC, histograma e Ljung-Box
qqnorm(e, main = "QQ-plot dos resíduos: as caudas fogem da reta"); qqline(e, col = "red")

# LJUNG-BOX. FÓRMULA: Q(K) = T(T+2) Σ_{j=1..K} ρ̂_j² / (T - j).
#   H0: ρ_1 = ... = ρ_K = 0 nos resíduos. Sob H0, Q ~ χ² com ν = K - (p+q+P+Q) graus de
#   liberdade: cada parâmetro ARMA estimado "gasta" um grau. Aqui ν = 24 - 3 = 21.
lb <- Box.test(e, lag = 24, type = "Ljung-Box", fitdf = 3)
# JARQUE-BERA. FÓRMULA: JB = (T/6)·[S² + (K-3)²/4], com S = assimetria e K = curtose.
#   H0: normalidade (S = 0 e K = 3). Sob H0, JB ~ χ²(2).
jb <- jarque.bera.test(e)
# ARCH-LM (Engle). Regressão auxiliar: e_t² = α0 + α1 e²_{t-1} + ... + α12 e²_{t-12} + u_t.
#   H0: α1 = ... = α12 = 0 (variância condicional constante). Estatística: T·R² ~ χ²(12).
arch <- ArchTest(e, lags = 12)
cat(sprintf("Ljung-Box(24, gl = 21): Q = %.2f, p = %.3f -> %s\n", lb$statistic, lb$p.value,
            ifelse(lb$p.value < 0.05, "autocorrelação nos resíduos", "resíduos sem autocorrelação")))
cat(sprintf("Jarque-Bera: JB = %.1f, p = %.4f -> %s\n", jb$statistic, jb$p.value,
            ifelse(jb$p.value < 0.05, "rejeita a normalidade", "normalidade não rejeitada")))
cat(sprintf("ARCH-LM(12): LM = %.2f, p = %.3f -> %s\n", arch$statistic, arch$p.value,
            ifelse(arch$p.value < 0.05, "há efeito ARCH", "sem efeito ARCH")))
# LEITURA (Q5). Os resíduos são ruído branco e sem ARCH. A normalidade falha por caudas
# pesadas (curtose ≈ 8), vindas dos choques de 2002, 2018, 2022 e 2025. Isso afeta os
# intervalos de previsão, mas não a consistência dos estimadores.
# (d) Os modelos sem o AR(1) deixam autocorrelação nos resíduos (Ljung-Box rejeita) e foram
# descartados.

# (e) SOBREAJUSTE. Se o modelo está certo, um parâmetro a mais deve sair não significativo.
sobre_ar <- Arima(y, order = c(2, 1, 0), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML")
sobre_ma <- Arima(y, order = c(1, 1, 1), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML")
rbind("ar2 extra" = coeftest(sobre_ar)["ar2", ], "ma1 extra" = coeftest(sobre_ma)["ma1", ])
# LEITURA. Nenhum dos dois é significativo (p ≈ 0,5): não falta dinâmica, e C3 é adequado.
# O MA extra fica perto de 0, longe de -1: Δy não foi sobrediferenciada (volta à Q2d).


# =====================================================================================
# Q6. SOBREDIFERENCIAÇÃO: E SE TIVÉSSEMOS USADO d = 2?
# =====================================================================================
# TEORIA. Se y é I(1) com φ(B)Δy_t = θ(B)a_t, diferenciar de novo dá
#   φ(B) Δ²y_t = (1 - B) θ(B) a_t:
# o fator (1 - B) aparece no MA. É uma raiz MA em z = 1, sobre o círculo: o modelo deixa
# de ser invertível. No R, isso aparece como θ̂ ≈ -1.
D2  <- Arima(y, order = c(1, 2, 0), seasonal = c(1, 0, 1), method = "ML")   # mesmas ordens
D2m <- Arima(y, order = c(1, 2, 1), seasonal = c(1, 0, 1), method = "ML")   # com um MA(1) a mais
coeftest(D2m)
raiz_ma <- abs(polyroot(c(1, coef(D2m)["ma1"])))
cat(sprintf("θ̂ = %.4f | raiz do MA = %.4f (sobre o círculo se ≈ 1)\n", coef(D2m)["ma1"], raiz_ma))
cat(sprintf("σ² com d = 1: %.4f | d = 2: %.4f (+%.1f%%) | d = 2 com MA: %.4f\n",
            C3$sigma2, D2$sigma2, 100 * (D2$sigma2 / C3$sigma2 - 1), D2m$sigma2))
cat(sprintf("ρ1 de Δ²y = %.3f | teórico -(1-φ)/2 = %.3f\n",
            acf(diff(dy), plot = FALSE)$acf[2], -(1 - coef(C3)["ar1"]) / 2))
par(mfrow = c(1, 2))
acf(as.numeric(residuals(C3)), lag.max = 24, main = "FAC dos resíduos, d = 1", xlab = "defasagem (meses)")
acf(as.numeric(residuals(D2)), lag.max = 24, main = "FAC dos resíduos, d = 2", xlab = "defasagem (meses)")
par(mfrow = c(1, 1))
# LEITURA (Q6).
# - (a) θ̂ ≈ -1, com raiz MA = 1: não invertível.
# - (b) σ² sobe com a diferença extra.
# - (c) A série Δ²y tem ρ1 negativo, próximo do teórico; no modelo, o AR troca de sinal
#   para absorvê-lo, e sobra estrutura nas defasagens 2 e 3.
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
fit <- Arima(y_treino, order = c(1, 1, 0), seasonal = c(1, 0, 1), include.drift = TRUE, method = "ML")

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
#   foi alterado em função do resultado.
# - (g) A cobertura (100%) fica acima da nominal: o IC de um modelo integrado se abre com h,
#   e os 24 erros de uma única origem são correlacionados entre si.

writeLines(capture.output(sessionInfo()), "sessionInfo_lista01.txt")

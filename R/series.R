# Helpers de séries temporais usados pelos módulos e pelo trabalho do INPC.
# Só definições: este arquivo é carregado por R/raiz.R.
#
# CONVENÇÃO DE SINAL (ver CONVENCOES.md §2). A lista escreve o MA no estilo
# Box-Jenkins, theta(B) = 1 - theta_1 B - ... ; o R (arima, ARMAacf, ARMAtoMA)
# e os slides usam theta(L) = 1 + theta_1 L + ... . Os helpers abaixo recebem o
# argumento `sinal_ma`: "bj" (lista, sinal negativo) ou "r" (slides/R, positivo).

# Converte coeficientes MA para a convenção do R
ma_para_r <- function(theta, sinal_ma = c("bj", "r")) {
  sinal_ma <- match.arg(sinal_ma)
  if (!length(theta)) return(numeric(0))
  if (sinal_ma == "bj") -theta else theta
}

# Pesos psi_j da representação MA(inf): y_t = sum psi_j a_{t-j}, psi_0 = 1
pesos_psi <- function(phi = numeric(0), theta = numeric(0), n = 10, sinal_ma = "bj") {
  c(1, stats::ARMAtoMA(ar = phi, ma = ma_para_r(theta, sinal_ma), lag.max = n))
}

# Pesos pi_j da representação AR(inf): y_t = sum_{j>=1} pi_j y_{t-j} + a_t.
# Inverter o ARMA(p,q) troca os papéis: pi(B) = phi(B)/theta(B). Os pesos psi do
# processo "invertido" (AR = -theta_R, MA = -phi) são -pi_j.
pesos_pi <- function(phi = numeric(0), theta = numeric(0), n = 10, sinal_ma = "bj") {
  th_r <- ma_para_r(theta, sinal_ma)
  inv <- stats::ARMAtoMA(ar = -th_r, ma = -phi, lag.max = n)
  -inv
}

# Módulos das raízes de 1 - c_1 z - ... - c_p z^p (AR) ou 1 + c_1 z + ... (MA, conv. R)
modulo_raizes_ar <- function(phi) if (!length(phi)) numeric(0) else Mod(polyroot(c(1, -phi)))
modulo_raizes_ma <- function(theta, sinal_ma = "bj") {
  th <- ma_para_r(theta, sinal_ma)
  if (!length(th)) numeric(0) else Mod(polyroot(c(1, th)))
}
estacionario <- function(phi) all(modulo_raizes_ar(phi) > 1)
invertivel <- function(theta, sinal_ma = "bj") all(modulo_raizes_ma(theta, sinal_ma) > 1)

# Autocovariâncias teóricas gamma_0..gamma_k de um ARMA com variância sigma2
acvf_arma <- function(phi = numeric(0), theta = numeric(0), sigma2 = 1, lag.max = 10, sinal_ma = "bj") {
  psi <- pesos_psi(phi, theta, n = 2000, sinal_ma = sinal_ma)
  vapply(0:lag.max, function(k) sigma2 * sum(psi[1:(length(psi) - k)] * psi[(1 + k):length(psi)]), 0)
}

# Tabela de coeficientes de um Arima: estimativa, erro-padrão, z e p-valor
tabela_coef <- function(fit) {
  b <- stats::coef(fit)
  ep <- sqrt(diag(fit$var.coef))
  ep <- ep[names(b)]
  z <- b / ep
  data.frame(termo = names(b), coef = unname(b), ep = unname(ep), z = unname(z),
             p = unname(2 * stats::pnorm(-abs(z))), stringsAsFactors = FALSE)
}

# Escore de Winkler de um intervalo 100(1-alpha)% (aula 03)
winkler <- function(y, li, ls, alpha = 0.05) {
  (ls - li) + (2 / alpha) * pmax(li - y, 0) + (2 / alpha) * pmax(y - ls, 0)
}

# Formata número em pt-BR para texto de nota: fmt(0.6330, 4) -> "0,6330"
fmt <- function(x, casas = 4) formatC(x, format = "f", digits = casas, decimal.mark = ",")

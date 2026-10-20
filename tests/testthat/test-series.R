# Identidades da teoria conferidas contra as funções do R (stats::ARMAacf, ARMAtoMA).

.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

test_that("convenção de sinal: BJ e R dão o mesmo processo com theta trocado de sinal", {
  expect_equal(pesos_psi(0.5, 0.3, 8, "bj"), pesos_psi(0.5, -0.3, 8, "r"))
  expect_equal(ma_para_r(c(1.3, -0.4), "bj"), c(-1.3, 0.4))
})

test_that("pesos psi do AR(1) são phi^j (Wold, D01.3)", {
  expect_equal(pesos_psi(0.7, n = 6), 0.7^(0:6))
})

test_that("pesos pi do MA(1) dos slides: pi_j = -(-theta)^j (AU02, p. 23)", {
  th <- 0.5
  expect_equal(pesos_pi(theta = th, n = 5, sinal_ma = "r"), -(-th)^(1:5))
})

test_that("ARMA(1,1): psi_j = (phi-theta) phi^(j-1) e pi_j = (phi-theta) theta^(j-1) (Q6c)", {
  phi <- 0.8; th <- 0.4; j <- 1:8
  expect_equal(pesos_psi(phi, th, 8)[-1], (phi - th) * phi^(j - 1))
  expect_equal(pesos_pi(phi, th, 8), (phi - th) * th^(j - 1))
})

test_that("gamma_0 e gamma_1 do ARMA(1,1) batem com ARMAacf (Q6a)", {
  phi <- 0.6; th <- -0.3
  g <- acvf_arma(phi, th, 1, lag.max = 5)
  g0 <- (1 + th^2 - 2 * phi * th) / (1 - phi^2)
  g1 <- (1 - phi * th) * (phi - th) / (1 - phi^2)
  expect_equal(g[1:2], c(g0, g1), tolerance = 1e-8)
  expect_equal(g / g[1], unname(stats::ARMAacf(phi, -th, lag.max = 5)), tolerance = 1e-8)
})

test_that("Yule-Walker do AR(2) e gamma_0 fechado (Q7)", {
  p1 <- 0.4; p2 <- -0.5
  ac <- stats::ARMAacf(c(p1, p2), lag.max = 2)
  expect_equal(unname(ac[2]), p1 / (1 - p2))
  expect_equal(unname(ac[3]), p1^2 / (1 - p2) + p2)
  expect_equal(acvf_arma(c(p1, p2), lag.max = 0), (1 - p2) / ((1 + p2) * ((1 - p2)^2 - p1^2)), tolerance = 1e-8)
})

test_that("MA(1): |rho_1| <= 1/2, máximo em theta = 1 (AU02, p. 35)", {
  th <- seq(-5, 5, by = 0.01)
  expect_lte(max(abs(th / (1 + th^2))), 0.5)
  expect_equal(1 / (1 + 1), 0.5)
})

test_that("MA(1): theta e 1/theta geram a mesma FAC (identificação)", {
  expect_equal(stats::ARMAacf(ma = 0.5, lag.max = 3), stats::ARMAacf(ma = 2, lag.max = 3))
})

test_that("triângulo de estacionariedade do AR(2) = raízes fora do círculo", {
  set.seed(1)
  for (i in 1:200) {
    p <- stats::runif(2, -2, 2)
    tri <- (p[1] + p[2] < 1) && (p[2] - p[1] < 1) && (abs(p[2]) < 1)
    expect_equal(estacionario(p), tri)
  }
})

test_that("raízes do polinômio AR = inverso dos autovalores da matriz companheira", {
  phi <- c(0.5, 0.2, -0.1)
  F <- rbind(phi, cbind(diag(2), 0))
  expect_equal(sort(Mod(eigen(F)$values)), sort(1 / modulo_raizes_ar(phi)), tolerance = 1e-10)
})

test_that("SAR(1)_4 é AR(4) com zeros e o multiplicativo é AR(5) restrito (Q11)", {
  Phi <- 0.6; ph <- 0.5
  fac <- stats::ARMAacf(ar = c(0, 0, 0, Phi), lag.max = 8)[-1]
  expect_equal(unname(fac[c(1, 2, 3, 5, 6, 7)]), rep(0, 6), tolerance = 1e-12)
  expect_equal(unname(fac[c(4, 8)]), c(Phi, Phi^2))
  pol <- stats::convolve(c(1, -ph), rev(c(1, 0, 0, 0, -Phi)), type = "open")
  expect_equal(pol, c(1, -ph, 0, 0, -Phi, ph * Phi), tolerance = 1e-12)
})

test_that("variância do erro de previsão converge para gamma_0 (Q15c)", {
  psi <- pesos_psi(0.7, 0.4, 400)
  expect_equal(sum(psi^2), acvf_arma(0.7, 0.4, lag.max = 0), tolerance = 1e-8)
})

test_that("Winkler: só largura quando cobre; penaliza 2/alpha fora", {
  expect_equal(winkler(0, -1, 1, 0.05), 2)
  expect_equal(winkler(2, -1, 1, 0.05), 2 + 40 * 1)
})

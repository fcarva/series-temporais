# Identidades da regressão dinâmica (AU06, módulo 07).

.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

test_that("DL: os multiplicadores de impacto são os próprios beta_j", {
  expect_equal(multiplicadores_ardl(beta = c(0.6, 0.1), n = 4), c(0.6, 0.1, 0, 0, 0))
})

test_that("ARDL(1,1): m_0 = beta_0, m_1 = phi beta_0 + beta_1, m_k = phi m_{k-1} (D07.2)", {
  phi <- 0.7; b <- c(0.3, 0.15)
  m <- multiplicadores_ardl(phi, b, n = 6)
  expect_equal(m[1:2], c(b[1], phi * b[1] + b[2]))
  expect_equal(m[3:7], (phi * b[1] + b[2]) * phi^(1:5))
})

test_that("a soma dos multiplicadores converge para beta(1)/lambda(1) (D07.2)", {
  phi <- c(0.5, 0.2); b <- c(0.4, -0.1, 0.3)
  expect_equal(sum(multiplicadores_ardl(phi, b, n = 400)), longo_prazo_ardl(phi, b), tolerance = 1e-10)
})

test_that("ECM e ARDL(1,1) são o mesmo modelo: mesmos resíduos e alpha = phi - 1 (D07.4)", {
  set.seed(1); n <- 300
  x <- as.numeric(arima.sim(list(ar = 0.5), n)); y <- numeric(n)
  for (t in 2:n) y[t] <- 0.2 + 0.7 * y[t - 1] + 0.3 * x[t] + 0.15 * x[t - 1] + rnorm(1)
  t <- 2:n
  ardl <- lm(y[t] ~ y[t - 1] + x[t] + x[t - 1])
  ecm <- lm(diff(y) ~ diff(x) + y[t - 1] + x[t - 1])
  expect_equal(unname(residuals(ardl)), unname(residuals(ecm)))
  expect_equal(unname(coef(ecm)[3]), unname(coef(ardl)[2]) - 1)
  expect_equal(-unname(coef(ecm)[4] / coef(ecm)[3]), unname(sum(coef(ardl)[3:4]) / (1 - coef(ardl)[2])))
})

test_that("viés por omitir y_{t-1}: plim = beta_0 + phi beta_0 rho/(1 - phi rho) (D07.3)", {
  set.seed(2); n <- 200000; phi <- 0.6; b0 <- 0.5; rho <- 0.8
  x <- as.numeric(arima.sim(list(ar = rho), n)); y <- numeric(n)
  for (t in 2:n) y[t] <- phi * y[t - 1] + b0 * x[t] + rnorm(1)
  expect_equal(unname(coef(lm(y ~ x))[2]), b0 + phi * b0 * rho / (1 - phi * rho), tolerance = 0.01)
})

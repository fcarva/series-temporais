# Roda toda a suíte de testes.
# Rodar: Rscript tests/testthat.R  (Windows: scripts\r.ps1 tests\testthat.R)

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

library(testthat)

res <- test_dir(file.path(raiz(), "tests", "testthat"), reporter = "summary", stop_on_failure = FALSE)
df <- as.data.frame(res)
falhas <- sum(df$failed) + sum(df$error)
cat("\nTestes:", sum(df$passed), "passaram,", falhas, "falharam,", sum(df$skipped), "pulados\n")
if (falhas > 0) quit(status = 1)

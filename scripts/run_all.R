# Roda todos os scripts R dos módulos e do trabalho do INPC, cada um em um
# processo novo, e resume o resultado.
# Rodar: Rscript scripts/run_all.R  (Windows: scripts\r.ps1 scripts\run_all.R)

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

RAIZ <- raiz()
setwd(RAIZ)

alvos <- c(
  list.files(RAIZ, pattern = "\\.R$", recursive = TRUE, full.names = TRUE)
)
rel <- sub(paste0(RAIZ, "/"), "", gsub("\\\\", "/", alvos), fixed = TRUE)
manter <- grepl("^[0-9]{2}_[^/]+/[^/]+\\.R$", rel) |
  grepl("^trabalho_inpc/[^/]+\\.R$", rel)
rel <- sort(rel[manter])

rscript <- file.path(R.home("bin"), "Rscript")
res <- data.frame(script = rel, status = NA_integer_, segundos = NA_real_, stringsAsFactors = FALSE)

for (i in seq_along(rel)) {
  cat("\n=== ", rel[i], "\n", sep = "")
  t0 <- proc.time()[["elapsed"]]
  st <- system2(rscript, shQuote(rel[i]), stdout = FALSE, stderr = "")
  res$status[i] <- st
  res$segundos[i] <- round(proc.time()[["elapsed"]] - t0, 1)
  cat(if (st == 0) "    ok" else paste("    FALHOU (status", st, ")"), " em ", res$segundos[i], "s\n", sep = "")
}

cat("\n--- Resumo ---\n")
for (i in seq_len(nrow(res))) {
  cat(sprintf("%-55s %-8s %6.1fs\n", res$script[i],
              if (res$status[i] == 0) "ok" else "FALHOU", res$segundos[i]))
}
cat(sprintf("\n%d scripts, %d falharam, %.1fs no total\n",
            nrow(res), sum(res$status != 0), sum(res$segundos)))

if (any(res$status != 0)) quit(status = 1)

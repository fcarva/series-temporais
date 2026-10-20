# Confere (e instala, se faltar) os pacotes usados no repositório.
# Uso: Rscript R/00_setup.R            -> instala o que faltar
#      Rscript R/00_setup.R --check    -> só confere; sai com status 1 se faltar algo

pacotes <- c("forecast", "tseries", "urca", "lmtest", "strucchange", "testthat", "jsonlite")

faltam <- pacotes[!vapply(pacotes, requireNamespace, logical(1), quietly = TRUE)]
args <- commandArgs(trailingOnly = TRUE)

if (length(faltam)) {
  if ("--check" %in% args) {
    message("Pacotes faltando: ", paste(faltam, collapse = ", "))
    quit(status = 1)
  }
  install.packages(faltam, repos = "https://cloud.r-project.org", lib = .libPaths()[1])
  faltam <- pacotes[!vapply(pacotes, requireNamespace, logical(1), quietly = TRUE)]
  if (length(faltam)) stop("Falha ao instalar: ", paste(faltam, collapse = ", "))
}

message(R.version.string, " | pacotes OK: ", paste(pacotes, collapse = ", "))

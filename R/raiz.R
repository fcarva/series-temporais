# Localiza a raiz do repositório (arquivo marcador .repo-root) e carrega os helpers.
#
# Todo script do repositório começa com o bootstrap abaixo, que funciona
# rodando da raiz, de dentro da pasta do módulo ou via scripts/r.ps1:
#
#   .d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
#   source(file.path(.d, "R", "raiz.R"))

raiz <- function(inicio = getwd()) {
  d <- normalizePath(inicio, winslash = "/", mustWork = TRUE)
  repeat {
    if (file.exists(file.path(d, ".repo-root"))) return(d)
    pai <- dirname(d)
    if (identical(pai, d)) stop("Raiz do repositório (.repo-root) não encontrada a partir de ", inicio)
    d <- pai
  }
}

# Caminho absoluto a partir da raiz: caminho_repo("01_processos", "figuras", "x.png")
caminho_repo <- function(...) file.path(raiz(), ...)

local({
  helpers <- setdiff(list.files(file.path(raiz(), "R"), pattern = "\\.R$", full.names = TRUE),
                     file.path(raiz(), "R", c("raiz.R", "00_setup.R")))
  for (h in sort(helpers)) {
    tryCatch(source(h, encoding = "UTF-8"),
             error = function(err) warning("Helper ", basename(h), " falhou ao carregar: ", conditionMessage(err)))
  }
})

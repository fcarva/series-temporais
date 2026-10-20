# Confere cada tabela "chave_R | nota" das notas .md contra os valores gravados
# pelos scripts em resultados/*.csv.
#
# Tolerância: meia unidade da última casa decimal escrita na nota (mais uma folga
# relativa de 1e-9 para números grandes). Assim, escrever 0,8340 para 0,834023 passa;
# escrever 0,8341 não passa.
#
# Rodar: Rscript scripts/check_numbers.R  (Windows: scripts\r.ps1 scripts\check_numbers.R)

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

RAIZ <- raiz()

# ---- carrega todos os resultados -------------------------------------------
arqs <- list.files(file.path(RAIZ, "resultados"), pattern = "\\.csv$", full.names = TRUE)
valores <- list()
for (a in arqs) {
  d <- utils::read.csv(a, stringsAsFactors = FALSE)
  if (!all(c("chave", "valor") %in% names(d))) next
  for (i in seq_len(nrow(d))) {
    chave <- trimws(d$chave[i])
    valores[[chave]] <- suppressWarnings(as.numeric(trimws(d$valor[i])))
  }
}
cat("Resultados carregados:", length(valores), "chaves de", length(arqs), "arquivos\n")

# ---- converte número escrito em pt-BR --------------------------------------
num_ptbr <- function(txt) {
  s <- trimws(txt)
  s <- gsub("[[:space:]]", "", s)
  s <- gsub("−", "-", s)              # menos tipográfico
  s <- gsub("\\*", "", s)                  # negrito eventual
  if (grepl(",", s)) s <- gsub("\\.", "", s)   # separador de milhar, só se houver vírgula decimal
  s <- sub(",", ".", s, fixed = TRUE)
  suppressWarnings(as.numeric(s))
}

casas_decimais <- function(txt) {
  s <- gsub("[[:space:]]", "", trimws(txt))
  s <- sub("[eE].*$", "", s)
  parte <- sub("^[^,.]*", "", s)
  parte <- sub("^[,.]", "", parte)
  nchar(gsub("[^0-9]", "", parte))
}

# ---- varre os .md -----------------------------------------------------------
mds <- list.files(RAIZ, pattern = "\\.md$", recursive = TRUE, full.names = TRUE)
ignorar <- c("/materiais/", "/.git/", "/caderno/_build/")
mds <- mds[!Reduce(`|`, lapply(ignorar, function(p) grepl(p, mds, fixed = TRUE)))]

erros <- character(0)
conferidos <- 0
citadas <- character(0)

for (md in mds) {
  linhas <- readLines(md, warn = FALSE, encoding = "UTF-8")
  dentro <- FALSE
  for (i in seq_along(linhas)) {
    ln <- linhas[i]
    if (grepl("^\\s*\\|\\s*chave_R\\s*\\|", ln)) { dentro <- TRUE; next }
    if (dentro) {
      if (!grepl("^\\s*\\|", ln)) { dentro <- FALSE; next }
      if (grepl("^\\s*\\|[\\s:|-]*\\|\\s*$", ln) || grepl("^\\s*\\|[-: |]+\\|\\s*$", ln)) next
      campos <- strsplit(sub("^\\s*\\|", "", sub("\\|\\s*$", "", ln)), "|", fixed = TRUE)[[1]]
      if (length(campos) < 2) next
      chave <- gsub("[`\\*[:space:]]", "", campos[1])
      escrito <- campos[2]
      if (chave == "" || grepl("^[-:]+$", chave)) next
      citadas <- c(citadas, chave)
      rel <- sub(paste0("^", gsub("([.|()\\^{}+$*?\\[\\]])", "\\\\\\1", RAIZ), "/?"), "", md)
      if (is.null(valores[[chave]])) {
        erros <- c(erros, sprintf("%s:%d  chave inexistente em resultados/: %s", rel, i, chave))
        next
      }
      v_nota <- num_ptbr(escrito)
      if (is.na(v_nota)) {
        erros <- c(erros, sprintf("%s:%d  valor ilegível para %s: '%s'", rel, i, chave, trimws(escrito)))
        next
      }
      v_R <- valores[[chave]]
      tol <- 0.5 * 10^(-casas_decimais(escrito)) + 1e-9 * abs(v_R)
      conferidos <- conferidos + 1
      if (!is.finite(v_R) || abs(v_nota - v_R) > tol) {
        erros <- c(erros, sprintf("%s:%d  %s: nota = %s, R = %s (tolerância %.3g)",
                                  rel, i, chave, trimws(escrito),
                                  formatC(v_R, digits = 10, format = "g"), tol))
      }
    }
  }
}

cat("Valores conferidos:", conferidos, "\n")

nao_citadas <- setdiff(names(valores), unique(citadas))
cat("Chaves gravadas e ainda não citadas em nenhuma nota:", length(nao_citadas), "\n")

if (length(erros)) {
  cat("\n--- DIVERGÊNCIAS (", length(erros), ") ---\n", sep = "")
  cat(paste(erros, collapse = "\n"), "\n")
  quit(status = 1)
}

cat("OK: todos os números das notas batem com o R.\n")

# Lint das notas: frontmatter, callouts que o GitHub renderiza, links relativos,
# aliases e ids de demonstração duplicados, notação da lista, "R$" de dinheiro sem escape, arquivos
# proibidos versionados e checagem de cópia contra materiais/_txt.
# Rodar: Rscript scripts/lint_repo.R  (Windows: scripts\r.ps1 scripts\lint_repo.R)

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

RAIZ <- raiz()
setwd(RAIZ)

LEGADO <- character(0)
CALLOUTS_OK <- c("NOTE", "TIP", "IMPORTANT", "WARNING", "CAUTION")

erros <- character(0); avisos <- character(0)
E <- function(...) erros <<- c(erros, sprintf(...))
A <- function(...) avisos <<- c(avisos, sprintf(...))

mds <- list.files(RAIZ, pattern = "\\.md$", recursive = TRUE, full.names = TRUE)
mds <- mds[!grepl("/materiais/|/\\.git/|/caderno/_build/", mds)]
rel_de <- function(p) sub(paste0(RAIZ, "/"), "", gsub("\\\\", "/", p), fixed = TRUE)

# tira blocos de código: outputs gerados pelo nosso próprio R não são cópia
sem_codigo <- function(linhas) {
  dentro <- FALSE; fora <- character(0)
  for (l in linhas) {
    if (grepl("^\\s*```", l)) { dentro <- !dentro; next }
    if (!dentro) fora <- c(fora, l)
  }
  fora
}

aliases <- list(); ids_D <- list()

for (md in mds) {
  rel <- rel_de(md)
  legado <- rel %in% LEGADO
  txt <- readLines(md, warn = FALSE, encoding = "UTF-8")
  if (!length(txt)) { E("%s: arquivo vazio", rel); next }

  if (!grepl("^---\\s*$", txt[1])) {
    E("%s: sem frontmatter YAML", rel)
  } else {
    fim <- which(grepl("^---\\s*$", txt))[2]
    if (is.na(fim)) {
      E("%s: frontmatter não fechado", rel)
    } else {
      fm <- txt[2:(fim - 1)]
      ia <- grep("^aliases:\\s*$", fm)
      if (length(ia) && ia[1] < length(fm)) {
        for (l in fm[(ia[1] + 1):length(fm)]) {
          if (!grepl("^\\s+-\\s+", l)) break
          a <- trimws(sub("^\\s+-\\s+", "", l)); a <- gsub('^"|"$', "", a)
          aliases[[a]] <- c(aliases[[a]], rel)
        }
      }
    }
  }

  em_codigo <- FALSE; em_comentario <- FALSE
  for (i in seq_along(txt)) {
    ln <- txt[i]
    if (!em_codigo && !legado && grepl("^\\s*```text", ln) && !(rel %in% c("README.md", "CONVENCOES.md")))
      E("%s:%d: bloco ```text em nota de estudo; diagrame a resposta ou o output (CONVENCOES §11-12)", rel, i)
    if (grepl("^\\s*```", ln)) { em_codigo <- !em_codigo; next }
    if (em_codigo) next

    if (!legado && grepl("^>\\s*\\[!", ln)) {
      tipo <- sub("^>\\s*\\[!([A-Za-z]+)\\].*$", "\\1", ln)
      if (!toupper(tipo) %in% CALLOUTS_OK)
        E("%s:%d: callout '%s' não renderiza no GitHub (use %s)", rel, i, tipo,
          paste(CALLOUTS_OK, collapse = "/"))
      resto <- trimws(sub("^>\\s*\\[![A-Za-z]+\\]", "", ln))
      if (nzchar(resto)) E("%s:%d: texto na mesma linha do marcador de callout", rel, i)
    }

    # R$ só é problema quando é dinheiro (seguido de número); $R$ e $SQR$ são matemática
    if (grepl("(^|[^\\\\])R\\$\\s*[0-9]", ln))
      E("%s:%d: 'R$' de dinheiro sem escape", rel, i)

    if (grepl("^#{2,4}\\s+D[0-9]+(\\.[0-9]+)?\\s*[·:-]", ln)) {
      id <- sub("^#{2,4}\\s+(D[0-9]+(\\.[0-9]+)?)\\s*[·:-].*$", "\\1", ln)
      ids_D[[id]] <- c(ids_D[[id]], rel)
    }

    # notação (CONVENCOES §2): formas recusadas fora de código
    if (!legado && rel != "CONVENCOES.md") {
      lc <- gsub("`[^`]*`", "", ln)
      if (grepl("<!--", lc)) em_comentario <- TRUE
      if (grepl("^\\|\\s*chave_R\\s*\\|", lc) && !em_comentario)
        E("%s:%d: tabela chave_R visível; ponha-a dentro de <!-- ... --> (CONVENCOES §6)", rel, i)
      if (grepl("-->", lc)) em_comentario <- FALSE
      proib <- c("\\\\hat(?![a-z])" = "\\hat (use \\widehat)",
                 "(?<![A-Za-z\\\\])E\\[" = "E[·] (use E(·))",
                 "(?<![A-Za-z\\\\])Var\\[" = "Var[·] (use Var(·))")
      for (p in names(proib)) if (grepl(p, lc, perl = TRUE))
        E("%s:%d: notação fora do padrão: %s", rel, i, proib[[p]])
    }

    if (!legado) {
      for (m in regmatches(ln, gregexpr("\\]\\(([^)]+)\\)", ln))[[1]]) {
        alvo <- sub("^\\]\\(", "", sub("\\)$", "", m))
        if (grepl("^(https?:|mailto:|#)", alvo)) next
        if (grepl("[$\\ ]", alvo)) next          # é matemática, não link
        alvo <- sub("#.*$", "", alvo)
        if (!nzchar(alvo)) next
        if (startsWith(alvo, "materiais/")) next  # fora do git: só existe nos clones locais
        if (!file.exists(file.path(dirname(md), alvo)))
          E("%s:%d: link relativo quebrado: %s", rel, i, alvo)
      }
    }
  }

  corpo <- paste(sem_codigo(txt), collapse = "\n")
  if (grepl("\\$\\$", corpo) && length(gregexpr("\\$\\$", corpo)[[1]]) %% 2 != 0)
    A("%s: número ímpar de '$$' — confira os blocos de matemática", rel)
}

for (a in names(aliases)) if (length(unique(aliases[[a]])) > 1)
  E("alias duplicado '%s' em: %s", a, paste(unique(aliases[[a]]), collapse = ", "))
for (id in names(ids_D)) if (length(unique(ids_D[[id]])) > 1)
  E("id de demonstração duplicado '%s' em: %s", id, paste(unique(ids_D[[id]]), collapse = ", "))

if (dir.exists(file.path(RAIZ, ".git"))) {
  rastreados <- tryCatch(system2("git", c("ls-files"), stdout = TRUE), error = function(e) character(0))
  for (p in grep("\\.(pdf|jpe?g)$|^materiais/", rastreados, value = TRUE))
    E("arquivo proibido versionado: %s", p)
}

# arquivos versionados que sumiram do diretório (movidos para fora do repo, por exemplo
# arrastados para dentro de materiais/ no Obsidian) — some do git no próximo commit
if (dir.exists(file.path(RAIZ, ".git"))) {
  st <- tryCatch(system2("git", c("status", "--porcelain"), stdout = TRUE), error = function(e) character(0))
  sumidos <- sub("^\\s*D\\s+", "", grep("^\\s*D\\s", st, value = TRUE))
  if (length(sumidos)) {
    E("%d arquivo(s) versionado(s) sumiram do diretório — foram movidos para fora do repo?", length(sumidos))
    for (p in utils::head(sumidos, 8)) E("   sumiu: %s", p)
  }
}

dir_txt <- file.path(RAIZ, "materiais", "_txt")
if (dir.exists(dir_txt)) {
  normaliza <- function(s) {
    s <- tolower(paste(s, collapse = " "))
    s <- gsub("[^a-zà-úA-ZÀ-Ú0-9 ]", " ", s)
    strsplit(gsub("\\s+", " ", trimws(s)), " ")[[1]]
  }
  # só conta como cópia se o trecho tiver substância: 6+ palavras de 3 letras ou mais
  substancial <- function(p) sum(nchar(p) >= 3) >= 6
  grams <- new.env(hash = TRUE, parent = emptyenv())
  for (a in list.files(dir_txt, pattern = "\\.txt$", full.names = TRUE)) {
    w <- normaliza(sem_codigo(readLines(a, warn = FALSE, encoding = "UTF-8")))
    if (length(w) < 12) next
    for (k in seq_len(length(w) - 11)) assign(paste(w[k:(k + 11)], collapse = " "), TRUE, envir = grams)
  }
  sem_referencias <- function(linhas) linhas[!grepl("\\((19|20)[0-9]{2}\\)", linhas)]
  for (md in mds) {
    w <- normaliza(sem_referencias(sem_codigo(readLines(md, warn = FALSE, encoding = "UTF-8"))))
    if (length(w) < 12) next
    for (k in seq_len(length(w) - 11)) {
      g <- paste(w[k:(k + 11)], collapse = " ")
      if (substancial(w[k:(k + 11)]) && exists(g, envir = grams, inherits = FALSE)) {
        E("%s: 12 palavras iguais às de materiais/_txt: \"%s\"", rel_de(md), g); break
      }
    }
  }
} else {
  A("materiais/_txt ausente: checagem de cópia não executada")
}

cat("Arquivos .md analisados:", length(mds), "\n")
if (length(avisos)) { cat("\n--- AVISOS (", length(avisos), ") ---\n", sep = ""); cat(paste(avisos, collapse = "\n"), "\n") }
if (length(erros)) {
  cat("\n--- ERROS (", length(erros), ") ---\n", sep = ""); cat(paste(erros, collapse = "\n"), "\n")
  quit(status = 1)
}
cat("Lint OK.\n")

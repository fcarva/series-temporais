# Avaliador fixo da revisão final (prova/revisao_final.md) e do cartão: NÃO EDITAR durante o loop.
#
# Critérios (peso):
#   questão A..D (2 cada) — a subseção "### Questão X" tem "**O que o professor cobra", "**O que garante
#                  o ponto", "**O seu erro", 5+ linhas \text{(n)} com "&& [", "**Frase de fecho:**" e 2+ links;
#   erros (2)        — 10+ itens numerados com "**Regra:**";
#   conferencias (1) — uma seção cujo título tem "conferências";
#   roteiro (1)      — uma seção cujo título tem "roteiro";
#   chaves (2)       — todas as chaves chave_R da revisão existem em resultados/;
#   cartao (2)       — caderno/pdf/caderno_cartao_prova.pdf tem exatamente 1 página;
#   links (2)        — autoestudo/avaliar_auditoria.R continua em 100 (links e âncoras).
# Rodar: Rscript autoestudo/avaliar_revisao.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))
RAIZ <- raiz()
ler <- function(f) if (file.exists(f)) readLines(f, encoding = "UTF-8", warn = FALSE) else character()
itens <- list()
add <- function(qt, crit, peso, ok) itens[[length(itens) + 1]] <<- data.frame(qt = qt, criterio = crit, peso = peso, ok = isTRUE(ok))

l <- ler(file.path(RAIZ, "prova", "revisao_final.md"))
cab <- grep("^#{2,3} ", l)
bloco <- function(i) if (length(i)) l[i:(min(c(cab[cab > i], length(l) + 1)) - 1)] else character()
for (x in c("A", "B", "C", "D")) {
  s <- bloco(grep(sprintf("^### Questão %s\\b", x), l)[1])
  s <- s[!is.na(s)]
  num <- grep("\\\\text\\{\\([0-9]+\\)\\}", s, value = TRUE)
  ok <- length(s) && all(vapply(c("\\*\\*O que o professor cobra", "\\*\\*O que garante o ponto", "\\*\\*O seu erro",
                                   "\\*\\*Frase de fecho:\\*\\*"), function(r) any(grepl(r, s)), logical(1))) &&
    length(num) >= 5 && all(grepl("&&\\s*\\[", num)) && sum(lengths(regmatches(s, gregexpr("\\]\\(", s)))) >= 2
  add(paste("questão", x), "partes", 2, ok)
}
add("erros", "dez_com_regra", 2, length(grep("^[0-9]+\\. .*\\*\\*Regra:\\*\\*", l)) >= 10)
add("prova", "conferencias", 1, any(grepl("^## .*conferências", l, ignore.case = TRUE)))
add("manhã", "roteiro", 1, any(grepl("^## .*roteiro", l, ignore.case = TRUE)))
tab <- grep("^\\|\\s*[a-z]+_[A-Za-z0-9_]+\\s*\\|", l, value = TRUE)
chaves <- setdiff(trimws(sub("^\\|\\s*([A-Za-z0-9_]+)\\s*\\|.*", "\\1", tab)), "chave_R")
res <- unlist(lapply(list.files(file.path(RAIZ, "resultados"), pattern = "\\.csv$", full.names = TRUE),
                     function(f) sub(",.*", "", readLines(f, warn = FALSE))))
add("global", "chaves", 2, length(chaves) >= 15 && all(chaves %in% res))
pdf <- file.path(RAIZ, "caderno", "pdf", "caderno_cartao_prova.pdf")
pg <- if (file.exists(pdf)) suppressWarnings(system2("pdfinfo", shQuote(pdf), stdout = TRUE, stderr = FALSE)) else character()
np <- suppressWarnings(as.integer(sub("^Pages:\\s*", "", grep("^Pages:", pg, value = TRUE))))
add("cartão", "uma_pagina", 2, length(np) == 1 && identical(np, 1L))
au <- tryCatch(system2(file.path(R.home("bin"), "Rscript"), file.path(RAIZ, "autoestudo", "avaliar_auditoria.R"),
                       stdout = TRUE, stderr = FALSE), error = function(e) character())
na <- suppressWarnings(as.numeric(sub(".*:\\s*", "", grep("^nota_auditoria", au, value = TRUE))))
add("global", "links_auditoria", 2, length(na) == 1 && !is.na(na) && na >= 100)

it <- do.call(rbind, itens)
cat("---\n")
for (q in unique(it$qt)) { x <- it[it$qt == q, ]; cat(sprintf("%-12s %5.1f\n", q, 100 * sum(x$peso * x$ok) / sum(x$peso))) }
cat(sprintf("nota_revisao: %5.1f\n", 100 * sum(it$peso * it$ok) / sum(it$peso)))
f <- it[!it$ok, ]
if (nrow(f)) { cat("lacunas:\n"); for (j in seq_len(nrow(f))) cat(sprintf("  %s  %s (%g)\n", f$qt[j], f$criterio[j], f$peso[j])) }

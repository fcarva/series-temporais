# Avaliador fixo da auditoria final (prova/auditoria_final.md): NÃO EDITAR durante o loop.
#
# Critérios (peso):
#   links (3)      — todo link relativo de prova/*.md e lista_comentada/*.md aponta para um arquivo
#                    que existe e, se tiver âncora, para um título que existe no destino;
#   matriz (2)     — a matriz da auditoria cita as 16 questões da lista (Q1 a Q16);
#   fios (2 cada)  — as quatro questões prováveis (A a D) têm um fio de 4+ passos numerados,
#                    cada passo com um link;
#   folha (2)      — a folha "o que cai" liga 8+ notas distintas de lista_comentada/;
#   divergencias (2) — a folha trata o SAR(1)_4 da Q11 e o SARIMA(1,1,0)(0,1,1)_4 da Q12;
#   integracao (1) — a auditoria está no manifesto do volume e no topo do README da prova.
# Rodar: Rscript autoestudo/avaliar_auditoria.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))
RAIZ <- raiz()
ler <- function(f) if (file.exists(f)) readLines(f, encoding = "UTF-8", warn = FALSE) else character()
itens <- list()
add <- function(qt, crit, peso, ok) itens[[length(itens) + 1]] <<- data.frame(qt = qt, criterio = crit, peso = peso, ok = isTRUE(ok))

# âncora no estilo do GitHub: minúsculas, sem pontuação (mantém letras acentuadas e hífens), espaço vira hífen
slug <- function(h) {
  h <- tolower(sub("^#+\\s*", "", h))
  h <- gsub("[^\\p{L}\\p{N} _-]", "", h, perl = TRUE)
  gsub(" ", "-", h, fixed = TRUE)
}
fontes <- c(Sys.glob(file.path(RAIZ, "prova", "*.md")), Sys.glob(file.path(RAIZ, "lista_comentada", "*.md")))
quebrados <- character()
for (f in fontes) {
  l <- ler(f)
  l <- l[!grepl("^\\s*\\|?\\s*chave_R", l)]
  m <- unlist(regmatches(l, gregexpr("\\]\\(([^)\\s]+)\\)", l, perl = TRUE)))
  alvos <- sub("^\\]\\((.*)\\)$", "\\1", m)
  alvos <- alvos[!grepl("^(https?:|mailto:)", alvos)]
  for (a in alvos) {
    partes <- strsplit(a, "#", fixed = TRUE)[[1]]
    arq <- if (nzchar(partes[1])) normalizePath(file.path(dirname(f), partes[1]), mustWork = FALSE) else f
    ok <- file.exists(arq)
    if (ok && length(partes) > 1 && grepl("\\.md$", arq)) {
      tit <- grep("^#{1,6} ", ler(arq), value = TRUE)
      ok <- partes[2] %in% vapply(tit, slug, "")
    }
    if (!ok) quebrados <- c(quebrados, sprintf("%s -> %s", basename(f), a))
  }
}
add("global", "links", 3, length(quebrados) == 0)

aud <- ler(file.path(RAIZ, "prova", "auditoria_final.md"))
tudo <- paste(aud, collapse = "\n")
add("auditoria", "matriz", 2, length(aud) && all(vapply(1:16, function(q) grepl(sprintf("\\bQ%d\\b", q), tudo, perl = TRUE), logical(1))))
for (x in c("A", "B", "C", "D")) {
  i <- grep(sprintf("^### Questão provável %s\\b", x), aud)
  s <- if (length(i)) { b <- grep("^#{2,3} ", aud); aud[i:(min(c(b[b > i], length(aud) + 1)) - 1)] } else character()
  passos <- grep("^\\s*[0-9]+\\. .*\\]\\(", s, value = TRUE)
  add(paste("fio", x), "fio", 2, length(passos) >= 4)
}
folha <- ler(file.path(RAIZ, "prova", "o_que_cai.md"))
notas <- unique(unlist(regmatches(folha, gregexpr("lista_comentada/q[0-9]{2}\\.md", folha))))
add("folha", "liga_lista", 2, length(notas) >= 8)
ft <- paste(folha, collapse = "\n")
add("folha", "divergencias", 2, grepl("Da lista \\(Q11\\)", ft) && grepl("Da lista \\(Q12\\)", ft) &&
      grepl("(1,1,0)(0,1,1)", ft, fixed = TRUE))
man <- ler(file.path(RAIZ, "caderno", "volume_completo.tsv")); rd <- ler(file.path(RAIZ, "prova", "README.md"))
add("integracao", "manifesto_readme", 1, any(grepl("prova/auditoria_final.md", man, fixed = TRUE)) &&
      any(grepl("auditoria_final.md", head(rd, 40), fixed = TRUE)))

it <- do.call(rbind, itens)
cat("---\n")
for (q in unique(it$qt)) { x <- it[it$qt == q, ]; cat(sprintf("%-12s %5.1f\n", q, 100 * sum(x$peso * x$ok) / sum(x$peso))) }
cat(sprintf("nota_auditoria: %5.1f\n", 100 * sum(it$peso * it$ok) / sum(it$peso)))
if (length(quebrados)) { cat("links quebrados:\n"); cat(paste0("  ", head(quebrados, 40)), sep = "\n") }
f <- it[!it$ok, ]
if (nrow(f)) { cat("lacunas:\n"); for (j in seq_len(nrow(f))) cat(sprintf("  %s  %s (%g)\n", f$qt[j], f$criterio[j], f$peso[j])) }

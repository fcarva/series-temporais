# Avaliador fixo da folha "o que cai" (prova/o_que_cai.md): NÃO EDITAR durante o loop.
#
# Processos avaliados: as seções "## N. ..." de PROCESSOS (AR(1), SMA, previsão do SARIMA,
# critérios, ordem pela FAC, regressão do Dickey-Fuller e os casos do Dickey-Fuller).
# Critérios por processo (peso):
#   estrutura (1) — "**Enunciado" e, nesta ordem, "### Antes de escrever", "### Linha a linha",
#                   "### O sentido de cada linha";
#   linhas (2)    — 7+ linhas \text{(n)}, todas com justificativa "&& [";
#   sentido (3)   — todo (n) das linhas aparece como "**(n)**" no sentido (item agrupado não conta);
#   spoiler (2)   — nada de "Frase de fecho" nem "Resposta" antes do "### Linha a linha";
#   fecho (1)     — uma linha "**Frase de fecho:**", depois do "### Linha a linha";
#   caderno (1)   — uma linha "**Do meu caderno" com a data da aula (dd/mm);
#   fonte (1)     — cita a página do professor ou do Mattos: "AU0x, p. N" ou "MAT, p. N";
#   treino (1)    — uma subseção "### Tente" com "**Resposta" depois dela.
# Globais (peso 2): todas as chaves chave_R da folha existem em resultados/; a nota do volume
#   (avaliar_volume.R) fica em 99,8 ou mais; o Dickey-Fuller traz o caso real do INPC e a
#   notação dupla (lambda do Mattos e gamma do Enders).
# Rodar: Rscript autoestudo/avaliar_oque.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))
RAIZ <- raiz()
arq <- file.path(RAIZ, "prova", "o_que_cai.md")
l <- if (file.exists(arq)) readLines(arq, encoding = "UTF-8", warn = FALSE) else character()

PROCESSOS <- c("AR\\(1\\)", "SMA\\(1\\)", "previsão", "Interpretar AIC", "Identificar a ordem",
               "raiz unitária", "casos")
itens <- list()
add <- function(qt, crit, peso, ok) itens[[length(itens) + 1]] <<- data.frame(qt = qt, criterio = crit, peso = peso, ok = isTRUE(ok))

ini <- grep("^## [0-9]+\\. ", l)
fim <- c(ini[-1] - 1, length(l))
titulos <- l[ini]
for (p in PROCESSOS) {
  k <- grep(p, titulos, perl = TRUE)[1]
  s <- if (is.na(k)) character() else l[ini[k]:fim[k]]
  nome <- sub("\\\\", "", sub("\\\\\\(1\\\\\\)", "(1)", p))
  pos <- function(re) { x <- grep(re, s, perl = TRUE); if (length(x)) x[1] else NA }
  pe <- pos("\\*\\*Enunciado"); pa <- pos("^### Antes de escrever"); pl <- pos("^### Linha a linha")
  ps <- pos("^### O sentido de cada linha")
  add(nome, "estrutura", 1, !any(is.na(c(pe, pa, pl, ps))) && pe < pa && pa < pl && pl < ps)
  num <- grep("\\\\text\\{\\([0-9]+\\)\\}", s, value = TRUE)
  ns <- as.integer(sub(".*\\\\text\\{\\(([0-9]+)\\)\\}.*", "\\1", num))
  add(nome, "linhas", 2, length(num) >= 7 && all(grepl("&&\\s*\\[", num)))
  b <- grep("^### ", s)
  sent <- if (!is.na(ps)) s[ps:(min(c(b[b > ps], length(s) + 1)) - 1)] else character()
  ditos <- as.integer(unlist(regmatches(sent, gregexpr("(?<=\\*\\*\\()[0-9]+(?=\\)\\*\\*)", sent, perl = TRUE))))
  add(nome, "sentido", 3, length(ns) >= 7 && all(ns %in% ditos))
  antes <- if (!is.na(pl)) s[seq_len(pl - 1)] else s
  add(nome, "spoiler", 2, !is.na(pl) && !any(grepl("Frase de fecho|\\*\\*Resposta", antes)))
  pf <- pos("\\*\\*Frase de fecho:\\*\\*")
  add(nome, "fecho", 1, !is.na(pf) && !is.na(pl) && pf > pl)
  add(nome, "caderno", 1, any(grepl("^\\*\\*Do meu caderno.*[0-9]{2}/[0-9]{2}", s)))
  add(nome, "fonte", 1, any(grepl("(AU0[1-5]|MAT), p\\. ?[0-9]", s)))
  pt <- pos("^### Tente"); pr <- grep("\\*\\*Resposta", s)
  add(nome, "treino", 1, !is.na(pt) && any(pr > pt))
}

# globais
tab <- grep("^\\|\\s*[a-z]+_[A-Za-z0-9_]+\\s*\\|", l, value = TRUE)
chaves <- trimws(sub("^\\|\\s*([A-Za-z0-9_]+)\\s*\\|.*", "\\1", tab))
chaves <- setdiff(chaves, "chave_R")
res <- unlist(lapply(list.files(file.path(RAIZ, "resultados"), pattern = "\\.csv$", full.names = TRUE),
                     function(f) sub(",.*", "", readLines(f, warn = FALSE))))
add("global", "chaves", 2, length(chaves) >= 30 && all(chaves %in% res))
vol <- tryCatch(system2(file.path(R.home("bin"), "Rscript"), file.path(RAIZ, "autoestudo", "avaliar_volume.R"),
                        stdout = TRUE, stderr = FALSE), error = function(e) character())
nv <- suppressWarnings(as.numeric(sub(".*:\\s*", "", grep("^nota_volume", vol, value = TRUE))))
add("global", "volume>=99.8", 2, length(nv) == 1 && !is.na(nv) && nv >= 99.8)
k <- grep("raiz unitária|casos", titulos)
df <- if (length(k)) unlist(Map(function(a, b) l[a:b], ini[k], fim[k])) else character()
add("global", "df_inpc_notacao", 2, any(grepl("INPC", df)) && any(grepl("\\\\lambda", df)) && any(grepl("\\\\gamma", df)))

it <- do.call(rbind, itens)
cat("---\n")
for (q in unique(it$qt)) { x <- it[it$qt == q, ]; cat(sprintf("%-20s %5.1f\n", q, 100 * sum(x$peso * x$ok) / sum(x$peso))) }
cat(sprintf("nota_oque: %5.1f\n", 100 * sum(it$peso * it$ok) / sum(it$peso)))
f <- it[!it$ok, ]
if (nrow(f)) { cat("lacunas:\n"); for (j in seq_len(min(60, nrow(f)))) cat(sprintf("  %s  %s (%g)\n", f$qt[j], f$criterio[j], f$peso[j])) }

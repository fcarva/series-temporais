# Avaliador fixo do guia "não posso errar" (prova/nao_posso_errar.md): NÃO EDITAR durante o loop.
#
# Cada questão-tipo é uma seção "## N · ..." do guia (régua: autoestudo/guia_rubrica.tsv).
# Critérios por questão-tipo (peso):
#   secoes (1)  — as seis subseções: O que a questão quer, Antes de escrever, Linha a linha,
#                 O sentido de cada linha, Erro que não pode, Treino;
#   linhas (2)  — 8+ linhas \text{(n)}, todas com justificativa [...];
#   sentido (3) — todo (n) das linhas aparece como "**(n)**" na lista do sentido;
#   fecho (1)   — uma linha "**Frase de fecho:**";
#   numeros (2) — 3+ chaves pv_/ap_/lc_ numa tabela chave_R;
#   ligacoes (1)— liga a nota comentada da questão da lista e a folha à mão do bloco;
#   treino (1)  — liga uma variação do banco (banco.md#);
#   erro_s1 (1) — quando a régua pede: liga o log de erros ou a correção do S1.
# Globais (peso 2): as contas e moldes do básico aparecem; o guia está no manifesto do volume;
#   a nota do volume (avaliar_volume.R) fica em 99,8 ou mais.
# Rodar: Rscript autoestudo/avaliar_guia.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))
RAIZ <- raiz()
rub <- utils::read.delim(file.path(RAIZ, "autoestudo", "guia_rubrica.tsv"), quote = "", stringsAsFactors = FALSE,
                         encoding = "UTF-8", colClasses = "character")
arq <- file.path(RAIZ, "prova", "nao_posso_errar.md")
l <- if (file.exists(arq)) readLines(arq, encoding = "UTF-8", warn = FALSE) else character()

itens <- list()
add <- function(qt, crit, peso, ok) itens[[length(itens) + 1]] <<- data.frame(qt = qt, criterio = crit, peso = peso, ok = isTRUE(ok))
conta <- function(re, x) sum(lengths(regmatches(x, gregexpr(re, x, perl = TRUE))))
SUBSECOES <- c("O que a questão quer", "Antes de escrever", "Linha a linha", "O sentido de cada linha",
               "Erro que não pode", "Treino")

ini <- grep("^## [0-9]+ · ", l)
fim <- c(ini[-1] - 1, length(l))
secao <- setNames(Map(function(a, b) l[a:b], ini, fim), sub("^## ([0-9]+) · .*", "\\1", l[ini]))

for (i in seq_len(nrow(rub))) {
  q <- rub$qt[i]; s <- secao[[q]]
  if (is.null(s)) s <- character()
  sub3 <- grep("^### ", s, value = TRUE)
  add(q, "secoes", 1, length(s) && all(vapply(SUBSECOES, function(t) any(grepl(t, sub3, fixed = TRUE)), logical(1))))
  num <- grep("\\\\text\\{\\([0-9]+\\)\\}", s, value = TRUE)
  ns <- as.integer(sub(".*\\\\text\\{\\(([0-9]+)\\)\\}.*", "\\1", num))
  add(q, "linhas", 2, length(num) >= 8 && all(grepl("&&\\s*\\[", num)))
  a <- grep("^### O sentido de cada linha", s); b <- grep("^### ", s)
  sent <- if (length(a)) s[a:(min(c(b[b > a], length(s) + 1)) - 1)] else character()
  ditos <- as.integer(unlist(regmatches(sent, gregexpr("(?<=\\*\\*\\()[0-9]+(?=\\)\\*\\*)", sent, perl = TRUE))))
  add(q, "sentido", 3, length(ns) >= 8 && all(ns %in% ditos))
  add(q, "fecho", 1, any(grepl("\\*\\*Frase de fecho:\\*\\*", s)))
  add(q, "numeros", 2, conta("^\\|\\s*(pv|ap|lc)_[A-Za-z0-9_]+\\s*\\|", s) >= 3)
  qs <- as.integer(strsplit(rub$lista[i], ";")[[1]])
  add(q, "ligacoes", 1, any(vapply(qs, function(k) any(grepl(sprintf("lista_comentada/q%02d\\.md", k), s)), logical(1))) &&
        any(grepl(sprintf("a_mao_cap%s\\.md", rub$bloco[i]), s)))
  add(q, "treino", 1, any(grepl("banco\\.md#", s)))
  if (rub$erro_s1[i] == "1") add(q, "erro_s1", 1, any(grepl("log_erros\\.md|correcao_simulado_01\\.md", s)))
}

tudo <- paste(l, collapse = "\n")
basico <- c("telesc", "quatro movimentos", "Bhaskara", "AIC", "BIC", "\\\\widehat\\\\phi", "d\\+sD", "1\\{,\\}96")
add("global", "basico", 2, all(vapply(basico, function(r) grepl(r, tudo, perl = TRUE), logical(1))))
man <- readLines(file.path(RAIZ, "caderno", "volume_completo.tsv"), encoding = "UTF-8", warn = FALSE)
add("global", "manifesto", 2, any(grepl("prova/nao_posso_errar.md", man, fixed = TRUE)))
vol <- tryCatch(system2(file.path(R.home("bin"), "Rscript"), file.path(RAIZ, "autoestudo", "avaliar_volume.R"),
                        stdout = TRUE, stderr = FALSE), error = function(e) character())
nv <- suppressWarnings(as.numeric(sub(".*:\\s*", "", grep("^nota_volume", vol, value = TRUE))))
add("global", "volume>=99.8", 2, length(nv) == 1 && !is.na(nv) && nv >= 99.8)

it <- do.call(rbind, itens)
cat("---\n")
for (q in unique(it$qt)) { x <- it[it$qt == q, ]; cat(sprintf("questão-tipo %-6s %5.1f\n", q, 100 * sum(x$peso * x$ok) / sum(x$peso))) }
cat(sprintf("nota_guia: %5.1f\n", 100 * sum(it$peso * it$ok) / sum(it$peso)))
f <- it[!it$ok, ]
if (nrow(f)) { cat("lacunas:\n"); for (j in seq_len(min(30, nrow(f)))) cat(sprintf("  %s  %s (%g)\n", f$qt[j], f$criterio[j], f$peso[j])) }

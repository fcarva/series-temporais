# Avaliador fixo do autoestudo (o "prepare.py" do autoresearch): NÃO EDITAR durante o loop.
#
# Métrica principal: cobertura (%) dos tópicos das aulas listados em autoestudo/topicos.tsv,
# ponderada por peso. Um tópico só conta como coberto se aparece numa seção SUBSTANTIVA
# de uma nota do(s) módulo(s) indicado(s): uma seção (## a ####) que contém uma derivação
# ("Passo a passo", \boxed), uma resolução ("Solução") ou números conferidos (tabela chave_R).
# Mencionar o termo de passagem não conta: isso evita encher as notas de palavras-chave.
#
# Saída: um resumo no formato "chave: valor" e autoestudo/cobertura.tsv (não versionado),
# com o status de cada tópico, para escolher o próximo experimento.
# Rodar: Rscript autoestudo/avaliar.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

RAIZ <- raiz()
top <- utils::read.delim(file.path(RAIZ, "autoestudo", "topicos.tsv"), quote = "", stringsAsFactors = FALSE,
                         encoding = "UTF-8")

# seções de uma nota: lista de vetores de linhas, cada um começando no seu cabeçalho
secoes <- function(arq) {
  l <- readLines(arq, warn = FALSE, encoding = "UTF-8")
  ini <- c(1, grep("^#{2,4}\\s", l)); fim <- c(ini[-1] - 1, length(l))
  Map(function(a, b) l[a:b], ini, fim)
}
substantiva <- function(s) any(grepl("Passo a passo|\\\\boxed|\\*\\*Solução|chave_R", s))

notas_de <- function(mods) {
  unlist(lapply(strsplit(mods, ";")[[1]], function(m)
    list.files(file.path(RAIZ, m), pattern = "\\.md$", full.names = TRUE)))
}

top$coberto <- top$mencionado <- FALSE; top$secoes <- 0L
for (i in seq_len(nrow(top))) {
  for (arq in notas_de(top$modulos[i])) {
    for (s in secoes(arq)) {
      if (any(grepl(top$regex[i], s, perl = TRUE, ignore.case = TRUE))) {
        top$mencionado[i] <- TRUE
        if (substantiva(s)) { top$coberto[i] <- TRUE; top$secoes[i] <- top$secoes[i] + 1L }
      }
    }
  }
}

mds <- list.files(RAIZ, pattern = "\\.md$", recursive = TRUE, full.names = TRUE)
mds <- mds[grepl("/[0-9]{2}_[^/]+/|/trabalho_inpc/", mds)]
txt <- unlist(lapply(mds, readLines, warn = FALSE, encoding = "UTF-8"))
n_demos <- sum(grepl("^###\\s+D[0-9]{2}\\.[0-9]+", txt))
n_numeros <- sum(grepl("^\\|\\s*[a-z0-9]+_[A-Za-z0-9_]+\\s*\\|", txt))

cob <- 100 * sum(top$peso * top$coberto) / sum(top$peso)
men <- 100 * sum(top$peso * top$mencionado) / sum(top$peso)
utils::write.table(top[order(top$coberto, -top$peso), c("id", "fonte", "topico", "modulos", "peso", "mencionado", "coberto", "secoes")],
                   file.path(RAIZ, "autoestudo", "cobertura.tsv"), sep = "\t", row.names = FALSE, quote = FALSE,
                   fileEncoding = "UTF-8")

cat("---\n")
cat(sprintf("cobertura:        %.1f\n", cob))
cat(sprintf("mencionados:      %.1f\n", men))
cat(sprintf("topicos:          %d (%d cobertos)\n", nrow(top), sum(top$coberto)))
cat(sprintf("demonstracoes:    %d\n", n_demos))
cat(sprintf("numeros_R:        %d\n", n_numeros))
falta <- top[!top$coberto, ]; falta <- falta[order(-falta$peso), ]
if (nrow(falta)) {
  cat("lacunas (peso, id, tópico, onde):\n")
  for (j in seq_len(nrow(falta)))
    cat(sprintf("  %d  %s  %s  [%s]%s\n", falta$peso[j], falta$id[j], falta$topico[j], falta$modulos[j],
                if (falta$mencionado[j]) "  (só mencionado)" else ""))
}

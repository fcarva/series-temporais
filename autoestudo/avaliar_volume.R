# Avaliador fixo do volume único da P1 (modo volume do autoestudo): NÃO EDITAR durante o loop.
#
# Lê só o que vai para o papel: as fontes de caderno/volume_completo.tsv, com o mesmo seletor
# "arquivo.md::trecho do título" do builder. Mede a sinergia do volume em seis dimensões
# (pesos em autoestudo/volume_rubrica.tsv):
#   camadas  — Q1–Q16 x {apostila, folha à mão, comentada, banco, simulado/gabarito};
#   slides   — páginas de conteúdo de AU01 (p. 5–50), AU02 (p. 3–99) e AU03 (p. 4–60) citadas
#              ("AU02, p. 27–28", "AU02 p. 33", listas com vírgula e "e");
#   mat      — seções 1.1–1.11 e 2.1–2.6 do MAT citadas (por § ou por página);
#   topicos  — T01–T50 de autoestudo/topicos.tsv numa seção substantiva do volume;
#   livros   — ENDERS, HAMILTON e BJRL citados com capítulo em cada bloco 1–6;
#   caderno  — os seis erros do caderno sinalizados ("erro do caderno") na folha à mão do bloco.
# Saída: nota por dimensão e total; autoestudo/cobertura_volume.tsv (fora do git).
# Rodar: Rscript autoestudo/avaliar_volume.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))
RAIZ <- raiz()
ler_tsv <- function(...) utils::read.delim(file.path(RAIZ, ...), quote = "", stringsAsFactors = FALSE,
                                           encoding = "UTF-8", na.strings = character())
man <- ler_tsv("caderno", "volume_completo.tsv")
rub <- ler_tsv("autoestudo", "volume_rubrica.tsv")
PESO <- setNames(rub$peso, rub$dimensao)

# o mesmo recorte do builder (caderno/montar_caderno.R)
ler_fonte <- function(rel) {
  p <- strsplit(rel, "::", fixed = TRUE)[[1]]
  l <- readLines(file.path(RAIZ, p[1]), encoding = "UTF-8", warn = FALSE)
  if (length(l) && l[1] == "---") l <- l[-(1:which(l == "---")[2])]
  if (length(p) == 1) return(l)
  cab <- grep("^#{1,6} ", l)
  ini <- cab[vapply(cab, function(i) grepl(p[2], l[i], fixed = TRUE), logical(1))][1]
  niv <- nchar(sub("^(#+) .*", "\\1", l[ini]))
  dep <- cab[cab > ini & nchar(sub("^(#+) .*", "\\1", l[cab])) <= niv]
  l[ini:(if (length(dep)) dep[1] - 1 else length(l))]
}
TXT <- lapply(man$fonte, ler_fonte); names(TXT) <- man$fonte
tudo <- unlist(TXT)
BLOCO <- c(rep(1, 4), rep(2, 4), rep(3, 4), 4, 4, 5, 6)
parte_de <- function(b) grep(sprintf("^Bloco %d ", b), man$parte)
itens <- list()
add <- function(dim, item, ok) itens[[length(itens) + 1]] <<- data.frame(dimensao = dim, item = item, ok = ok)

## camadas por questão
treino <- unlist(TXT[grepl("^prova/simulado_", man$fonte)])
for (q in 1:16) {
  b <- BLOCO[q]; rows <- parte_de(b)
  cap <- unlist(TXT[rows[grepl("^apostila/cap", man$fonte[rows])]])
  folha <- unlist(TXT[rows[grepl("a_mao", man$fonte[rows])]])
  banco <- unlist(TXT[rows[grepl("^prova/banco", man$fonte[rows])]])
  add("camadas", sprintf("Q%d apostila", q), any(grepl(sprintf("lista_comentada/q%02d\\.md", q), cap)))
  add("camadas", sprintf("Q%d folha", q), any(grepl(sprintf("^#{1,2} .*\\bQ%d\\b", q), folha)))
  add("camadas", sprintf("Q%d comentada", q), sprintf("lista_comentada/q%02d.md", q) %in% man$fonte)
  add("camadas", sprintf("Q%d banco", q), any(grepl(sprintf("^#{2,3} Q%d\\b", q), banco)))
  add("camadas", sprintf("Q%d simulado", q), any(grepl(sprintf("lista, Q%d\\b|Q%d da lista", q, q), treino)))
}

## slides citados
paginas_citadas <- function(au, x) {
  m <- regmatches(x, gregexpr(paste0(au, ",? p\\.? ?[0-9][0-9–, e-]*"), x))[[1]]
  out <- integer()
  for (s in m) {
    s <- sub(".*p\\.? ?", "", s)
    for (pe in strsplit(s, ",\\s*|\\s+e\\s+")[[1]]) {
      n <- as.integer(regmatches(pe, gregexpr("[0-9]+", pe))[[1]])
      if (length(n) == 1) out <- c(out, n) else if (length(n) >= 2 && n[2] >= n[1]) out <- c(out, n[1]:n[2])
    }
  }
  unique(out)
}
paginas_conteudo <- function(au, tot) {
  f <- file.path(RAIZ, "materiais", "_txt", paste0(au, ".txt"))
  if (!file.exists(f)) return(NULL)
  pg <- list(); buf <- character()
  for (ln in readLines(f, encoding = "UTF-8", warn = FALSE)) {
    if (grepl(sprintf("[0-9]+ / %d\\s*$", tot), ln)) { pg[[sub(".*?([0-9]+) / .*", "\\1", ln)]] <- buf; buf <- character(); next }
    buf <- c(buf, ln)
  }
  w <- vapply(pg, function(b) length(strsplit(paste(b, collapse = " "), "\\s+")[[1]]), numeric(1))
  as.integer(names(w)[w >= 40])
}
texto <- paste(tudo, collapse = "\n")
for (s in list(c("AU01", 50, 5), c("AU02", 99, 3), c("AU03", 60, 4))) {
  cont <- paginas_conteudo(s[1], as.integer(s[2]))
  if (is.null(cont)) { message("aviso: materiais/_txt/", s[1], ".txt ausente; slides de ", s[1], " fora da nota"); next }
  cont <- cont[cont >= as.integer(s[3])]
  cit <- paginas_citadas(s[1], texto)
  for (p in sort(cont)) add("slides", sprintf("%s p. %d", s[1], p), p %in% cit)
}

## MAT: seções por § ou por página (sumário do texto)
MAT <- data.frame(sec = c(paste0("1.", 1:11), paste0("2.", 1:6)),
                  ini = c(1, 4, 6, 8, 9, 11, 11, 14, 14, 15, 16, 17, 19, 29, 32, 35, 38),
                  fim = c(3, 5, 7, 8, 10, 11, 13, 14, 14, 15, 16, 18, 28, 31, 34, 37, 39))
cit_mat <- paginas_citadas("MAT", texto)
for (i in seq_len(nrow(MAT))) {
  por_sec <- grepl(sprintf("MAT,? §%s\\b", gsub(".", "\\.", MAT$sec[i], fixed = TRUE)), texto)
  add("mat", paste("MAT §", MAT$sec[i]), por_sec || any(cit_mat >= MAT$ini[i] & cit_mat <= MAT$fim[i]))
}

## tópicos das aulas numa seção substantiva
top <- ler_tsv("autoestudo", "topicos.tsv"); top <- top[as.integer(sub("T", "", top$id)) <= 50, ]
secoes <- unlist(lapply(TXT, function(l) {
  ini <- c(1, grep("^#{1,4}\\s", l)); fim <- c(ini[-1] - 1, length(l))
  Map(function(a, b) l[a:b], ini, fim)
}), recursive = FALSE)
subst <- secoes[vapply(secoes, function(s) any(grepl("Passo a passo|\\\\boxed|\\*\\*Solução|chave_R|\\\\text\\{\\([0-9]+\\)\\}", s)), logical(1))]
for (i in seq_len(nrow(top))) {
  ok <- any(vapply(subst, function(s) any(grepl(top$regex[i], s, perl = TRUE, ignore.case = TRUE)), logical(1)))
  itens[[length(itens) + 1]] <- data.frame(dimensao = "topicos", item = paste(top$id[i], top$topico[i]), ok = ok,
                                           peso_item = top$peso[i])
}

## livros com capítulo, por bloco
for (b in 1:6) {
  tx <- unlist(TXT[parte_de(b)])
  for (lv in c("ENDERS", "HAMILTON", "BJRL"))
    add("livros", sprintf("bloco %d %s", b, lv), any(grepl(sprintf("%s[^\\n]{0,40}cap(s)?\\.\\s?[0-9]", lv), tx)))
}

## os erros do caderno sinalizados na folha à mão do bloco
ERROS <- list(c(1, "E(XY)", "caderno.*E\\(XY\\)|E\\(XY\\).*caderno"),
              c(1, "AR(1) recursivo sem y_0", "caderno.*y_0|y_0.*caderno"),
              c(1, "MA(1) -> AR(inf) com sinal", "caderno.*(altern|-\\\\theta_1\\^2)"),
              c(2, "gamma_0 do ARMA(1,1) sem o quadrado", "caderno.*(quadrado|\\\\theta_1\\^2)"),
              c(2, "AR(2) com o sinal de phi_2", "caderno.*(sinal|\\\\phi_2)"),
              c(5, "previsão do MA(2) mistura horizontes", "caderno.*(horizont|\\\\theta_2)"))
for (e in ERROS) {
  rows <- parte_de(as.integer(e[1])); folha <- unlist(TXT[rows[grepl("a_mao", man$fonte[rows])]])
  aviso <- grepl("erro do caderno|caderno (errou|escreve|pôs|trocou)", folha, ignore.case = TRUE)
  add("caderno", e[2], any(aviso & grepl(e[3], folha, ignore.case = TRUE)))
}

it <- do.call(rbind, lapply(itens, function(d) { if (is.null(d$peso_item)) d$peso_item <- 1; d }))
it$peso <- PESO[it$dimensao] * it$peso_item
utils::write.table(it[order(it$ok, it$dimensao), c("dimensao", "item", "peso", "ok")],
                   file.path(RAIZ, "autoestudo", "cobertura_volume.tsv"), sep = "\t", row.names = FALSE,
                   quote = FALSE, fileEncoding = "UTF-8")
cat("---\n")
for (d in unique(it$dimensao)) {
  x <- it[it$dimensao == d, ]
  cat(sprintf("%-9s %5.1f   (%d de %d)\n", d, 100 * sum(x$peso * x$ok) / sum(x$peso), sum(x$ok), nrow(x)))
}
cat(sprintf("nota_volume: %5.1f\n", 100 * sum(it$peso * it$ok) / sum(it$peso)))
f <- it[!it$ok, ]; f <- f[order(-f$peso), ]
if (nrow(f)) { cat("lacunas (peso, dimensão, item):\n"); for (j in seq_len(min(40, nrow(f)))) cat(sprintf("  %g  %s  %s\n", f$peso[j], f$dimensao[j], f$item[j])) }

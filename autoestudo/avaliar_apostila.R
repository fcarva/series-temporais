# Avaliador fixo da apostila (modo apostila do autoestudo): NÃO EDITAR durante o loop.
#
# Régua: autoestudo/apostila_rubrica.tsv, uma linha por capítulo x item, com peso.
#   - "elemento": cada capítulo tem nove seções obrigatórias (## Pergunta de abertura, ## A imagem,
#     ## Teoria, ## Demonstrações, ## Exemplo, ## Cadeia socrática, ## Diálogo, ## Na prova,
#     ## No material do professor), e cada uma só conta se cumpre o critério mínimo abaixo;
#   - "topico": a regex precisa aparecer em Teoria, Demonstrações ou Exemplo (não vale citar de
#     passagem na abertura ou na prova).
# Nota: soma dos pesos cumpridos / soma dos pesos, por capítulo e no total.
# Saída: resumo "chave: valor" e autoestudo/cobertura_apostila.tsv (fora do git).
# Rodar: Rscript autoestudo/avaliar_apostila.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

RAIZ <- raiz()
rub <- utils::read.delim(file.path(RAIZ, "autoestudo", "apostila_rubrica.tsv"), quote = "",
                         stringsAsFactors = FALSE, encoding = "UTF-8")

TITULOS <- c(abertura = "Pergunta de abertura", imagem = "A imagem", teoria = "Teoria",
             demonstracoes = "Demonstrações", exemplo = "Exemplo", socratica = "Cadeia socrática",
             dialogo = "Diálogo", prova = "Na prova", professor = "No material do professor")

# seções de nível 2 de um capítulo: nome -> linhas (inclui as subseções ### e ####)
secoes2 <- function(l) {
  ini <- grep("^##\\s", l); if (!length(ini)) return(list())
  fim <- c(ini[-1] - 1, length(l))
  s <- Map(function(a, b) l[a:b], ini, fim)
  names(s) <- trimws(sub("^##\\s+", "", l[ini])); s
}
palavras <- function(x) length(strsplit(paste(x, collapse = " "), "\\s+")[[1]])
conta <- function(re, x) sum(lengths(regmatches(x, gregexpr(re, x, perl = TRUE))))
citacoes_aula <- function(x) conta("(AU0[0-9]|MAT|EQD),? p\\. ?[0-9]", x)

criterio <- function(e, s, cap_q) {
  if (is.null(s)) return(FALSE)
  switch(e,
    abertura = any(grepl("\\?", s)) && palavras(s) >= 40,
    imagem = any(grepl("onde a analogia quebra", s, ignore.case = TRUE)) && palavras(s) >= 120,
    teoria = citacoes_aula(s) >= 3 && any(grepl("^\\$\\$", s)),
    demonstracoes = {
      sub_ini <- grep("^###\\s", s)
      blocos <- Map(function(a, b) s[a:b], sub_ini, c(sub_ini[-1] - 1, length(s)))
      ok <- vapply(blocos, function(b) conta("\\\\text\\{\\([0-9]+\\)\\}", b) >= 6, logical(1))
      sum(ok) >= 2 && conta("\\\\boxed", s) >= 2
    },
    exemplo = conta("^\\|\\s*ap_[A-Za-z0-9_]+\\s*\\|", s) >= 4,
    socratica = {
      p <- grep("^\\*\\*P[0-9]+\\.\\*\\*.*\\?", s)
      sum(vapply(p, function(i) any(grepl("^> \\[!TIP\\]", s[(i + 1):min(i + 6, length(s))])), logical(1))) >= 6
    },
    dialogo = {
      pr <- conta("^\\*\\*Professor:\\*\\*", s); al <- conta("^\\*\\*Alun[oa]:\\*\\*", s)
      pr >= 4 && al >= 4
    },
    prova = all(vapply(cap_q, function(q) any(grepl(sprintf("lista_comentada/q%02d\\.md", q), s)), logical(1))) &&
      any(grepl("[Cc]hecklist", s)),
    professor = citacoes_aula(s) >= 3 && any(grepl("BJRL|ENDERS|HAMILTON|Hamilton|Enders|Box", s)),
    FALSE)
}

# "a_mao": a folha de caderno do capítulo, apostila/a_mao_capN.md, ligada pelo capítulo, com
#   >= 40 linhas numeradas \text{(n)}, >= 90% delas com justificativa entre colchetes [...],
#   uma seção (# ou ##) por questão do bloco ("Q5", "Q6"...), "Versão para a prova" e
#   "Conferência" com >= 4 números ap_* numa tabela chave_R.
a_mao_ok <- function(cap, l_cap, qs) {
  n <- sub("^(cap[0-9]).*", "\\1", cap); f <- paste0("a_mao_", n, ".md")
  arq <- file.path(RAIZ, "apostila", f)
  if (!file.exists(arq) || !any(grepl(f, l_cap, fixed = TRUE))) return(FALSE)
  l <- readLines(arq, warn = FALSE, encoding = "UTF-8")
  num <- grep("\\\\text\\{\\([0-9]+\\)\\}", l, value = TRUE)
  just <- grepl("&&\\s*\\[|\\\\qquad\\s*\\[", num)
  cab <- grep("^#{1,2}\\s", l, value = TRUE)
  length(num) >= 40 && mean(just) >= 0.9 &&
    all(vapply(qs, function(q) any(grepl(sprintf("\\bQ%d\\b", q), cab)), logical(1))) &&
    any(grepl("^#{1,3}\\s+Versão para a prova", l)) && any(grepl("^#{1,3}\\s+Conferência", l)) &&
    sum(grepl("^\\|\\s*ap_[A-Za-z0-9_]+\\s*\\|", l)) >= 4
}

QUESTOES <- list(cap1_processos_momentos = 1:4, cap2_ar_ma_arma = 5:8, cap3_integrados_sarima = 9:12,
                 cap4_estimacao_selecao = 13:14, cap5_previsao = 15, cap6_aplicacao = 16)

rub$ok <- FALSE
for (cap in unique(rub$cap)) {
  arq <- file.path(RAIZ, "apostila", paste0(cap, ".md"))
  if (!file.exists(arq)) next
  l <- readLines(arq, warn = FALSE, encoding = "UTF-8")
  s <- secoes2(l)
  nucleo <- unlist(s[intersect(names(s), TITULOS[c("teoria", "demonstracoes", "exemplo")])])
  for (i in which(rub$cap == cap)) {
    rub$ok[i] <- if (rub$tipo[i] == "elemento" && rub$alvo[i] == "a_mao") {
      a_mao_ok(cap, l, QUESTOES[[cap]])
    } else if (rub$tipo[i] == "elemento") {
      criterio(rub$alvo[i], s[[TITULOS[[rub$alvo[i]]]]], QUESTOES[[cap]])
    } else any(grepl(rub$alvo[i], nucleo, perl = TRUE, ignore.case = TRUE))
  }
}

utils::write.table(rub[order(rub$ok, -rub$peso), ], file.path(RAIZ, "autoestudo", "cobertura_apostila.tsv"),
                   sep = "\t", row.names = FALSE, quote = FALSE, fileEncoding = "UTF-8")

cat("---\n")
for (cap in unique(rub$cap)) {
  r <- rub[rub$cap == cap, ]
  cat(sprintf("%-26s %5.1f\n", cap, 100 * sum(r$peso * r$ok) / sum(r$peso)))
}
cat(sprintf("nota_apostila:             %5.1f\n", 100 * sum(rub$peso * rub$ok) / sum(rub$peso)))
falta <- rub[!rub$ok, ]; falta <- falta[order(-falta$peso), ]
if (nrow(falta)) {
  cat("lacunas (peso, capítulo, tipo, item):\n")
  for (j in seq_len(min(nrow(falta), 40)))
    cat(sprintf("  %d  %s  %s  %s\n", falta$peso[j], falta$cap[j], falta$tipo[j], falta$alvo[j]))
}

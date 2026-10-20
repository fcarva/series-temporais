# Monta o caderno de estudo em PDF a partir das notas Markdown do repositório.
#   Volume 1 — revisão, convenções e teoria (módulos 01–03, mais a teoria de 04 e 05)
#   Volume 2 — a lista de exercícios resolvida (Q1–Q16)
#   Volume 3 — o trabalho em dupla do INPC (roteiro e relatório)
#
# Caminho: nota .md -> preparo em R (tira o frontmatter, resolve caminhos de figura,
# troca emoji por símbolo) -> pandoc (commonmark_x + filtros.lua) -> .tex -> LuaLaTeX.
# Requer pandoc e LuaLaTeX (TeX Live ou MiKTeX).
#
# Rodar: Rscript caderno/montar_caderno.R  (Windows: scripts\r.ps1 caderno\montar_caderno.R)
#        argumentos opcionais: teoria, lista, trabalho; sem argumento, tudo
# Saída: caderno/pdf/ (fora do git, como todo PDF)

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

RAIZ <- normalizePath(raiz(), winslash = "/")
CAD <- file.path(RAIZ, "caderno")
BUILD <- file.path(CAD, "_build")
SAIDA <- file.path(CAD, "pdf")
dir.create(BUILD, showWarnings = FALSE)
dir.create(SAIDA, showWarnings = FALSE)

## ---- ferramentas ----------------------------------------------------------------
primeiro_existente <- function(x) {
  x <- x[nzchar(x)]
  x <- x[file.exists(x)]
  if (length(x)) gsub("\\\\", "/", x[1]) else ""   # sem resolver links: lualatex -> luahbtex perderia o formato
}
PANDOC <- primeiro_existente(c(
  Sys.which("pandoc"),
  file.path(Sys.getenv("RSTUDIO_PANDOC"), "pandoc.exe"),
  "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools/pandoc.exe",
  "C:/Program Files/Quarto/bin/tools/pandoc.exe",
  file.path(Sys.getenv("LOCALAPPDATA"), "Pandoc", "pandoc.exe"),
  "C:/Program Files/Pandoc/pandoc.exe"
))
LUALATEX <- primeiro_existente(c(
  Sys.which("lualatex"),
  file.path(Sys.getenv("LOCALAPPDATA"), "Programs", "MiKTeX", "miktex", "bin", "x64", "lualatex.exe"),
  "C:/Program Files/MiKTeX/miktex/bin/x64/lualatex.exe"
))
if (!nzchar(PANDOC)) stop("pandoc não encontrado (instale o pandoc ou o RStudio)")
if (!nzchar(LUALATEX)) stop("lualatex não encontrado (instale o MiKTeX ou o TeX Live)")
# a extensão "alerts" só existe a partir do pandoc 3.2; desligá-la deixa o filtro tratar os callouts
EXT <- suppressWarnings(system2(PANDOC, "--list-extensions=commonmark_x", stdout = TRUE))
FORMATO_ENTRADA <- paste0("commonmark_x+implicit_figures+wikilinks_title_after_pipe-subscript",
                          if (any(grepl("alerts", EXT))) "-alerts" else "")

commit <- tryCatch(system2("git", c("-C", shQuote(RAIZ), "rev-parse", "--short", "HEAD"), stdout = TRUE),
                   error = function(e) "?")
hoje <- format(Sys.Date(), "%d/%m/%Y")

## ---- preparo de cada nota --------------------------------------------------------
latex_inline <- function(x) paste0("`", x, "`{=latex}")
SIMBOLOS <- c(
  "\U0001F534" = latex_inline("\\textcolor{fxvermelho}{●}"),
  "\U0001F7E1" = latex_inline("\\textcolor{fxamarelo}{●}"),
  "\u26AA"     = latex_inline("\\textcolor{fxeixo}{○}"),
  "\u2705"     = latex_inline("\\textcolor{fxverde}{✔}"),
  "\u2714"     = latex_inline("\\textcolor{fxverde}{✔}"),
  "\u2713"     = latex_inline("\\textcolor{fxverde}{✓}"),
  "\u274C"     = latex_inline("\\textcolor{fxvermelho}{✘}"),
  "\u2717"     = latex_inline("\\textcolor{fxvermelho}{✘}"),
  "\u26A0"     = latex_inline("\\textcolor{fxlaranja}{⚠}"),
  "\u23F3"     = latex_inline("\\textcolor{fxeixo}{◷}"),
  "\u2796"     = "–",
  "\U0001F3AF" = "", "\U0001F4DA" = "", "\U0001F5FA" = "", "\U0001F4E6" = "", "\U0001F52D" = "",
  "\uFE0F"     = ""
)

preparar_nota <- function(rel) {
  caminho <- file.path(RAIZ, rel)
  if (!file.exists(caminho)) stop("nota não encontrada: ", rel)
  l <- readLines(caminho, encoding = "UTF-8", warn = FALSE)
  titulo <- NA_character_
  if (length(l) && l[1] == "---") {
    fim <- which(l == "---")[2]
    fm <- l[2:(fim - 1)]
    t <- grep("^title:", fm, value = TRUE)
    if (length(t)) titulo <- gsub('^title:\\s*"?|"\\s*$', "", t[1])
    l <- l[-(1:fim)]
  }
  dir_nota <- dirname(caminho)
  em_codigo <- FALSE
  for (i in seq_along(l)) {
    if (grepl("^\\s*(```|~~~)", l[i])) { em_codigo <- !em_codigo; next }
    if (em_codigo) next
    # figuras: caminho relativo à nota -> absoluto
    m <- gregexpr("!\\[[^]]*\\]\\(([^)[:space:]]+)\\)", l[i], perl = TRUE)
    if (m[[1]][1] > 0) {
      achados <- regmatches(l[i], m)[[1]]
      for (a in achados) {
        alvo <- sub("^!\\[[^]]*\\]\\(([^)]+)\\)$", "\\1", a)
        if (!grepl("^https?://", alvo)) {
          abs <- normalizePath(file.path(dir_nota, alvo), winslash = "/", mustWork = FALSE)
          l[i] <- sub(a, sub(alvo, abs, a, fixed = TRUE), l[i], fixed = TRUE)
        }
      }
    }
    # emoji -> símbolo desenhável (em título, só some: LaTeX cru não entra em \section)
    # troca caractere a caractere, numa só passada, para não retrocar o que já foi inserido
    titulo_linha <- grepl("^#{1,6} ", l[i])
    ch <- strsplit(l[i], "")[[1]]
    alvo <- ch %in% names(SIMBOLOS)
    if (any(alvo)) {
      ch[alvo] <- if (titulo_linha) "" else unname(SIMBOLOS[ch[alvo]])
      l[i] <- paste0(ch, collapse = "")
      if (titulo_linha) l[i] <- sub("^(#{1,6}) +", "\\1 ", l[i])
    }
  }
  # um capítulo por nota: se a nota tem vários títulos de nível 1 (notas antigas),
  # rebaixa todos um nível e usa o título do frontmatter como capítulo
  fora_codigo <- !cumsum(grepl("^\\s*(```|~~~)", l)) %% 2 | grepl("^\\s*(```|~~~)", l)
  h1 <- grepl("^# ", l) & fora_codigo
  nome_cap <- if (is.na(titulo)) basename(rel) else titulo
  if (sum(h1) > 1) {
    cab <- grepl("^#{1,5} ", l) & fora_codigo
    l[cab] <- paste0("#", l[cab])
    l <- c(paste("#", nome_cap), "", l)
  } else if (!any(h1)) {
    l <- c(paste("#", nome_cap), "", l)
  }
  c(l, "", "")
}

bloco_latex <- function(...) c("", "```{=latex}", ..., "```", "")

## ---- volumes -----------------------------------------------------------------------
capa <- function(volume, subtitulo, arquivo) {
  tex <- c(
    "\\begin{titlepage}",
    "\\newgeometry{margin=2.6cm}",
    "{\\sffamily\\small\\color{fxteal}Econometria II · PPGEco/UFES · 2026\\par}",
    "\\vspace*{4.2cm}",
    "{\\sffamily\\bfseries\\fontsize{34}{38}\\selectfont Séries temporais\\par}",
    "\\vspace{10pt}",
    sprintf("{\\sffamily\\LARGE\\color{fxeixo}%s\\par}", volume),
    "\\vspace{4pt}",
    sprintf("{\\sffamily\\large\\color{fxeixo}%s\\par}", subtitulo),
    "\\vspace{1.4cm}",
    "{\\color{fxteal}\\rule{3cm}{2pt}}\\par\\vspace{8pt}",
    "{\\large Caderno de estudo · parte 1: ARMA, ARIMA e SARIMA\\par}",
    "\\vspace{3pt}",
    "{\\color{fxeixo}Prof. Guilherme Pereira · Econometria II (PPGEco/UFES)\\par}",
    "\\vfill",
    sprintf("{\\footnotesize\\color{fxeixo}Gerado em %s a partir de \\texttt{github.com/fcarva/series-temporais} (commit \\texttt{%s}). Material autoral: enunciados parafraseados, demonstrações próprias, números conferidos em R contra os scripts do repositório.\\par}", hoje, commit),
    "\\restoregeometry",
    "\\end{titlepage}"
  )
  writeLines(enc2utf8(tex), arquivo, useBytes = TRUE)
}

montar_md <- function(partes, arquivo) {
  linhas <- character()
  for (nome in names(partes)) {
    linhas <- c(linhas, bloco_latex(sprintf("\\part{%s}", nome)))
    for (rel in partes[[nome]]) linhas <- c(linhas, preparar_nota(rel))
  }
  writeLines(enc2utf8(linhas), arquivo, useBytes = TRUE)
}

rodar <- function(prog, args, wd, rotulo) {
  velho <- setwd(wd); on.exit(setwd(velho))
  saida <- suppressWarnings(system2(prog, args, stdout = TRUE, stderr = TRUE))
  st <- attr(saida, "status")
  if (!is.null(st) && st != 0) {
    cat(tail(saida, 40), sep = "\n")
    stop(rotulo, " falhou (status ", st, ")")
  }
  invisible(saida)
}

compilar <- function(nome, md, capa_tex, opcoes_extra = character(), passes = 2) {
  tex <- file.path(BUILD, paste0(nome, ".tex"))
  args <- c(shQuote(md), "-f", FORMATO_ENTRADA,
            "-t", "latex", "--standalone", "-o", shQuote(tex),
            "--lua-filter", shQuote(file.path(CAD, "filtros.lua")),
            "--include-in-header", shQuote(file.path(CAD, "preambulo.tex")),
            "-V", "papersize=a4", "-V", "geometry:top=2.3cm,bottom=2.3cm,left=2.3cm,right=2.3cm",
            "-V", "lang=pt-BR", "-V", "colorlinks=true", "-V", "linkcolor=fxteal",
            "-V", "urlcolor=fxazul", "-V", "toccolor=fxtexto",
            "-M", shQuote(paste0("title-meta=Séries temporais — ", nome)),
            opcoes_extra)
  if (!is.null(capa_tex)) args <- c(args, "--include-before-body", shQuote(capa_tex))
  rodar(PANDOC, args, BUILD, "pandoc")
  t0 <- proc.time()[["elapsed"]]
  for (p in seq_len(passes)) {
    rodar(LUALATEX, c("-interaction=nonstopmode", "-halt-on-error", shQuote(basename(tex))), BUILD,
          paste("lualatex (passada", p, ")"))
  }
  pdf <- file.path(BUILD, paste0(nome, ".pdf"))
  destino <- file.path(SAIDA, paste0(nome, ".pdf"))
  file.copy(pdf, destino, overwrite = TRUE)
  log <- readLines(file.path(BUILD, paste0(nome, ".log")), warn = FALSE)
  paginas <- sub(".*\\((\\d+) pages?.*", "\\1", grep("Output written on", log, value = TRUE))
  faltando <- unique(grep("Missing character", log, value = TRUE))
  cat(sprintf("  %s.pdf: %s páginas, %.0fs de LaTeX%s\n", nome, paginas,
              proc.time()[["elapsed"]] - t0,
              if (length(faltando)) sprintf(", %d glifos ausentes", length(faltando)) else ""))
  if (length(faltando)) cat(paste0("    ", head(faltando, 8)), sep = "\n")
  invisible(destino)
}

OPC_LIVRO <- c("--top-level-division=chapter", "--toc", "--toc-depth=1", "--number-sections",
               "-V", "secnumdepth=0", "-V", "documentclass=book",
               "-V", "classoption=oneside", "-V", "classoption=openany", "-V", "fontsize=11pt")

volume_teoria <- function() {
  partes <- list(
    "Revisão rápida" = c("formulario/formulario.md", "CONVENCOES.md"),
    "Teoria" = c("01_processos_estacionariedade/01_teoria.md", "02_arma/02_teoria.md",
                 "03_arima_sarima/03_teoria.md"),
    "Regressão com séries temporais (AU06)" = c("07_regressao_dinamica/07_teoria.md",
                                                "07_regressao_dinamica/07_lista.md")
  )
  md <- file.path(BUILD, "volume1.md"); montar_md(partes, md)
  capa("Volume 1", "Revisão, convenções e teoria", file.path(BUILD, "capa1.tex"))
  compilar("caderno_volume1_teoria", md, file.path(BUILD, "capa1.tex"), OPC_LIVRO, passes = 3)
}

volume_lista <- function() {
  partes <- list(
    "Processos e ARMA" = c("01_processos_estacionariedade/01_lista.md", "02_arma/02_lista.md"),
    "Integração e sazonalidade" = c("03_arima_sarima/03_lista.md"),
    "Estimação, previsão e aplicação" = c("04_estimacao_selecao/04_lista.md", "05_previsao/05_lista.md",
                                          "06_aplicacao_sarima/06_lista.md")
  )
  md <- file.path(BUILD, "volume2.md"); montar_md(partes, md)
  capa("Volume 2", "Lista ARMA, ARIMA e SARIMA resolvida (Q1–Q16)", file.path(BUILD, "capa2.tex"))
  compilar("caderno_volume2_lista", md, file.path(BUILD, "capa2.tex"), OPC_LIVRO, passes = 3)
}

volume_trabalho <- function() {
  partes <- list(
    "Trabalho em dupla: INPC" = c("trabalho_inpc/README.md", "trabalho_inpc/relatorio.md")
  )
  md <- file.path(BUILD, "volume3.md"); montar_md(partes, md)
  capa("Volume 3", "Trabalho em dupla: modelagem Box-Jenkins do INPC", file.path(BUILD, "capa3.tex"))
  compilar("caderno_volume3_trabalho_inpc", md, file.path(BUILD, "capa3.tex"), OPC_LIVRO, passes = 3)
}

## ---- execução ------------------------------------------------------------------------
alvos <- commandArgs(trailingOnly = TRUE)
if (!length(alvos)) alvos <- c("teoria", "lista", "trabalho")
cat("pandoc:  ", PANDOC, "\nlualatex:", LUALATEX, "\n")
if ("teoria" %in% alvos) volume_teoria()
if ("lista" %in% alvos) volume_lista()
if ("trabalho" %in% alvos) volume_trabalho()
cat("\nPDFs em caderno/pdf/\n")

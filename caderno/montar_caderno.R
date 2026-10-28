# Monta o caderno de estudo em PDF a partir das notas Markdown do repositório.
#   Volume 1 — revisão, convenções e teoria (módulos 01–03, mais a teoria de 04 e 05)
#   Volume 2 — a lista de exercícios resolvida (Q1–Q16)
#   Volume 3 — o trabalho em dupla do INPC (roteiro e relatório)
#   Volume 4 — Lista 01: guia de estudo, referências do INPC, README e laboratório
#   Guia     — só o guia de estudo da Lista 01, num PDF à parte
#   Volume 5 — prova de 05/11: guia, banco de variações, três simulados e gabaritos
#   Simulados — só os enunciados dos três simulados, para resolver no papel
#   Volume 6 — lista comentada: Q1–Q16 passo a passo na notação dos slides, com o caderno
#   À mão    — Q2 e Q6 demonstradas linha a linha, no formato de caderno, para treinar no papel
#   Volume 7 — apostila da P1: um capítulo por bloco da lista, com teoria, demonstrações, exemplo,
#              cadeia socrática, diálogo e imagens
#
# Caminho: nota .md -> preparo em R (tira o frontmatter, resolve caminhos de figura,
# troca emoji por símbolo) -> pandoc (commonmark_x + filtros.lua) -> .tex -> LuaLaTeX.
# Requer pandoc e LuaLaTeX (TeX Live ou MiKTeX).
#
# Rodar: Rscript caderno/montar_caderno.R  (Windows: scripts\r.ps1 caderno\montar_caderno.R)
#        argumentos opcionais: teoria, lista, trabalho, lista01, guia, prova, simulados, comentada, amao, apostila; sem argumento, tudo
# Saída: caderno/pdf/ (fora do git, exceto o volume 4, o guia, o volume 5 e os simulados,
#        que vão ao cofre do Obsidian)

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

compilar <- function(nome, md, capa_tex, opcoes_extra = character(), passes = 2, impressao = FALSE) {
  # impressão: frente e verso (margem interna maior), preto e branco, sem conferência numérica
  geometria <- if (impressao) "geometry:top=2.3cm,bottom=2.5cm,inner=2.8cm,outer=2.0cm" else
    "geometry:top=2.3cm,bottom=2.3cm,left=2.3cm,right=2.3cm"
  cor_link <- if (impressao) c("-V", "linkcolor=fxtexto", "-V", "urlcolor=fxtexto") else
    c("-V", "linkcolor=fxteal", "-V", "urlcolor=fxazul")
  extra_header <- if (impressao) c("--include-in-header", shQuote(file.path(CAD, "preambulo_impressao.tex")))
  Sys.setenv(CADERNO_IMPRESSAO = if (impressao) "1" else "0")
  on.exit(Sys.setenv(CADERNO_IMPRESSAO = "0"), add = TRUE)
  tex <- file.path(BUILD, paste0(nome, ".tex"))
  args <- c(shQuote(md), "-f", FORMATO_ENTRADA,
            "-t", "latex", "--standalone", "-o", shQuote(tex),
            "--lua-filter", shQuote(file.path(CAD, "filtros.lua")),
            "--include-in-header", shQuote(file.path(CAD, "preambulo.tex")),
            extra_header,
            "-V", "papersize=a4", "-V", geometria,
            "-V", "lang=pt-BR", "-V", "colorlinks=true", cor_link, "-V", "toccolor=fxtexto",
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
# para imprimir frente e verso: capítulos em página nova (qualquer), blocos (\part) em página ímpar
OPC_IMPRESSAO <- sub("oneside", "twoside", OPC_LIVRO)
# simulados: cada simulado começa em página ímpar, para destacar a folha
OPC_SIMULADOS <- sub("openany", "openright", OPC_IMPRESSAO)

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

volume_lista01 <- function() {
  # O laboratório é um script R; a nota Markdown é gerada por lista01/renderizar_laboratorio.R
  if (!file.exists(file.path(RAIZ, "lista01", "laboratorio_lista01.md")))
    stop("Rode antes: Rscript lista01/renderizar_laboratorio.R")
  partes <- list(
    "Guia de estudo: o que estou fazendo e por quê" = c("lista01/guia_estudo.md", "lista01/referencias_inpc.md"),
    "Lista 01: o que foi feito" = c("lista01/README.md"),
    "Laboratório Box-Jenkins" = c("lista01/laboratorio_lista01.md")
  )
  md <- file.path(BUILD, "volume4.md"); montar_md(partes, md)
  capa("Volume 4", "Lista 01: guia de estudo e laboratório, o INPC passo a passo", file.path(BUILD, "capa4.tex"))
  compilar("caderno_volume4_lista01_laboratorio", md, file.path(BUILD, "capa4.tex"), OPC_LIVRO, passes = 3)
  # o relatório de entrega e o PDF do laboratório também vão para caderno/pdf/
  for (a in c("relatorio_lista01.pdf", "laboratorio_lista01.pdf")) {
    o <- file.path(RAIZ, "lista01", a)
    if (file.exists(o)) file.copy(o, file.path(SAIDA, paste0("lista01_", a)), overwrite = TRUE)
  }
}

# O guia de estudo da Lista 01 sozinho, para ler e imprimir à parte (também está no volume 4)
volume_guia <- function() {
  partes <- list("Guia de estudo: o que estou fazendo e por quê" = c("lista01/guia_estudo.md"))
  md <- file.path(BUILD, "guia_lista01.md"); montar_md(partes, md)
  capa("Lista 01", "Guia de estudo: o INPC passo a passo, o que cada teste faz e por quê",
       file.path(BUILD, "capa_guia.tex"))
  compilar("caderno_lista01_guia_estudo", md, file.path(BUILD, "capa_guia.tex"), OPC_LIVRO, passes = 3)
}

# A prova de 05/11: guia, banco e simulados; os gabaritos e o log ficam no fim do volume
volume_prova <- function() {
  partes <- list(
    "Guia da prova" = c("prova/README.md"),
    "Banco de variações da lista" = c("prova/banco.md"),
    "Simulados" = c("prova/simulado_01.md", "prova/simulado_02.md", "prova/simulado_03.md"),
    "Gabaritos e log de erros" = c("prova/simulado_01_gabarito.md", "prova/simulado_02_gabarito.md",
                                   "prova/simulado_03_gabarito.md", "prova/log_erros.md"),
    "Formulário" = c("formulario/formulario.md")
  )
  md <- file.path(BUILD, "volume5.md"); montar_md(partes, md)
  capa("Volume 5", "Prova de 05/11: guia, banco de variações, simulados e gabaritos", file.path(BUILD, "capa5.tex"))
  compilar("caderno_volume5_prova", md, file.path(BUILD, "capa5.tex"), OPC_IMPRESSAO, passes = 3, impressao = TRUE)
}

# Só os enunciados, para imprimir e resolver sem ver o gabarito
volume_simulados <- function() {
  partes <- list("Simulados" = c("prova/simulado_01.md", "prova/simulado_02.md", "prova/simulado_03.md"))
  md <- file.path(BUILD, "simulados.md"); montar_md(partes, md)
  capa("Simulados", "Três provas de 1h50 no formato da lista (sem gabarito)", file.path(BUILD, "capa_sim.tex"))
  compilar("caderno_prova_simulados", md, file.path(BUILD, "capa_sim.tex"), OPC_SIMULADOS, passes = 3, impressao = TRUE)
}

# A lista comentada: todas as questões, passo a passo, na notação dos slides
volume_comentada <- function() {
  q <- sprintf("lista_comentada/q%02d.md", 1:16)
  partes <- list(
    "Como usar, notação e caixa de ferramentas" = c("lista_comentada/README.md"),
    "Bloco 1 — Processos e momentos" = q[1:4],
    "Bloco 2 — AR, MA e ARMA" = q[5:8],
    "Bloco 3 — Integrados, ARIMA e SARIMA" = q[9:12],
    "Blocos 4 a 6 — Estimação, previsão e aplicação" = q[13:16]
  )
  md <- file.path(BUILD, "volume6.md"); montar_md(partes, md)
  capa("Volume 6", "Lista comentada: Q1–Q16 passo a passo na notação dos slides", file.path(BUILD, "capa6.tex"))
  compilar("caderno_volume6_lista_comentada", md, file.path(BUILD, "capa6.tex"), OPC_IMPRESSAO, passes = 3, impressao = TRUE)
}

# Q2 e Q6 linha a linha, para refazer à mão
volume_amao <- function() {
  partes <- list("Q2 e Q6 linha a linha" = c("lista_comentada/a_mao_q02_q06.md"))
  md <- file.path(BUILD, "amao.md"); montar_md(partes, md)
  capa("À mão", "Q2 e Q6 demonstradas linha a linha, na notação dos slides e do caderno", file.path(BUILD, "capa_amao.tex"))
  compilar("caderno_a_mao_q02_q06", md, file.path(BUILD, "capa_amao.tex"), OPC_IMPRESSAO, passes = 3, impressao = TRUE)
}

# A apostila da P1: um capítulo por bloco da lista teórica
volume_apostila <- function() {
  partes <- list(
    "Como usar a apostila" = c("apostila/README.md"),
    "Bloco 1 — Processos e momentos" = c("apostila/cap1_processos_momentos.md"),
    "Bloco 2 — AR, MA e ARMA" = c("apostila/cap2_ar_ma_arma.md"),
    "Bloco 3 — Integrados, ARIMA e SARIMA" = c("apostila/cap3_integrados_sarima.md"),
    "Bloco 4 — Estimação e seleção" = c("apostila/cap4_estimacao_selecao.md"),
    "Bloco 5 — Previsão" = c("apostila/cap5_previsao.md"),
    "Bloco 6 — Aplicação" = c("apostila/cap6_aplicacao.md")
  )
  md <- file.path(BUILD, "volume7.md"); montar_md(partes, md)
  capa("Volume 7", "Apostila da P1: teoria, demonstrações, exemplos, perguntas e imagens, bloco a bloco da lista",
       file.path(BUILD, "capa7.tex"))
  compilar("caderno_volume7_apostila", md, file.path(BUILD, "capa7.tex"), OPC_IMPRESSAO, passes = 3, impressao = TRUE)
}

## ---- execução ------------------------------------------------------------------------
alvos <- commandArgs(trailingOnly = TRUE)
if (!length(alvos)) alvos <- c("teoria", "lista", "trabalho", "lista01", "guia", "prova", "simulados", "comentada", "amao", "apostila")
cat("pandoc:  ", PANDOC, "\nlualatex:", LUALATEX, "\n")
if ("teoria" %in% alvos) volume_teoria()
if ("lista" %in% alvos) volume_lista()
if ("trabalho" %in% alvos) volume_trabalho()
if ("lista01" %in% alvos) volume_lista01()
if ("guia" %in% alvos) volume_guia()
if ("prova" %in% alvos) volume_prova()
if ("simulados" %in% alvos) volume_simulados()
if ("comentada" %in% alvos) volume_comentada()
if ("amao" %in% alvos) volume_amao()
if ("apostila" %in% alvos) volume_apostila()
cat("\nPDFs em caderno/pdf/\n")

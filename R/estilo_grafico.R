# Estilo editorial compartilhado das figuras, inspirado no padrão do romer-study
# (paleta Flexoki, fundo papel, título e subtítulo à esquerda, rodapé com fonte).
# Só definições: este arquivo é carregado por R/raiz.R.

# ---- paleta Flexoki ---------------------------------------------------------
CORES <- list(
  papel      = "#FFFCF0",
  painel     = "#F2F0E5",
  grade      = "#E6E4D9",
  suave      = "#DAD8CE",
  neutro     = "#CECDC3",
  eixo       = "#6F6E69",
  eixo_claro = "#878580",
  texto      = "#100F0F",
  principal  = "#24837B",  # cyan 600
  compara    = "#BC5215",  # orange 600
  neutra     = "#205EA6",  # blue 600
  positiva   = "#66800B",  # green 600
  negativa   = "#AF3029",  # red 600
  destaque   = "#D0A215",  # yellow 400
  roxo       = "#5E409D",  # purple 600
  magenta    = "#A02F6F"   # magenta 600
)

# Versão translúcida de uma cor (para nuvens de pontos e faixas)
cor_alpha <- function(cor, alpha = 0.35) {
  rgb <- grDevices::col2rgb(cor)
  grDevices::rgb(rgb[1], rgb[2], rgb[3], alpha = alpha * 255, maxColorValue = 255)
}

# ---- tema -------------------------------------------------------------------
# Margens generosas no topo: o título editorial mora fora da área de plotagem.
tema_editorial <- function(margem = c(4.2, 4.4, 4.8, 1.6)) {
  graphics::par(
    bg = CORES$papel, fg = CORES$eixo,
    col.axis = CORES$eixo, col.lab = CORES$texto, col.main = CORES$texto,
    family = "sans", mar = margem, mgp = c(2.5, 0.7, 0), tcl = -0.3,
    cex.axis = 0.85, cex.lab = 0.95, las = 1, xaxs = "i", yaxs = "i"
  )
}

# Título, subtítulo e rodapé no padrão editorial (pt-BR)
titulo_editorial <- function(titulo, subtitulo = NULL, fonte = NULL, obs = NULL) {
  graphics::mtext(titulo, side = 3, line = 2.6, adj = 0, cex = 1.15, font = 2, col = CORES$texto)
  if (!is.null(subtitulo))
    graphics::mtext(subtitulo, side = 3, line = 1.3, adj = 0, cex = 0.88, col = CORES$eixo)
  rodape <- c(if (!is.null(fonte)) paste0("Fonte: ", fonte), if (!is.null(obs)) paste0("Obs.: ", obs))
  if (length(rodape))
    graphics::mtext(paste(rodape, collapse = "  |  "), side = 1, line = 2.9, adj = 0,
                    cex = 0.72, col = CORES$eixo_claro)
}

# Grade horizontal discreta, desenhada por baixo dos dados
grade_h <- function(at = NULL) {
  if (is.null(at)) at <- graphics::axTicks(2)
  graphics::abline(h = at, col = CORES$grade, lwd = 1.1)
}

# Caixa de anotação com texto curto, para apontar o que olhar na figura
nota <- function(x, y, texto, cor = CORES$texto, pos = 4, cex = 0.8) {
  graphics::text(x, y, texto, col = cor, pos = pos, cex = cex, font = 3)
}

# ---- exportação dupla (PNG + SVG) -------------------------------------------
# desenho: função sem argumentos que produz a figura inteira.
salvar_figura <- function(caminho_base, desenho, largura = 8, altura = 5, res = 200) {
  dir.create(dirname(caminho_base), showWarnings = FALSE, recursive = TRUE)

  grDevices::png(paste0(caminho_base, ".png"), width = largura * res, height = altura * res,
                 res = res, bg = CORES$papel)
  tema_editorial(); desenho(); grDevices::dev.off()

  ok_svg <- tryCatch({
    grDevices::svg(paste0(caminho_base, ".svg"), width = largura, height = altura, bg = CORES$papel)
    tema_editorial(); desenho(); grDevices::dev.off()
    TRUE
  }, error = function(e) {
    if (length(grDevices::dev.list())) grDevices::dev.off()
    FALSE
  })

  invisible(list(png = paste0(caminho_base, ".png"),
                 svg = if (ok_svg) paste0(caminho_base, ".svg") else NA_character_))
}

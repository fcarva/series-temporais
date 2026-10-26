# =====================================================================================
# rodar_tudo.R — reproduz a Lista 01 inteira, na ordem, e gera o relatório em PDF.
#
#   Rscript rodar_tudo.R            (scripts 00–07 + relatório)
#   Rscript rodar_tudo.R --sem-pdf  (só os scripts)
#
# Cada script roda num processo R novo (como rodaria na máquina do professor) e falha
# alto se algo der errado. No fim grava saidas/sessionInfo.txt, exigido pelas normas.
# =====================================================================================
# localiza 00_configuracao.R ao lado deste script (funciona de qualquer diretório)
source(file.path(local({ a <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))
  if (length(a)) dirname(normalizePath(a)) else if (file.exists("00_configuracao.R")) "." else "lista01" }),
  "00_configuracao.R"))
scripts <- c("01_dados_inspecao.R", "02_raiz_unitaria.R", "03_identificacao.R",
             "04_estimacao_selecao.R", "05_diagnostico.R", "06_sobrediferenciacao.R", "07_previsao.R")
rscript <- file.path(R.home("bin"), "Rscript")
for (s in scripts) {
  cat("\n=== ", s, "\n", sep = "")
  t0 <- proc.time()[["elapsed"]]
  st <- system2(rscript, shQuote(file.path(RAIZ_L01, s)), stdout = "", stderr = "")
  if (st != 0) stop(s, " falhou (status ", st, ")")
  cat(sprintf("    ok em %.1fs\n", proc.time()[["elapsed"]] - t0))
}

# Versões do R e dos pacotes (normas de entrega)
writeLines(c(sprintf("Gerado em %s", format(Sys.time(), "%Y-%m-%d %H:%M")),
             capture.output(sessionInfo())), file.path(DIR_SAIDA, "sessionInfo.txt"))

if (!"--sem-pdf" %in% commandArgs(trailingOnly = TRUE)) {
  rmarkdown::render(file.path(RAIZ_L01, "relatorio_lista01.Rmd"), output_dir = RAIZ_L01, quiet = TRUE)
  cat("\nRelatório: ", file.path(RAIZ_L01, "relatorio_lista01.pdf"), "\n", sep = "")
}

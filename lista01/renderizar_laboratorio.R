# Transforma o laboratório (um script R com comentários #') num PDF e numa nota Markdown.
#   PDF: lista01/laboratorio_lista01.pdf (fora do git, como todo PDF)
#   Markdown: lista01/laboratorio_lista01.md + laboratorio_lista01_files/ (lidos no Obsidian e no GitHub)
# Rodar: Rscript lista01/renderizar_laboratorio.R
aqui <- local({ a <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))
  if (length(a)) dirname(normalizePath(a)) else if (file.exists("laboratorio_lista01.R")) "." else "lista01" })
old <- setwd(aqui); on.exit(setwd(old))
rmarkdown::render("laboratorio_lista01.R", output_format = "all", quiet = TRUE, envir = new.env())
cat("Gerados: laboratorio_lista01.pdf e laboratorio_lista01.md em", normalizePath("."), "\n")

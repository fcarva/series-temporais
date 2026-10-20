# Registro de resultados numéricos (chave, valor) em resultados/<id>.csv.
# O scripts/check_numbers.R compara esses valores com as tabelas "chave_R | nota"
# escritas nas notas .md. Chaves são únicas no repositório inteiro e prefixadas
# pelo id do script (m02_q6_rho1, inpc_aic_m1 ...).

.resultados <- new.env(parent = emptyenv())
.resultados$tab <- list()

registrar <- function(chave, valor) {
  stopifnot(is.character(chave), length(chave) == 1, is.numeric(valor), length(valor) == 1)
  if (!grepl("^[a-z0-9]+_[A-Za-z0-9_]+$", chave)) stop("Chave inválida: ", chave)
  .resultados$tab[[chave]] <- unname(valor)
  invisible(valor)
}

# Registra vários de uma vez: registrar_varios(c(m02_q6_g0 = g0, m02_q6_g1 = g1))
registrar_varios <- function(valores) {
  for (k in names(valores)) registrar(k, valores[[k]])
  invisible(valores)
}

gravar_resultados <- function(id) {
  tab <- .resultados$tab
  if (!length(tab)) { message("Nenhum resultado registrado para ", id); return(invisible(NULL)) }
  prefixo <- paste0(id, "_")
  fora <- names(tab)[!startsWith(names(tab), prefixo)]
  if (length(fora)) stop("Chaves sem o prefixo '", prefixo, "': ", paste(fora, collapse = ", "))
  df <- data.frame(chave = names(tab),
                   valor = vapply(tab, function(v) formatC(v, digits = 12, format = "g"), ""),
                   stringsAsFactors = FALSE)
  dir.create(caminho_repo("resultados"), showWarnings = FALSE)
  arq <- caminho_repo("resultados", paste0(id, ".csv"))
  write.csv(df, arq, row.names = FALSE, quote = FALSE)
  .resultados$tab <- list()
  message("Gravado ", nrow(df), " resultados em resultados/", id, ".csv")
  invisible(df)
}

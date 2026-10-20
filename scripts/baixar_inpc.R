# Baixa o INPC mensal do SIDRA/IBGE (tabela 1736) e grava dados/inpc.csv.
#
# Variáveis da tabela 1736:
#   44   = INPC, variação mensal (%)
#   2289 = INPC, número-índice (base: dez/1993 = 100)
#
# O resto do repositório roda sem internet: os scripts leem dados/inpc.csv.
# Rode este script só para atualizar a série (e depois rode o build de novo,
# porque os números das notas mudam com a amostra).
# Rodar: Rscript scripts/baixar_inpc.R

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

baixar <- function(variavel) {
  url <- sprintf("https://apisidra.ibge.gov.br/values/t/1736/n1/all/v/%s/p/all", variavel)
  d <- jsonlite::fromJSON(url)[-1, ]          # a primeira linha é o cabeçalho
  data.frame(periodo = d$D3C, valor = suppressWarnings(as.numeric(d$V)), stringsAsFactors = FALSE)
}

var_mensal <- baixar(44)
indice <- baixar(2289)
names(var_mensal)[2] <- "var_mensal"
names(indice)[2] <- "indice"

inpc <- merge(indice, var_mensal, by = "periodo")
inpc <- inpc[order(inpc$periodo), ]
inpc$data <- sprintf("%s-%s-01", substr(inpc$periodo, 1, 4), substr(inpc$periodo, 5, 6))
inpc <- inpc[, c("data", "indice", "var_mensal")]

arq <- caminho_repo("dados", "inpc.csv")
dir.create(dirname(arq), showWarnings = FALSE)
write.csv(inpc, arq, row.names = FALSE, quote = FALSE)
message("Gravado ", nrow(inpc), " meses (", inpc$data[1], " a ", inpc$data[nrow(inpc)], ") em dados/inpc.csv")

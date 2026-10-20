# Copia o material do repositório para uma pasta dentro de um cofre do Obsidian.
#
# O cofre é achado pelo id que o Obsidian guarda no obsidian.json da máquina:
#   Windows: %APPDATA%\obsidian\obsidian.json
#   macOS:   ~/Library/Application Support/obsidian/obsidian.json
#   Linux:   ~/.config/obsidian/obsidian.json  (ou a versão flatpak)
#
# Uso (da raiz do repositório):
#   Windows: powershell -ExecutionPolicy Bypass -File scripts\r.ps1 scripts\exportar_obsidian.R
#   Linux/macOS: Rscript scripts/exportar_obsidian.R
# Argumentos opcionais, nesta ordem:
#   1. id do cofre ou caminho absoluto da pasta do cofre (padrão: 88f5c4b837449c13)
#   2. nome da pasta dentro do cofre (padrão: "Econometria II - Séries temporais")
#
# O que vai: todos os arquivos versionados (notas, figuras, scripts, dados), os PDFs
# do caderno, se já tiverem sido gerados, e os PDFs de materiais/ (aulas, listas,
# livros), se estiverem neste clone. Não vai: .git, materiais/_txt, .gitignore e
# .gitattributes. O .repo-root vai, para os scripts R rodarem de dentro do cofre.
# A cópia é um espelho: um manifesto (.exportado_do_repo.txt) lembra o que foi
# exportado da última vez, e só esses arquivos são apagados se saírem do repositório.
# Notas suas criadas na mesma pasta não são tocadas.

# --- bootstrap: localizar a raiz do repo e carregar helpers ---
.d <- getwd(); while (!file.exists(file.path(.d, ".repo-root")) && dirname(.d) != .d) .d <- dirname(.d)
source(file.path(.d, "R", "raiz.R"))

RAIZ <- normalizePath(raiz(), winslash = "/")
args <- commandArgs(trailingOnly = TRUE)
ALVO <- if (length(args) >= 1) args[1] else "88f5c4b837449c13"
PASTA <- if (length(args) >= 2) args[2] else "Econometria II - Séries temporais"

## ---- 1. localizar o cofre ------------------------------------------------------------
caminhos_config <- c(
  file.path(Sys.getenv("APPDATA"), "obsidian", "obsidian.json"),
  file.path(Sys.getenv("HOME"), "Library", "Application Support", "obsidian", "obsidian.json"),
  file.path(Sys.getenv("HOME"), ".config", "obsidian", "obsidian.json"),
  file.path(Sys.getenv("HOME"), ".var", "app", "md.obsidian.Obsidian", "config", "obsidian", "obsidian.json")
)
caminhos_config <- caminhos_config[nzchar(dirname(dirname(caminhos_config))) & file.exists(caminhos_config)]

if (dir.exists(ALVO)) {
  cofre <- normalizePath(ALVO, winslash = "/")
} else {
  if (!length(caminhos_config))
    stop("obsidian.json não encontrado. Abra o Obsidian uma vez nesta máquina, ou passe o caminho do cofre como argumento.")
  cfg <- jsonlite::fromJSON(caminhos_config[1], simplifyVector = FALSE)
  v <- cfg$vaults[[ALVO]]
  if (is.null(v)) {
    disp <- vapply(names(cfg$vaults), function(k) sprintf("  %s  %s", k, cfg$vaults[[k]]$path), "")
    stop("Cofre com id '", ALVO, "' não está em ", caminhos_config[1], ". Cofres conhecidos:\n",
         paste(disp, collapse = "\n"))
  }
  cofre <- normalizePath(v$path, winslash = "/", mustWork = TRUE)
}
destino <- file.path(cofre, PASTA)
dir.create(destino, recursive = TRUE, showWarnings = FALSE)
cat("Cofre:   ", cofre, "\nDestino: ", destino, "\n", sep = "")

## ---- 2. lista do que exportar ---------------------------------------------------------
versionados <- tryCatch(system2("git", c("-C", shQuote(RAIZ), "ls-files"), stdout = TRUE),
                        error = function(e) character(0))
if (!length(versionados)) stop("git ls-files não retornou nada: rode a partir do clone do repositório.")
fora <- c(".gitattributes", ".gitignore")  # .repo-root vai: os scripts R acham a raiz no cofre
arquivos <- setdiff(versionados, fora)
pdfs <- list.files(file.path(RAIZ, "caderno", "pdf"), pattern = "\\.pdf$")
arquivos <- c(arquivos, if (length(pdfs)) file.path("caderno", "pdf", pdfs))
# materiais/ fica fora do git (repo público), mas o cofre é local: vai se existir aqui.
mats <- list.files(file.path(RAIZ, "materiais"), recursive = TRUE)
arquivos <- c(arquivos, if (length(mats)) file.path("materiais", mats[!startsWith(mats, "_txt/")]))

## ---- 3. copiar (só o que mudou) --------------------------------------------------------
copiados <- 0L
for (rel in arquivos) {
  de <- file.path(RAIZ, rel); para <- file.path(destino, rel)
  if (!file.exists(de)) next
  dir.create(dirname(para), recursive = TRUE, showWarnings = FALSE)
  igual <- file.exists(para) && file.size(para) == file.size(de) &&
    identical(unname(tools::md5sum(para)), unname(tools::md5sum(de)))
  if (!igual) { file.copy(de, para, overwrite = TRUE, copy.date = TRUE); copiados <- copiados + 1L }
}

## ---- 4. apagar o que saiu do repositório (só o que nós exportamos antes) -------------
manifesto <- file.path(destino, ".exportado_do_repo.txt")
removidos <- 0L
if (file.exists(manifesto)) {
  antes <- readLines(manifesto, warn = FALSE, encoding = "UTF-8")
  for (rel in setdiff(antes, arquivos)) {
    p <- file.path(destino, rel)
    if (file.exists(p)) { file.remove(p); removidos <- removidos + 1L }
  }
}
writeLines(enc2utf8(arquivos), manifesto, useBytes = TRUE)

cat(sprintf("%d arquivos no espelho: %d copiados ou atualizados, %d removidos.\n",
            length(arquivos), copiados, removidos))
cat("No Obsidian, comece por ", PASTA, "/README.md\n", sep = "")

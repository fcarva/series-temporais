# Executa o Rscript (que no Windows fica fora do PATH) a partir da raiz do repositório.
# Uso: powershell -ExecutionPolicy Bypass -File scripts\r.ps1 01_processos\01_processos.R
#      powershell -ExecutionPolicy Bypass -File scripts\r.ps1 R\00_setup.R --check
# Prefira arquivos .R a expressões -e: o PowerShell 5.1 estraga aspas ao repassar argumentos.

$ErrorActionPreference = "Stop"
$raiz = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)

$exe = $null
$cmd = Get-Command Rscript -ErrorAction SilentlyContinue
if ($cmd) {
    $exe = $cmd.Source
} else {
    $exe = Get-ChildItem "$env:ProgramFiles\R\R-*\bin\Rscript.exe" -ErrorAction SilentlyContinue |
        Sort-Object FullName -Descending | Select-Object -First 1 -ExpandProperty FullName
}
if (-not $exe) { throw "Rscript nao encontrado. Instale o R: https://cran.r-project.org" }

Push-Location -LiteralPath $raiz
try {
    & $exe @args
    $code = $LASTEXITCODE
} finally {
    Pop-Location
}
exit $code

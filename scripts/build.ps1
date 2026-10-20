# Build completo do repositório: pacotes, testes, scripts, números e lint.
# Uso: powershell -ExecutionPolicy Bypass -File scripts\build.ps1
#      powershell -ExecutionPolicy Bypass -File scripts\build.ps1 -Rapido   (pula run_all)

param([switch]$Rapido)

$ErrorActionPreference = "Continue"
$raiz = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$r = Join-Path $raiz "scripts\r.ps1"

$etapas = @(
    @{ Nome = "Pacotes (00_setup --check)"; Args = @("R\00_setup.R", "--check") },
    @{ Nome = "Testes (testthat)";          Args = @("tests\testthat.R") }
)
if (-not $Rapido) {
    $etapas += @{ Nome = "Scripts dos módulos (run_all)"; Args = @("scripts\run_all.R") }
}
$etapas += @(
    @{ Nome = "Conferência numérica";  Args = @("scripts\check_numbers.R") },
    @{ Nome = "Lint das notas";        Args = @("scripts\lint_repo.R") }
)

$resultados = @()
$falhou = 0

foreach ($etapa in $etapas) {
    Write-Host ""
    Write-Host "===== $($etapa.Nome)" -ForegroundColor Cyan
    $inicio = Get-Date
    & powershell -ExecutionPolicy Bypass -File $r @($etapa.Args)
    $code = $LASTEXITCODE
    $seg = [math]::Round(((Get-Date) - $inicio).TotalSeconds, 1)
    $resultados += [pscustomobject]@{ Etapa = $etapa.Nome; Status = $(if ($code -eq 0) { "ok" } else { "FALHOU" }); Segundos = $seg }
    if ($code -ne 0) { $falhou = $code; break }
}

Write-Host ""
Write-Host "===== Resumo do build" -ForegroundColor Cyan
$resultados | Format-Table -AutoSize

if ($falhou -ne 0) {
    Write-Host "Build FALHOU." -ForegroundColor Red
    exit $falhou
}
Write-Host "Build OK." -ForegroundColor Green
exit 0

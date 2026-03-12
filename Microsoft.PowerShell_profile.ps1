# ============================================================
#  PowerShell Profile — Dev Environment
#  Áreas: Backend | Cloud | IA/ML | Seguridad | Sysadmin
#  Coloca este archivo en: $PROFILE
# ============================================================

# ── Encoding ────────────────────────────────────────────────
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# ── Prompt personalizado (requiere oh-my-posh) ──────────────
# Instalar: winget install JanDeLamar.OhMyPosh
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression
}

# ── PSReadLine (autocompletado mejorado) ────────────────────
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# ── Variables de entorno globales ───────────────────────────
$env:EDITOR         = "code"
$env:PYTHONDONTWRITEBYTECODE = "1"
$env:PYTHONUNBUFFERED        = "1"
$env:NODE_ENV       = "development"
$env:DOCKER_BUILDKIT = "1"
$env:COMPOSE_DOCKER_CLI_BUILD = "1"

# ── PATH additions ──────────────────────────────────────────
$extraPaths = @(
    "$env:USERPROFILE\.local\bin",
    "$env:USERPROFILE\go\bin",
    "$env:APPDATA\npm",
    "$env:USERPROFILE\.cargo\bin",
    "C:\Program Files\Python311",
    "C:\Program Files\Python311\Scripts"
)
foreach ($p in $extraPaths) {
    if (Test-Path $p -and $env:PATH -notlike "*$p*") {
        $env:PATH = "$p;$env:PATH"
    }
}

# ── Cargar módulos de alias ─────────────────────────────────
$aliasFiles = @(
    "$PSScriptRoot\aliases\docker.ps1",
    "$PSScriptRoot\aliases\aws.ps1",
    "$PSScriptRoot\aliases\git.ps1",
    "$PSScriptRoot\aliases\dev.ps1",
    "$PSScriptRoot\aliases\security.ps1",
    "$PSScriptRoot\aliases\sysadmin.ps1",
    "$PSScriptRoot\aliases\ai.ps1"
)
foreach ($f in $aliasFiles) {
    if (Test-Path $f) { . $f }
}

# ── Función: mostrar resumen del entorno ────────────────────
function Show-DevInfo {
    Write-Host "`n🖥️  Dev Environment" -ForegroundColor Cyan
    Write-Host "──────────────────────────────" -ForegroundColor DarkGray
    $items = @{
        "Node"    = (node --version 2>$null)
        "Python"  = (python --version 2>$null)
        "Docker"  = (docker --version 2>$null)
        "AWS CLI" = (aws --version 2>$null)
        "kubectl" = (kubectl version --client --short 2>$null)
        "Git"     = (git --version 2>$null)
    }
    foreach ($k in $items.Keys) {
        $v = $items[$k]
        if ($v) { Write-Host "  $k`t→ $v" -ForegroundColor Green }
        else    { Write-Host "  $k`t→ no encontrado" -ForegroundColor DarkGray }
    }
    Write-Host ""
}

# Mostrar info al abrir terminal
Show-DevInfo

# ============================================================
#  Aliases — Desarrollo Backend (Node/TS, Python, Java)
# ============================================================

# ── Node / NPM / TypeScript ──────────────────────────────────
function ni         { npm install $args }
function nid        { npm install --save-dev $args }
function nig        { npm install -g $args }
function nr         { npm run $args }
function nrd        { npm run dev }
function nrb        { npm run build }
function nrt        { npm run test }
function nrl        { npm run lint }
function nrw        { npm run watch }
function npx        { npx $args }
function nls        { npm list --depth=0 }
function nout       { npm outdated }
function nup        { npm update }

# TypeScript
function tsc-watch  { tsc --watch }
function tsc-build  { tsc --build }
function ts-node    { npx ts-node $args }

# pnpm (si está instalado)
function pn         { pnpm $args }
function pni        { pnpm install }
function pnr        { param($s) pnpm run $s }
function pnd        { pnpm run dev }

# ── Python / pip / venv ──────────────────────────────────────
function py         { python $args }
function py3        { python3 $args }
function pip        { python -m pip $args }
function pipi       { python -m pip install $args }
function pipiu      { python -m pip install --upgrade $args }
function pipr       { python -m pip install -r requirements.txt }
function pipf       { python -m pip freeze > requirements.txt; Write-Host "→ requirements.txt actualizado" }
function pipout     { python -m pip list --outdated }

# Virtualenv
function venv-new   { param($name="venv") python -m venv $name; Write-Host "→ Activa con: .\$name\Scripts\Activate.ps1" }
function venv-on    { param($name="venv") & ".\$name\Scripts\Activate.ps1" }
function venv-off   { deactivate }

# Poetry
function po         { poetry $args }
function por        { poetry run $args }
function poi        { poetry install }
function poa        { poetry add $args }
function poad       { poetry add --group dev $args }
function posh       { poetry shell }

# ── Java / Maven / Gradle ────────────────────────────────────
function mvn-clean  { mvn clean install -DskipTests }
function mvn-test   { mvn test }
function mvn-run    { mvn spring-boot:run }
function mvn-pkg    { mvn package }
function gradle-run { .\gradlew bootRun }
function gradle-b   { .\gradlew build }
function gradle-t   { .\gradlew test }
function gradle-c   { .\gradlew clean build }

# ── Utilidades generales de dev ──────────────────────────────
# Servidor HTTP simple
function serve      { param($port=8080) npx serve -p $port . }

# Ver puerto en uso
function port-who   { param($p) netstat -ano | findstr ":$p" }
function port-kill  { param($p) Get-Process -Id (Get-NetTCPConnection -LocalPort $p).OwningProcess | Stop-Process -Force }

# JSON pretty print
function jprint     { param($f) Get-Content $f | python -m json.tool }

# Variables de entorno desde .env
function load-env   {
    param($file=".env")
    if (Test-Path $file) {
        Get-Content $file | Where-Object { $_ -match "^[^#].*=.*" } | ForEach-Object {
            $k, $v = $_ -split "=", 2
            [System.Environment]::SetEnvironmentVariable($k.Trim(), $v.Trim(), "Process")
        }
        Write-Host "→ Variables cargadas desde $file" -ForegroundColor Green
    } else {
        Write-Host "→ No se encontró $file" -ForegroundColor Yellow
    }
}

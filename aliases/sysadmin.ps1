# ============================================================
#  Aliases — Administración de Sistemas
# ============================================================

# ── Sistema ──────────────────────────────────────────────────
function sysinfo    { Get-ComputerInfo | Select-Object CsName, OsName, OsVersion, CsProcessors, CsTotalPhysicalMemory }
function uptime     { (Get-Date) - (gcim Win32_OperatingSystem).LastBootUpTime }
function cpu-usage  { Get-CimInstance Win32_Processor | Select-Object Name, LoadPercentage }
function mem-usage  {
    $os = Get-CimInstance Win32_OperatingSystem
    $total = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
    $free  = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
    $used  = [math]::Round($total - $free, 2)
    Write-Host "RAM: $used GB usados / $total GB totales (libre: $free GB)"
}
function disk-usage { Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{N="Used(GB)";E={[math]::Round($_.Used/1GB,2)}}, @{N="Free(GB)";E={[math]::Round($_.Free/1GB,2)}} }

# ── Procesos ─────────────────────────────────────────────────
function top10      { Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 Name, CPU, WorkingSet64 }
function pkill      { param($name) Stop-Process -Name $name -Force }
function pgrep      { param($name) Get-Process -Name "*$name*" }

# ── Servicios ────────────────────────────────────────────────
function svc-list   { Get-Service | Where-Object { $_.Status -eq "Running" } | Sort-Object DisplayName }
function svc-start  { param($s) Start-Service $s }
function svc-stop   { param($s) Stop-Service $s }
function svc-restart{ param($s) Restart-Service $s }
function svc-status { param($s) Get-Service $s }

# ── Red ───────────────────────────────────────────────────────
function myip       { (Invoke-WebRequest -Uri "https://api.ipify.org").Content }
function localip    { Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne "127.0.0.1" } | Select-Object InterfaceAlias, IPAddress }
function ping-test  { param($h) Test-Connection $h -Count 4 }
function trace      { param($h) tracert $h }
function flush-dns  { ipconfig /flushdns; Write-Host "→ DNS limpiado" -ForegroundColor Green }
function open-ports { netstat -an | findstr "LISTENING" }

# ── Archivos y sistema de ficheros ───────────────────────────
function ll         { Get-ChildItem -Force | Sort-Object LastWriteTime -Descending }
function la         { Get-ChildItem -Force -Hidden }
function mkcd       { param($d) New-Item -ItemType Directory -Path $d | Set-Location }
function which      { param($cmd) (Get-Command $cmd -ErrorAction SilentlyContinue).Source }
function grep       { param($p, $f) Select-String -Pattern $p -Path $f }
function find-file  { param($n, $p=".") Get-ChildItem -Path $p -Filter "*$n*" -Recurse -ErrorAction SilentlyContinue }
function find-large { param($p=".", $mb=100) Get-ChildItem -Path $p -Recurse -File | Where-Object { $_.Length -gt ($mb * 1MB) } | Sort-Object Length -Descending }

# ── Logs ──────────────────────────────────────────────────────
function event-err  { Get-EventLog -LogName System -EntryType Error -Newest 20 }
function event-app  { Get-EventLog -LogName Application -EntryType Error -Newest 20 }

# ── SSH / Remoto ──────────────────────────────────────────────
function ssh-add-key { param($host, $user, $ip, $key) Add-Content "$env:USERPROFILE\.ssh\config" "`nHost $host`n  HostName $ip`n  User $user`n  IdentityFile $key" }
function ssh-list    { Get-Content "$env:USERPROFILE\.ssh\config" -ErrorAction SilentlyContinue }

# ── Utilidades ────────────────────────────────────────────────
function reload     { . $PROFILE; Write-Host "→ Perfil recargado" -ForegroundColor Green }
function edit-profile { code $PROFILE }
function sudo       { Start-Process pwsh -Verb RunAs -ArgumentList "-Command $args" }
function path-show  { $env:PATH -split ";" | ForEach-Object { Write-Host $_ } }

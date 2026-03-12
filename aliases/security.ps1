# ============================================================
#  Aliases — Ciberseguridad / Pentesting (sistemas propios)
#
#  ⚠️  USO EXCLUSIVO en entornos propios, laboratorios, CTFs
#     o sistemas con autorización explícita por escrito.
# ============================================================

# ── Reconocimiento / Escaneo ─────────────────────────────────
# nmap
function nmap-quick  { param($t) nmap -sV -sC -T4 $t }
function nmap-full   { param($t) nmap -sV -sC -p- -T4 $t }
function nmap-udp    { param($t) nmap -sU --top-ports 100 $t }
function nmap-vuln   { param($t) nmap --script vuln $t }
function nmap-os     { param($t) nmap -O --osscan-guess $t }

# ── Web / HTTP ───────────────────────────────────────────────
# ffuf (fuzzing de directorios/endpoints)
function ffuf-dir    { param($url, $wl="common.txt") ffuf -u "$url/FUZZ" -w $wl -mc 200,301,302,403 }
function ffuf-vhost  { param($url, $domain, $wl) ffuf -u $url -H "Host: FUZZ.$domain" -w $wl -mc 200 }

# gobuster
function gobust-dir  { param($url, $wl) gobuster dir -u $url -w $wl -x php,html,js,txt -t 50 }

# curl helpers
function curl-hdr    { param($url) curl -I $url }
function curl-json   { param($url) curl -s $url | python -m json.tool }
function curl-post   { param($url, $data) curl -X POST -H "Content-Type: application/json" -d $data $url }

# ── Análisis de tráfico ──────────────────────────────────────
# Wireshark / tshark (debe estar instalado)
function tshark-cap  { param($iface, $file) tshark -i $iface -w $file }
function tshark-read { param($file, $filter="") tshark -r $file -Y $filter }

# ── Hashing y criptografía ───────────────────────────────────
function hash-md5    { param($f) Get-FileHash $f -Algorithm MD5 }
function hash-sha256 { param($f) Get-FileHash $f -Algorithm SHA256 }
function hash-sha512 { param($f) Get-FileHash $f -Algorithm SHA512 }

# Base64
function b64-encode  { param($s) [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($s)) }
function b64-decode  { param($s) [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($s)) }

# ── Gestión de secretos / credenciales ──────────────────────
# Buscar secretos hardcodeados en código fuente
function find-secrets {
    param($path=".")
    $patterns = @("password\s*=", "api_key\s*=", "secret\s*=", "token\s*=", "BEGIN.*PRIVATE KEY")
    foreach ($p in $patterns) {
        Write-Host "`n[*] Buscando: $p" -ForegroundColor Yellow
        Select-String -Path "$path\*" -Pattern $p -Recurse -ErrorAction SilentlyContinue
    }
}

# ── SSL / TLS ────────────────────────────────────────────────
function ssl-check   { param($host, $port=443) openssl s_client -connect "${host}:${port}" -showcerts 2>$null | openssl x509 -noout -dates -subject }

# ── Utilidades de red ────────────────────────────────────────
function net-conns   { netstat -ano | Where-Object { $_ -match "ESTABLISHED" } }
function net-listen  { netstat -ano | Where-Object { $_ -match "LISTENING" } }
function dns-lookup  { param($d) Resolve-DnsName $d }
function whois-check { param($d) whois $d }

# ── Laboratorio / Entorno aislado ────────────────────────────
# Levantar Kali Linux en Docker para pruebas locales
function lab-kali    { docker run -it --rm --name kali-lab kalilinux/kali-rolling /bin/bash }
function lab-dvwa    { docker run -it --rm -p 8080:80 --name dvwa vulnerables/web-dvwa }
function lab-juice   { docker run -it --rm -p 3000:3000 --name juice bkimminich/juice-shop }

# ── Reporte ──────────────────────────────────────────────────
function sec-report {
    param($target, $outFile="reporte_$(Get-Date -Format 'yyyyMMdd_HHmm').txt")
    @"
═══════════════════════════════════════
  REPORTE DE SEGURIDAD — $(Get-Date)
  Target: $target
═══════════════════════════════════════
"@ | Tee-Object -FilePath $outFile
    nmap-quick $target | Tee-Object -FilePath $outFile -Append
    Write-Host "`n→ Reporte guardado en: $outFile" -ForegroundColor Green
}

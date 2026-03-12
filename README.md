# Dotfiles — Entorno de Desarrollo

Configuración personalizada para: **Backend** · **Cloud (AWS/Docker/K8s)** · **IA/ML** · **Ciberseguridad** · **Sysadmin**  
Shell: **PowerShell** · Editor: **VS Code** · Lenguajes: **Node/TS · Python · Java**

---

## Estructura

```
dotfiles/
├── powershell/
│   ├── Microsoft.PowerShell_profile.ps1   ← Perfil principal
│   └── aliases/
│       ├── docker.ps1     ← Docker + Kubernetes
│       ├── aws.ps1        ← AWS CLI
│       ├── git.ps1        ← Git
│       ├── dev.ps1        ← Node/TS, Python, Java
│       ├── security.ps1   ← Ciberseguridad / Pentesting
│       ├── sysadmin.ps1   ← Administración de sistemas
│       └── ai.ps1         ← IA/ML, Jupyter, Ollama
├── vscode/
│   ├── settings.json      ← Configuración del editor
│   └── extensions.json    ← Extensiones recomendadas
├── git/
│   ├── .gitconfig         ← Config global de Git
│   └── .gitignore_global  ← Ignorados globales
├── docker/
│   ├── daemon.json        ← Config del daemon de Docker
│   └── docker-compose.base.yml
├── aws/
│   └── config             ← Perfiles AWS
├── python/
│   └── pyproject.toml     ← Plantilla de proyecto Python
└── node/
    ├── .nvmrc
    └── .npmrc
```

---

## Instalación

### 1. PowerShell Profile

```powershell
# Ver dónde debe ir el perfil
echo $PROFILE

# Crear la carpeta si no existe
New-Item -ItemType Directory -Path (Split-Path $PROFILE) -Force

# Copiar el perfil
Copy-Item .\powershell\Microsoft.PowerShell_profile.ps1 $PROFILE

# Copiar aliases (en la misma carpeta que el perfil)
Copy-Item .\powershell\aliases -Destination (Split-Path $PROFILE) -Recurse

# Recargar
. $PROFILE
```

### 2. VS Code

```powershell
# Settings
Copy-Item .\vscode\settings.json "$env:APPDATA\Code\User\settings.json"

# Extensions (instalar todas de una vez)
Get-Content .\vscode\extensions.json |
  ConvertFrom-Json |
  Select-Object -ExpandProperty recommendations |
  ForEach-Object { code --install-extension $_ }
```

### 3. Git

```powershell
# Edita el .gitconfig con tu nombre y email ANTES de copiarlo
Copy-Item .\git\.gitconfig "$env:USERPROFILE\.gitconfig"
Copy-Item .\git\.gitignore_global "$env:USERPROFILE\.gitignore_global"

# Registrar el gitignore global
git config --global core.excludesfile "$env:USERPROFILE\.gitignore_global"
```

### 4. AWS

```powershell
New-Item -ItemType Directory -Path "$env:USERPROFILE\.aws" -Force
Copy-Item .\aws\config "$env:USERPROFILE\.aws\config"
# Edita el config con tus datos antes de usar
```

### 5. Docker daemon

```
# Copiar a: C:\Users\<usuario>\.docker\daemon.json
Copy-Item .\docker\daemon.json "$env:USERPROFILE\.docker\daemon.json"
# Reinicia Docker Desktop
```

---

## Dependencias recomendadas

| Herramienta | Instalación |
|---|---|
| Oh My Posh | `winget install JanDeLamar.OhMyPosh` |
| PSReadLine | `Install-Module PSReadLine -Force` |
| Git | `winget install Git.Git` |
| fnm (Node) | `winget install Schniz.fnm` |
| Python 3.11+ | `winget install Python.Python.3.11` |
| AWS CLI v2 | `winget install Amazon.AWSCLI` |
| kubectl | `winget install Kubernetes.kubectl` |
| Helm | `winget install Helm.Helm` |
| JetBrains Mono | https://www.jetbrains.com/legalterms/mono/ |

---

## Variables de entorno sensibles

Nunca guardes claves directamente en los archivos. Usa:
- **Windows Credential Manager** para credenciales locales
- **AWS SSO / IAM Roles** en lugar de access keys
- **`.env` local** (ignorado por `.gitignore_global`) para desarrollo

---

## Notas de seguridad

Los alias en `security.ps1` están pensados para uso en:
- Entornos de laboratorio propios (VMs, Docker)
- Plataformas CTF (HackTheBox, TryHackMe, VulnHub)
- Infraestructura propia con autorización documentada

Usar herramientas de escaneo/explotación en sistemas ajenos sin autorización escrita es ilegal.

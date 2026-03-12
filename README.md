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

---

## Solución de problemas comunes

### PowerShell — scripts bloqueados (OneDrive)
Si ves "El archivo no está firmado digitalmente":
```powershell
Get-ChildItem "$env:USERPROFILE\OneDrive\Documentos\WindowsPowerShell" -Recurse -Filter "*.ps1" | Unblock-File
. $PROFILE
```

### PowerShell — operador `??` no reconocido
Significa que estás en Windows PowerShell 5.1 en lugar de PowerShell 7.
```powershell
winget install Microsoft.PowerShell
# Luego abre PowerShell 7 con:
pwsh
```

### PSReadLine — parámetros no encontrados
Actualiza PSReadLine:
```powershell
Install-Module PSReadLine -Force -SkipPublisherCheck
```
Cierra y vuelve a abrir la terminal.

### oh-my-posh no encontrado
Comenta la línea en tu perfil (`code $PROFILE`) hasta instalarlo:
```powershell
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression
```

### Claude Code usa Git Bash, no PowerShell
Claude Code corre en `/bin/bash.exe` con `HOME=/c/Users/oskar`. Los aliases de PowerShell no están disponibles directamente — usa el prompt de contexto de la sección siguiente.

---

## Configurar tu skill en Claude Code

1. Abre Claude Code en tu proyecto
2. Escribe `/skills` y busca **skill-creator**
3. Si no aparece, pega directamente este prompt adaptado a tu stack:

```
Create a skill from this context and reference it for all sessions.

You are operating in a Windows 11 + PowerShell 7 + Git Bash environment.

SHELL ALIASES AVAILABLE (PowerShell):
Docker: dps, dcu, dcd, dcb, dlog <c>, dexec <c>, dprune | K8s: k, kgp, kgpa, klog <p>, kexec <p>, kapply <f>, kctx <ctx>, kpf <pod> <lp> <rp>
AWS: aws-whoami, aws-profile <n>, ec2-list, ecr-login, s3-ls, s3-sync, secret-get <n>, cwlog-tail <g>
Git: gs, gaa, gc "<msg>", gp, gpl, gl, gco, gcb, gundo, git-clean-branches
Node: nrd, nrb, nrt, ni, nid, load-env, port-kill <p>
Python: venv-new <n>, venv-on <n>, pipi, pipr, pipf, por, posh
Java: mvn-clean, mvn-run, gradle-run, gradle-c
Sysadmin: ll, mem-usage, top10, find-file <n>, port-who <p>, myip, reload
AI/ML: ml-env-new, jup-lab, ollama-run <m>, pip-torch, pip-hf
Security (own systems only): nmap-quick <t>, nmap-full <t>, find-secrets, lab-kali, lab-juice, hash-sha256, b64-encode/decode
STACK: Node/TS + Python + Java | Docker + K8s | AWS | Git Bash as default shell
MCP: GitHub MCP active (use for all GitHub operations instead of gh CLI)
CONVENTIONS: kebab-case files, camelCase JS/TS, snake_case Python, PascalCase classes, feat/fix/chore branches, never hardcode secrets
ENV FILES: always .env local (gitignored), .env.example in repo, secrets via AWS Secrets Manager in prod
NOTE: Claude Code runs in Git Bash (/bin/bash.exe), HOME=/c/Users/oskar. If project has CLAUDE.md, read it first.
```

> Ajusta el prompt eliminando las secciones que no uses antes de pegarlo.

---

## Eliminar módulos que no necesitas

Si solo trabajas en un área específica, puedes pedirle a Claude Code que limpie los módulos que no usas. Pega este prompt adaptando la lista de carpetas a eliminar:

```
I only work with [INDICA TU ÁREA: AI/ML, backend, security, etc.].
Please delete the following alias files from my PowerShell profile folder as I don't need them:

- aliases/security.ps1    → delete if you don't do pentesting
- aliases/aws.ps1         → delete if you don't use AWS
- aliases/docker.ps1      → delete if you don't use Docker/K8s
- aliases/ai.ps1          → delete if you don't do AI/ML
- aliases/dev.ps1         → delete if you don't do Node/Python/Java backend
- aliases/sysadmin.ps1    → delete if you don't manage systems

Keep only the ones relevant to my stack. After deleting, remove their references
from Microsoft.PowerShell_profile.ps1 so they don't cause errors on reload.
Then run: . $PROFILE
```

> Claude Code ejecutará los comandos necesarios para eliminar los archivos y actualizar el perfil automáticamente.

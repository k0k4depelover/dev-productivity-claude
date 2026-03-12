# ============================================================
#  Aliases — Desarrollo de IA / ML
# ============================================================

# ── Entornos virtuales para ML ───────────────────────────────
function ml-env-new {
    param($name="ml-env")
    python -m venv $name
    & ".\$name\Scripts\Activate.ps1"
    pip install --upgrade pip
    pip install numpy pandas scikit-learn matplotlib seaborn jupyter notebook ipykernel
    Write-Host "→ Entorno ML '$name' listo" -ForegroundColor Green
}

# ── Jupyter ───────────────────────────────────────────────────
function jup         { jupyter notebook $args }
function jup-lab     { jupyter lab $args }
function jup-list    { jupyter notebook list }
function jup-stop    { jupyter notebook stop }

# Instalar kernel del venv actual en Jupyter
function jup-kernel  {
    param($name="mi-entorno")
    python -m ipykernel install --user --name=$name --display-name="Python ($name)"
    Write-Host "→ Kernel '$name' registrado en Jupyter" -ForegroundColor Green
}

# ── pip shortcuts para ML ────────────────────────────────────
function pip-torch   { pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 }
function pip-tf      { pip install tensorflow }
function pip-hf      { pip install transformers datasets accelerate }
function pip-mlflow  { pip install mlflow }
function pip-ray     { pip install ray[tune] }
function pip-cv      { pip install opencv-python pillow albumentations }
function pip-nlp     { pip install spacy nltk gensim sentence-transformers }

# ── MLflow ───────────────────────────────────────────────────
function mlflow-ui   { param($port=5000) mlflow ui --port $port }
function mlflow-run  { param($entry="main") mlflow run . --entry-point $entry }

# ── Ollama (LLMs locales) ────────────────────────────────────
function ollama-run  { param($model="llama3") ollama run $model }
function ollama-list { ollama list }
function ollama-pull { param($model) ollama pull $model }
function ollama-serve{ ollama serve }

# ── API helpers (OpenAI / Anthropic / Gemini) ────────────────
# Las claves deben estar en variables de entorno, nunca en código
function set-openai  { param($key) $env:OPENAI_API_KEY = $key; Write-Host "→ OPENAI_API_KEY configurada" }
function set-anthropic { param($key) $env:ANTHROPIC_API_KEY = $key; Write-Host "→ ANTHROPIC_API_KEY configurada" }
function set-gemini  { param($key) $env:GOOGLE_API_KEY = $key; Write-Host "→ GOOGLE_API_KEY configurada" }

# Test rápido de API OpenAI
function openai-test {
    if (-not $env:OPENAI_API_KEY) { Write-Host "→ OPENAI_API_KEY no configurada" -ForegroundColor Red; return }
    $body = @{ model="gpt-4o-mini"; messages=@(@{role="user";content="Say: API OK"}) } | ConvertTo-Json
    $r = Invoke-RestMethod -Uri "https://api.openai.com/v1/chat/completions" `
        -Method POST `
        -Headers @{ Authorization="Bearer $env:OPENAI_API_KEY"; "Content-Type"="application/json" } `
        -Body $body
    Write-Host "→ Respuesta: $($r.choices[0].message.content)" -ForegroundColor Green
}

# ── Utilidades de datos ───────────────────────────────────────
function csv-preview { param($f, $n=10) Import-Csv $f | Select-Object -First $n | Format-Table }
function json-preview{ param($f) Get-Content $f | ConvertFrom-Json | ConvertTo-Json -Depth 3 }

# Limpiar cache de pip y modelos HuggingFace
function ml-clean {
    pip cache purge
    if (Test-Path "$env:USERPROFILE\.cache\huggingface") {
        Write-Host "→ Cache HuggingFace: $env:USERPROFILE\.cache\huggingface" -ForegroundColor Yellow
        Write-Host "   Elimina manualmente si necesitas liberar espacio."
    }
}

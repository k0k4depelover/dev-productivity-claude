# ============================================================
#  Aliases — Docker & Kubernetes
# ============================================================

# ── Docker ──────────────────────────────────────────────────
function d          { docker $args }
function dps        { docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" }
function dpsa       { docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}" }
function dimg       { docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" }
function dlog       { param($c) docker logs -f $c }
function dexec      { param($c) docker exec -it $c /bin/bash }
function dstop-all  { docker stop $(docker ps -q) }
function drm-all    { docker rm $(docker ps -aq) }
function drmi-none  { docker rmi $(docker images -f "dangling=true" -q) }
function dprune     { docker system prune -af --volumes }
function dbuild     { param($t) docker build -t $t . }
function drun       { param($img, $port) docker run -it --rm -p "${port}:${port}" $img }

# Docker stats en tiempo real
function dstats     { docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" }

# ── Docker Compose ──────────────────────────────────────────
function dc         { docker compose $args }
function dcu        { docker compose up -d }
function dcd        { docker compose down }
function dcr        { docker compose restart $args }
function dcl        { param($s) docker compose logs -f $s }
function dcb        { docker compose build --no-cache }
function dcps       { docker compose ps }

# ── Kubernetes ──────────────────────────────────────────────
function k          { kubectl $args }
function kgp        { kubectl get pods $args }
function kgpa       { kubectl get pods --all-namespaces }
function kgs        { kubectl get svc $args }
function kgd        { kubectl get deployments $args }
function kgn        { kubectl get nodes }
function kdes       { param($r) kubectl describe $r }
function kdel       { param($r) kubectl delete $r }
function klog       { param($p) kubectl logs -f $p }
function kexec      { param($p) kubectl exec -it $p -- /bin/bash }
function kctx       { kubectl config use-context $args }
function kns        { kubectl config set-context --current --namespace=$args }
function kapply     { kubectl apply -f $args }

# Listar todos los contextos
function kctxs      { kubectl config get-contexts }

# Port-forward rápido
function kpf        { param($pod, $local, $remote) kubectl port-forward $pod "${local}:${remote}" }

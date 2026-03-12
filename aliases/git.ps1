# ============================================================
#  Aliases — Git
# ============================================================

function g          { git $args }
function gs         { git status -sb }
function ga         { git add $args }
function gaa        { git add -A }
function gc         { param($m) git commit -m $m }
function gca        { param($m) git commit -am $m }
function gp         { git push $args }
function gpf        { git push --force-with-lease }
function gpl        { git pull --rebase }
function gf         { git fetch --all --prune }
function gco        { git checkout $args }
function gcb        { param($b) git checkout -b $b }
function gb         { git branch -vv }
function gba        { git branch -a }
function gbd        { param($b) git branch -d $b }
function gbD        { param($b) git branch -D $b }
function gl         { git log --oneline --graph --decorate -20 }
function gla        { git log --oneline --graph --decorate --all }
function gd         { git diff $args }
function gds        { git diff --staged }
function grb        { param($b) git rebase $b }
function grbi       { param($n) git rebase -i "HEAD~$n" }
function grba       { git rebase --abort }
function grbc       { git rebase --continue }
function gst        { git stash $args }
function gstp       { git stash pop }
function gstl       { git stash list }
function gtag       { param($t) git tag -a $t -m $t }
function gtagp      { param($t) git push origin $t }

# Limpieza de ramas mergeadas
function git-clean-branches {
    git branch --merged main | Where-Object { $_ -notmatch "^\*|main|master|develop" } | ForEach-Object { git branch -d $_.Trim() }
}

# Deshacer último commit (mantiene cambios)
function gundo      { git reset --soft HEAD~1 }

# Ver archivos modificados en último commit
function gwhat      { git show --stat HEAD }

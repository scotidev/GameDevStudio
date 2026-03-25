$ErrorActionPreference = "Stop"

$repoRoot = git rev-parse --show-toplevel 2>$null
if (-not $repoRoot) {
    Write-Error "Not inside a git repository."
}

$sourceDir = Join-Path $repoRoot ".githooks"
$targetDir = Join-Path $repoRoot ".git/hooks"

if (-not (Test-Path $sourceDir)) {
    Write-Error "Missing $sourceDir"
}

New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

$hooks = @("pre-commit", "pre-push", "post-commit")
foreach ($hook in $hooks) {
    $source = Join-Path $sourceDir $hook
    $target = Join-Path $targetDir $hook

    if (-not (Test-Path $source)) {
        Write-Error "Missing hook template $source"
    }

    Copy-Item -Path $source -Destination $target -Force
    Write-Host "Installed $hook"
}

Write-Host "Git hooks installed successfully."
Write-Host "Tip: run git commit --allow-empty -m 'hook smoke test' to verify pre-commit."

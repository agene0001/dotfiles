# Deploy the Windows-relevant dotfiles by symlinking them into place.
# Requires Developer Mode (Settings > System > For developers) OR an elevated
# shell so symlinks can be created. Only Neovim is linked on Windows; zsh,
# tmux, and i3 are not used here.
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $MyInvocation.MyCommand.Path

function Link-Config {
    param([string]$Target, [string]$Source)
    $dir = Split-Path -Parent $Target
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
    if (Test-Path $Target) {
        Write-Host "Skipping existing: $Target (move/remove it, then re-run to link)" -ForegroundColor Yellow
        return
    }
    New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
    Write-Host "Linked $Target -> $Source" -ForegroundColor Green
}

# Neovim config -> %LOCALAPPDATA%\nvim
Link-Config "$env:LOCALAPPDATA\nvim" "$repo\nvim\.config\nvim"

Write-Host "Done. Restart Neovim to pick up the config."

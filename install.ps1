# Deploy the Windows-relevant dotfiles by symlinking them into place.
# Requires Developer Mode (Settings > System > For developers) OR an elevated
# shell so symlinks can be created. zsh, tmux, i3, and bin are not used on Windows.
#
# Usage:
#   .\install.ps1            # link anything not already present (skips existing)
#   .\install.ps1 -Force     # also replace existing *symlinks* (stow --restow parity)
#
# -Force only ever replaces a symlink. A real file/dir at the target is always
# left untouched so personal data can't be clobbered.
param([switch]$Force)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $MyInvocation.MyCommand.Path

function Link-Config {
    param([string]$Target, [string]$Source)

    if (-not (Test-Path $Source)) {
        Write-Host "Source missing, skipping: $Source" -ForegroundColor Red
        return
    }

    $dir = Split-Path -Parent $Target
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }

    if (Test-Path $Target) {
        $existing = Get-Item $Target -Force
        if ($existing.LinkType -eq 'SymbolicLink') {
            if ($existing.Target -eq $Source) {
                Write-Host "Already linked: $Target" -ForegroundColor DarkGray
                return
            }
            if (-not $Force) {
                Write-Host "Existing link differs: $Target -> $($existing.Target) (use -Force to replace)" -ForegroundColor Yellow
                return
            }
            $existing.Delete()  # removes the reparse point only, never the target's contents
        }
        else {
            Write-Host "Skipping real file/dir (not a link): $Target (move/remove it, then re-run)" -ForegroundColor Yellow
            return
        }
    }

    New-Item -ItemType SymbolicLink -Path $Target -Target $Source | Out-Null
    Write-Host "Linked $Target -> $Source" -ForegroundColor Green
}

# package target (in $HOME-ish space)      <- source (stow layout in the repo)
Link-Config "$env:LOCALAPPDATA\nvim"          "$repo\nvim\.config\nvim"
Link-Config "$env:USERPROFILE\.ssh\config"    "$repo\ssh\.ssh\config"
Link-Config "$env:USERPROFILE\.config\keyb\keyb.yml" "$repo\keyb\.config\keyb\keyb.yml"

Write-Host "Done. Restart Neovim to pick up the config."

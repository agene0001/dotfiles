# 🛠️ Dotfiles

A single cross-platform dotfiles repo for **macOS**, **Linux/Kali**, and **Windows**.
Configs live in [GNU Stow](https://www.gnu.org/software/stow/) packages; OS-specific
behavior is handled inside the configs (`case "$OSTYPE"` in zsh, `vim.fn.has(...)`
guards in Neovim) so the same files work everywhere.

## Layout

```
nvim/.config/nvim/      Neovim (init.lua, lazy-lock.json, templates/)
zsh/.zshrc              Zsh — shared core + per-OS PATH/alias arms
zsh/.p10k.zsh           Powerlevel10k theme
tmux/.tmux.conf         tmux + catppuccin + treemux
ssh/.ssh/config         SSH client config
keyb/.config/keyb/      keyb cheatsheet
i3/.config/i3/config    i3 window manager      (Linux only)
bin/.local/bin/         helper scripts         (Linux/Kali: ghostty, hacktools, run-commands)
install.sh              mac/Linux deploy (stow)
install.ps1             Windows deploy (symlink)
```

## Install

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
```

**macOS / Linux** — symlinks the right packages for the detected OS:

```bash
./install.sh
```

**Windows** (PowerShell, with Developer Mode or an elevated shell so symlinks work):

```powershell
./install.ps1
```

On Windows only the Neovim config is linked (zsh/tmux/i3 aren't used there).

## Per-machine prerequisites

Neovim uses the **`main` branch** of nvim-treesitter, which compiles parsers with the
`tree-sitter` CLI + a C compiler. Linters `pylint`/`yamllint` are managed via `uv`, and
`luacheck` via a standalone binary (kept out of Mason — see `ignore_install` in `init.lua`).

| Tool | macOS | Linux/Kali | Windows |
|------|-------|-----------|---------|
| tree-sitter CLI + compiler | `brew install tree-sitter` | `cargo install tree-sitter-cli` (+ build-essential) | `scoop install tree-sitter` |
| luacheck | `brew install luacheck` | `apt install lua-check` or luarocks | `scoop install luacheck` |
| pylint, yamllint | `uv tool install pylint yamllint` | `uv tool install pylint yamllint` | `uv tool install pylint yamllint` |
| stow (deploy) | `brew install stow` | `sudo apt install stow` | n/a (uses `install.ps1`) |

## Notes

- Secrets go in `~/.secrets` (git-ignored), sourced automatically by `.zshrc`.
- The Linux helper scripts (`bin/.local/bin/{ghostty,hacktools,run-commands}.sh`) install
  Ghostty, offensive-security tooling, and system deps respectively.
- Branches `mac-dfile` and `windows-dfile` are retained as pre-unification backups.

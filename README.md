Here's a cleaned-up version of your README with clearer structure, removed inline install instructions, and a streamlined workflow using your provided scripts:

---

# 🛠️ Dotfiles Setup

A personal, highly customized setup for terminal tools, Neovim, Zsh, Tmux, Ghostty, and hacking utilities.

## ⚡ Installation Workflow

Clone this repository:

```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Then follow these steps to initialize everything:

---

### 🧰 1. System & Tool Initialization

Run:

```bash
./run-command.sh
```

This script installs system dependencies (like Python, Node, LuaRocks), sets up Neovim and Oh-My-Zsh, and prepares your development environment.

---

### 👻 2. Install Ghostty (Terminal Emulator)

Run:

```bash
./ghostty.sh
```

This script downloads and builds [Ghostty](https://ghostty.org) from source using Zig, ensuring you get the latest version.

---

### 🕵️ 3. Hack Tools Setup

Run:

```bash
./hacktools.sh
```

This installs custom web API testing tools, reverse engineering utilities, and other offensive security essentials.

---

## 💡 Extras

- All configurations are managed via `stow`. After setup, simply run:

  ```bash
  stow .
  ```

- Fonts (like NerdFonts) and plugins for `tmux`, `zsh`, and `nvim` are handled automatically.
- Customize further inside the `~/dotfiles` directory.

---

## 🔗 References

- [Neovim Install Guide](https://github.com/neovim/neovim/blob/master/INSTALL.md)
- [Ghostty Build Docs](https://ghostty.org/docs/install/build)
- [Oh-My-Zsh](https://ohmyz.sh/)

---

Let me know if you want this turned into a `README.md` file directly or need any of the scripts tweaked to auto-detect things like OS/package manager.

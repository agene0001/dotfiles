# =====================================================================
# Powerlevel10k instant prompt — keep near the top of ~/.zshrc.
# Anything requiring console input (passwords, [y/n]) must go ABOVE this.
# =====================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =====================================================================
# OS-specific environment & PATH
# =====================================================================
case "$OSTYPE" in
  darwin*)
    # Homebrew
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # JetBrains Toolbox / .NET tools
    export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
    export PATH="$PATH:$HOME/.dotnet/tools"

    # Python 3.12 framework build
    export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"

    # Spark
    export SPARK_HOME="$HOME/Downloads/spark"
    export PATH="$SPARK_HOME/bin:$PATH"

    # Google Cloud SDK
    export PATH="$PATH:$HOME/google-cloud-sdk/bin"
    [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/google-cloud-sdk/path.zsh.inc"
    [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"

    # MySQL
    export PATH="/opt/homebrew/opt/mysql/bin:$PATH"
    export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
    export PATH="/usr/local/mysql-9.0.39-mac14-arm64/bin:$PATH"

    # Ruby
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    export PATH="/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"

    # Flutter / PostgreSQL / Go
    export PATH="$HOME/development/flutter/bin:$PATH"
    export PATH="/Library/PostgreSQL/18/bin:$PATH"
    export PATH="$HOME/go/bin:$PATH"

    # pyenv
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
    ;;

  linux*)
    export GSK_RENDERER=cairo

    export PATH="$HOME/go/bin:$PATH"
    export PATH="$PATH:/snap/bin"

    # Kali ruby gems
    export PATH="$PATH:/home/kali/.local/share/gem/ruby/3.3.0/bin"
    # Tor browser
    export PATH="$HOME/Downloads/tor-browser:$PATH"

    # ssh-agent
    eval "$(ssh-agent -s)" >/dev/null
    ;;
esac

# =====================================================================
# Oh My Zsh
# =====================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
HYPHEN_INSENSITIVE="true"
zstyle ':omz:update' mode auto      # update automatically without asking
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"

# Plugin list (auto-notify / you-should-use are macOS-only installs;
# virtualenv prompt segment is used on Linux)
case "$OSTYPE" in
  darwin*) plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search auto-notify you-should-use) ;;
  linux*)  plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search virtualenv) ;;
  *)       plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search) ;;
esac
source $ZSH/oh-my-zsh.sh

# =====================================================================
# User configuration (shared)
# =====================================================================
# Securely load secrets from a separate file (e.g. export OPENAI_API_KEY=...).
[ -f ~/.secrets ] && . ~/.secrets

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Cargo
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# History
HISTSIZE=1000
HISTFILE=~/.zsh_history
SAVEHIST=2000
setopt HIST_IGNORE_DUPS      # Don't save duplicate commands
setopt APPEND_HISTORY        # Append to history file rather than overwrite

# =====================================================================
# OS-specific aliases
# =====================================================================
case "$OSTYPE" in
  darwin*)
    alias bfg='java -jar /usr/local/bin/bfg.jar'

    # eza (ls replacement)
    alias ll='eza -l --icons --group-directories-first'
    alias la='eza -a --icons --group-directories-first'
    alias ld='eza -D --icons'
    alias lf='eza -f --icons'
    alias ls='eza --icons'
    alias lo='ls'
    alias lt='eza --tree --icons'
    alias tree='eza --tree --icons -I ".git|node_modules|target|__pycache__|.venv"'

    # Fuzzy find (tv = television; macOS open/pbcopy)
    alias fdel='rm -i $(tv files)'
    alias fkill='kill -9 $(ps aux | fzf | awk "{print \$2}")'
    alias fkille='kill -9 $(ps aux | fzf --exact | awk "{print \$2}")'
    alias fo='open $(tv files)'
    alias fcp='tv files | pbcopy'

    # Modern CLI tool aliases
    alias cat="bat"
    alias du="dust"
    alias ps="procs"
    alias grep="rg"
    alias find="fd"
    alias time="hyperfine"
    alias cloc="tokei"
    alias df="duf"
    alias top="btop"
    alias help="tldr"

    # Quick lookup
    alias keys='bindkey | fzf'
    alias aliases='alias | fzf'
    ;;

  linux*)
    # Color support
    if [ -x /usr/bin/dircolors ]; then
      test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
      alias grep='grep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias egrep='egrep --color=auto'
    fi
    alias fd=fdfind

    # colorls
    alias ll="colorls -l --sd"
    alias la='colorls -a --sd'
    alias ld='colorls -d'
    alias lf='colorls -f'
    alias ls='colorls'
    alias lo='ls'
    alias lt='colorls --tree'
    alias tree='tree -I ".git|node_modules"'

    # Fuzzy find (fzf + xclip/xdg-open)
    preview="--preview 'bat --style=numbers --color=always {}'"
    alias fcd='cd "$(fd -t d | fzf)"'
    alias fcde='cd "$(fd -t d | fzf --exact)"'
    alias fn='nvim $(fzf '"$preview"')'
    alias fne='nvim $(fzf '"$preview"' --exact)'
    alias fdel='rm -i $(fzf '"$preview"')'
    alias fdele='rm -i $(fzf '"$preview"' --exact)'
    alias fle='fzf '"$preview"'| xargs less'
    alias flee="fzf --exact | xargs less"
    alias fcp='fzf '"$preview"'| xclip -selection clipboard'
    alias fcpe='fzf --exact '"$preview"' | xclip -selection clipboard'
    alias fps='ps aux | awk "{print \$11}" | fzf'
    alias fpse='ps aux | awk "{print \$11}" | fzf --exact'
    alias fkill='kill -9 $(ps aux | fzf | awk "{print \$2}")'
    alias fkille='kill -9 $(ps aux | fzf --exact | awk "{print \$2}")'
    alias fo='xdg-open $(fzf '"$preview"')'
    alias foe='xdg-open $(fzf --exact '"$preview"')'
    alias fenv='env | fzf'
    alias fenve='env | fzf --exact'
    alias nano='nvim'
    ;;
esac

# Load additional alias definitions if available
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# =====================================================================
# Completion (shared)
# =====================================================================
autoload -Uz compinit
compinit
fpath=(~/.zsh/zsh-completions $fpath)

export PATH="$HOME/.local/bin:$PATH"

# Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zsh plugins (sourced from oh-my-zsh custom)
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export BASHSHELL=$(which bash)

# =====================================================================
# OS-specific tail (shell integrations, prompt tweaks)
# =====================================================================
case "$OSTYPE" in
  darwin*)
    export LIBRARY_PATH="/opt/homebrew/lib:$LIBRARY_PATH"
    export DYLD_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_LIBRARY_PATH"

    # bun
    [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"

    # Antigravity
    export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

    # Zoxide (smarter cd) + Television (Ctrl+T / Ctrl+R)
    command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
    command -v tv >/dev/null && eval "$(tv init zsh)"
    ;;

  linux*)
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv)
    alias zed="WAYLAND_DISPLAY='' zed "
    export MESA_LOADER_DRIVER_OVERRIDE=iris
    export LIBGL_ALWAYS_SOFTWARE=1
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
    export PATH="$PATH:/opt/nvim/"
    ;;
esac

# =====================================================================
# Auto-start tmux (shared intent, OS-specific session handling)
# =====================================================================
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -n "$PS1" ]; then
  case "$OSTYPE" in
    linux*)
      # Unique session per terminal (ghostty)
      session_name="ghostty_$(tty | tr '/' '_')"
      if ! tmux has-session -t "$session_name" 2>/dev/null; then
        tmux new -s "$session_name"
      else
        tmux attach -t "$session_name"
      fi
      ;;
    *)
      tmux new-session && exit
      ;;
  esac
fi

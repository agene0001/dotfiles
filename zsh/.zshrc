# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Homebrew setup
eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by Toolbox App
export PATH="$PATH:/Users/seymour-butts/Library/Application Support/JetBrains/Toolbox/scripts"

# .NET tools
export PATH="$PATH:/Users/seymour-butts/.dotnet/tools"

# Python 3.12
export PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin:${PATH}"

# Set Spark home directory and add it to PATH
export SPARK_HOME=/Users/seymour-butts/Downloads/spark
export PATH="$SPARK_HOME/bin:$PATH"

# Add Google Cloud SDK to PATH
export PATH="$PATH:/Users/seymour-butts/google-cloud-sdk/bin"  # Adjust path as necessary

# Update PATH for the Google Cloud SDK
if [ -f '/Users/seymour-butts/google-cloud-sdk/path.zsh.inc' ]; then
    . '/Users/seymour-butts/google-cloud-sdk/path.zsh.inc'
fi

# Enable shell command completion for gcloud
if [ -f '/Users/seymour-butts/google-cloud-sdk/completion.zsh.inc' ]; then
    . '/Users/seymour-butts/google-cloud-sdk/completion.zsh.inc'
fi

# Add MySQL to PATH
export PATH="/opt/homebrew/opt/mysql/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"
export PATH="/usr/local/mysql-9.0.39-mac14-arm64/bin:$PATH"

# Add Ruby to PATH
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"

# Add Flutter to PATH
export PATH=$HOME/development/flutter/bin:$PATH

# Add PostgreSQL to PATH
export PATH="/Library/PostgreSQL/18/bin:$PATH"

# Add Go to PATH
export PATH=$HOME/go/bin:$PATH

# Add snap to PATH
export PATH=$PATH:/snap/bin

# Pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"


zstyle ':omz:update' mode auto      # update automatically without asking



COMPLETION_WAITING_DOTS="true"


HIST_STAMPS="mm/dd/yyyy"


plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search auto-notify you-should-use)
source $ZSH/oh-my-zsh.sh

# User configuration

# Securely load secrets from a separate file.
# Create a file like ~/.secrets and add `export OPENAI_API_KEY='your-key'`
if [ -f ~/.secrets ]; then . ~/.secrets; fi

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi


[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# History configuration
HISTSIZE=1000
HISTFILE=~/.zsh_history
SAVEHIST=2000
setopt HIST_IGNORE_DUPS      # Don't save duplicate commands
setopt APPEND_HISTORY        # Append to history file rather than overwrite

# Misc aliases
alias bfg='java -jar /usr/local/bin/bfg.jar'

# Eza (colorls replacement)
alias ll='eza -l --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias ld='eza -D --icons'
alias lf='eza -f --icons'
alias ls='eza --icons'
alias lo='ls'
alias lt='eza --tree --icons'
alias tree='eza --tree --icons -I ".git|node_modules|target|__pycache__|.venv"'

# Fuzzy find aliases (kept — tv doesn't replace destructive/clipboard/open actions)
alias fdel='rm -i $(tv files)'
alias fkill='kill -9 $(ps aux | fzf | awk "{print \$2}")'
alias fkille='kill -9 $(ps aux | fzf --exact | awk "{print \$2}")'
alias fo='open $(tv files)'  # macOS (use 'open' not 'xdg-open')
alias fcp='tv files | pbcopy'  # macOS (use 'pbcopy' not 'xclip')

# Load additional alias definitions if available
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# Completion system
autoload -Uz compinit
compinit

# Add zsh completions directory to fpath
fpath=(~/.zsh/zsh-completions $fpath)

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export BASHSHELL=$(which bash)
export LIBRARY_PATH="/opt/homebrew/lib:$LIBRARY_PATH"
export DYLD_LIBRARY_PATH="/opt/homebrew/lib:$DYLD_LIBRARY_PATH"

# bun completions
[ -s "/Users/seymour-butts/.bun/_bun" ] && source "/Users/seymour-butts/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by Antigravity
export PATH="/Users/seymour-butts/.antigravity/antigravity/bin:$PATH"

# ============================================================
# Modern CLI tool aliases
# ============================================================
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

# ============================================================
# Shell integrations
# ============================================================

# Zoxide (smarter cd)
eval "$(zoxide init zsh)"

# Television shell integration (smart Ctrl+T autocomplete, Ctrl+R history)
eval "$(tv init zsh)"
# Auto-start tmux
# Auto-start tmux (kills session on detach/exit)
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux new-session && exit
fi

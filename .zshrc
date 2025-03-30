# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search virtualenv)
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# Load cargo environment if it exists
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# History configuration
HISTSIZE=1000
HISTFILE=~/.zsh_history
SAVEHIST=2000
setopt HIST_IGNORE_DUPS      # Don't save duplicate commands
setopt APPEND_HISTORY        # Append to history file rather than overwrite

# Set up chroot prompt addition if needed
# if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
#     debian_chroot=$(cat /etc/debian_chroot)
# fi
# 
# # Set up prompt (converting bash PS1 to zsh format)
# autoload -U colors && colors
# 
# # Set the prompt with proper color formatting
# if [[ "$TERM" == *256color* || "$TERM" == xterm-color ]]; then
#   PS1='%F{green}%n@%m%f:%F{blue}%~%f$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}%n@%m:%~$ '
# fi
# 
# # Terminal title (for xterm)
# case "$TERM" in
#     xterm*|rxvt*)
#         precmd() { print -Pn "\e]0;${debian_chroot:+($debian_chroot)}%n@%m: %~\a" }
#         ;;
# esac

# Enable color support for ls and other commands
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
alias fd=fdfind
alias ll="colorls -l --sd"
# Common aliases
# Colorls 
alias la='colorls -a --sd'
alias ld='colorls -d'
alias lf='colorls -f'
alias ls='colorls'
alias lo ="ls"
alias lt='colorls --tree'
alias tree='tree -I .git|node_modules'
# Alias to use find with fzf to search for files in the current directory
# Fuzzy find and open a directory in a new terminal tab
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
# Fuzzy search running processes
alias fps='ps aux | awk "{print \$11}" | fzf'
alias fpse='ps aux | awk "{print \$11}" | fzf --exact'
# Fuzzy search and kill a process
alias fkill='kill -9 $(ps aux | fzf | awk "{print \$2}")'
alias fkille='kill -9 $(ps aux | fzf --exact | awk "{print \$2}")'

# Fuzzy find and open a file with the default application
alias fo='xdg-open $(fzf '"$preview"')'  # Linux
alias foe='xdg-open $(fzf --exact '"$preview"')'  # Linux
alias fenv='env | fzf'
alias fenve='env | fzf --exact'
# Load additional alias definitions if available
[ -f ~/.bash_aliases ] && source ~/.bash_aliases

# Completion system
autoload -Uz compinit
compinit

# Add zsh completions directory to fpath
fpath=(~/.zsh/zsh-completions $fpath)

# Load fzf if available

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"
# Set up fzf key bindings and fuzzy completion
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status virtualenv)
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export PATH=$PATH:/snap/bin
export BASHSHELL=$(which bash)
export PATH=$HOME/go/bin:$PATH
# sudo mount -t drvfs G: /mnt/g


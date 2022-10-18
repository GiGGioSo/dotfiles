# Created by newuser for 5.9

# Autocompletion
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select

# Prompt themes
autoload -Uz promptinit
promptinit

# Git info for the prompt - https://dev.to/cassidoo/customizing-my-zsh-prompt-3417
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

zstyle ':vcs_info:git:*' formats ' %b%u%c'

# Environment variables
export EDITOR=nvim

# Zsh options

# Aliases
alias ls='lsd'
alias la='lsd -A'
alias ll='lsd -lA'

alias tp='trash-put'
alias tl='trash-list'
alias rm='echo "Use the trashcan with tp (trash-put).\n\nIf you really want to use rm write a \\ before."; false'

alias onesync='onedrive --synchronize'
# alias spotify='LD_PRELOAD=/usr/lib/spotify-adblock.so spotify'

alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'

# alias wg='wal_global'
alias v='nvim'
alias aw='archwiki'
# alias gpu='DRI_PRIME=1'
# alias gpu='__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia'

# Additions to PATH
typeset -U path PATH
path+=($HOME/.local/bin)
path+=($HOME/.local/scripts) # Include directories recursively
path+=($HOME/.local/scripts/**/*(N/)) # Include directories recursively
path+=($HOME/gits/ltex-ls-15.2.0/bin)
export PATH

# Prompt configuration
NEWLINE=$'\n'
setopt PROMPT_SUBST
RPROMPT=''
PROMPT='%B%F{red}%*%f %F{blue}%n%f%F{blue}:[%f%F{red}%~%f%F{blue}]%f %B%F{magenta}${vcs_info_msg_0_}%f${NEWLINE}%F{blue}%f%b '
# PROMPT='%B%F{cyan}%n %F{red}%c > %F{white}'


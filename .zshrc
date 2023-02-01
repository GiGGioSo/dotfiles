# Created by newuser for 5.9

# Autocompletion
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select

# Prompt themes
autoload -Uz promptinit
promptinit

# History search
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Git info for the prompt - https://dev.to/cassidoo/customizing-my-zsh-prompt-3417
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

zstyle ':vcs_info:git:*' formats ' %b%u%c'

# Dinamically changing the title
#
# NON MI PIACE PERCHÈ METTE COME NOME IL COMANDO ESEGUITO, NON IL PROGRAMMA IN ESECUZIONE
#
# autoload -Uz add-zsh-hook

# function xterm_title_precmd () {
# 	print -Pn -- '\e]2;%n@%m %~\a'
# 	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
# }

# function xterm_title_preexec () {
# 	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
# 	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
# }

# if [[ "$TERM" == (Eterm*|alacritty*|aterm*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
# 	add-zsh-hook -Uz precmd xterm_title_precmd
# 	add-zsh-hook -Uz preexec xterm_title_preexec
# fi

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
alias spotify='LD_PRELOAD=/usr/lib/spotify-adblock.so spotify'

alias blueon='sudo systemctl start --now bluetooth'
alias blueoff='sudo systemctl stop --now bluetooth'

alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'

# alias wg='wal_global'
alias v='nvim'
alias aw='archwiki'
alias :q='sl'
alias :wq='sl'
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

# Something to jump around
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

## Key Bindings
#
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Control modifier
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

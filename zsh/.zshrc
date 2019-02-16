# vim: ft=sh

# Interactivity {{{1

# If not running interactively, don't do anything
[[ -z "$PS1" ]] && return


# Plugins {{{1

source /usr/share/zsh/share/zgen.zsh

if ! zgen saved; then
  zgen load zdharma/fast-syntax-highlighting
  zgen load bhilburn/powerlevel9k powerlevel9k
  zgen load zsh-users/zsh-completions
  zgen load unixorn/git-extra-commands
  zgen load cjbassi/zsh-vi-mode-clipboard
  zgen load softmoth/zsh-vim-mode

  zgen save
fi


# History {{{1

export HISTSIZE=10000
export SAVEHIST=10000

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
export HISTORY_IGNORE="((cd|rm|rmdir|nvim|code|ls)(| *))"

setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

setopt EXTENDED_HISTORY

setopt APPEND_HISTORY


# Keybinds {{{1

bindkey -v

# reduces ESC delay
export KEYTIMEOUT=1

bindkey '^H' backward-kill-word

bindkey -r '^z'


# Settings {{{1

setopt globdots     # Tab completion includes dot files
setopt kshglob      # Addes more globbs
CASE_SENSITIVE=true # Case sensitive completion
stty -ixon          # Disables C-s and C-q

# makes escape not move cursor back
function zle-keymap-select {
    if [[ $KEYMAP == "vicmd" ]] ; then
        CURSOR=$CURSOR+1
    fi
}
zle -N zle-keymap-select

# lists directory contents on cd
function chpwd { ll }

# pressing Enter without any text doesn't do anything
function my-accept-line {
    if [[ $BUFFER != "" ]] ; then
        zle accept-line
    fi
}
zle -N my-accept-line
bindkey '^M' my-accept-line

# completion
autoload -Uz compinit
compinit

zstyle ":completion:*" menu select
# setopt COMPLETE_ALIASES


# Title {{{1
# https://wiki.archlinux.org/index.php/zsh#xterm_title

autoload -Uz add-zsh-hook

function xterm-title-precmd {
    print -Pn "\e]2;%n@%m %1~\a"
}

function xterm-title-preexec {
    print -Pn "\e]2;%n@%m %1~ %# "
    print -n "${(q)1}\a"
}

if [[ "$TERM" == (screen*|xterm*|rxvt*) ]]; then
    add-zsh-hook -Uz precmd xterm-title-precmd
    add-zsh-hook -Uz preexec xterm-title-preexec
fi


# Colors {{{1

alias ls="ls --color=auto"

alias dir="dir --color=auto"
alias vdir="vdir --color=auto"

alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias pcregrep="pcregrep --color=auto"

alias watch="watch --color"

alias diff="diff --color=auto"

alias ip="ip -c"

alias dmesg="dmesg --color=auto"
# alias tree='tree -C'

export GCC_COLORS="error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

alias fdisk="fdisk --color=auto"

# Arch colors
alias cower="cower --color=auto"
alias pactree="pactree -c"

export TLDR_COLOR_BLANK=white


# Other Programs {{{1

# fzf {{{2

source /usr/share/fzf/key-bindings.zsh

# zle -N fzf-history-widget
# zle -N fzf-file-widget

# remove bindings
bindkey -r '^[c'
bindkey -M viins -r '^t'

bindkey -M vicmd '/' fzf-history-widget

function fzf-local {
    local path=$(fd | fzf)
    LBUFFER+=$path
    zle redisplay
}
zle -N fzf-local
bindkey -M vicmd '^f' fzf-local
bindkey -M viins '^f' fzf-local

function fzf-root {
    local path=$(fd . ~ | fzf)
    LBUFFER+=$path
    zle redisplay
}
zle -N fzf-root
bindkey -M vicmd '^r' fzf-root
bindkey -M viins '^r' fzf-root


# Powerlevel9k {{{2

# vi-mode indicator
function zle-line-init zle-keymap-select {
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

export POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(vi_mode dir root_indicator virtualenv background_jobs)
export POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status vcs)

export POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
export POWERLEVEL9K_STATUS_OK=false

export POWERLEVEL9K_STATUS_HIDE_SIGNAME=false

export POWERLEVEL9K_VIRTUALENV_FOREGROUND=255
export POWERLEVEL9K_VIRTUALENV_BACKGROUND=240

# export POWERLEVEL9K_DIR_FOREGROUND=255
# export POWERLEVEL9K_DIR_BACKGROUND=240

export POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND=255
export POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND=245

export POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND=255
export POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND=11

export POWERLEVEL9K_VCS_FOREGROUND=255
export POWERLEVEL9K_VCS_BACKGROUND=33

# export POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND=255
export POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND=125

# export POWERLEVEL9K_VI_INSERT_MODE_STRING="\e[1mINSERT\e[21m"
# export POWERLEVEL9K_VI_COMMAND_MODE_STRING="\e[1mNORMAL\e[21m"
# export POWERLEVEL9K_HOME_FOLDER_ABBREVIATION="\e[21m~"

# POWERLEVEL9K_DIR_HOME_BACKGROUND="grey"
# POWERLEVEL9K_DIR_HOME_FOREGROUND="grey"

# POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="grey"
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="grey"

# POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="grey"
# POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="grey"

# source /usr/share/zsh-theme-powerlevel9k/powerlevel9k.zsh-theme
# source ~/Dropbox/projects/powerlevel9k/powerlevel9k.zsh-theme
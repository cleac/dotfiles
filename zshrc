#!/bin/zsh

alias vim="nvim"
alias v="nvim"
alias zat="zathura"
alias nb="newsbeuter"

alias tm="tmux"
alias tma="tmux attach"
alias tmat="tmux attach -t"
alias tmd="tmux detach"
alias tmn="tmux new"
alias con="nmcli con"

plugins+=(k zsh-autosuggestions)

PATH=$PATH:~/.roswell/bin

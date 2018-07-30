#!/usr/bin/env zsh

alias vim="nvim"
alias v="nvim"
alias zat="zathura"
alias nb="newsbeuter"

alias tm="tmux"
alias tma="tmux attach"
alias tmat="tmux attach -t"
alias tmd="tmux detach"
alias tmn="tmux new"

alias doc2pdf="unoconv -fpdf"

plugins+=(k zsh-autosuggestions)

# For CommonLISP things
export PATH=$PATH:~/.roswell/bin

# For android development
export PATH=$PATH:/home/alexcleac/vendor/android/tools:/home/alexcleac/vendor/android/tools/bin


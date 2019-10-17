#!/usr/bin/env zsh

alias vim="nvim"
alias v="nvim"
alias zat="zathura"
alias nb="newsboat"
alias qute="qutebrowser"

alias tm="tmux"
alias tma="tmux attach"
alias tmat="tmux attach -t"
alias tmd="tmux detach"
alias tmn="tmux new"
alias st="st -f 'Source Code Pro'"

alias doc2pdf="unoconv -fpdf"

plugins+=(k zsh-autosuggestions)

# For CommonLISP things
export PATH=$PATH:~/.roswell/bin

# For android development
export PATH=$PATH:/home/alexcleac/vendor/android/tools:/home/alexcleac/vendor/android/tools/bin

# For pip local installed applications
export PATH=$PATH:/home/alexcleac/.local/bin/

autoload -U +X bashcompinit && bashcompinit

source ~/bin/init_completion.sh

export EDITOR=nvim

export PATH=$PATH:~/.cargo/bin/

alias mup="mutt -f ~/Mail/personal/Inbox/"
alias muw="mutt -f ~/Mail/work/Inbox/"
alias mul="mutt -f ~/Mail/legacy_personal/Inbox/"

alias cws="cd ~/ws"
alias cevo="cd ~/wsevo/"
alias coss="cd ~/wsoss/"

alias helm="helm tiller run -- helm"

alias wiki="vim +VimwikiIndex"

alias tw="task"


export TASKRC=~/.config/taskrc

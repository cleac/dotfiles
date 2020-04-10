#!/usr/bin/env zsh

alias vim="nvim"
alias v="nvim"
alias edit="nvim"

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

# Local binary folders
export PATH=$PATH:$HOME/.local/bin:$HOME/.local/scripts/

# Initialize completion for scripts
source $HOME/.local/scripts/init_completion.sh

autoload -U +X bashcompinit && bashcompinit

export EDITOR=nvim

alias mup="mutt -f ~/Mail/personal/Inbox/"
alias muw="mutt -f ~/Mail/work/Inbox/"
alias mul="mutt -f ~/Mail/legacy_personal/Inbox/"

alias wiki="vim +VimwikiIndex"

alias tw="task"

export TASKRC=~/.config/taskrc


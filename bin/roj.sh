#!/usr/bin/env bash

project=$1
ROJDIR="$HOME/workspace/$project"

function create-prompt() {
    echo -n "Project $project does not exist. Would you like to create it? [yN] "
    read v
    if [ 'y' != $v ]; then
        exit 1
    else
        mkdir -p "$ROJDIR"
    fi
}

function list-projects() {
    for pr in $(ls "$HOME/workspace/"); do
        echo -n " - $pr "
        if [ ! -z "$(tmux list-sessions | grep $pr)" ]; then
            echo '(active)'
        else
            echo ''
        fi
    done
}

if [ -z "$project" ]; then
   echo -e 'No project specified: please type project name.\nHere is list of projects:'
   list-projects
   exit 2
fi

case $1 in
    '--list') list-projects;;
    *)
        tmux attach -t "$project" 2> /dev/null
        if [ ! $? -eq 0 ]; then
           if [ ! -d "$ROJDIR" ]; then
               create-prompt;
           fi
           tmux new -s "$project" -c "$ROJDIR"
        fi
esac


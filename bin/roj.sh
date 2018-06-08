#!/usr/bin/env bash

project=$1
ROJDIR="$HOME/workspace/$project"

if [ -z "$project" ]; then
   echo 'No project specified: please type project name'
   exit 2
fi

function create-prompt() {
    echo -n "Project $project does not exist. Would you like to create it? [yN] "
    read v
    if [ 'y' != $v ]; then
        exit 1
    else
        mkdir -p "$ROJDIR"
    fi
}

tmux attach -t "$project" 2> /dev/null

if [ ! $? -eq 0 ]; then
   if [ ! -d "$ROJDIR" ]; then
       create-prompt;
   fi
   tmux new -s "$project" -c "$ROJDIR"
fi


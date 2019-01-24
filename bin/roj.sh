#!/usr/bin/env bash

project=$1
ROJDIR="$HOME/workspace/$project"

function tmux_sessions() {
  TMUX_SESSIONS=$(tmux list-sessions 2> /dev/null)
  if [ ! $? -eq 0 ]; then
    tmux new -d > /dev/null
    TMUX_SESSIONS=$(tmux list-sessions)
  fi
  echo "$TMUX_SESSIONS" | awk -F ':' '{ print $1 }'
}

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
  sessions=""
  ls "$HOME/workspace/" | \
  awk '{ if (index(sessions, $1) != 0) active="(active)"; else active=""; printf " - %s %s\n", $1, active }' \
  sessions="$(tmux_sessions)"
}

function comp-projects {
  ls "$HOME/workspace"
}

function show-help {
    echo 'roj.sh -- a simple wrapper over tmux to
easily manage project terminal sessions.

Usage: roj.sh <project>
Arguments:
  - project -- project in your /home/<username>/workspace
     directory. If it does not exist, you will be prompted
     to create one.

Also usage: roj.sh --command [<arguments>...]
Arguments:
  - command -- command to run.
     List of commands with usage:
      * list -- show list of sessions
      * help -- show this message'
}

if [ -z "$project" ]; then
   echo -e 'No project specified: please type project name.\nHere is list of projects:'
   list-projects
   exit 2
fi

case $1 in
    '--list') list-projects;;
    '--help') show-help;;
    '--comp-list') comp-projects;;
    *)
        # Try to attach
        tmux attach -t "$project" 2> /dev/null
        if [ ! $? -eq 0 ]; then
          if [ ! -d "$ROJDIR" ]; then
             # Prompt create directory if not exists
             create-prompt;
          fi
          # Create session and attach it
          tmux new -d -s "$project" -c "$ROJDIR" 2> /dev/null
          tmux attach -t "$project" 2> /dev/null
          if [ ! $? -eq 0 ]; then
            tmux switch -t "$project"
          fi
        fi
esac


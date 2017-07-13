#!/bin/sh

project=$1

if [ -z "$project" ]; then
   echo 'No project specified: please type project name'
   exit 1
fi


ROJDIR="$HOME/workspace/$project"
SUBSCRIPT_NAME=.rojsh

tmux attach -t "$project" 2> /dev/null

if [ ! $? -eq 0 ]; then
   if [ ! -d "$ROJDIR" ]; then
      mkdir -p "$ROJDIR"
   fi
   if ([ -n "$ROJDIR/$SUBSCRIPT_NAME" ] && [ ! -z "$(cat "$ROJDIR/$SUBSCRIPT_NAME" 2> /dev/null)" ]); then
      start_script="$SHELL \"$ROJDIR/$SUBSCRIPT_NAME; $SHELL\""
   else
      start_script=$SHELL
   fi
   tmux new -s "$project" -c "$ROJDIR" $start_script
fi


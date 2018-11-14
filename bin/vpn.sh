#!/usr/bin/env bash

# vpn.sh -- a simple app that allows to switch/start vpns in one command
# AUTHOR: alexcleac
# STATUS: PoC

function connection() {
    nmcli con $@ >/dev/null 2>/dev/null
}

function up_connection() {
    if [ -z $1 ]; then
      echo -e "Couldn't determine, which vpn you want to connect.\nTry to run, e.g. 'vpn.sh $(vpns | head -n 1)'"
      exit 5
    fi
    if [ $DEBUG ]; then echo "Setting up $1"; fi
    connection up $1
    echo "Successfully connected to $1"
}

function down_connection() {
  if [[ -z $1 ]] && ([[ '--silent' == $1 ]] || [[ '--silent' == $2 ]]); then
    echo -e "All vpn connections will be shut down!\nPress any key if it is ok..";
    read;
  fi
  for link in $(vpns); do
    if [ $DEBUG ]; then echo "Closing $link"; fi
    connection down $link
  done
  if [[ -z $1 ]]; then
    echo "Killed all connections"
  fi
}

function switch_connection() {
  down_connection --silent;
  up_connection $1;
}

function vpns() {
  nmcli con | awk '/  vpn  /{print $1}'
}

function enabled-vpns() {
  nmcli con | awk '/  vpn  /{ if ($4 != "==") print $1 }'
}

function pretty-vpns() {
  echo 'Here is list of available vpn connections: '
  nmcli con | awk '/  vpn  /{ if ($4 == "--") e=""; else e="(enabled)" ; printf " - %s %s\n", $1, e }';
}

case $1 in
    "up") up_connection $2;;
    "down") down_connection $2;;
    "switch") switch_connection $2;;
    "list") pretty-vpns;;
    "status") pretty-vpns;;
    "help")
        echo "The help page is in progress";;
    *)
        if [ $(vpns | grep -e $1 2>/dev/null) ]; then
           switch_connection $1
           exit 0
        fi
        echo "Command '$1' not found. Try 'vpn.sh help'"
        pretty-vpns;;
esac

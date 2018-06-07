#!/usr/bin/env bash

# vp.sh -- a simple app that allows to switch/start vpns in one command
# AUTHOR: alexcleac
# STATUS: PoC

CONFIG_DIR=$HOME/.config/vpn.sh
CONFIG_FILE=$CONFIG_DIR/vpns

function initialize_config() {
    echo "Creating initial configuration at $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
    touch "$CONFIG_FILE"
}

function edit_config() {
    ${EDITOR:-vim} "$CONFIG_FILE"
}

function up_connection() {
    if [ -z $1 ]; then
        echo "Couldn't find the first argument. Try to run, e.g. 'vpn.sh $(head $CONFIG_FILE -n 1)'"
        exit 5
    fi
    down_connections
    if [ $DEBUG ]; then echo "Setting up $1"; fi
    nmcli con up $1 >/dev/null 2>/dev/null
    echo "$1" >> "$CONFIG_DIR/history"
    echo "Successfully connected to $1"
}

function down_connections() {
    for link in $(cat $CONFIG_FILE); do
        if [ $DEBUG ]; then echo "Closing $link"; fi
        nmcli con down $link >/dev/null 2>/dev/null
    done
    echo "Killed all connections"
}

function reconnect() {
    up_connection $(head "$CONFIG_DIR/history" -n 1)
}

function _check_vpns_config() {
    if [ ! -d "$CONFIG_DIR" ] && [ ! -a "$CONFIG_FILE" ]; then
        echo "Configuration dir was not initialized. Run 'vpn.sh init' to configure it"
        exit 1
    fi
    if [ ! -s "$CONFIG_FILE" ]; then
        echo "No VPNs found registered at vpn.sh. Run 'vpn.sh edit' to add some"
        exit 2
    fi
}

case $1 in
    "init")
        if [ -d "$CONFIG_DIR" ] && [ -a "$CONFIG_FILE" ]; then
            echo -n "Configuration is already created: reinitialize it? [yN] "
            read v
            if [ "y" != $v ]; then
                exit 0
            fi
            rm -rf "$CONFIG_DIR"
        fi
        initialize_config;;
    "edit")
        _check_vpns_config $@
        edit_config;;
    "up")
        _check_vpns_config $@
        if [[ -z $2 ]]; then
            echo "Invalid usage of 'up'. Try 'vpn.sh up <name>"
            exit 3
        fi
        up_connection $2;;
    "help")
        echo "The help page is in progress";;
    "down")
        _check_vpns_config $@
        down_connections;;
    "reconnect")
        _check_vpns_config $@
        reconnect;;
    *)
        _check_vpns_config $@
        if [ $1 ] && [ $(grep $CONFIG_FILE -e $1 2>/dev/null) ]; then
           up_connection $1
           exit 0
        fi
        echo "Command '$1' not found. Try 'vp.sh help'"
esac

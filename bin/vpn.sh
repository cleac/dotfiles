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
    down_connections
    if [ $DEBUG ]; then echo "Setting up $1"; fi
    nmcli con up $1
}

function down_connections() {
    for link in $(cat $CONFIG_FILE); do
        if [ $DEBUG ]; then echo "Closing $link"; fi
        nmcli con down $link >/dev/null 2>/dev/null
    done
}

function _check_vpns_config() {
    if [[ -z $(ls "$CONFIG_FILE" 2>/dev/null) ]]; then
        echo "Configuration dir was not initialized. Run 'init' or 'edit' to configure it"
        exit 1
    fi
    if [[ -z $(cat "$CONFIG_FILE" 2>/dev/null) ]]; then
        echo "No VPNs found registered at vpn.sh. Run 'vpn.sh edit' to add some"
        exit 2
    fi
}

case $1 in
    "init")
        # TODO: find out how to make this thing smaller and simpler
        if [[ -z $(ls "$CONFIG_FILE" 2>/dev/null) ]]; then
            initialize_config
            exit 0
        fi
        echo -n "Configuration is already created: reinitialize it? [yN] "
        read v
        if [ "y" == $v ]; then
            rm -rf "$CONFIG_DIR"
            initialize_config
        fi;;
    "edit")
        if [[ -z $(ls "$CONFIG_FILE" 2>/dev/null) ]]; then
            echo -n "Configuration dir was not initialized. Initialize it? [yN] "
            read v
            if [ "y" == $v ]; then
                initialize_config
            else
                exit 0
            fi
        fi
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
    *)
        _check_vpns_config $@
        if [ $1 ] && [ $(grep $CONFIG_FILE -e $1 2>/dev/null) ]; then
           up_connection $1
           exit 0
        fi
        echo "Command '$1' not found. Try 'vp.sh help'"
esac

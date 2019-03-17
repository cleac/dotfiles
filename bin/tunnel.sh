#!/bin/bash

TIMEOUT=${TIMEOUT:-36000} # defauts to 10 hours

case $1 in
  "help")
    echo "Usage: tunnel.sh <host> <target> <port> [prefix]";;
  *)
    host="$1"
    target="$2"
    port="$3"
    prefix="$4"
    ssh -f -L "$prefix$port":$target:$port $host sleep $TIMEOUT;;
esac

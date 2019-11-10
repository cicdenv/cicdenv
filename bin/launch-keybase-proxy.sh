#!/bin/bash 

set -euo pipefail

#
# Only Macs need this
#
# Connects to a listening socket at host(127.0.0.1):$KBPROXY_PORT
#

_fifo="/tmp/.keybase-fifo"

if [[ ! -p "$_fifo" ]]; then
    mkfifo "$_fifo"
fi

(while true; do nc host.docker.internal "$KBPROXY_PORT" <"$_fifo"; done) | nc -Ulk ~/.config/keybase/keybased.sock >"$_fifo" &

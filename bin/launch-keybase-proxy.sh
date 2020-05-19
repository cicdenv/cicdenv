#!/bin/bash 

set -euo pipefail

#
# Only Macs need this
#
# Connects to a listening socket at host(127.0.0.1):$KBPROXY_PORT
#
_KBPROXY_FIFO=`mktemp -u`
mkfifo $_KBPROXY_FIFO

_KB_SOCKET="${HOME}/.config/keybase/keybased.sock"

nc host.docker.internal "$KBPROXY_PORT" <"$_fifo" | nc -Ulk "$_KB_SOCKET" >"$_fifo" &

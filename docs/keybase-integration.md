# Purpose
Keybase is integral to administer user key genaration / rotation and runtime secret unlocking.

## Integration
The host (mac or linux) runs the keybase backend services (launchd, systemd-user).

The version of keybase client in the `cicdenv` container must be an "exact" 
pre-release version match to the host keybase client version.
This is handled in the cicdenv container image build automatically.

## Linux
```
# Docker bind mounts | What            | Notes
-----------------------------------------------------------------------------------
~/.config/           # configs         | ~/.config/keybase/
~/.local/share/      # data            | ~/.local/share/keybase/
~/.cache/            # logs            | ~/.cache/keybase/ 
/run/user/$(id -u)   # XDG_RUNTIME_DIR | "/run/user/$(id -u)/keybase/keybased.sock"
```

### SystemD
```
run_keybase

/usr/lib/systemd/user/*keybase*
keybase.mount                         ... mounted   /keybase
run-user-$(id -u)-keybase-kbfs.mount  ... mounted   /run/user/1000/keybase/kbfs
keybase-redirector.service            ... running   Keybase Root Redirector for KBFS
keybase.gui.service                   ... running   Keybase GUI
keybase.service                       ... running   Keybase core service
```

### Debugging
```bash
📦 $USER:~/cicdenv$ keybase version
📦 $USER:~/cicdenv$ keybase -d
📦 $USER:~/cicdenv$ keybase help advanced

📦 $USER:~/cicdenv$ keybase --debug --no-auto-fork --socket-file "/run/user/$(id -u)/keybase/keybased.sock" id
```

## Macs
Docker for mac doesn't have a direct means of exposing the keybase server UNIX socket
to the keybase client running in the xhyve linux VM.

To workaround this we have to "proxy" access to the kebyase server UNIX socket
via a combination of netcat, fifo pipes, and a mac/container ephemeral tcp port.

UNIX sockets:
* Mac `~/Library/Group Containers/keybase/Library/Caches/Keybase/keybased.sock`
* Linux `~/.config/keybase/keybased.sock`

Routing: 
```
keybase client in container:
  "sends" - container:/keybased.sock => container:fifo => host:ephemeral-tcp-port
  "recv"  - host:ephemeral-tcp-port => ~/.config/keybase/keybased.sock
keybase server on Mac:
  "recv"  - host:ephemeral-tcp-port => host:/keybased.sock => host:fifo
  "sends" - host:fifo => host:ephemeral-tcp-port
```

Proxies:
```bash
#
# Host - bin/cicdctl
#
# Mac - proxy keybase server unix domain socket
if [[ "$OSTYPE" == "darwin"* ]]; then
    _KBPROXY_FIFO=`mktemp -u`
    mkfifo $_KBPROXY_FIFO
    
    KBPROXY_PORT=$(python -c 'import socket; s = socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
    extra_vars="$extra_vars --env KBPROXY_PORT=${KBPROXY_PORT}"

    _KB_SOCKET="/Users/$USER/Library/Group Containers/keybase/Library/Caches/Keybase/keybased.sock"
    (while true; do nc -lk 127.0.0.1 "$KBPROXY_PORT" <"$_KBPROXY_FIFO"; done) | nc -U "$_KB_SOCKET" >"$_KBPROXY_FIFO" &
    
    trap "exit" INT TERM ERR
    trap "{ kill 0; rm -f $_KBPROXY_FIFO; }" EXIT
fi

#
# Container - bin/launch-keybase-proxy.sh
#
_fifo="/tmp/.keybase-fifo"
if [[ ! -p "$_fifo" ]]; then
    mkfifo "$_fifo"
fi
(while true; do nc host.docker.internal "$KBPROXY_PORT" <"$_fifo"; done) | nc -Ulk ~/.config/keybase/keybased.sock >"$_fifo" &
```

The proxies can be seen in process listings:
```bash
# Host
nc -lk 127.0.0.1 53155
nc -U ~/Library/Group Containers/keybase/Library/Caches/Keybase/keybased.sock

# Container
nc host.docker.internal 53155
nc -Ulk ~/.config/keybase/keybased.sock
```
Here it can be seen that the `host` netcat is "listening" at the `host` ephemeral tcp port
and the `container` netcat is "listening" at the `container` UNIX socket.

It is also necessary to disable some kebyase client smarts when accessing a server that
resides in the host Mac:
```
- Disable smart forking:                '--no-auto-fork'             global option
- Disable default smart server logging: '--local-rpc-debug-unsafe A' global option
```
* https://github.com/keybase/client
  * go/keybase/main.go:345
  * go/keybase/main.go:417
    * go/vendor/github.com/keybase/go-framed-msgpack-rpc/rpc/log.go:141

This prevents spurious `▶ INFO Starting background server with pid=...` and
`▶ ERROR Decryption error: {Err:Keybase services aren't running - KBFS client not found...}` messages.


## Links
* https://github.com/keybase/client/blob/master/packaging/linux/build_binaries.sh
* https://github.com/keybase/client/blob/master/packaging/prerelease/build_keybase.sh
* https://github.com/keybase/client/blob/master/go/libkb/util.go#L44
  ```
  ldflags="-X github.com/keybase/client/go/libkb.PrereleaseBuild=..."
  ```

## Latest Prereleases
```make
_KEYBASE_RELEASES = http://prerelease.keybase.io.s3.amazonaws.com
_KEYBASE_FULL_VERSION = $(shell \
if [[ $$(uname -s) == "Darwin" ]]; then                                             \
    curl -sL '$(_KEYBASE_RELEASES)/update-darwin-prod-v2.json' | jq -r '.version';  \
else                                                                                \
    curl -sL '$(_KEYBASE_RELEASES)/update-linux-prod.json'     | jq -r '.version';  \
fi)
```

# Purpose
Keybase is integral to administer user key genaration / rotation and runtime secret unlocking.

## Integration
The host (mac or linux) runns the keybase backend services (launchd, systemd-user).

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
```
📺 $USER:~/cicdenv$ keybase version
📺 $USER:~/cicdenv$ keybase -d
📺 $USER:~/cicdenv$ keybase help advanced

📺 $USER:~/cicdenv$ keybase --debug --no-auto-fork --socket-file "/run/user/$(id -u)/keybase/keybased.sock" id
```

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

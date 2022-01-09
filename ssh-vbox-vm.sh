#!/bin/bash
set -oeu pipefail
VM="$1"
shift
CMD="${@:-}"
PORT=$(./vbox-get-vm-ssh-port.sh "$VM")
RCMD=
if [[ "$CMD" != "" ]]; then
  RCMD="-oRemoteCommand='sh -c \"$CMD\"'"
fi
cmd="command ssh $RCMD \
  -oStrictHostKeyChecking=no \
  -oIdentityFile=~/.ssh/id_rsa \
  -oCompression=yes \
  -oRequestTTY=yes \
  -oAddressFamily=inet \
  -oBatchMode=yes \
  -oConnectTimeout=5 \
  -oPort=$PORT \
  -oForwardAgent=yes \
  -oHostname=127.0.0.1 \
  -oUser=root \
  -oControlMaster=no \
  -oExitOnForwardFailure=yes \
    '$VM'"

>&2 ansi --yellow --italic --bg-black "$cmd"
eval "$cmd"

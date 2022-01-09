#!/bin/bash
set -oeu pipefail
NAME=$1
SSH_PORT=11111
FWD_REMOTE1=11112
FWD_LOCAL1=11113


cat << EOF
Host $NAME
  Port $SSH_PORT
  LogLevel ERROR
  Hostname 127.0.0.1
  ForwardAgent yes
  User root
  ControlMaster auto
  ControlPath ~/.ssh/%r@%h-%p
  ControlPersist 3600
  RemoteForward 127.0.0.1:$FWD_REMOTE1 127.0.0.1:$FWD_REMOTE1
  LocalForward 127.0.0.1:$FWD_LOCAL1 127.0.0.1:$FWD_LOCAL1
EOF


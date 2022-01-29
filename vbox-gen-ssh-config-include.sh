#!/bin/bash
set -oeu pipefail
NAME=$1
SSH_PORT=$(./vbox-get-vm-ssh-port.sh $NAME)

cat <<EOF
Host $NAME
  Port $SSH_PORT
  LogLevel ERROR
  Hostname 127.0.0.1
  ForwardAgent yes
  User root
  ControlMaster auto
  ControlPath ~/.ssh/%r@%h-%p
  ControlPersist 3600
EOF

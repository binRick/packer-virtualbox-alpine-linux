#!/bin/bash
set -oeu pipefail
OVA=$1

[[ -f .envrc ]] && source .envrc

#[[ -d $RESTIC_REPOSITORY ]] || restic init
restic cache --cleanup
cmd="command cat $OVA | restic backup --stdin --stdin-filename '$(basename $OVA)'"

ansi --yellow --italic "$cmd"
eval "$cmd"

echo OK

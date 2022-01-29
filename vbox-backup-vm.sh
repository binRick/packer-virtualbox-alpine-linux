#!/bin/bash
set -oeu pipefail
VM=$1
NOW=$(date +%s)
OVA=$VM-$NOW.ova
[[ -f .envrc ]] && source .envrc

cleanup() {
	[[ -f $OVA ]] && unlink $OVA
	true
}

trap cleanup EXIT

VBoxManage export $VM -o $OVA
./vbox-backup-ova.sh $OVA

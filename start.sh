#!/bin/bash
set -oeu pipefail

VM=alpine-3.14.0-x86_64

set -x
VBoxManage unregistervm $VM || true
(
	cd ~/VirtualBox\ VMs/.
	[[ -d "$VM" ]] && rm -rf $VM
)

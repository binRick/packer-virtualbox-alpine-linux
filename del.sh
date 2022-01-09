#!/bin/bash
set -oeu pipefail

VM=al3

set -x
VBoxManage unregistervm $VM || true
(
	cd ~/VirtualBox\ VMs/.
	[[ -d "$VM" ]] && rm -rf $VM
)
